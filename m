Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063607;
	b=ObwUNR6ma2xV0AJ/op+DcDR9gmZYpwJg5i4UcVan7mqmnuq92PKsgRuv5x/dlH/ioabF
	 2DdJUpHHqvRPU1LHLFaLok/IzkrIKcgPmiyP2eBUVe6cVi+MtnxkJLS764tn+t5eazIrU
	 gF8haRMx7zjmAFAJWGlkXeh9LFMQEOsE7TxJN6uRQcQ+SNijaK9sFHEOh/gq+9PJMp7lk
	 KkU+FA7gzB5nqWfhX/BHKrKn5nYOrDUJUHL/XaiwRGT+yYZGAMzKrNlscjClQF3bRiBMq
	 AfAT+Fx0WDfFwJgOAZkxtxsWXNRULerl796XKfy9d3zuYq8h29zyq6V963AEu5lraag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063607;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kjETemNpQpnHdMNciCe4i61OLyP1ZXBPjGT9YNIRWCY=;
	b=j5z9yoellQXkZN88mUnfqKzIDSZ4w8tqwREC0n8dELuvIAu22P1y467fR/YbbZqqOXyZ
	 ATzQw0XaSza21QOjB+/xYhwOVcnsKfLZggEeJNK8CYK7rqA4auyPo1OKzsAh6qCZRvDBr
	 M7y9uFglBPHWAUI2yBfBY1xl1tCslLsGmj0rlE/IgYpQVEHKPMrmkSXTGNd1oEkHeTxqN
	 PvstpkQ1wLNixogYSSsHEXk54QEHGd0afHYXiLp53JjktpCA8/iqBrMerVqBfu9ApDVSc
	 HBoL7yBG8vSquwW2z3oAMErU2KXNVdtGrheUIzWhBkYAbEY4paprEkZ14lKbWRrJC/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M8wvWArE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB37606EE81;
	Sat,  7 Nov 2026 15:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M8wvWArE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38931F0089F;
	Sat,  7 Nov 2026 15:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063607;
	bh=kjETemNpQpnHdMNciCe4i61OLyP1ZXBPjGT9YNIRWCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M8wvWArEmA3DTpnivBhVFj2UGZbp9eST6IWg2Ac1qF4lGbu0z8njPIDPn7DAUbUUs
	 omk/l8fRpaIzLnXZgDfJQCaO65h663P7DBF9lOiZWTA/AlkOATzgKi3g5FCw8PbkVu
	 jl/Mj+EB5y+Q+UacxyTJ2mYHXYxztJa+MJhJBlEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Kazinsky <a.kazinsky@ideco.ru>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 722/869] ASoC: tlv320aic32x4: Prevent division by zero in divider callbacks
Date: Sat,  7 Nov 2026 08:56:44 -0500
Message-ID: <20261107134917.303631603@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Alex Kazinsky <a.kazinsky@ideco.ru>

[ Upstream commit 8cf9607d2d855629260fc78e6b54ea7a98525708 ]

A zero rate requested through clk_set_rate() or clk_round_rate() reaches
clk_aic32x4_div_determine_rate() when the minimum rate is zero. Clamping
the requested rate to the allowed range leaves it unchanged, causing
division by zero when calculating the divisor.

A zero parent rate can also cause division by zero in determine_rate().
For example, if reading a parent divider's register fails,
clk_aic32x4_div_recalc_rate() returns zero, which the clock framework
caches as the parent's rate. A subsequent rate request for a child
divider receives this value in best_parent_rate. With a nonzero requested
rate, the calculated divisor is zero. It passes the existing upper-bound
check and causes division by zero in the resulting rate calculation.

The set_rate callback can receive a zero rate when an ancestor's rate
changes. clk_calc_subtree() calculates descendant rates through
recalc_rate() without calling their determine_rate callbacks. If reading
a descendant divider's register fails, clk_aic32x4_div_recalc_rate()
returns zero. This becomes the descendant's new_rate, which
clk_change_rate() passes to clk_aic32x4_div_set_rate(), causing division
by zero.

Reject zero rates in both callbacks and reject a zero divisor in
clk_aic32x4_div_determine_rate().

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: a51b50062091 ("ASoC: tlv320aic32x4: Model DAC/ADC dividers in CCF")
Cc: stable@vger.kernel.org
Signed-off-by: Alex Kazinsky <a.kazinsky@ideco.ru>
Link: https://patch.msgid.link/20261023130854.93639-1-a.kazinsky@ideco.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320aic32x4-clk.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tlv320aic32x4-clk.c b/sound/soc/codecs/tlv320aic32x4-clk.c
index 5c0a76a4a106b..1a815de909097 100644
--- a/sound/soc/codecs/tlv320aic32x4-clk.c
+++ b/sound/soc/codecs/tlv320aic32x4-clk.c
@@ -320,6 +320,9 @@ static int clk_aic32x4_div_set_rate(struct clk_hw *hw, unsigned long rate,
 	struct clk_aic32x4 *div = to_clk_aic32x4(hw);
 	u8 divisor;
 
+	if (!rate)
+		return -EINVAL;
+
 	divisor = DIV_ROUND_UP(parent_rate, rate);
 	if (divisor > AIC32X4_DIV_MAX)
 		return -EINVAL;
@@ -333,8 +336,11 @@ static int clk_aic32x4_div_determine_rate(struct clk_hw *hw,
 {
 	unsigned long divisor;
 
+	if (!req->rate)
+		return -EINVAL;
+
 	divisor = DIV_ROUND_UP(req->best_parent_rate, req->rate);
-	if (divisor > AIC32X4_DIV_MAX)
+	if (!divisor || divisor > AIC32X4_DIV_MAX)
 		return -EINVAL;
 
 	req->rate = DIV_ROUND_UP(req->best_parent_rate, divisor);
-- 
2.53.0



