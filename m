Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513D5566C53;
	Wed,  9 Sep 2026 13:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962247; cv=none; b=F0R069Mogwb4tJnp5CJUnwMRe1xgKnlNCUvHvj96C4csf726ioN68G4bKu+OaH3PuadU/if+uclmfyPDr8a7QipeEn2sjKKGO2kOqPHn+pVHhfCGEf2e8rL1sO4C7fAeuFVVGkTXe1XT5K44WJTdGumNWuktRSnyDv0NzvKQoHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962247; c=relaxed/simple;
	bh=If0Sv9bZvPZqhPwvSd79E8UmW0wNaO8uXmxLYclRMhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h++CG3Revf/l9qWi3Y3LKE58/+mZaOhlkmokDOWIv/LePtLl9RGaJkWpKkannvk9CteZp0wiMl8YF4wjCMOIy4j2fB6OnoV/j2JZwQNoCH5mtdKe1LVRV7wDdvxCfxsVbaAaN4CN4uv56FyjtkC9cVjeV81RE47grlaf+wptY/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pg3X7d3e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pg3X7d3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C711F00A3A;
	Wed,  9 Sep 2026 13:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962246;
	bh=Q/qpWoOD60Coz8y3JdT3OveVnPORG0ef0f/nsCmroDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pg3X7d3eEy4oB+6OeLp7yE5dI9p2ku6MdaCdNt7+KGmIWGQfE3caOEkzeENzPvtil
	 QvSdtC3tgYXB5fZdlTl9DivUfczscwWFY6M6QERKFFyyvICSza84qTS6GREc64gnm/
	 zHQv6LPSnJMeZW+g6s4jBWMX5bH0kqI4yuD3C85M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 225/556] ASoC: fsl_easrc: Use div64_u64 for 64-by-64 division
Date: Wed,  9 Sep 2026 15:38:25 +0200
Message-ID: <20260909134238.324444648@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2058,7 +2058,7 @@ static int fsl_easrc_m2m_calc_out_len(st
 		/* right shift 12 bit to make ratio in 32bit space */
 		val2 = (u64)in_samples << (frac_bits - 12);
 		val1 = val1 >> 12;
-		do_div(val2, val1);
+		val2 = div64_u64(val2, val1);
 		out_samples = val2;
 
 		out_length = out_samples * out_width * channels;


