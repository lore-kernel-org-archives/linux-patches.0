Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622772;
	b=mTfp2tF3dYZjlAYvAyCBK2yNTNbDq5jCMRq1NPIG3ShftyXFyFoxvvxzLbIKZBeLx6FT
	 QV8s7Ar6bG7IFVtm2QJUW70FPOATP21G1E05sH1zmC/dnahXYofjVGHr+qAGqkfYMMu7n
	 kkbl7AwYJdLSkKzBTwjcyfECFZYkgwehTk0xujECK4IR6zq18pziWGsqzPRtdRtKnqvpD
	 6vYxJopnY5quM+s8dedQ6Dgx8bRmopOFZUB1PzllhBI95IX88vNDlPodsYpJpcE+gSdTF
	 /06IN5cpfeJkM/BbFZ/IyPKKS6lnNL9c4HXzqvfiHiLPI+XEC13yoxc7Bd2QcL6kxRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YiVjvMv24OtEJ+inPD3MARagbK/OD6+c1tQhxdSE4Z4=;
	b=dAmWPMHg1FX2tcwBEeJfykrDB/+0NTrk2tywR0yf8C08/IzHGJHbA5InHHhKW5EM91GV
	 M6CW8Ck2CbrI4UCStuPGcDPtmPjlgUuHql5SYBQbdJF2tDWbuyMiQdXk3NQT05fdmBxph
	 H/W3W4wZTUiUtLqNfXFh/N3Tw76ERbidran+kmV0uX/4sGVa/IRvYvkINMESCj/NKmYBJ
	 ydc+zGz+niB1z1j2u6xIpcdaXr81Q5+0JbVBvOd9Su1dA0MQuitoPSbjMcK7CB8BHYZt5
	 NwNT7ejSSUeWlZ1NxMBYOwirYjJkaye7S4I9VUlA7Wp4e7dDSvz4Zr5O66S/XvQsujQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HwtMgfro;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A829606A327;
	Wed, 25 Nov 2026 16:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HwtMgfro
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3941F000C0;
	Wed, 25 Nov 2026 16:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622772;
	bh=YiVjvMv24OtEJ+inPD3MARagbK/OD6+c1tQhxdSE4Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HwtMgfroQ4Hko1V3HbRM2XKsD1wyiYgoFuL/5eqPsvmUnLjWlGnuSKLG8IFelc9bC
	 roxefVy9eHRsO8pb6ge7ljF5yo9+u7nCQobLO5K7/8J0CO06D7DVk4Azt7knU4oD0e
	 eZ7uwn7gXfheFDJF9JHwR/t8nT0XhaQacpGN/IZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Dewald <kevin@simpleble.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 597/990] Bluetooth: hci_event: Fix LE link drop on remote features command status
Date: Wed, 25 Nov 2026 15:32:44 +0100
Message-ID: <20261125143836.075994733@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Dropped the hunk for hci_cs_le_read_all_remote_features() (function absent here) and placed the fix inside the nested if (conn) { if (conn->state == BT_CONFIG) } form of hci_cs_le_read_remote_features(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 3e487963eaff9..797b86f57c6db 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2941,6 +2941,22 @@ static void hci_cs_le_read_remote_features(struct hci_dev *hdev, u8 status)
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



