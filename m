Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8F51C7B71;
	Tue, 27 Aug 2024 15:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772377; cv=none; b=ke0zFY6HXZe2PKxJGekuEWVCLjri+Bqpqs0cx0+KeCwb5KjKzPBFhHijCuaomPPT52sjW/QerEkCyWcFbTPlqGZA1+8HOJukK0uE7QUk99znJTY5C7hJymZszAxzUq6YbNPyqTmkhQpHVSS0GyNj/Qa8O7G4PIG3RZsOnKWueDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772377; c=relaxed/simple;
	bh=+QcArnx4CATao7C9Avtkh/4qVuKCv9hecm8yvVeWMF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QvUrtjzWssDLk8LrIx7N+P2mfNz/SktTBC91cBY2sqr+26nMzYOzm9m5MEumKzNYBLBTy1wdPbqH6tM3KCn4DX9V6jDW3eoLb/PtC8lS4deaL9k78CSc/Mv/pn5L7b++8PewRH8/EBoVfelrfu8oY+9JJq0/EzMj0jS95erPY0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XUsm24BC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XUsm24BC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D267C61071;
	Tue, 27 Aug 2024 15:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772376;
	bh=+QcArnx4CATao7C9Avtkh/4qVuKCv9hecm8yvVeWMF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XUsm24BCURX9rHuMSwvFdMDIrZCf0XpC/UDGq64PgH+8On5/VU9rSdpqUAau2VPNm
	 oO/RFDo7oF2QIag3utWbdbZVmb2KduF2zSkeLxXgdOa5iy7O4riOrSrs2Wf9o6NKdr
	 RQIpaBXqnttzz6GSk9RZak9SthU0QZS02BzznLfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erico Nunes <nunes.erico@gmail.com>,
	Qiang Yu <yuq825@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 169/321] drm/lima: set gp bus_stop bit before hard reset
Date: Tue, 27 Aug 2024 16:37:57 +0200
Message-ID: <20240827143844.664349339@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



