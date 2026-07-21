Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5814439908;
	Tue, 21 Jul 2026 20:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666924; cv=none; b=NKZsBSCo2NN56VB5ioJ+1+cFzd/sB6mr5M/a8kK1oh1lSm0l7ve3T3kyBpjEMh6tM0gKtVzE1O1e/OhRiZ084Zyopcf2BYVCF6so2quhMshUt5TvSy5+53kRZtgz9pwOFOCWnI+rGnqzpgby/TMg0+JB+Yl/IyTqD5CoSHmkguo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666924; c=relaxed/simple;
	bh=NebXBvP4cyw2gvKjKMVxo6UKdltF5+NEAoPKc2yhuys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0E4MqJka/2Zykr6a8VtrEVp1bLJG8h5EypCQaZLqC+oeAtVelLIitzM6yDeugyUYfyLcaPvq+DnmDrmWyKm4DOUW40CHumqzhzHfkJXfiHXnUoluLdzQD0THv0ZNanu2tdpWYD91eFcdoCnV94aqWLEQ5alBln0hwkUFpckIms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YGFUbtWW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YGFUbtWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E394B1F000E9;
	Tue, 21 Jul 2026 20:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666919;
	bh=MeZaMXQgDexo2KNtU+3dKM28tr3TI8YWo0QSbeNGFcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YGFUbtWWCj/xvIPpbnA74fZKNnE9K+AmQx/zfLnhw9ZQvx87fHvK7hh/Z3idl6SQn
	 DEHrEHjbSLt0W/EyXxdrz3Wl8a1IrfggmdSg9xsS36E+DMjezk55E3Gwu1v98BG88Y
	 FerXdGZ0v2o59YyxyfmxT3JpJQ24bYrsthfcj46Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0864/1266] Bluetooth: ISO: exclude RFU bits from ISO_SDU_Length
Date: Tue, 21 Jul 2026 17:21:41 +0200
Message-ID: <20260721152501.182444356@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b25746b91986c2..ad640f85a66079 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -2914,8 +2914,9 @@ static inline struct hci_sco_hdr *hci_sco_hdr(const struct sk_buff *skb)
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



