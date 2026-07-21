Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B6242DFEC;
	Tue, 21 Jul 2026 22:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674124; cv=none; b=Y2YB3g0eBIPK2hl91o62if5MyohsZXYzESvnL8q3oHAGP8rSuix3Eh9I3nuziKCulyDsp0CyG+H+akfeoBLJjK+1I66OYJNvogcLDz+oDe8c0ZRjGo11ZwQPHYkHna+yH+9y0vRw0xENxBdH80iVHtMWpQ3ZdxZv7ZExyAH7wYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674124; c=relaxed/simple;
	bh=WL6LK1On8pB2A5ahe6RQ7/7jU1vt3DCJMvn2FnIrDGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0vNGGbvG8gVUaR3FlGZO0fVG+I2UyoW/3HeH+B6qKr1M+RKmrKiuHN2DjtEeLGJRy4p5mnew9egU2S2BGktvWYmt4Vj9go5YaG79dBcPEjH0/tGYOnq5sV+8h7bcvWDphQn0wqvvXwmr9wTVzKVSLDI25PUZd3ak+7A/DZUk9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DBFXIhm2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DBFXIhm2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBDD51F000E9;
	Tue, 21 Jul 2026 22:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674123;
	bh=EmBOqooNAMEIKrQSEcVk/C2+XPlL4yeZ1ICl1nCiMcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DBFXIhm20Zg/uZnPCeihKIopeF6XGVuo5rqX1H0Xj6tl9q5dg1iUS2yalQ8RvIM7q
	 HO10obJjNmKFLVi8D3leqg6xbFD2+dv6oxA3PMoAng4lCdYciiggz+polSwPPNM4c+
	 hpNktRhsxHc95+vLeXlJZszudJXeft12fFNuySJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 405/699] Bluetooth: ISO: exclude RFU bits from ISO_SDU_Length
Date: Tue, 21 Jul 2026 17:22:44 +0200
Message-ID: <20260721152404.831513207@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit fd076d8deeab6f9f18ef13400f89e1f550df665b ]

slen contains ISO_SDU_Length (12 bits), RFU (2 bits),
Packet_Status_Flags (2 bits).

Exclude the RFU bits from hci_iso_data_len. Also add masks to the pack
macro.

Fixes: 4de0fc599eb9 ("Bluetooth: Add definitions for CIS connections")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index ede7a153c69a5f..02a27fb4a634a1 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -2538,8 +2538,9 @@ static inline struct hci_sco_hdr *hci_sco_hdr(const struct sk_buff *skb)
 #define hci_iso_flags_pack(pb, ts)	((pb & 0x03) | ((ts & 0x01) << 2))
 
 /* ISO data length and flags pack/unpack */
-#define hci_iso_data_len_pack(h, f)	((__u16) ((h) | ((f) << 14)))
-#define hci_iso_data_len(h)		((h) & 0x3fff)
+#define hci_iso_data_len_pack(h, f)	((__u16) (((h) & 0x0fff) | \
+						  (((f) & 0x3) << 14)))
+#define hci_iso_data_len(h)		((h) & 0x0fff)
 #define hci_iso_data_flags(h)		((h) >> 14)
 
 /* le24 support */
-- 
2.53.0



