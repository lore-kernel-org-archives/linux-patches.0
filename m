Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BB71DEFD8;
	Wed, 19 Mar 2025 14:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395212; cv=none; b=Hq+LdQV5Y/+NH1XaK86vB3p0DiTGci1Sx7GgGOfCuhR9MN/fWyUMcDq7y+x0pZX7qSrN52WmDf7AqRteUyQ8WbvhgaYs0fkdcE2srBUwGLS2EvIUqvWp0HL1AwhmgW2zCs19+ES8+i5vOC2FV6ETb9KkFS6e3hLJGX9YSiygYys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395212; c=relaxed/simple;
	bh=IAIaVO9Pg/Wnn1Aj8X4lR/bFxT/NO/niRfMy8NVZvuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Auu7MjiTilZMIWEILJBvzIxtUE4C0Tp9jknNvoB4Zggz0gIVIQQKyYiEK5qhH3zjhiBm2ON67Gxx8/i14wtLwL3M6RSkzZMEcIjXp54Q/0Rlj9ST3BTfk4E+L950GUHxQkfR2fp/Q/X0PM87pLC0HQfm7Qu4UYXEra6JCopWLeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NUW3Q8q+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NUW3Q8q+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5382C4CEE4;
	Wed, 19 Mar 2025 14:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395211;
	bh=IAIaVO9Pg/Wnn1Aj8X4lR/bFxT/NO/niRfMy8NVZvuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NUW3Q8q+9wLyfjMdi8oS2p5iAydb4l1Kz3UiVhw4F6rJyu/bdfcv66N9nH6YpWNkE
	 oDKM08yYPqngQLapuC1cBDaPJL0bYZx5beE6G96DzdfTX8phKU2Qzjn2osr4LWovNX
	 GGIWPEYATvIMXrxP+PDX7bcv7foxAyuHFCVk8VOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/166] ASoC: SOF: amd: Handle IPC replies before FW_BOOT_COMPLETE
Date: Wed, 19 Mar 2025 07:30:44 -0700
Message-ID: <20250319143021.989432108@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fcb54f545fea3..a4e9bc20adaff 100644
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



