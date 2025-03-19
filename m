Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCD31B2194;
	Wed, 19 Mar 2025 14:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394912; cv=none; b=mJyQILrbsPWPq90v+4RNt2Q+Qb6HQ8xwVKuxQ7XH0dlVfCx5TTg5Er6E3a73tAy1h8DE2QOza4C0nbRQPA3ScoPLx3m4X3mI0scnN0Ym1qbAaRmzBkVfCpG1gjKVZZy/GYcm+/USg7wm0NjY3oyEqXQHRkFGZ3GylPGVbeukX9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394912; c=relaxed/simple;
	bh=xc13w1/m0R4RhR06Whudbke44zAksu/vPbl7VYH8Pbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjzz27cQlhbV5Gm3pxay43GQ5duEkwJiz8J167ulCMw455esPagckycRwgwRxWv4LhTD5xHTAh7P6wUbkYGIixP3OHYSj5lYtrbTfnsyx67RhyMzZWAWSnEQFbQMQ046nm7OKJq54nBVS5RCGHePSVHr/NrhlVn3v0/efWBlRhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sqks/XmE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sqks/XmE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1015CC4CEE4;
	Wed, 19 Mar 2025 14:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394912;
	bh=xc13w1/m0R4RhR06Whudbke44zAksu/vPbl7VYH8Pbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sqks/XmELTEG1ATlHwsQvZVKW2VEPYqxpt9jbRPCKudBc3fBJQOsOSgMayODNziUu
	 EdZ+28oIHXrVjQXJX2tsjPKOP+J1R3ccXQDK+6eWyA7xrVDtEjp/JCnZeCIDPN0VBr
	 b6+7pICwunulxHjx9Sgf4IZSwW3PnBiasXLFCmdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 122/241] ASoC: SOF: amd: Handle IPC replies before FW_BOOT_COMPLETE
Date: Wed, 19 Mar 2025 07:29:52 -0700
Message-ID: <20250319143030.742169329@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit ac84ca815adb4171a4276b1d44096b75f6a150b7 ]

In some cases, e.g. during resuming from suspend, there is a possibility
that some IPC reply messages get received by the host while the DSP
firmware has not yet reached the complete boot state.

Detect when this happens and do not attempt to process the unexpected
replies from DSP.  Instead, provide proper debugging support.

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://patch.msgid.link/20250207-sof-vangogh-fixes-v1-3-67824c1e4c9a@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/amd/acp-ipc.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/sound/soc/sof/amd/acp-ipc.c b/sound/soc/sof/amd/acp-ipc.c
index 5f371d9263f3b..12caefd087885 100644
--- a/sound/soc/sof/amd/acp-ipc.c
+++ b/sound/soc/sof/amd/acp-ipc.c
@@ -167,6 +167,7 @@ irqreturn_t acp_sof_ipc_irq_thread(int irq, void *context)
 
 	if (sdev->first_boot && sdev->fw_state != SOF_FW_BOOT_COMPLETE) {
 		acp_mailbox_read(sdev, sdev->dsp_box.offset, &status, sizeof(status));
+
 		if ((status & SOF_IPC_PANIC_MAGIC_MASK) == SOF_IPC_PANIC_MAGIC) {
 			snd_sof_dsp_panic(sdev, sdev->dsp_box.offset + sizeof(status),
 					  true);
@@ -188,13 +189,21 @@ irqreturn_t acp_sof_ipc_irq_thread(int irq, void *context)
 
 	dsp_ack = snd_sof_dsp_read(sdev, ACP_DSP_BAR, ACP_SCRATCH_REG_0 + dsp_ack_write);
 	if (dsp_ack) {
-		spin_lock_irq(&sdev->ipc_lock);
-		/* handle immediate reply from DSP core */
-		acp_dsp_ipc_get_reply(sdev);
-		snd_sof_ipc_reply(sdev, 0);
-		/* set the done bit */
-		acp_dsp_ipc_dsp_done(sdev);
-		spin_unlock_irq(&sdev->ipc_lock);
+		if (likely(sdev->fw_state == SOF_FW_BOOT_COMPLETE)) {
+			spin_lock_irq(&sdev->ipc_lock);
+
+			/* handle immediate reply from DSP core */
+			acp_dsp_ipc_get_reply(sdev);
+			snd_sof_ipc_reply(sdev, 0);
+			/* set the done bit */
+			acp_dsp_ipc_dsp_done(sdev);
+
+			spin_unlock_irq(&sdev->ipc_lock);
+		} else {
+			dev_dbg_ratelimited(sdev->dev, "IPC reply before FW_BOOT_COMPLETE: %#x\n",
+					    dsp_ack);
+		}
+
 		ipc_irq = true;
 	}
 
-- 
2.39.5



