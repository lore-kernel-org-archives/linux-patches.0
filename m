Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624732;
	b=EQb6suOS1YKcU36HcM8mucachVCIL7E8yKYwazeO0KqI0hpuK4QnTyyHhu1+i+qKbaA7
	 bLd4+pHy1TCkH170WxOVOI8Nxrlbtjoom4NfBG61m6oKujRqz7Z0Dqqy4jjWyIx5DlJBK
	 ggvchXU+qH8uBlNvPOIYpy0b4OOwcMJoxiJSo5vURq24UMPZodzNB+0NjMyCDS1NVBqpn
	 0df8cmjxYYCLq4gsHzXvaLZ5XF3Fi8oIECvfBJ1lU+ynhscSkfClMOm3ZB7AGtOwRBYwq
	 7avSd5acf/v2EvYjbnVazKzXUrR9JL2CTSm4OrkOIiA3CO0xJhfW5jILv8Nyr9H6hTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624732;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vOkjXLcDWCg0tM9fF06RuYLfkfpB2UHtAjdswGCzeNM=;
	b=PVrdkDIAJWJ39SnMA4q7aDHuSdj4rexU/OcZlm7iBjTuLjSmkahthYWHFxjDeQNOERGc
	 w6omWxooISC+xH+nuPqqhLgwNz4lgH2HclZtx0UcuwWYkw6D/dAodBNsE5u4R5U9UQrxR
	 r4oBuszjpqWQpkyRqg11Di/OTLACWHle8SOwdCFr1X2+eOMUSEpWeTJkws+Rphv195qES
	 epIIzEEBCILI/MzdcGZ+WKasVSkywvZT4zhNDw4DIRvR4y82hei+JexOa1N5/0E1R0b46
	 0FrrGbtiZ8mO/9YE118AH7nvsVnqYemUXVT3IUWan26BkpmuehoqGtBXYF2NmYGV75Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MZDu7f+5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADBC606A336;
	Wed, 25 Nov 2026 16:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MZDu7f+5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4591F000D1;
	Wed, 25 Nov 2026 16:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624731;
	bh=vOkjXLcDWCg0tM9fF06RuYLfkfpB2UHtAjdswGCzeNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MZDu7f+5bMLA1MXgQGCCkZcXVnOi5ip5i+/E21SgpCrQx7zd4ho1sNDlB4UIgweaP
	 R3HTjVPQj6pJ1hNwVXVbLUnV5l8pDQ+pvfVmTpNuGqfgiBOI3CxFvEmJQ4ifKNzbAF
	 Wk6n2/SW4wFYrPxX5HKbyRO25RNseRpWDFiIaeIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 290/816] ASoC: SOF: amd: guard adata->sdw dereferences with NULL check in IRQ handler
Date: Wed, 25 Nov 2026 15:30:38 +0100
Message-ID: <20261125143855.918877090@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 34ea81a7f284a13d825279fdede36b7f793f9936 ]

The ACP external IRQ handler is registered before sdw_amd_probe() assigns
adata->sdw, so a stray interrupt in the probe window could reach the
adata->sdw->pdev[i] dereference with adata->sdw still NULL.

The same window exists on the teardown side: after sdw_amd_exit() frees
the context but before adata->sdw is cleared by the caller.

Add NULL checks for adata->sdw in acp_irq_handler() before dereferencing
->pdev[0] and ->pdev[1], and in amd_sof_handle_acp70_sdw_wake_event() for
the same reason.  The interrupt-status register write that acknowledges the
IRQ is kept outside the guard so the hardware bit is always cleared
regardless of whether the SoundWire context is live.

Fixes: 96eb81851012 ("ASoC: SOF: amd: add interrupt handling for SoundWire manager devices")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Fixes: 1f41bf67bfe3 ("ASoC: SOF: amd: add soundwire wake irq handling")
Link: https://patch.msgid.link/20261107175339.3547918-3-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/amd/acp.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/sound/soc/sof/amd/acp.c b/sound/soc/sof/amd/acp.c
index 33eb03051a7b2..a2abcb6d090ce 100644
--- a/sound/soc/sof/amd/acp.c
+++ b/sound/soc/sof/amd/acp.c
@@ -403,16 +403,20 @@ static void amd_sof_handle_acp70_sdw_wake_event(struct acp_dev_data *adata)
 	struct amd_sdw_manager *amd_manager;
 
 	if (adata->acp70_sdw0_wake_event) {
-		amd_manager = dev_get_drvdata(&adata->sdw->pdev[0]->dev);
-		if (amd_manager)
-			pm_request_resume(amd_manager->dev);
+		if (adata->sdw) {
+			amd_manager = dev_get_drvdata(&adata->sdw->pdev[0]->dev);
+			if (amd_manager)
+				pm_request_resume(amd_manager->dev);
+		}
 		adata->acp70_sdw0_wake_event = 0;
 	}
 
 	if (adata->acp70_sdw1_wake_event) {
-		amd_manager = dev_get_drvdata(&adata->sdw->pdev[1]->dev);
-		if (amd_manager)
-			pm_request_resume(amd_manager->dev);
+		if (adata->sdw) {
+			amd_manager = dev_get_drvdata(&adata->sdw->pdev[1]->dev);
+			if (amd_manager)
+				pm_request_resume(amd_manager->dev);
+		}
 		adata->acp70_sdw1_wake_event = 0;
 	}
 }
@@ -504,10 +508,12 @@ static irqreturn_t acp_irq_handler(int irq, void *dev_id)
 
 	val = snd_sof_dsp_read(sdev, ACP_DSP_BAR, desc->ext_intr_stat);
 	if (val & ACP_SDW0_IRQ_MASK) {
-		amd_manager = dev_get_drvdata(&adata->sdw->pdev[0]->dev);
 		snd_sof_dsp_write(sdev, ACP_DSP_BAR, desc->ext_intr_stat, ACP_SDW0_IRQ_MASK);
-		if (amd_manager)
-			schedule_work(&amd_manager->amd_sdw_irq_thread);
+		if (adata->sdw) {
+			amd_manager = dev_get_drvdata(&adata->sdw->pdev[0]->dev);
+			if (amd_manager)
+				schedule_work(&amd_manager->amd_sdw_irq_thread);
+		}
 		irq_flag = 1;
 	}
 
@@ -524,11 +530,13 @@ static irqreturn_t acp_irq_handler(int irq, void *dev_id)
 	if (desc->ext_intr_stat1) {
 		val = snd_sof_dsp_read(sdev, ACP_DSP_BAR, desc->ext_intr_stat1);
 		if (val & ACP_SDW1_IRQ_MASK) {
-			amd_manager = dev_get_drvdata(&adata->sdw->pdev[1]->dev);
 			snd_sof_dsp_write(sdev, ACP_DSP_BAR, desc->ext_intr_stat1,
 					  ACP_SDW1_IRQ_MASK);
-			if (amd_manager)
-				schedule_work(&amd_manager->amd_sdw_irq_thread);
+			if (adata->sdw) {
+				amd_manager = dev_get_drvdata(&adata->sdw->pdev[1]->dev);
+				if (amd_manager)
+					schedule_work(&amd_manager->amd_sdw_irq_thread);
+			}
 			irq_flag = 1;
 		}
 		switch (adata->pci_rev) {
-- 
2.53.0



