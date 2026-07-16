Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AB94248CD;
	Thu, 16 Jul 2026 14:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211982; cv=none; b=XTyzUoDR05k1MVb48k86Wri5oX25TIorzqKf3+WD7DR0YS90b6XZCd7684rDsXjonkKg/6D4LbdaxO8Kwd1iMqDzcNqFIQ8p7XYAun3/cdJqCUAkjm6jMPuXXFeVf59i4oKphjLHpXdgRzp5lteYV0cg35ftLASVhW79m6elbqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211982; c=relaxed/simple;
	bh=iRdNTlYY/SUVTFrqTwiTFbMWpOM7UqTAYhSVoG5UvWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgxynxDbDwIutx7oIu3Qz5WqEahMnTVPVo8H9BRpaPlvcvXZ+PRWYTvmdsIfvR/jmQ+NDJF90I2T5mj9k4gPnPlr1RMKlSwo/CAHUfabeDZ3Kya5cXB2Oo6a+RUUsApMKE3+R/6Qm1ppMr4E89RHLSzZkUWMpFC11DaJXsSRrhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mJo3gpXc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJo3gpXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3434F1F000E9;
	Thu, 16 Jul 2026 14:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211981;
	bh=QaMnI4GhAtbEBmt0t4DhZ1oS9ODLTBokDSFKg1gneII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mJo3gpXc91wIoUYs4hlMYdcV9wEepk5sL/RJ2IXVsHkP6+6mBlcap75QDrwQNqzpD
	 l83t80Al5Abb0JXs+1zhkdR7q2y4gHM+/guBuBgw5FT6u7SKjlA1Ycqos6pC3v2WLt
	 5KRvnMek7yme6sfyVfLDtRBjDHhpDpa5Ooq1b5gE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 155/349] Bluetooth: ISO: avoid NULL deref of conn in iso_conn_big_sync()
Date: Thu, 16 Jul 2026 15:31:29 +0200
Message-ID: <20260716133036.853463692@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Muhammad Bilal <meatuni001@gmail.com>

commit d5541eb148da72d5e0a1bca8ecd171f9fc8b366f upstream.

iso_conn_big_sync() drops the socket lock to call hci_get_route() and
then re-acquires it, but dereferences iso_pi(sk)->conn->hcon afterwards
without re-checking that conn is still valid.

While the lock is dropped, the connection can be torn down under the
same socket lock: iso_disconn_cfm() -> iso_conn_del() -> iso_chan_del()
sets iso_pi(sk)->conn to NULL (and the broadcast teardown path can also
clear conn->hcon on its own). When iso_conn_big_sync() re-acquires the
lock and reads conn->hcon, conn may be NULL, causing a NULL pointer
dereference (hcon is the first member of struct iso_conn).

This path is reached from iso_sock_recvmsg() for a PA-sync broadcast
sink socket (BT_SK_DEFER_SETUP | BT_SK_PA_SYNC), so the dropped-lock
window can race with connection teardown driven by controller events.

Re-validate iso_pi(sk)->conn and its hcon after re-acquiring the socket
lock and bail out if the connection went away, as already done in the
sibling iso_sock_rebind_bc().

Fixes: 7a17308c17880d ("Bluetooth: iso: Fix circular lock in iso_conn_big_sync")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/iso.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1443,6 +1443,7 @@ static void iso_conn_big_sync(struct soc
 {
 	int err;
 	struct hci_dev *hdev;
+	struct iso_conn *conn;
 	bdaddr_t src, dst;
 	u8 src_type;
 
@@ -1465,8 +1466,17 @@ static void iso_conn_big_sync(struct soc
 	hci_dev_lock(hdev);
 	lock_sock(sk);
 
+	/* The socket lock was dropped for hci_get_route(), so the connection
+	 * may have been torn down meanwhile: iso_chan_del() clears conn and
+	 * the broadcast teardown path can clear conn->hcon on its own. Check
+	 * both before dereferencing conn->hcon.
+	 */
+	conn = iso_pi(sk)->conn;
+	if (!conn || !conn->hcon)
+		goto unlock;
+
 	if (!test_and_set_bit(BT_SK_BIG_SYNC, &iso_pi(sk)->flags)) {
-		err = hci_conn_big_create_sync(hdev, iso_pi(sk)->conn->hcon,
+		err = hci_conn_big_create_sync(hdev, conn->hcon,
 					       &iso_pi(sk)->qos,
 					       iso_pi(sk)->sync_handle,
 					       iso_pi(sk)->bc_num_bis,
@@ -1475,6 +1485,7 @@ static void iso_conn_big_sync(struct soc
 			bt_dev_err(hdev, "hci_big_create_sync: %d", err);
 	}
 
+unlock:
 	release_sock(sk);
 	hci_dev_unlock(hdev);
 	hci_dev_put(hdev);


