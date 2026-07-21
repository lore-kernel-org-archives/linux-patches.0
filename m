Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FC846F4A1;
	Tue, 21 Jul 2026 19:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662989; cv=none; b=aAPRZDj+vm+XJ3gJbhQp16jS37ebSb8EoVK7zODcPm+W0cjBytKeRs5jU4SArNbhsva9hRsqdXMd/kGJOQVaESmdidV5pEoeXg3AIOvYS0+L4FzRevRvGhOxa8Pjgly8KBLZB13K6AvIrQpJPw00xtAgy12kFNfwZB2MxCY4MiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662989; c=relaxed/simple;
	bh=lxgNnj5yatEXMsxyzSq8WQ/uOswVUoXLNpcScv9ZYQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRPK/tzOtRZO0crgehwDdEZhpYT7Gbn9gfsWZaAuNRzWhqwv2iMgUgDy+zB0ziezbj/FcXIQIgykxvxxQxL9yqD5AQLNvnI/5mbalmB8HLca0CK5QFoCOyRTAZf0S0G4L0mezUpCtRFXcnID5ynF9rbf//NYrmzphDwJqeh5oTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dnw9kYdv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dnw9kYdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7395A1F000E9;
	Tue, 21 Jul 2026 19:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662988;
	bh=6/g2FPffDv8m63fdDfCtNmrdPUtMQUvAsSq3YGAznQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dnw9kYdv9rJjltMjQLN4i5fodIh1b0ToAitnXeKgQqkAcwOmwaGvSCdUhKCEcwchA
	 +9PySOUFhb0F6nXxlL0A2/Yvpi0t3F8K8mD8YqCNiVn+yvf6yKOW6KEXBjoyGMlaKX
	 LEGnLwuAWYuYo9ivVeupvVR9CLr6P+1SUwkYhrXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandrova Alyona <aga@itb.spb.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0654/1276] net: dsa: sja1105: round up PTP perout pin duration
Date: Tue, 21 Jul 2026 17:18:17 +0200
Message-ID: <20260721152500.743986090@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index a1f4ca6ad888f1..cc47e9b5623c59 100644
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



