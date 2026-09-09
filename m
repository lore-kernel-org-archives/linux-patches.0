Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06ED655C1D2;
	Wed,  9 Sep 2026 14:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963689; cv=none; b=dNaXjXVgOcsLC92/OuOZLShAydwTI0H+1TxmMzxxoqW3tbdhqfMH0/1OM4Ke/sv8s7b5rtxolms5S/IWgBxt5XQubqpv8JVjDQ0WBrKKl63fg7EVhJhOTTvYNugcXys8jvw1j4n5B2pL9CaQnc+xPtCVhK5K3CQVBhSlSZeq5f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963689; c=relaxed/simple;
	bh=Qkef9++aPQ1E6hhLHU8VuhJVJAjjSYHmD/Eb+7V/PzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9scZ14n5vdvZnZHpV14R3iqssDBe3ZfW0NaejUczIxxD1cDkswDaRZhkLYsiq1GOOR5Jw+PTz5C1GM3rJjW5GSmct0pP770vJHO/Xmyi39Mwkhh2XxlFH0yrwi3HC0I6L+WqJDtNEqS02tRrl706y/LAftQ+jcvtJxbSQUZxAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vqfv6tS6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vqfv6tS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6191F00A3A;
	Wed,  9 Sep 2026 14:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963687;
	bh=m7DGyHecq3pfO+39fSy/NsSS/uNKmFhyaqy7blFGGng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vqfv6tS66yn/OOXifKtMWV4W3qSi/ncIORCAapn6FFkE5qZN7NLsekSpBFZJX07iS
	 Af82cgty7ChKBP6f6RcS3GoQFvDQC4lC3c2vSHs/JA4OzOKaUWFiMm6ln2SdLq9Rbd
	 Vj2y6cysJ+lJDL3AIjtfjBC9SCpJwy2q3Qo5t8Go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 163/583] ASoC: fsl_easrc: Use div64_u64 for 64-by-64 division
Date: Wed,  9 Sep 2026 15:37:28 +0200
Message-ID: <20260909134243.855134157@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: wangdicheng <wangdicheng@kylinos.cn>

commit a46ccc71877e962783e0fffa105e41615904c511 upstream.

Fix a coccinelle warning about do_div() truncating a 64-bit divisor:

sound/soc/fsl/fsl_easrc.c:2061:2-8: WARNING: do_div() does a 64-by-32 division, please consider using div64_u64 instead.

In fsl_easrc_m2m_calc_out_len(), val1 is computed as:

  val1 = (u64)in_rate << frac_bits;   // frac_bits up to 39
  do_div(val1, out_rate);
  val1 += (s64)ctx_priv->ratio_mod << (frac_bits - 31);
  val1 = val1 >> 12;

In the worst case (in_rate=384000, out_rate=8000, frac_bits=39):
  val1 = 384000 << 39 / 8000 = 26,388,279,068,672
  val1 >> 12 = 6,440,497,829  (33 bits, exceeds 32-bit range)

val1 is then used as the divisor in do_div(val2, val1), where
do_div() silently truncates it to 32 bits, producing incorrect
results. Use div64_u64() to perform a proper 64-by-64 division.

Fixes: 955ac624058f ("ASoC: fsl_easrc: Add EASRC ASoC CPU DAI drivers")
Cc: stable@vger.kernel.org
Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
Link: https://patch.msgid.link/20260717091542.721877-4-wangdich9700@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/fsl_easrc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/fsl/fsl_easrc.c
+++ b/sound/soc/fsl/fsl_easrc.c
@@ -2055,7 +2055,7 @@ static int fsl_easrc_m2m_calc_out_len(st
 		/* right shift 12 bit to make ratio in 32bit space */
 		val2 = (u64)in_samples << (frac_bits - 12);
 		val1 = val1 >> 12;
-		do_div(val2, val1);
+		val2 = div64_u64(val2, val1);
 		out_samples = val2;
 
 		out_length = out_samples * out_width * channels;


