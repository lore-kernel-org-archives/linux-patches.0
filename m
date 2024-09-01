Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7541C68C;
	Sun,  1 Sep 2024 16:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208825; cv=none; b=u8fd4CqRF1NWf8TQbIZeqRIBCeV5xkbK9w4uFK5nBTXxMDwUvy5h046jBrDxE468CQKzIj9zVPF2gO/omonQH+lMLhXAqBP8gYi4yI9WYL81sfCvrXFBEGZj5dbHdAVVN66ZEK+vd743WwX59uTjEjmTIhVCshg3o8X9aLdHIR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208825; c=relaxed/simple;
	bh=x8cpt4cpdqXaayB7ZI1OK4dmRUs+YJjoHtmX9jdWR/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6aJHLHY4Is4N1YecffIhov/HpvBcwoRD9j5AvGoARezuVEWkRgLCEmX0IGiTgqIHbSW+gA+qzlxMoOQL14TUtKGu+ZfB9Ie8vMySvv+e/H+IqdRNWJ7+pOT8wgu7Of/kGZ6FE28TkFbSHS2j4L0ceUJckhtk6RqIgn/X3KeQDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bbVowFIS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bbVowFIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8CCC4CEC3;
	Sun,  1 Sep 2024 16:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208824;
	bh=x8cpt4cpdqXaayB7ZI1OK4dmRUs+YJjoHtmX9jdWR/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bbVowFISzlhCEX7c9321cR0EWT6zhOPA12kSFqqgb8AZ4u6TqBxeFaoqR6Ki3bFte
	 qFM6bcluTUKJghaSZp9bWeRrFc1uYO/Osg/aBkO6eDq2rqwzpeUPi7SjUVdPKHCQCs
	 x7dp56sAolD8wr04g7V5UKo8aBOelYylGZcPfRBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erico Nunes <nunes.erico@gmail.com>,
	Qiang Yu <yuq825@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 049/134] drm/lima: set gp bus_stop bit before hard reset
Date: Sun,  1 Sep 2024 18:16:35 +0200
Message-ID: <20240901160811.954339224@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 3fca560087c97..4bf216cb33030 100644
--- a/drivers/gpu/drm/lima/lima_gp.c
+++ b/drivers/gpu/drm/lima/lima_gp.c
@@ -138,6 +138,11 @@ static void lima_gp_task_run(struct lima_sched_pipe *pipe,
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
@@ -151,6 +156,13 @@ static int lima_gp_hard_reset(struct lima_ip *ip)
 
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



