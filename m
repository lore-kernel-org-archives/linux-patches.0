Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAA717C;
	Sun,  1 Sep 2024 17:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210062; cv=none; b=OK/+zb5ZYjLhM6sHgzBMH7YFbR1ARvg4CFb7epXlPUz87Nb0sftOojd1dWXbpaE8i0wtVErc9mH8nUsAG67hNnZkYJJo+Acbc47djtcNudQq8+RWZ4IQIcgSXRgLW+d15Q5EJmcYjI0jcx3fpSvLzhdEoBZxbWbxopibnE7tp/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210062; c=relaxed/simple;
	bh=HXAXUEk0M7FQKX5HB0PKMCvIfiH6oJfBvFzy8XlOUcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxyJBOkn6JPubUrGIRUUluSyy1Sh9VQC4zkxdCdfv6/6B15SQTIYx9kFli1v702CxpE3bALiJilWDLY6gTSGDl5ZYUMWe1WOyHyMPyEgt/sJvF3mcBmNCIyjb17K+QAaYDJ3r7lAbvcABhRhakCbvqI4pkv2yGxuB4JseQCezgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qkBpVGta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qkBpVGta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA88C4CEC3;
	Sun,  1 Sep 2024 17:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210061;
	bh=HXAXUEk0M7FQKX5HB0PKMCvIfiH6oJfBvFzy8XlOUcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qkBpVGtaIZeI03zZsz/RHXWQ7WRkYSsiChB6Gy4IzaCxiGbbVjNwriBuKBaPd/b8u
	 NG6Px/f5Zf0kVdc/0mjrAYF5JMvlC5pZgRxHwM32MJGox3EBsfZavZ+P2g61OmRAP/
	 wVngqRYaIn61P1Um/Umdkkax29SXUfnxPqimSqV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erico Nunes <nunes.erico@gmail.com>,
	Qiang Yu <yuq825@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 077/215] drm/lima: set gp bus_stop bit before hard reset
Date: Sun,  1 Sep 2024 18:16:29 +0200
Message-ID: <20240901160826.263876165@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erico Nunes <nunes.erico@gmail.com>

[ Upstream commit 27aa58ec85f973d98d336df7b7941149308db80f ]

This is required for reliable hard resets. Otherwise, doing a hard reset
while a task is still running (such as a task which is being stopped by
the drm_sched timeout handler) may result in random mmu write timeouts
or lockups which cause the entire gpu to hang.

Signed-off-by: Erico Nunes <nunes.erico@gmail.com>
Signed-off-by: Qiang Yu <yuq825@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240124025947.2110659-5-nunes.erico@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/lima/lima_gp.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/lima/lima_gp.c b/drivers/gpu/drm/lima/lima_gp.c
index ca3842f719842..82071835ec9ed 100644
--- a/drivers/gpu/drm/lima/lima_gp.c
+++ b/drivers/gpu/drm/lima/lima_gp.c
@@ -166,6 +166,11 @@ static void lima_gp_task_run(struct lima_sched_pipe *pipe,
 	gp_write(LIMA_GP_CMD, cmd);
 }
 
+static int lima_gp_bus_stop_poll(struct lima_ip *ip)
+{
+	return !!(gp_read(LIMA_GP_STATUS) & LIMA_GP_STATUS_BUS_STOPPED);
+}
+
 static int lima_gp_hard_reset_poll(struct lima_ip *ip)
 {
 	gp_write(LIMA_GP_PERF_CNT_0_LIMIT, 0xC01A0000);
@@ -179,6 +184,13 @@ static int lima_gp_hard_reset(struct lima_ip *ip)
 
 	gp_write(LIMA_GP_PERF_CNT_0_LIMIT, 0xC0FFE000);
 	gp_write(LIMA_GP_INT_MASK, 0);
+
+	gp_write(LIMA_GP_CMD, LIMA_GP_CMD_STOP_BUS);
+	ret = lima_poll_timeout(ip, lima_gp_bus_stop_poll, 10, 100);
+	if (ret) {
+		dev_err(dev->dev, "%s bus stop timeout\n", lima_ip_name(ip));
+		return ret;
+	}
 	gp_write(LIMA_GP_CMD, LIMA_GP_CMD_RESET);
 	ret = lima_poll_timeout(ip, lima_gp_hard_reset_poll, 10, 100);
 	if (ret) {
-- 
2.43.0



