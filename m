Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7614028F7;
	Tue, 21 Jul 2026 18:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657835; cv=none; b=J+keA9H7KtVPWTWUlpjJGXxjQYZisVceM3e6M9CVyfccB4liAujwSl3ifUMZnUXv/cmrcTXGo73w/31ZV0z1xSHDNHwychrirVd2nv5HO2LLcZFMGVguAvhFGOQ+gNV2+wZ8i0skt4oI2QZwm4MplD5U5UxI7pIVIUqrWtxRVvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657835; c=relaxed/simple;
	bh=QtWEisZxP0DQ3hS1BUIKozrD+u7Gt0rNnOJV9RE62+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m9Vr4HTwuKugR9nW3MQ6SuUCDXCRdkQ9hQKLztFv5n5wgwW5F9yDTwi99ryU2ZvhmDDbRI/uQMTn2kMi96dO5/zeZGv46G+iGiX2f55unxj1DOEAsY93gOZV1xQv8Z9uEBr/gNrjO0KQ3omGDYxITbGa2UyBdwHopqiHEXmTK4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w+zXnjL9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w+zXnjL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD371F000E9;
	Tue, 21 Jul 2026 18:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657833;
	bh=aRdU6ZwljzxhT/TqH/+aA6ZYLZ91XA2KudwasrUX4jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w+zXnjL98Ae6cIKX5nQm3SUcTDMwUFYthH0oCvqZT7pg0rIIiRRerFMJxsKBpbFbQ
	 JjbVMTHfhzQVoXpKvQ844S0xWGtYBY95oJbJ4eOtaGk10UpmpAte2Myq0K+q59HOjF
	 cuXK6XoE5wiUHS7WATUafroxvnhzOFGdGBqgMl+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandrova Alyona <aga@itb.spb.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0914/1611] net: dsa: sja1105: round up PTP perout pin duration
Date: Tue, 21 Jul 2026 17:17:10 +0200
Message-ID: <20260721152535.944204429@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Aleksandrova Alyona <aga@itb.spb.ru>

[ Upstream commit aee5836273b07b439fb245fb43930664d8b78518 ]

pin_duration is converted from the user-provided period to SJA1105
clock ticks and is later passed as the cycle_time argument to
future_base_time().

Very small period values may become zero after the conversion,
which can lead to a division by zero in future_base_time().

Round zero pin_duration up to 1 tick so that the smallest unsupported
periods use the minimum non-zero hardware duration instead of passing
zero to future_base_time().

Fixes: 747e5eb31d59 ("net: dsa: sja1105: configure the PTP_CLK pin as EXT_TS or PER_OUT")
Signed-off-by: Aleksandrova Alyona <aga@itb.spb.ru>
Link: https://patch.msgid.link/20260618110508.53094-1-aga@itb.spb.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index fefe46e2a5e612..350f958dcb2af1 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -755,7 +755,7 @@ static int sja1105_per_out_enable(struct sja1105_private *priv,
 		 * 2 edges on PTP_CLK. So check for truncation which happens
 		 * at periods larger than around 68.7 seconds.
 		 */
-		pin_duration = ns_to_sja1105_ticks(pin_duration / 2);
+		pin_duration = max_t(u64, ns_to_sja1105_ticks(pin_duration / 2), 1);
 		if (pin_duration > U32_MAX) {
 			rc = -ERANGE;
 			goto out;
-- 
2.53.0



