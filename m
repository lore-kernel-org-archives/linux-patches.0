Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31103F54B6;
	Thu, 16 Jul 2026 14:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210855; cv=none; b=UtZewu4KaksZeqlfj/TCWNejEqniVFYZs7Gwm2fuzoTEJk+qZif5HU68aRlIiNSogjeJe2jKBD/6WhkgBIwKmE51Z10GUD8JoUpQLkf1aNyJTCyhHizzgPscK76X70x1o24DzLGxk7K3rxeZJ7/iTRtLz7II+0Si2EHNZ7mdxw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210855; c=relaxed/simple;
	bh=1q7lnPLvYo30UabvEl54qgS3pm9A8PDyZ4yckWi/VSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WmTW1Lwe9DS+u08rG9jahnw8UPQBBK2MSwuMjujNknwxqRJ08Uof64niqDO7dh/3ex3NLfD6kzJyAA6uFXUfXSNBJvXTH16LkX143S2G6QmLc6V+2G4aFqIkgEvNGezxI9p/7wyz7p5T+gK5fP5s0QdWZwf2Ns6+19+Ff9QgPCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xhLmdVtt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xhLmdVtt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A371F000E9;
	Thu, 16 Jul 2026 14:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210854;
	bh=ri52M4VVbLqWxfyN/pd6iYBgBlsZ88Iu0sUTYmAuiSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xhLmdVtt0JC2zdLiLsK5WK/21fIo6ddiMPuTBzKzyPw+maAqkw+l/tRipraPLh6Sk
	 9YZvrKvGKHIbRYL2puYmt5+0N75DSthTXluV0RWXVZ7ey4gnmm8CPfNgZA9LTi6vnd
	 pIUV0SmhXcrZwDO6VtQWO3gKmrCnjg5IB9G8VNUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 206/480] Bluetooth: ISO: avoid NULL deref of conn in iso_conn_big_sync()
Date: Thu, 16 Jul 2026 15:29:13 +0200
Message-ID: <20260716133049.182701374@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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
@@ -1515,6 +1515,7 @@ static void iso_conn_big_sync(struct soc
 {
 	int err;
 	struct hci_dev *hdev;
+	struct iso_conn *conn;
 	bdaddr_t src, dst;
 	u8 src_type;
 
@@ -1537,8 +1538,17 @@ static void iso_conn_big_sync(struct soc
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
@@ -1547,6 +1557,7 @@ static void iso_conn_big_sync(struct soc
 			bt_dev_err(hdev, "hci_big_create_sync: %d", err);
 	}
 
+unlock:
 	release_sock(sk);
 	hci_dev_unlock(hdev);
 	hci_dev_put(hdev);


