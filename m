Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621878;
	b=jDX6S5X5dEFIXVJsUoKdX0NZU8tXxb0Yawi0KQY5xlAQ05zCpHTazx3hyksKekWo3A6D
	 LYIDPPOZ3tj6234uwI3AOq83HNnzLzaHj41vEyiQma88Vu5Wj+MgBldDg4bBFkGgxGKNU
	 hHl3+ZlHIT7vludT4q8kAwRqrAcWmKDBlPrYQ3BFq3YK3219lAlAandUFK4uwLp1nPNro
	 LMaJQH6y26zAA/HC1COfcuRiiAtF4M4T57auFCodW+kk7nkDsY5BDstrBwOCsXHvFtpHJ
	 4fmfOCTypKk4fzkrLEY1i4JcRgVpGcz/PsgvziuNI73S1xDm7UTF5inB8TMRFCG3T8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x4D4JCn3Qhlc43oR8C9bAVVUe2i93abXt5DKuUGHsYc=;
	b=EPD3v1YaGE1QI21oBgRE5EnAEtTsTOrzTzbThqq37dteW0A9lIjXHyT3euXOQZHr2cVH
	 ABELqSvQNVe7FWGYWegguCWf+qSgE9fqRecNur8NVazThD6mFOO/6SlVzHoaVh/DBXfZe
	 dqYLOm84gfCZvi9HT9fl4swiv2c9KjZ9BG2rllSGMkRSUgCtiUmeqJXA6hrho63BXSWb4
	 5waK1peLGShWMLHEt+ppUBR/vn95IwINityu0YFl9v/YBYXwIsafRGYTuNyzqG+cKfUDk
	 kkkq2sX7yaeUp9KwBszFE473HvKcE2+EjPXNYGaMEgon1OSq3XL1BAEP4/BGZIXRcNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ncRBbLR5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CAE0606A321;
	Wed, 25 Nov 2026 15:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ncRBbLR5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20FE1F000CF;
	Wed, 25 Nov 2026 15:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621877;
	bh=x4D4JCn3Qhlc43oR8C9bAVVUe2i93abXt5DKuUGHsYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ncRBbLR5Pmb14yyMVDWXrJtxCuCZ+aw7MTTqrdqt0XNEJW6Jd+YuTm6yu0vsGEPJT
	 60GWioHsbuqbYTTYSQOAqVSfaZXxgtePGgC8Nt57SkVY/cEpyBj4nbadS7OzJmNprT
	 xLwpr0tAha5TtqpLbL13x9YtnW2NJXdEbwNuCOZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 363/990] ASoC: SOF: amd: guard adata->sdw dereferences with NULL check in IRQ handler
Date: Wed, 25 Nov 2026 15:28:50 +0100
Message-ID: <20261125143830.595655464@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 475b77b8ea309..e84ab3069b38f 100644
--- a/sound/soc/sof/amd/acp.c
+++ b/sound/soc/sof/amd/acp.c
@@ -394,16 +394,20 @@ static void amd_sof_handle_acp70_sdw_wake_event(struct acp_dev_data *adata)
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
@@ -495,10 +499,12 @@ static irqreturn_t acp_irq_handler(int irq, void *dev_id)
 
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
 
@@ -515,11 +521,13 @@ static irqreturn_t acp_irq_handler(int irq, void *dev_id)
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



