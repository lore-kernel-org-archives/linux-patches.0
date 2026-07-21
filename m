Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FA339A7FE;
	Tue, 21 Jul 2026 18:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658209; cv=none; b=o41v00b2GSouijJ9P8e2qGi09zeypf/fBBHbekWCEo8xV1Qj4R3IelFSZNVnQR+dGNVOx2aPFb1qGO/EApPLEC/l+9mlBH1ZK3B+ho1ssx7+gr7ptbonk3pEzoaGA9v+0QOUsdm2xZyoxfI5Z7KPbqWyRB5xCjnnEedTjvzFuQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658209; c=relaxed/simple;
	bh=brZN3SjmVGGpIaV8+NZX9/IGXfk8+38Z3GuALdLK+j4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYmRrD6Gh0Hz7Bu6tJ/heJIkIcf2Lu7jlcPJS3AaUFkFQRuCS+vxRa41pBst7htZXA19Hzjo2T2s1HTuhj3oP7cWQ/0yKOR/gcX34kSociQFVWqVF9r3h3hahOABGNq+MCsDCk4Igg3o0h+38Ktmmy42hFH9X+L6LV+B4pwO/o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ndFmyX8f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ndFmyX8f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7D81F000E9;
	Tue, 21 Jul 2026 18:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658208;
	bh=hDCdojnNVo/L9Ixhc8ctt8DTB+PNR62I+TXMwQhX7RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ndFmyX8fgEALlsmpXUkdYv5ubFre3oMATC+Ivn6iLVpgPbmNXnyVxMjVbe8yQJalc
	 v3qK6GaS8bzIo8mTPo8bDpMuVw3ARTZs9BHEVwuQNrOzIqIH0y4XKXOtRuYdNtseAF
	 6SREM9gc9+E/7cg8qbbcCNjtuy4q0GdHHUVPSP9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1056/1611] Bluetooth: ISO: exclude RFU bits from ISO_SDU_Length
Date: Tue, 21 Jul 2026 17:19:32 +0200
Message-ID: <20260721152539.160385979@linuxfoundation.org>
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
index cb4c02d0075904..2613cfe5b8a392 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -2993,8 +2993,9 @@ static inline struct hci_iso_hdr *hci_iso_hdr(const struct sk_buff *skb)
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



