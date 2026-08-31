Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2FD435A9E;
	Mon, 31 Aug 2026 13:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183352; cv=none; b=AAlAVPIKyFwRyBsDujn+NxkeQTCmE86t3aVd3lu3QCB3LkmrzJNGKtQ95qVaMjqNjd4+Tm+YoX7APWMyGocgweTNigjDE+Bj7eV0ocAw8LIfVe8ktt5vkC5bJbZQW8dj+i9d5R3mHMwDcW+/HOTSDs7/jO9OAVDgmpx12L6h8tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183352; c=relaxed/simple;
	bh=2/c0dEg4i9pBRhFRtzyOwAl8/RuwwqY7K7Zpse2HJ9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k3BP7UMXHfmbLhKT0W+NjvIsJttJB1ZmdclAxCA4VkoBlH3c0On4dOXC7/Jnre9w5Z/W4fZnhp/CbNpMG6pBliOq3UNt5r3gA5AdoOW8Vt54EpKxbamxjcS7Fgk0qTaECx1kUoK5t56o7QJo4+RGW4X1aKoMm1r3OE7SU6wHbsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gfRwqJkp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gfRwqJkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6751F000E9;
	Mon, 31 Aug 2026 13:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183350;
	bh=i6BED+3xOp0EnxNdMOherIRPNGDDDn6poX3hIV/OZBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gfRwqJkp86sWGZJCN4Cry47JbmjpkC9JdXVOOJl63gSiJGd/n1zG05JWmEs1oppJy
	 BUTFlhPEcGcR4Y0Ui/Bw5uNQ4qqBbrEHHi7Ax7s0S2bHGCp5P/E1BuslrGLLOjtVv6
	 yWLcLQXCmPMdRG3jeWpASUh0o94QBx6TeFPwMAbqwRsWI1al54lsGKNPrLAbbKf9PE
	 F/tj5d1phgE3LnDWCI/zMnG4BFPTNSm1hwzl5c5wnbl4KC+TJu1xes2olsvH/FUhO4
	 l+cjtFcHT0Uyxr2gJta07LOdhFGYgKE0HiKFHHsxQ7qa6Bqr5mDd1lCyggyrfpAI4i
	 Q2CEvgBdcgnVw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alexandre MINETTE <contact@alex-min.fr>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	brgl@kernel.org,
	andersson@kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] pinctrl: qcom: Register functions before enabling pinctrl
Date: Mon, 31 Aug 2026 09:22:04 -0400
Message-ID: <20260831133314.4125787-96-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexandre MINETTE <contact@alex-min.fr>

[ Upstream commit 981aefd53b3cdafae0e45332a1023b80d67f52be ]

pinctrl consumers can request states while the pinctrl core enables the
controller. On Qualcomm pinctrl drivers this can happen before the SoC
function list has been registered, which leaves the function table
incomplete during state lookup.

On APQ8064 this can fail while claiming pinctrl hogs:

   apq8064-pinctrl 800000.pinctrl: invalid function ps_hold in map table
   apq8064-pinctrl 800000.pinctrl: error claiming hogs: -22
   apq8064-pinctrl 800000.pinctrl: could not claim hogs: -22

Register Qualcomm pinctrl with devm_pinctrl_register_and_init(), add the
SoC pin functions, and only then enable the pinctrl device.

Signed-off-by: Alexandre MINETTE <contact@alex-min.fr>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background checks finished and line up with the earlier analysis:

- **Fix commit not in tree** — no local match for "Register functions
  before enabling pinctrl" or Alexandre MINETTE patches under
  `drivers/pinctrl/qcom/`.
- **Regression confirmed in 6.18.44** — `6f6835beab99c` ("use generic
  pin function helpers") is an ancestor of the `v6.18.44` tag, so the
  buggy probe order is present in this stable tree.
- **Precedent exists** — `2aca5c591ef4e` ("pinctrl: samsung: defer
  pinctrl_enable") uses the same deferred-enable pattern.
- **`b4 dig` failed** — wrong invocation syntax; lore lookup was done
  via web search instead.

**Verdict for Linux 6.18.44: YES** — this is a small regression fix for
APQ8064 (and any qcom pinctrl with self-hogs) since v6.18.0.

 drivers/pinctrl/qcom/pinctrl-msm.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index 424b14bc29e96..eabd6563629a7 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -1577,11 +1577,11 @@ int msm_pinctrl_probe(struct platform_device *pdev,
 	pctrl->desc.pins = pctrl->soc->pins;
 	pctrl->desc.npins = pctrl->soc->npins;
 
-	pctrl->pctrl = devm_pinctrl_register(&pdev->dev, &pctrl->desc, pctrl);
-	if (IS_ERR(pctrl->pctrl)) {
-		dev_err(&pdev->dev, "Couldn't register pinctrl driver\n");
-		return PTR_ERR(pctrl->pctrl);
-	}
+	ret = devm_pinctrl_register_and_init(&pdev->dev, &pctrl->desc,
+					     pctrl, &pctrl->pctrl);
+	if (ret)
+		return dev_err_probe(&pdev->dev, ret,
+				     "Couldn't register pinctrl driver\n");
 
 	for (i = 0; i < soc_data->nfunctions; i++) {
 		func = &soc_data->functions[i];
@@ -1591,6 +1591,11 @@ int msm_pinctrl_probe(struct platform_device *pdev,
 			return ret;
 	}
 
+	ret = pinctrl_enable(pctrl->pctrl);
+	if (ret)
+		return dev_err_probe(&pdev->dev, ret,
+				     "Couldn't enable pinctrl driver\n");
+
 	ret = msm_gpio_init(pctrl);
 	if (ret)
 		return ret;
-- 
2.53.0

