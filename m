Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56BA302741;
	Wed, 28 Jan 2026 15:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615854; cv=none; b=WTe7mC8bYKZn/HZpPSMZjc73GZQ/qtdu/YV1U6+WPZ0BEeaNV25PS/Msjj+cLm5TY4ZZDbX2aeeUwuYysD3sjPq1kkvUoc1GkZOd19rUqoecDq7p1oVtSaj9IluudWiM5c6+/rgjLMfln1UqVI9HaGy3a+DsLMwhpogPDB5OU5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615854; c=relaxed/simple;
	bh=PJGIZMNroizbX4tOJPLhXEdb2ZGW6xfCEQdFMg3+dK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ln8xqJgf6pMm1yuu2dD1djcxkh5pT72nggwr2a7MZ1qC+R4HvuDfXIPaIlwhcU6dwu63ywCmxhsCmJ2wUB/p3ry9hNZVzVCPlaOy8x1hwRb+3HMCk+FYCjFunVA6QvU1SYRe9CmS9Y4h531kapmLcHRryj4jqBFs50p6nqHdme4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RPdGTejy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RPdGTejy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E00C4CEF1;
	Wed, 28 Jan 2026 15:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615854;
	bh=PJGIZMNroizbX4tOJPLhXEdb2ZGW6xfCEQdFMg3+dK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RPdGTejyN2JF6DechtwcneVhgh00uhrK6c8LpAU/ffJwsqJ2Hj4Ox6Z/uloNTPnXM
	 d0BxpdndWvGOWyiYGCws+rMB5V9lvpSoe4v1JeQqRV2gW6LEdurRFiYviFsewJLqN6
	 AFPrZE6gfz1eCL1ztglK6x/SJFiBTUR4jR8yKshw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brajesh Gupta <brajesh.gupta@imgtec.com>,
	Matt Coster <matt.coster@imgtec.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 101/227] drm/imagination: Wait for FW trace update command completion
Date: Wed, 28 Jan 2026 16:22:26 +0100
Message-ID: <20260128145348.099957874@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brajesh Gupta <brajesh.gupta@imgtec.com>

[ Upstream commit 812062e74a3945b575dce89d330b67cb50054a77 ]

Possibility of no FW trace available after update in the fw_trace_mask due
to asynchronous mode of command consumption in the FW.

To ensure FW trace is available after update, wait for FW trace log update
command completion from the FW.

Fixes: cc1aeedb98ad ("drm/imagination: Implement firmware infrastructure and META FW support")
Signed-off-by: Brajesh Gupta <brajesh.gupta@imgtec.com>
Reviewed-by: Matt Coster <matt.coster@imgtec.com>
Link: https://patch.msgid.link/20260108040936.129769-1-brajesh.gupta@imgtec.com
Signed-off-by: Matt Coster <matt.coster@imgtec.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imagination/pvr_fw_trace.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/imagination/pvr_fw_trace.c b/drivers/gpu/drm/imagination/pvr_fw_trace.c
index a1098b5214856..e7f4554510fd4 100644
--- a/drivers/gpu/drm/imagination/pvr_fw_trace.c
+++ b/drivers/gpu/drm/imagination/pvr_fw_trace.c
@@ -136,6 +136,7 @@ update_logtype(struct pvr_device *pvr_dev, u32 group_mask)
 	struct rogue_fwif_kccb_cmd cmd;
 	int idx;
 	int err;
+	int slot;
 
 	if (group_mask)
 		fw_trace->tracebuf_ctrl->log_type = ROGUE_FWIF_LOG_TYPE_TRACE | group_mask;
@@ -153,8 +154,13 @@ update_logtype(struct pvr_device *pvr_dev, u32 group_mask)
 	cmd.cmd_type = ROGUE_FWIF_KCCB_CMD_LOGTYPE_UPDATE;
 	cmd.kccb_flags = 0;
 
-	err = pvr_kccb_send_cmd(pvr_dev, &cmd, NULL);
+	err = pvr_kccb_send_cmd(pvr_dev, &cmd, &slot);
+	if (err)
+		goto err_drm_dev_exit;
+
+	err = pvr_kccb_wait_for_completion(pvr_dev, slot, HZ, NULL);
 
+err_drm_dev_exit:
 	drm_dev_exit(idx);
 
 err_up_read:
-- 
2.51.0



