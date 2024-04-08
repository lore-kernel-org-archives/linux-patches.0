Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E5512AAC3;
	Mon,  8 Apr 2024 13:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583442; cv=none; b=db+DtCWBJJThoF7lY21T/e8SyUSW4rDi8dfLI8G5jek+Sguck5Rbjr4TzFU+ySylVEuTJqG9xO6Cs+iixa4kAE9/yvD9MWVuGbSIdZwN4iLVU+EB/map+w3wTfjbD9gt1taJ4WGWj9+pVLd/gTmKNi26gSfe0bsUx9vGTyQ6YyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583442; c=relaxed/simple;
	bh=8WnXANvX861nRnLOTdNQ+JiRaLfrNJyvo8uCCNgQ53M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGY0drHnbSIpzg1/cXy9NNTge4y1UTRYUWSv4IRfkmUDq9KqQSA7Q3xzpRXfmLGd9HWWlarn1TtXm/qD9tEA+KeJQP2NQBjVJpmFrIJMbsf83Rv5CJq0uaQy0sV9alfmQfrYnCgiknAOsdclX/krL6f3H8xSt+7XnP0QeCPBjRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tnJl/XY6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tnJl/XY6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A7CC433F1;
	Mon,  8 Apr 2024 13:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583442;
	bh=8WnXANvX861nRnLOTdNQ+JiRaLfrNJyvo8uCCNgQ53M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tnJl/XY6eH9WH+C9ppV2B1TdPRvGhJoK8fyvfhuUIxo7uATOFn9Iawc0tsXtL+VuL
	 4Y7ZI+pYEUs1IbXcn63xXC5TFp/vlezDpNimXQoEDQ41I8i+25johQ+F0pfY5e+386
	 OkKaIxwicRcFDhSm5MzeP1zettfsThbcbf8q4qB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 196/252] ASoC: SOF: amd: fix for false dsp interrupts
Date: Mon,  8 Apr 2024 14:58:15 +0200
Message-ID: <20240408125312.737542426@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit b9846a386734e73a1414950ebfd50f04919f5e24 ]

Before ACP firmware loading, DSP interrupts are not expected.
Sometimes after reboot, it's observed that before ACP firmware is loaded
false DSP interrupt is reported.
Registering the interrupt handler before acp initialization causing false
interrupts sometimes on reboot as ACP reset is not applied.
Correct the sequence by invoking acp initialization sequence prior to
registering interrupt handler.

Fixes: 738a2b5e2cc9 ("ASoC: SOF: amd: Add IPC support for ACP IP block")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://msgid.link/r/20240404041717.430545-1-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/amd/acp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/sof/amd/acp.c b/sound/soc/sof/amd/acp.c
index 4c54ce212de6a..cc006d7038d97 100644
--- a/sound/soc/sof/amd/acp.c
+++ b/sound/soc/sof/amd/acp.c
@@ -522,6 +522,10 @@ int amd_sof_acp_probe(struct snd_sof_dev *sdev)
 		goto unregister_dev;
 	}
 
+	ret = acp_init(sdev);
+	if (ret < 0)
+		goto free_smn_dev;
+
 	sdev->ipc_irq = pci->irq;
 	ret = request_threaded_irq(sdev->ipc_irq, acp_irq_handler, acp_irq_thread,
 				   IRQF_SHARED, "AudioDSP", sdev);
@@ -531,10 +535,6 @@ int amd_sof_acp_probe(struct snd_sof_dev *sdev)
 		goto free_smn_dev;
 	}
 
-	ret = acp_init(sdev);
-	if (ret < 0)
-		goto free_ipc_irq;
-
 	sdev->dsp_box.offset = 0;
 	sdev->dsp_box.size = BOX_SIZE_512;
 
-- 
2.43.0



