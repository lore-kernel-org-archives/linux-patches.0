Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC70139579;
	Tue, 26 Aug 2025 13:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214717; cv=none; b=sbN7PAx/Ps1AlJzZmZvUDFFJ15LuKeP+4XqzUSlnV3222TFeA8dWiJOcRbp7uJgLiXlIfzidx/f0l07FnDTn/E3Nbj+TWe89kUcksPTcOQD3509PRS17+HuXFSpuJTJwuNAEb/79Ohb10cGHlUxP3f9otY9tyQmpvt9uRHWrHTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214717; c=relaxed/simple;
	bh=JJCKzPF7cAs7jjfuq49Aupt8iNChrsuSPP5BQk22SXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZcJbchQJ5TTLBhbfPocAMQNELkgrfahhZaP9wsL8GokjDah9bOzY/fglV7KLQQczMLQKO7D3uOk3osdJmyKWc5egcqw4jHP84/1ZNnXrBGtpGfpgzDEk3abpuT5f/IjuWsfiTuYEN1xLkDFjhJPgPEo7ORA025H22VsHcc2Ci5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gYGqKWH5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gYGqKWH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB92C4CEF1;
	Tue, 26 Aug 2025 13:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214717;
	bh=JJCKzPF7cAs7jjfuq49Aupt8iNChrsuSPP5BQk22SXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gYGqKWH5guGUCdvFpMOKELaYPETxDSHj21qMifKWGQVj8Cx0d3lhNhSXFjZhsKFk1
	 3Im/ocGzy3LjGb6rZ5+P+/48cdezEB9Gjgu+sGCqgWAMQZbEXPZ+T3T8pSXNMlN1Io
	 krF1Eqf3shXvoMTebn1nQE8sjY9ZDcwZEtaIVRtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 242/482] ASoC: fsl_sai: replace regmap_write with regmap_update_bits
Date: Tue, 26 Aug 2025 13:08:15 +0200
Message-ID: <20250826110936.749383663@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 0e270f32975fd21874185ba53653630dd40bf560 ]

Use the regmap_write() for software reset in fsl_sai_config_disable would
cause the FSL_SAI_CSR_BCE bit to be cleared. Refer to
commit 197c53c8ecb34 ("ASoC: fsl_sai: Don't disable bitclock for i.MX8MP")
FSL_SAI_CSR_BCE should not be cleared. So need to use regmap_update_bits()
instead of regmap_write() for these bit operations.

Fixes: dc78f7e59169d ("ASoC: fsl_sai: Force a software reset when starting in consumer mode")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20250807020318.2143219-1-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_sai.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 33d01a5e9b31..e622c8375a46 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -768,9 +768,9 @@ static void fsl_sai_config_disable(struct fsl_sai *sai, int dir)
 	 * are running concurrently.
 	 */
 	/* Software Reset */
-	regmap_write(sai->regmap, FSL_SAI_xCSR(tx, ofs), FSL_SAI_CSR_SR);
+	regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx, ofs), FSL_SAI_CSR_SR, FSL_SAI_CSR_SR);
 	/* Clear SR bit to finish the reset */
-	regmap_write(sai->regmap, FSL_SAI_xCSR(tx, ofs), 0);
+	regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx, ofs), FSL_SAI_CSR_SR, 0);
 }
 
 static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
@@ -889,11 +889,11 @@ static int fsl_sai_dai_probe(struct snd_soc_dai *cpu_dai)
 	unsigned int ofs = sai->soc_data->reg_offset;
 
 	/* Software Reset for both Tx and Rx */
-	regmap_write(sai->regmap, FSL_SAI_TCSR(ofs), FSL_SAI_CSR_SR);
-	regmap_write(sai->regmap, FSL_SAI_RCSR(ofs), FSL_SAI_CSR_SR);
+	regmap_update_bits(sai->regmap, FSL_SAI_TCSR(ofs), FSL_SAI_CSR_SR, FSL_SAI_CSR_SR);
+	regmap_update_bits(sai->regmap, FSL_SAI_RCSR(ofs), FSL_SAI_CSR_SR, FSL_SAI_CSR_SR);
 	/* Clear SR bit to finish the reset */
-	regmap_write(sai->regmap, FSL_SAI_TCSR(ofs), 0);
-	regmap_write(sai->regmap, FSL_SAI_RCSR(ofs), 0);
+	regmap_update_bits(sai->regmap, FSL_SAI_TCSR(ofs), FSL_SAI_CSR_SR, 0);
+	regmap_update_bits(sai->regmap, FSL_SAI_RCSR(ofs), FSL_SAI_CSR_SR, 0);
 
 	regmap_update_bits(sai->regmap, FSL_SAI_TCR1(ofs),
 			   FSL_SAI_CR1_RFW_MASK(sai->soc_data->fifo_depth),
@@ -1694,11 +1694,11 @@ static int fsl_sai_runtime_resume(struct device *dev)
 
 	regcache_cache_only(sai->regmap, false);
 	regcache_mark_dirty(sai->regmap);
-	regmap_write(sai->regmap, FSL_SAI_TCSR(ofs), FSL_SAI_CSR_SR);
-	regmap_write(sai->regmap, FSL_SAI_RCSR(ofs), FSL_SAI_CSR_SR);
+	regmap_update_bits(sai->regmap, FSL_SAI_TCSR(ofs), FSL_SAI_CSR_SR, FSL_SAI_CSR_SR);
+	regmap_update_bits(sai->regmap, FSL_SAI_RCSR(ofs), FSL_SAI_CSR_SR, FSL_SAI_CSR_SR);
 	usleep_range(1000, 2000);
-	regmap_write(sai->regmap, FSL_SAI_TCSR(ofs), 0);
-	regmap_write(sai->regmap, FSL_SAI_RCSR(ofs), 0);
+	regmap_update_bits(sai->regmap, FSL_SAI_TCSR(ofs), FSL_SAI_CSR_SR, 0);
+	regmap_update_bits(sai->regmap, FSL_SAI_RCSR(ofs), FSL_SAI_CSR_SR, 0);
 
 	ret = regcache_sync(sai->regmap);
 	if (ret)
-- 
2.50.1



