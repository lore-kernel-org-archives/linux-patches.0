Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E142E612E;
	Tue, 16 Jun 2026 15:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623344; cv=none; b=jvQ9NTdqj5bALAlQkDCFetexSFcAMUEcZX20HW5i7Jzbbx5PQBx3jWHSmUsFyc6w1CNrKskvOIvrbyYtDZ0Y0cA31F6wU3FtOo4aWtKh443HBlrLzPPX+OipSkrZ3jEgGmx/+WxzBhRk1bHOIy/U2xL4djpd+jdEGRJH5X14Ajs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623344; c=relaxed/simple;
	bh=CJQDFi9AbYi8nS/3EOMRaKfQeP3tSqUgC2RAuH1wnc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxCqf/pNkWcIAijwZFP+UeQEQWjF68YSNApNNuJ8g9xnZs1XLAaQQTiuYSWdFRLiugN9LnAZX0tVnr1FuMHPqNkjpmtQcmLhqxSDwZzj480KUSeT8Pqxd3RUIU0ZHoytZBiIxO7Iy+8/XndXdArI0azg3HL+6k3XRGn59r1Ry6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u/wtk4+b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u/wtk4+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C33F1F000E9;
	Tue, 16 Jun 2026 15:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623343;
	bh=6UZFIujp9EJCI1fqGLLn2ATMeM6P3w6y+9bo/CqESjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u/wtk4+b++fcRUiNmVJC1fw8qCfmmmyFzzXEwcAEUc4S9C4OrbvzPL6rcT+NZBJIq
	 CwRFc6UvpjdppgwQ0Eahf6P4LW5EzLaJwoT++6aZkGoC2V7StHRc9lPqrb+HTs+2r8
	 R+s9gvmEnE4wtOCPO0LpCMMCmTRqAw++YCfn9TmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Umang Jain <uajain@igalia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 130/378] ASoC: SOF: amd: fix for ipc flags check
Date: Tue, 16 Jun 2026 20:26:01 +0530
Message-ID: <20260616145117.162602425@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 6042c91df60e825625bc7d5c5c3b5a87b91d5805 ]

Firmware will set dsp_ack to 1 when firmware sends response for the IPC
command issued by host. Similarly dsp_msg flag will be updated to 1.

During ACP D0 entry, the value read from the sof_dsp_ack_write scratch
flag can be uninitialized. A non-zero garbage value is treated as a
pending DSP IPC ack before SOF_FW_BOOT_COMPLETE, causing a spurious
"IPC reply before FW_BOOT_COMPLETE" log.

Fix the condition checks for ipc flags.

Fixes: 738a2b5e2cc9 ("ASoC: SOF: amd: Add IPC support for ACP IP block")
Link: https://github.com/thesofproject/linux/pull/5642
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Tested-by: Umang Jain <uajain@igalia.com>
Link: https://patch.msgid.link/20260609160938.3717513-1-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/amd/acp-ipc.c | 4 ++--
 sound/soc/sof/amd/acp.h     | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/amd/acp-ipc.c b/sound/soc/sof/amd/acp-ipc.c
index 3cd4674dd80075..94025bc799ea40 100644
--- a/sound/soc/sof/amd/acp-ipc.c
+++ b/sound/soc/sof/amd/acp-ipc.c
@@ -181,14 +181,14 @@ irqreturn_t acp_sof_ipc_irq_thread(int irq, void *context)
 	}
 
 	dsp_msg = snd_sof_dsp_read(sdev, ACP_DSP_BAR, ACP_SCRATCH_REG_0 + dsp_msg_write);
-	if (dsp_msg) {
+	if (dsp_msg == ACP_DSP_MSG_SET) {
 		snd_sof_ipc_msgs_rx(sdev);
 		acp_dsp_ipc_host_done(sdev);
 		ipc_irq = true;
 	}
 
 	dsp_ack = snd_sof_dsp_read(sdev, ACP_DSP_BAR, ACP_SCRATCH_REG_0 + dsp_ack_write);
-	if (dsp_ack) {
+	if (dsp_ack == ACP_DSP_ACK_SET) {
 		if (likely(sdev->fw_state == SOF_FW_BOOT_COMPLETE)) {
 			guard(spinlock_irq)(&sdev->ipc_lock);
 
diff --git a/sound/soc/sof/amd/acp.h b/sound/soc/sof/amd/acp.h
index 2b7ea8c6410602..7bcb76676a984a 100644
--- a/sound/soc/sof/amd/acp.h
+++ b/sound/soc/sof/amd/acp.h
@@ -116,6 +116,8 @@
 #define ACP_SRAM_PAGE_COUNT			128
 #define ACP6X_SDW_MAX_MANAGER_COUNT		2
 #define ACP70_SDW_MAX_MANAGER_COUNT		ACP6X_SDW_MAX_MANAGER_COUNT
+#define ACP_DSP_MSG_SET				1
+#define ACP_DSP_ACK_SET				1
 
 enum clock_source {
 	ACP_CLOCK_96M = 0,
-- 
2.53.0



