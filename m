Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020026;
	b=n+oQV7Jipqni27UEfvmXlerYlgQWVPyk+1btQYqR2fswPpuFfTg28ZlV3L+cO20jNV5q
	 1JMo8KknDUbIO12hBjeSmgtxpq9D1RJnVHUk+hlYyQ8ysPgRNb1Zc0Z26RBZ+5KIy6Gfz
	 JnPFO98Ez3fUQz+CK44Mn0Ney6E/vbpeuqo3F/R1Qn0mINmgxKQFkwSdjSkUfGk4HM4EN
	 EO/FtbB8gQamSjQON//0H+p4A4nnYKchu925eNo/Np6WXXuNO7z03YhTkRRZsf2VHeHyP
	 VBIDVxcU4y7LaHOAjy2wZxSX0nHdxnArmtSc00HJ1DOIbvxZDBd0owFnV9U00fjtKfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kimW1d6J6Zua5JjqC+ZK24zcmnWMH5CP6qpUPOP5gnU=;
	b=lLGOj0OZLJCr3gtG9U7+xR9H5BOKpaw2Kxv74n+5BN+v7+SW4wtwBu4NUw61DmG6VVjG
	 pjs6Q/ppjyI9ruXizr437fWkD030Dh1odgirtGTOQgo/xSwAjq7/jFiRpP8xVlbybnjKm
	 HosFVMEjKkoJERLWcpPTw7UwQtioeUHD098Iu/tKCcHNCWeU/gdlmhOMEoTf3JVyeckFK
	 omg+CuC+A0zec8hCq+ANqTVpzgAc6x93LregV0GatwiUc9CJ9NG0fwP4DkxJ+AY/AkmsW
	 xBhjbY/mR/dGuHzdQmcSKSy8UZD4xvtbajcbDb8pOfTyzAU9gxclbj7F0IsvVbIptoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N9qVF3KG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06E5606A32A;
	Wed, 18 Nov 2026 16:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N9qVF3KG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236F11F000C4;
	Wed, 18 Nov 2026 16:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020026;
	bh=kimW1d6J6Zua5JjqC+ZK24zcmnWMH5CP6qpUPOP5gnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N9qVF3KGiPM/459V3oxm5cMr2dbsyahC17Le0zeCwOIE7EUT6yS9Q8Jm0PHPJPLO4
	 /vH+a2GxuB166Cac4DKrYjquGnIRhPSNkEulTVR6rfukKa/hNHzxplSQMyuAicOxts
	 6/GeEUMAy/Cj/gqHptpImo5JDOvbGojxQ5k96xc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Priyanka Mani <priyankamani2100@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1806/2651] ASoC: mediatek: mt8365: Fix out-of-bounds read in get_iir_coef()
Date: Wed, 18 Nov 2026 15:50:46 +0100
Message-ID: <20261118150352.276487278@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Priyanka Mani <priyankamani2100@gmail.com>

[ Upstream commit e913917febd31998e3d0b9e8c861e538a6185045 ]

get_iir_coef() looks up a resampling coefficient set by reading an
index "k" from iir_coef_tbl_matrix[][] and using it to index
iir_coef_tbl_list[], which has 8 entries (valid indices 0..7).

Before the lookup, "k" is only rejected when it is >= IIR_NO_NEED (11),
or equal to IIR_RATIOVER (9) or IIR_INV_COEF (10). The value 8 is
neither a sentinel nor a valid table index, so it falls through to the
else branch and iir_coef_tbl_list[8] is read one element past the end
of the array. The bogus coef pointer and count are then returned to
mt8365_dai_set_config(), which dereferences coef.

The current matrix never produces 8, so this cannot be triggered today,
but the bounds check is wrong: it relies on the matrix contents instead
of the size of the array it guards. Bound the lookup with the actual
array size so only valid indices reach the table.

This was found by Smatch:

  sound/soc/mediatek/mt8365/mt8365-dai-i2s.c:271 get_iir_coef()
  error: buffer overflow 'iir_coef_tbl_list' 8 <= 8

Fixes: 402bbb13a195 ("ASoC: mediatek: mt8365: Add I2S DAI support")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/67af3580-a907-403d-8bfd-76b5c304ab99@stanley.mountain/
Signed-off-by: Priyanka Mani <priyankamani2100@gmail.com>
Link: https://patch.msgid.link/403cc04bb103dff096edf72b99ae6868ee91f359.1791782072.git.priyankamani2100@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8365/mt8365-dai-i2s.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/mediatek/mt8365/mt8365-dai-i2s.c b/sound/soc/mediatek/mt8365/mt8365-dai-i2s.c
index a058973662b3a..2e678f4aa4b1f 100644
--- a/sound/soc/mediatek/mt8365/mt8365-dai-i2s.c
+++ b/sound/soc/mediatek/mt8365/mt8365-dai-i2s.c
@@ -267,7 +267,7 @@ static const u32 *get_iir_coef(unsigned int input_fs,
 		if (k >= IIR_NO_NEED) {
 		} else if (k == IIR_RATIOVER) {
 		} else if (k == IIR_INV_COEF) {
-		} else {
+		} else if (k < ARRAY_SIZE(iir_coef_tbl_list)) {
 			coef = iir_coef_tbl_list[k].coef;
 			cnt = iir_coef_tbl_list[k].cnt;
 		}
-- 
2.53.0



