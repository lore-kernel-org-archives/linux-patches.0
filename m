Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B4A46D090;
	Fri,  7 Aug 2026 15:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116924; cv=none; b=FIJ9l+rUBOwr5C4RZGGfq3omTBGNb0qAindqhksU1cLdc6yrhHkTqPt7nt71A7bARENiMDk5Zct8DKOAzb9gs1qSk3UNpva2DncJcrQxWo7dsFtBbM97es1WSce47EcYzV0WyQzzlT9hNByC4IwreMO3H6yMuIGdAiV72ZYHdxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116924; c=relaxed/simple;
	bh=nt/4mqyA2BXwp948crimawJjOTK87fq4SQI/pIgE3XE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATC27sXfbY3biPIVp+wzj6dJ23TxzakyuwDg70Z/QOf1hIn3abqqsSGrzyQVGJIshA5zMafbAUh9MeZe5feJn6+0GfbcHYMaPd+5+O4uE0/YK5sPpoVSh3pmYcpXJuS0l+Lvw4hMYWpVphHH5KVz8itWzME3sO7ryQkWXSTDJIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PD6e/htv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PD6e/htv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9998F1F000E9;
	Fri,  7 Aug 2026 15:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116923;
	bh=4PPQGRfOxuLq3r8SKXj5d7b5dPa8IhXBJpVaYzhyz+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PD6e/htv51j5tTljEeoD/Faft2dc51dl2JBRFg+mH+McjDeQy0LNcEX79CbpOUIh/
	 f/vlU5vwgR3/a5KWQrVEeGPtcIkJKS3Re4ZRZQdRZx2F3BngvIT0hzkE9qPiwwzh2J
	 seBdPT2Wlym8WOwKn8ZRhN9A4QYPVqqtr0+1J6u4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 138/438] Bluetooth: ISO: ensure no dangling hcon references in iso_conn
Date: Fri,  7 Aug 2026 16:35:34 +0200
Message-ID: <20260807143430.946082101@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7e1dcaa22a5b2..31ceb1338dc23 100644
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
@@ -2499,6 +2513,7 @@ int iso_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr, __u8 *flags)
 }
 
 static void iso_connect_cfm(struct hci_conn *hcon, __u8 status)
+	__must_hold(&hcon->hdev->lock)
 {
 	if (hcon->type != CIS_LINK && hcon->type != BIS_LINK &&
 	    hcon->type != PA_LINK) {
@@ -2510,8 +2525,10 @@ static void iso_connect_cfm(struct hci_conn *hcon, __u8 status)
 			struct hci_link *link, *t;
 
 			list_for_each_entry_safe(link, t, &hcon->link_list,
-						 list)
+						 list) {
+				lockdep_assert_held(&link->conn->hdev->lock);
 				iso_conn_del(link->conn, bt_to_errno(status));
+			}
 
 			return;
 		}
@@ -2541,6 +2558,7 @@ static void iso_connect_cfm(struct hci_conn *hcon, __u8 status)
 }
 
 static void iso_disconn_cfm(struct hci_conn *hcon, __u8 reason)
+	__must_hold(&hcon->hdev->lock)
 {
 	if (hcon->type != CIS_LINK && hcon->type !=  BIS_LINK &&
 	    hcon->type != PA_LINK)
-- 
2.53.0



