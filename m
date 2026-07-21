Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB70B46F48B;
	Tue, 21 Jul 2026 19:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663320; cv=none; b=NgSmqF2pX9CT23fOmqttxvCLKIxtEuRDqiNlDdt0c3YnNgmU6RbUTd0HLlemZ4w99TsKjPVh7MDEvkvqujBMA94kxNzsXo/hYgFPYJQk7+lwYvcacO3T+kQWZF14u0mTofdnwqUKHd5N2xMpbYeNaT+gjZv9VBvDqWpk8ZsScyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663320; c=relaxed/simple;
	bh=J2cJFF6YGH94NpYyAH5YQceOtxLEoaMNgew6RmEAiFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNOdwV4OhueaF6paZAl+DHsF3xvB0NBADls2OQLN431BW+KKaHEPQxxGJRgMpVEcSNC+EGQhoMO/e7EirQ9aqpuB80zrT7+2peRekC1y+Yh6U1LxWdvgJGNkxeoOM10atoD9GS8Yhgs+Y3R7bKA6V0iyn9sI9nJN6HjeK4FoWqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJRA24Bn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJRA24Bn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3F21F00A3E;
	Tue, 21 Jul 2026 19:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663318;
	bh=9SbjbJqi3W0NzaZ4XmASCVdlcYjIvuzHkUkvYJNmJzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UJRA24BnLj3rISi2jQjNEYcC4ZyXwSixcKm5Sz9fqHI1qSH0PfZ6bXCU2dgusNpsH
	 rS18MoBfKusZ5JzGzuy1qnOMd9yhN0i5CITc/Uk25gCENg5NuII2+KSvOIhxQxDKiW
	 1EYga+9RfcJLiBhru8mMxPXToCghtrCWjHL/tPQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0776/1276] Bluetooth: ISO: exclude RFU bits from ISO_SDU_Length
Date: Tue, 21 Jul 2026 17:20:19 +0200
Message-ID: <20260721152503.442989526@linuxfoundation.org>
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
index 999ac27050993b..41b4e27a01b9f7 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -2958,8 +2958,9 @@ static inline struct hci_iso_hdr *hci_iso_hdr(const struct sk_buff *skb)
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



