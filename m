Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625377;
	b=DTy/Gs6A4w8bmq5fQTlLR80U57sOd7JQYF007F8cfuRAkburpnxxd2mGBNAdKawczWOq
	 XBn1GeRDxjQKlDZa1u8srR+8gp3Jk8yWXU+AlOvf1P2KdYhtuv+6z3ZKaF+K+51pR6AVU
	 7ZSVi5FIpwBmYMpqk4cvBHdMEGKO1dC3VEU2QdPdpRQwd0w/UBlk2uw7i/Ghd+wQZqOld
	 yp7hH9vr6HUIlt/hNtYp0J3xky8F+I/vqcUBkf6sdVJbPyYwd8phMpEQ63jIZWK7KyQbr
	 JsZzpAWAYTOkcPbXEco7zYKo57ZaMu0l2dZCH6kHBDfZIclTEsdXMzx7l1zkjxOtG6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625377;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c+t+VgHqKE6NnNGucSkWM+8pTE32N6SyMlxoS78yRVY=;
	b=Jhp9Stg+ej38lSjg5kRhY1CoxGxQDw9cSNStx0q3F7279CS5aXgwmayvPqDFcaC0c6CK
	 7dbTOC5Ca+CbccCbCMzfl9L+iMHCYZgy6y2FTCBcYBPijkY/tA5iA6C4wPrJ30Nmbwsr2
	 P9k+EF5301we58any3rzYQ5YbHx+6zQJ2mpuTCHcsxZszsc7HsKnmTQEWthbsgwTFJ31W
	 lB0eG65CF7/NBosufLhg0YmoF3sZnGg79/thCHrjf4iBHU30SEWiphhqUOXlLODpXRDqn
	 2pT9/Xy9Cvy1ZJx2W/rfIZjWmN1ZQBY7IrSc8DJcqu+Pp8AV83Cw3R+hXnRn8kRgT/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2BnXgwkl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA84606A323;
	Wed, 25 Nov 2026 16:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2BnXgwkl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5C81F000C6;
	Wed, 25 Nov 2026 16:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625377;
	bh=c+t+VgHqKE6NnNGucSkWM+8pTE32N6SyMlxoS78yRVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2BnXgwkl7bq9cl4t5uu9oRzfHipg138y00O0szFIt8tlNeXr0AlcmHzS3hZCf800L
	 ZiE98VP62OT6YcSQFN5Jvf2Zs4znhcH5ZRvaERHtrdkMq9Zh+r1Cy9Tq0AAa2cRFDY
	 mFkxJ87E+e642vIHX+cLUZfhamkU+SYisy90eALM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Dewald <kevin@simpleble.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 495/816] Bluetooth: hci_event: Fix LE link drop on remote features command status
Date: Wed, 25 Nov 2026 15:34:03 +0100
Message-ID: <20261125143900.647979313@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Dewald <kevin@simpleble.org>

[ Upstream commit 91638f53ff2b8234195ff27ec913e068269a28e9 ]

When the local controller supports peripheral-initiated features
exchange, the LE Read Remote Features procedure also runs for incoming
connections, and it fails with Unsupported Remote Feature (0x1a) if the
central does not support that feature. hci_le_remote_feat_complete_evt()
and hci_le_read_all_remote_features_evt() handle this and let the
connection transition into connected state.

A controller can also return that error in the Command Status event
instead. An Intel controller does so for a central that does not
support peripheral-initiated features exchange, presumably because it
already has the features of the central. hci_cs_le_read_remote_features()
and hci_cs_le_read_all_remote_features() then confirm the connection as
failed while it is still in BT_CONFIG, and the hci_conn_drop() in
le_read_features_complete() disconnects it right away:

  > HCI Event: LE Meta Event (0x3e) plen 31
      LE Enhanced Connection Complete (0x0a)
        Status: Success (0x00)
        Role: Peripheral (0x01)
  < HCI Command: LE Read Remote Used Features (0x08|0x0016) plen 2
  > HCI Event: Command Status (0x0f) plen 4
      LE Read Remote Used Features (0x08|0x0016) ncmd 1
        Status: Unsupported Remote Feature / Unsupported LMP Feature (0x1a)
  < HCI Command: Disconnect (0x01|0x0006) plen 3
        Reason: Remote User Terminated Connection (0x13)

Data the central sends afterwards is reported as:

  Bluetooth: hci0: ACL packet for unknown connection handle 3585

Handle Unsupported Remote Feature in the command status the same way as
in the complete events.

Fixes: 0fe29fd1cd77 ("Bluetooth: Read LE remote features during connection establishment")
Fixes: a106e50be74b ("Bluetooth: HCI: Add support for LL Extended Feature Set")
Assisted-by: Claude:claude-opus-5.5
Signed-off-by: Kevin Dewald <kevin@simpleble.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[ sashal: Kept this tree's nested if (conn) { if (conn->state == BT_CONFIG) {...} } with hci_conn_drop() and added the new block inside, and dropped the second hunk because the all-remote-features function doesn't exist here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 3eea2343f1977..f723210c52e53 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2930,6 +2930,22 @@ static void hci_cs_le_read_remote_features(struct hci_dev *hdev, u8 status)
 	conn = hci_conn_hash_lookup_handle(hdev, __le16_to_cpu(cp->handle));
 	if (conn) {
 		if (conn->state == BT_CONFIG) {
+			/* If the local controller supports peripheral-initiated
+			 * features exchange, but the remote controller does not,
+			 * then the controller may already return the error code
+			 * 0x1a for unsupported remote feature in the command
+			 * status.
+			 *
+			 * Handle it as hci_le_remote_feat_complete_evt() does and
+			 * allow the connection to transition into connected state.
+			 */
+			if (!conn->out &&
+			    status == HCI_ERROR_UNSUPPORTED_REMOTE_FEATURE &&
+			    (hdev->le_features[0] & HCI_LE_PERIPHERAL_FEATURES)) {
+				conn->state = BT_CONNECTED;
+				status = 0x00;
+			}
+
 			hci_connect_cfm(conn, status);
 			hci_conn_drop(conn);
 		}
-- 
2.53.0



