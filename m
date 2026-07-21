Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD7143E08B;
	Tue, 21 Jul 2026 22:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672038; cv=none; b=poINEVnHSHQ8ntb7Fie0dnoUHsMDCMD1k5EpXSZTraNnf0zQn6xpcaf3oKfrwImaFJKUMUQX/Rg+VsUPoZNa2I9tRj7ZzcBMugNhpIGO0wAX8PMWcJdOYmeZ+rZ+YZfoNksQVfsMrksO8pPFMQSnGDcB+678d66umhkwJE0euek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672038; c=relaxed/simple;
	bh=GDzajw8UJKD6uMHkF+yJpR4oRztVn1sN+2BTTM/fSFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQt7ZxXpbC6dpUM0s/Yru3B9ac9jPFpWlJ9abtuwUfabSF/Ul4YRMobKjGq+Nzkq04G0Cb/CtlzuWfC3PHu15nckbut3UasnBtG84NAdYh2K+2oZnv3ubsdRt5hpDyDbN794Ex+un3P6BpAuma905nNnGyXMUL9eKUIavkAEkeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sEDQnzNm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sEDQnzNm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5667F1F00A3A;
	Tue, 21 Jul 2026 22:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672036;
	bh=ckb/r9Ct9ZF4YN0vtzTXBwne30JYOTEOV11pkYKNE04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sEDQnzNmNm4YfO348n/3+k+VPC+trxCPSGIcVckBHO/x67gkg68iXy9P7HjA3rhhP
	 GSFcUilqh4ZbOg+wSJC8mbHkoCkUybG/tlxabhTU1w1DwNqT7Um4+o1Dy9kgtr5uJy
	 iVFOY1zXlTV8aEPxCQC7wVDTrY3L2IMaWODHqwps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandrova Alyona <aga@itb.spb.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 473/843] net: dsa: sja1105: round up PTP perout pin duration
Date: Tue, 21 Jul 2026 17:21:48 +0200
Message-ID: <20260721152416.677621127@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 54396992a9199c..c14d599d8682b5 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -766,7 +766,7 @@ static int sja1105_per_out_enable(struct sja1105_private *priv,
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



