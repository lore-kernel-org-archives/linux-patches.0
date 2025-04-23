Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB558289368;
	Wed, 23 Apr 2025 15:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422104; cv=none; b=BLWX9uxEZlGR+/T1yRtRf9iw8Ee3wI917Kc42pjNKNYloIy1UmtacGMvihVk9fqB7U3oYEZWiv9BFJQ9a2p0VFIdnSwo5lJ4NhjzVgmKErVRM/mG+QsOzbInoLXmf/237fj1ZHZaHBtFmoXWdEyEXNi/WEy6pyZi83N2H5jilYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422104; c=relaxed/simple;
	bh=E9pSR3STqRdJ2qwmKVQ601TYugzi4ZldwtixO0Aucp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RpfAQ5KZEkYFryxW0kCA7l8vfnxyV3O7tBZcbLENJCGGJVB1h2m5uRrUPq1MF+S3LSSZ66efC7YwFtO/pIMXtWEF8bHqQreSLTSZNg8ht6oQESlQD/obf/h3NcROwVts7T4TKLHH+/GFQULvZm6Sk3TklQ/jYw7U7FQFxmAz/g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3TW9+JG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3TW9+JG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672DAC4CEE2;
	Wed, 23 Apr 2025 15:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422104;
	bh=E9pSR3STqRdJ2qwmKVQ601TYugzi4ZldwtixO0Aucp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M3TW9+JGOgGAb8ov0k5oJiuskqKuBN2npYI9SyeRT2XFKaGBx+58ddb5lz8cw2no9
	 v2NyAsjahtJxPwP/nDEG0jpCQulT7fCxeI+edYJAWNAUXtkdZcnWHIQGUU9MWRIzEZ
	 Zw7qrKtbp08DuWEvInLeIjMO4HznPn+8x/sWsIBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Danis?= <frederic.danis@collabora.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 257/393] Bluetooth: l2cap: Check encryption key size on incoming connection
Date: Wed, 23 Apr 2025 16:42:33 +0200
Message-ID: <20250423142653.990031756@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frédéric Danis <frederic.danis@collabora.com>

[ Upstream commit 522e9ed157e3c21b4dd623c79967f72c21e45b78 ]

This is required for passing GAP/SEC/SEM/BI-04-C PTS test case:
  Security Mode 4 Level 4, Responder - Invalid Encryption Key Size
  - 128 bit

This tests the security key with size from 1 to 15 bytes while the
Security Mode 4 Level 4 requests 16 bytes key size.

Currently PTS fails with the following logs:
- expected:Connection Response:
    Code: [3 (0x03)] Code
    Identifier: (lt)WildCard: Exists(gt)
    Length: [8 (0x0008)]
    Destination CID: (lt)WildCard: Exists(gt)
    Source CID: [64 (0x0040)]
    Result: [3 (0x0003)] Connection refused - Security block
    Status: (lt)WildCard: Exists(gt),
but received:Connection Response:
    Code: [3 (0x03)] Code
    Identifier: [1 (0x01)]
    Length: [8 (0x0008)]
    Destination CID: [64 (0x0040)]
    Source CID: [64 (0x0040)]
    Result: [0 (0x0000)] Connection Successful
    Status: [0 (0x0000)] No further information available

And HCI logs:
< HCI Command: Read Encrypti.. (0x05|0x0008) plen 2
        Handle: 14 Address: 00:1B:DC:F2:24:10 (Vencer Co., Ltd.)
> HCI Event: Command Complete (0x0e) plen 7
      Read Encryption Key Size (0x05|0x0008) ncmd 1
        Status: Success (0x00)
        Handle: 14 Address: 00:1B:DC:F2:24:10 (Vencer Co., Ltd.)
        Key size: 7
> ACL Data RX: Handle 14 flags 0x02 dlen 12
      L2CAP: Connection Request (0x02) ident 1 len 4
        PSM: 4097 (0x1001)
        Source CID: 64
< ACL Data TX: Handle 14 flags 0x00 dlen 16
      L2CAP: Connection Response (0x03) ident 1 len 8
        Destination CID: 64
        Source CID: 64
        Result: Connection successful (0x0000)
        Status: No further information available (0x0000)

Fixes: 288c06973daa ("Bluetooth: Enforce key size of 16 bytes on FIPS level")
Signed-off-by: Frédéric Danis <frederic.danis@collabora.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 8d6fc18695033..1258532228bbb 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -3954,7 +3954,8 @@ static void l2cap_connect(struct l2cap_conn *conn, struct l2cap_cmd_hdr *cmd,
 
 	/* Check if the ACL is secure enough (if not SDP) */
 	if (psm != cpu_to_le16(L2CAP_PSM_SDP) &&
-	    !hci_conn_check_link_mode(conn->hcon)) {
+	    (!hci_conn_check_link_mode(conn->hcon) ||
+	    !l2cap_check_enc_key_size(conn->hcon))) {
 		conn->disc_reason = HCI_ERROR_AUTH_FAILURE;
 		result = L2CAP_CR_SEC_BLOCK;
 		goto response;
-- 
2.39.5



