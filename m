Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5D3535FA7;
	Thu, 17 Sep 2026 17:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664523; cv=none; b=QFv4M+UgFI0aQ2ITGn0/mk0Qavi2dOts0yUzdO3P1/9p0F8p+QpBGARPMBWfo7MBY8zrHF/snFRj0l3gR2vThZo8lBv/SAmc6O5biVinvihu8mVaJuUOuRGMFfKjGdv+HZQQgKyAPPBxWflh0UtlO4W4sIaw0wKiIr5SFJmrQhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664523; c=relaxed/simple;
	bh=8iv+qtLGcbrrdr40tJK0vafnEOkRM+L5gbSVujYcN40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQ/Om1i4vW+Ap/zyWOykGBpZKzdgjNzrkrvn244PKJbNtCLq+5M1nrfPreeYTsHJbup2w0yd8JQYSjPO0m1f3FYTKIunholXssg4SNe7VvdcDyPZzO/LpKVJTsgnuAFjA5795VZJKxPsCl7uUXdjEpI62ncmrItRG85sCVnctjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z+HQBCpM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z+HQBCpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0051F00899;
	Thu, 17 Sep 2026 17:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664522;
	bh=5RJJhuxWRnijQDGLcLQwJUtrk2FAXphLmvgdxWGLggI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z+HQBCpMj7y1mQZ0dvkXgdg3Hj0fzJ2Lr6rBAoBEDrm0l88QoOEKbPbKdzA92tweJ
	 H6ZE1EHI7ocR6EZcxo4z5NlGZQyIepEpxoNwaV+C3uAa7n01Q2hk8T+uGB4oi76TnA
	 vlaU9mJh4oiMYJz5hmDDvcx1Mfc+7hzWY8Butkk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI Review <sashiko-bot@kernel.org>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0401/1250] ASoC: rockchip: rockchip_pdm: Handle runtime PM resume failures in set_fmt
Date: Thu, 17 Sep 2026 16:03:16 +0100
Message-ID: <20260917151602.897769689@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c69cdd6f24994..01292b63bf9d6 100644
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



