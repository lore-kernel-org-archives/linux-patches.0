Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DD97E58C;
	Mon,  8 Apr 2024 13:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583508; cv=none; b=AFL6I8MIhxrOG5ooWZmh4ojoZW+KVY7WTC+cuS102+MVRWe+eWF6eL3JnGiifYlR96bfpjW8d2WFaVwdhya3nMMCaVJNn/kQVXePBu6lYBdYnChQWgu2dc9kTOdTTeT0VLp6JdwBBmvQWPT48EUNHUh9XM6Z45JSSVSRUwX179I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583508; c=relaxed/simple;
	bh=ab5jvdAGkJ6JBAGBFHW5cIq6n+8LjgUgiK8mjwprRtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BhIS9FCPoErRkROuoEmADxNGGncKLtFUKMyomYrUy5oKkHJUjCCrTm59NTeQTjQkcGd2+koChcAGC1CHF9ujDmMHqsJkmhaDoqn0Qhjrs6HfY/GN1sXJVGXwYBtpHocgtQu7k57koCBRjVqbPPJN9rIj7YZX/OLvGNHw0tMEslo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mmmpZXPb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mmmpZXPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED04C433F1;
	Mon,  8 Apr 2024 13:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583508;
	bh=ab5jvdAGkJ6JBAGBFHW5cIq6n+8LjgUgiK8mjwprRtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mmmpZXPbo3l9M5oG23IHsTJMvJ7fmInTVj7n9doGepLOBlaqip6i7cjm7VWrVL3KD
	 M7kJ8ahOthKVoufW6tgA3ECYNkbupn4Ust+i5HzX8idRe4eUBjAjQ7pSmv/xh4wsfY
	 qV7eeZvys1macgy35Md3K1PRbDUDH90uYGXNtG6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 186/273] ASoC: SOF: amd: fix for false dsp interrupts
Date: Mon,  8 Apr 2024 14:57:41 +0200
Message-ID: <20240408125315.067549998@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 4db8cdc91daae..2c242ef9f23c1 100644
--- a/sound/soc/sof/amd/acp.c
+++ b/sound/soc/sof/amd/acp.c
@@ -537,6 +537,10 @@ int amd_sof_acp_probe(struct snd_sof_dev *sdev)
 		goto unregister_dev;
 	}
 
+	ret = acp_init(sdev);
+	if (ret < 0)
+		goto free_smn_dev;
+
 	sdev->ipc_irq = pci->irq;
 	ret = request_threaded_irq(sdev->ipc_irq, acp_irq_handler, acp_irq_thread,
 				   IRQF_SHARED, "AudioDSP", sdev);
@@ -546,10 +550,6 @@ int amd_sof_acp_probe(struct snd_sof_dev *sdev)
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



