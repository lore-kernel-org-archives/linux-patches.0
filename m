Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B495F411FA8;
	Thu, 17 Sep 2026 18:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668043; cv=none; b=siSOwS4ypx+3e4S7WIfmCpWg8r5oaC2AnczRu/xvmIt/mJ7CCWHEQ/7oxcKjpqQVTGDh/W0npzoIG9uQ0s0NZgW1/XPqMFu3cWNuDgt/9x8GUzALBa36IprpCLWZHv7gCcDyQk8SmN38CXR7qHUiz6TcgMwlVdA8x+z3oex+gLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668043; c=relaxed/simple;
	bh=vTBL7VnAMJ81hX0FOHCWLcg/JX0GdMIO3Syjd7MbRFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJn7Adgb80A7gyxc/G/d4lhb4v7n3K4t7Ylro01GjmfXa+LR0zsjLn0sR54i2SXG0xZPDhu6DY+8lZ0U1HkwdE96PguzynSuKfN3ukxpMTTmRII6gjAFxCKRYy/JVij7oA61MGxSEkay146Om1Jc2eRHWOX0kDPNN08Il6ny9U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YpGbnNVb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YpGbnNVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA7C1F000FF;
	Thu, 17 Sep 2026 18:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668042;
	bh=XgtM0p9z5mCcxrfe9UWjPBkEgD8s7w6O9tkKKAtDA+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YpGbnNVbO6JLULMdRhB5vcvwVFRskiBvj5FbLCeDBWW8ITsJGCqzYU8khfcSrhtax
	 5t/2qPNDJQWjPwsFogReTk2s4rHPhvBxKBZZqsdlhNkxZImR4oqC/fSZ8mMHo6lSCq
	 4G3YhpVAWwFrkQTkvMjkp7PUMROqlg+NR5BYNgfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI Review <sashiko-bot@kernel.org>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0295/1102] ASoC: rockchip: rockchip_pdm: Handle runtime PM resume failures in set_fmt
Date: Thu, 17 Sep 2026 16:03:58 +0100
Message-ID: <20260917151547.022315008@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit ee7b5f7b39332febf917f9ebf212842cc9379815 ]

rockchip_pdm_set_fmt() calls pm_runtime_get_sync() before accessing
hardware registers, but ignores its return value.
If the runtime resume fails, the function continues to perform register
accesses while the device state is undefined.
Replace pm_runtime_get_sync() with pm_runtime_resume_and_get() and
return early on failure to avoid unpowered register accesses.

Reported-by: Sashiko AI Review <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260522110302.349421F000E9@smtp.kernel.org/
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260602101608.45137-6-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_pdm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/rockchip/rockchip_pdm.c b/sound/soc/rockchip/rockchip_pdm.c
index 30d51e03d49e9..1549800887416 100644
--- a/sound/soc/rockchip/rockchip_pdm.c
+++ b/sound/soc/rockchip/rockchip_pdm.c
@@ -321,6 +321,7 @@ static int rockchip_pdm_set_fmt(struct snd_soc_dai *cpu_dai,
 {
 	struct rk_pdm_dev *pdm = to_info(cpu_dai);
 	unsigned int mask = 0, val = 0;
+	int ret;
 
 	mask = PDM_CKP_MSK;
 	switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
@@ -334,7 +335,10 @@ static int rockchip_pdm_set_fmt(struct snd_soc_dai *cpu_dai,
 		return -EINVAL;
 	}
 
-	pm_runtime_get_sync(cpu_dai->dev);
+	ret = pm_runtime_resume_and_get(cpu_dai->dev);
+	if (ret)
+		return ret;
+
 	regmap_update_bits(pdm->regmap, PDM_CLK_CTRL, mask, val);
 	pm_runtime_put(cpu_dai->dev);
 
-- 
2.53.0



