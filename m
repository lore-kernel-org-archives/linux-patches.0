Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F68F43E4BB;
	Tue, 21 Jul 2026 21:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669818; cv=none; b=UYOHDldtRhuStxlJMQ8Xl2y07n22mzQYIxuHEltCk1E4n1K7Rxk8U8k0MABFFtEfWJjkpfBBGxhe6wRmRhkYlZwHFLYvikKnMhYK6fKcgyWTEL8eokQWzxVcwLx9R3XMrGEf0e4eb+WoOTsf0vSuqucneQG5OlmbdKsipykoU2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669818; c=relaxed/simple;
	bh=9YLuNbMPR1mGoaZFkwHhuOOIRikjwl2M/v0aHYrQRzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRG0sDO12Y9qLaKgGZHneTVMmcqd7Nm8zvLcyQfTr3YuvLH9sCRo0UrCn6lAzwXic1/mguxSa9liHePqdo5XVSQPSgvj631hVOqvR9jK5iQMxZ1ElPP1lSjTDs8HawssNWvdIqhjYGiS25ckp2Zn+fgKXyckG6Ljoh7Old75Wf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IwlBhg2v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IwlBhg2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627D31F000E9;
	Tue, 21 Jul 2026 21:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669814;
	bh=d4md+Tiw54pEUlg54UNFoWSrsq6lMEj2nYBfEQ+U+/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IwlBhg2vE/txrY089DC7Kv5NIPC0CjSIXCRDDdsBHkRBWiOTnRHBiZL01FP0J0+Gy
	 J+wReIWD5T3UXUZwha38Pjyn5IlbfF1UhYc+KED7MN3wdpB0SxoHDPZ3rOXrtyuLdM
	 3h6Iw8H3VTOSFvW5HNO5kAb4ZP1EvoPcr+As6l7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0695/1067] Bluetooth: ISO: exclude RFU bits from ISO_SDU_Length
Date: Tue, 21 Jul 2026 17:21:36 +0200
Message-ID: <20260721152440.141456551@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 018fc64329fc68..1a05fe12b28f03 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -2969,8 +2969,9 @@ static inline struct hci_sco_hdr *hci_sco_hdr(const struct sk_buff *skb)
 #define hci_iso_flags_pack(pb, ts)	((pb & 0x03) | ((ts & 0x01) << 2))
 
 /* ISO data length and flags pack/unpack */
-#define hci_iso_data_len_pack(h, f)	((__u16) ((h) | ((f) << 14)))
-#define hci_iso_data_len(h)		((h) & 0x3fff)
+#define hci_iso_data_len_pack(h, f)	((__u16) (((h) & 0x0fff) | \
+						  (((f) & 0x3) << 14)))
+#define hci_iso_data_len(h)		((h) & 0x0fff)
 #define hci_iso_data_flags(h)		((h) >> 14)
 
 /* codec transport types */
-- 
2.53.0



