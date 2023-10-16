Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6F21D55F
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dl5BLUBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97831C433C9;
	Mon, 16 Oct 2023 14:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467640;
	bh=7/Z40aGeKWIITDA9xt01/HF8L5Drvov2hQsd6Y5GQcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dl5BLUBPmhnqBUHl4v7m3H2xf9pp0m9n4iEb4U6B7SyfWyVeAX7qVB5/jCYqjpE6N
	 om79qzOE3G4yYTLedBOw0OKjaZCRtt544W41ROkrKGQBwGSa9IOkqIf+n8XDs0tGV0
	 r16k8dc6Zw9n61Oq/nLnIGUMvw+/lgKv1CYjVMNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	coolstar <coolstarorganization@gmail.com>,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.5 031/191] ASoC: SOF: amd: fix for firmware reload failure after playback
Date: Mon, 16 Oct 2023 10:40:16 +0200
Message-ID: <20231016084016.126371635@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

commit 7e1fe5d9e7eae67e218f878195d1d348d01f9af7 upstream.

Setting ACP ACLK as clock source when ACP enters D0 state causing
firmware load failure as mentioned in below scenario.

- Load snd_sof_amd_rembrandt
- Play or Record audio
- Stop audio
- Unload snd_sof_amd_rembrandt
- Reload snd_sof_amd_rembrandt

If acp_clkmux_sel register field is set, then clock source will be
set to ACP ACLK when ACP enters D0 state.

During stream stop, if there is no active stream is running then
acp firmware will set the ACP ACLK value to zero.

When driver is reloaded and clock source is selected as ACP ACLK,
as ACP ACLK is programmed to zero, firmware loading will fail.

For RMB platform, remove the clock mux selection field so that
ACP will use internal clock source when ACP enters D0 state.

Fixes: 41cb85bc4b52 ("ASoC: SOF: amd: Add support for Rembrandt plaform.")
Reported-by: coolstar <coolstarorganization@gmail.com>
Closes: https://github.com/thesofproject/sof/issues/8137
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://lore.kernel.org/r/20230927071412.2416250-1-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/amd/pci-rmb.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/soc/sof/amd/pci-rmb.c
+++ b/sound/soc/sof/amd/pci-rmb.c
@@ -34,7 +34,6 @@ static const struct sof_amd_acp_desc rem
 	.dsp_intr_base	= ACP6X_DSP_SW_INTR_BASE,
 	.sram_pte_offset = ACP6X_SRAM_PTE_OFFSET,
 	.hw_semaphore_offset = ACP6X_AXI2DAGB_SEM_0,
-	.acp_clkmux_sel = ACP6X_CLKMUX_SEL,
 	.fusion_dsp_offset = ACP6X_DSP_FUSION_RUNSTALL,
 };
 


