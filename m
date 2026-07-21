Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12048442FB7;
	Tue, 21 Jul 2026 22:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674083; cv=none; b=iMIvxQVS+ApYuxeBe1ijAiVJ/0I274LfmrfTNIxjvSDU6hlSF0s9GArsTdnESeiW7HdVt9O2lFR9SOjXTQ+dsd993dmZNYJpwWZrf1t/sFxdmOZFvBBBVSJoz+meRdIVZU1reQTo6LILd7FXB5Gq/cVGoiEkWQgAIoM37s+8oGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674083; c=relaxed/simple;
	bh=9Rv62Ranm+xCGkrvHtcS5TpgnGOHWv0wsO6kdmZwXw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IWVJZJ82B74WpstJxS3JjOg0wKa+bEc4egaY5u8OK/ljAamyxQJcj56irV26fiqVpsodIUj1yj5Mkh3JEExAXW+Q9OP92CvEID7+2YqMUHBvYi+C9lEaxFk6rtyAREXTF2Q3lvhBCuZBrmy5X1RgcL/o0j3QiHT4+2BeRsKRKBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xldfXNfV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xldfXNfV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB0A1F00A3D;
	Tue, 21 Jul 2026 22:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674077;
	bh=dCdegBYQ2RyokaC3wq72B3BJo8TSrMoyYjLySuVNWE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xldfXNfV+zBXKQQGX2ozaLTx2rA/DOuyOZiS64lqDWTrCCVTyZJWFgTZOTMA8yQLj
	 NE8xdkuHPMc6jzd2zrw2guO2Q1XhYGuFmtpPgLDujd4+E9TWL7aJt6CK1Eh8YnH+br
	 9sop0xgHFjvmIRTyXtTttqu/m6RuZ5t/kfdn76gM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandrova Alyona <aga@itb.spb.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 362/699] net: dsa: sja1105: round up PTP perout pin duration
Date: Tue, 21 Jul 2026 17:22:01 +0200
Message-ID: <20260721152403.859736046@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1b90570b257b50..c8a0a805303a54 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -711,7 +711,7 @@ static int sja1105_per_out_enable(struct sja1105_private *priv,
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



