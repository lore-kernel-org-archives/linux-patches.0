Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362964F93A8;
	Wed, 30 Sep 2026 16:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786320; cv=none; b=Q8nIv2YJTU3xFHFnc4KWfWSDcFmGubLm2y8E0e21TTx3mfsZe2uB7BWNevn6BBX0qYS+H1psL+WUtDtV4okkJU+oNMZVbZWLlG0HbvtgOCQs+Y2axwEPjT95garkRGKElvW0ryNt4rJ67BSky1xPZwKYQPnJPEgDOeJCURvj278=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786320; c=relaxed/simple;
	bh=0Wpa6TVsS4LEZDscYpLRaxEDMyEDgKBre9HsVMN5BNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IjmmdNlB5w8dII1aB+akRSzJW9RldfWJ2bI3dTeJciiFd7BYMVi5Ksn1bAczDuaD2POdKxBf5dxi9tj4hkROobBKTFgpvXh6mINTp2KCY3gkOJP3Bg28fJIvuHiUMFzPR3rh/W9bMuleV7fHhROu/5JpZMRWxJQspHI7sDBEu8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZFow70t9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZFow70t9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916791F000FF;
	Wed, 30 Sep 2026 16:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786319;
	bh=44b51n7Lv2GYrCOW1i6S+pBGhWC45osFg9sUnmng4nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZFow70t9xh/QPi9C5yz09YpNBXKFVorrjyWk3+bbtGYPODhUsoE+0TbyFvhsTNjmj
	 +rQWVMDJTzJynM3EP5obboAJ6NOaLOYiJoMMn1i5e7SQ4oLQVRkptV4n0MaDorm/4l
	 MJ1J+Y8DMzcOs8w2TThhSbUR5bmVMd7+5xi3ukdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christiano Amora <christiano.amora@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 819/982] Bluetooth: SMP: reject Security Request over BR/EDR
Date: Wed, 30 Sep 2026 17:25:55 +0200
Message-ID: <20260930152434.350683064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Christiano Amora <christiano.amora@gmail.com>

[ Upstream commit f033482d76a9f18080c7a40c5f9c678bd7adc8f3 ]

Bose QC Ultra Headphones (dual-mode, same public address on both
transports) occasionally send an SMP Security Request on the BR/EDR
SMP fixed channel right after the ACL link is encrypted. The kernel
handles it as if it were an LE link: smp_cmd_security_req() has no
transport check, smp_ltk_encrypt() looks up an LTK with the ACL
connection's dst_type, and hci_find_ltk() matches the peer's LE LTK
because the LE public address type is stored as ADDR_LE_DEV_PUBLIC (0),
the same value as BDADDR_BREDR. HCI_OP_LE_START_ENC is then issued on
the ACL handle, the controller rejects it with Invalid HCI Command
Parameters, and hci_cs_le_start_enc() disconnects the link with
HCI_ERROR_AUTH_FAILURE. The headphones drop within a second of
connecting, before any profile is up; a manual reconnect works.

btmon (MediaTek MT7922, kernel 7.0.12):

  > HCI Event: Encryption Change (0x08) plen 4
        Status: Success (0x00)
        Handle: 50 Address: BC:87:FA:47:73:5E (Bose Corporation)
        Encryption: Enabled with AES-CCM (0x02)
  > ACL Data RX: Handle 50 flags 0x02 dlen 6
        BR/EDR SMP: Security Request (0x0b) len 1
        Authentication requirement: No bonding, No MITM, SC (0x08)
  < HCI Command: LE Start Encryption (0x08|0x0019) plen 28
        Handle: 50 Address: BC:87:FA:47:73:5E (Bose Corporation)
  > HCI Event: Command Status (0x0f) plen 4
        LE Start Encryption (0x08|0x0019) ncmd 1
        Status: Invalid HCI Command Parameters (0x12)
  < HCI Command: Disconnect (0x01|0x0006) plen 3
        Handle: 50 Address: BC:87:FA:47:73:5E (Bose Corporation)
        Reason: Authentication Failure (0x05)

SMP over BR/EDR is limited to cross-transport key derivation; the
Security Request procedure (Core Specification Vol 3, Part H, Section
2.4.6, PDU in Section 3.6.7) has no BR/EDR counterpart. Reply with
Pairing Failed / Command Not Supported on a non-LE link, before the PDU
is parsed, and keep the connection. The reply is sent directly rather
than through smp_failure(): rejecting a command on the wrong transport
is not an authentication failure, and MGMT_EV_AUTH_FAILED would make
bluetoothd disconnect the device.

Tested on the affected host (kernel 7.0.12, MediaTek MT7922, Bose QC
Ultra) with the patched module built out of tree: 7 days and 49
reconnects without a drop, against 2 drops in the 3 days before the
patch. Every disconnect in that week had a userspace or remote reason.

Fixes: b5ae344d4c0f ("Bluetooth: Add full SMP BR/EDR support")
Assisted-by: LLM
Signed-off-by: Christiano Amora <christiano.amora@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/smp.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 1f8561112ec14..1700e295f14da 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -2295,6 +2295,23 @@ static u8 smp_cmd_security_req(struct l2cap_conn *conn, struct sk_buff *skb)
 
 	bt_dev_dbg(hdev, "conn %p", conn);
 
+	/* SMP over BR/EDR only covers cross-transport key derivation; the
+	 * Security Request procedure has no BR/EDR counterpart. Reject it
+	 * here, otherwise smp_ltk_encrypt() finds the peer's LE LTK
+	 * (ADDR_LE_DEV_PUBLIC and BDADDR_BREDR are both 0) and issues
+	 * HCI_OP_LE_START_ENC on the ACL handle, which the controller
+	 * rejects and hci_cs_le_start_enc() turns into a disconnect. Reply
+	 * without smp_failure(): this is not an authentication failure, and
+	 * MGMT_EV_AUTH_FAILED would make bluetoothd drop the device.
+	 */
+	if (hcon->type != LE_LINK) {
+		u8 reason = SMP_CMD_NOTSUPP;
+
+		smp_send_cmd(conn, SMP_CMD_PAIRING_FAIL, sizeof(reason),
+			     &reason);
+		return 0;
+	}
+
 	if (skb->len < sizeof(*rp))
 		return SMP_INVALID_PARAMS;
 
-- 
2.53.0



