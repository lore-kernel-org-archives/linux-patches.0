Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E5833C1AD;
	Fri,  7 Aug 2026 15:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114992; cv=none; b=iWzOi1aIZK+z53nYJBRXPOhvw+EcAbN8dTVCVDjGRwgsvsglQQOVMq3qTfU7LBG2OnI79DEpU3McazfhjdsBaiET5cEYmoWeBEWDTa/C3j2HB4ZuymM3TOj79ClYiDu0is2sTAAnGE8jJz13GELPu87Cuz2wJVA+lVOFo0wzV44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114992; c=relaxed/simple;
	bh=WcIm71VWRD15xh3h0TyYduSGgzpmND/SEc0E/PndF14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k434XdMQ0sfwKz/mcJKepqyfiPbloo8nNNOEujIZipev0KQRJfQ1Th0fOiB0Xulhz3YpEpxBkW3F5S+mIfRJV+8S9lIk8U3dwX+JNhHp6m6Zxvpv9aUXoT7ou5hOrpx384yCTgzrF6QbvE3rFVNhsww6Zuf5B4TkpeGCNBxuZA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LRs/vxx7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LRs/vxx7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815B11F000E9;
	Fri,  7 Aug 2026 15:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114991;
	bh=K0c/2Fpc8+Q87n2zpI+ZkH40shQ3OMuNcwGW/F5gmUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LRs/vxx7dRch0PUYFnf8vSz9+Mytucc6gK564op3rBjkrH1vw2IfDDLZmIb4+i4wG
	 4mhrXhu+YkYDMmC/i9XJnB9PBpKAAmpjvTVE1NiXMUeI1adq9twwPXmfhaQGDwS2II
	 aE6BYqLw0vs4xCLHEy+uUrNIhAXIvI2PNkPDpF9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 119/396] Bluetooth: ISO: ensure no dangling hcon references in iso_conn
Date: Fri,  7 Aug 2026 16:34:39 +0200
Message-ID: <20260807143426.870493211@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

[ Upstream commit aa9f7cb2bd3a2be998ceb739fc9a2f986eba43eb ]

After iso_conn_del(), ISO sockets should not dereference the hcon any
more.  Currently, clearing iso_conn::hcon relies on iso_conn_del()
releasing the last reference to the iso_conn.

Simplify this by explicitly clearing conn->hcon in iso_conn_del(), to
avoid more complex reasoning on races about who holds the last
reference.

Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: fdfde532ab1c ("Bluetooth: ISO: fix refcounting of iso_conn")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 3320be2d66b55..b21627b8e958b 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -262,6 +262,7 @@ static void iso_chan_del(struct sock *sk, int err)
 }
 
 static void iso_conn_del(struct hci_conn *hcon, int err)
+	__must_hold(&hcon->hdev->lock)
 {
 	struct iso_conn *conn = hcon->iso_data;
 	struct sock *sk;
@@ -276,11 +277,10 @@ static void iso_conn_del(struct hci_conn *hcon, int err)
 	iso_conn_lock(conn);
 	sk = iso_sock_hold(conn);
 	iso_conn_unlock(conn);
-	iso_conn_put(conn);
 
 	if (!sk) {
 		iso_conn_put(conn);
-		return;
+		goto done;
 	}
 
 	iso_sock_disable_timer(sk);
@@ -290,6 +290,15 @@ static void iso_conn_del(struct hci_conn *hcon, int err)
 	release_sock(sk);
 	iso_sock_kill(sk);
 	sock_put(sk);
+
+done:
+	/* No sk access to conn->hcon any more (lock_sock + hdev->lock) */
+	iso_conn_lock(conn);
+	conn->hcon = NULL;
+	hcon->iso_data = NULL;
+	iso_conn_unlock(conn);
+
+	iso_conn_put(conn);
 }
 
 static int __iso_chan_add(struct iso_conn *conn, struct sock *sk,
@@ -305,6 +314,11 @@ static int __iso_chan_add(struct iso_conn *conn, struct sock *sk,
 		return -EBUSY;
 	}
 
+	if (!conn->hcon) {
+		BT_ERR("conn->hcon missing");
+		return -EIO;
+	}
+
 	iso_pi(sk)->conn = conn;
 	conn->sk = sk;
 	clear_bit(ISO_CONN_DROPPED, conn->flags);
@@ -2410,6 +2424,7 @@ int iso_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr, __u8 *flags)
 }
 
 static void iso_connect_cfm(struct hci_conn *hcon, __u8 status)
+	__must_hold(&hcon->hdev->lock)
 {
 	if (hcon->type != CIS_LINK && hcon->type != BIS_LINK &&
 	    hcon->type != PA_LINK) {
@@ -2421,8 +2436,10 @@ static void iso_connect_cfm(struct hci_conn *hcon, __u8 status)
 			struct hci_link *link, *t;
 
 			list_for_each_entry_safe(link, t, &hcon->link_list,
-						 list)
+						 list) {
+				lockdep_assert_held(&link->conn->hdev->lock);
 				iso_conn_del(link->conn, bt_to_errno(status));
+			}
 
 			return;
 		}
@@ -2452,6 +2469,7 @@ static void iso_connect_cfm(struct hci_conn *hcon, __u8 status)
 }
 
 static void iso_disconn_cfm(struct hci_conn *hcon, __u8 reason)
+	__must_hold(&hcon->hdev->lock)
 {
 	if (hcon->type != CIS_LINK && hcon->type !=  BIS_LINK &&
 	    hcon->type != PA_LINK)
-- 
2.53.0



