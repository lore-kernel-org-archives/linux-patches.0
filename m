Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1420733C1AD;
	Fri,  7 Aug 2026 15:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114995; cv=none; b=gMwdig77H5q4m7FdUemL4hwCX27fcp1qDcRpq3qgZ8dTmC+H7SIe5lzAW564S4/dJPadm9zKivfdXlbTFikFrkxlKApy7MNNe9Yk3qEZYRqj8FJUt17rmTofMVcEhNQjMW7TH3YXzXSM1nMgvE8PV0qFZwIs/PrMjrfnyHKu52o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114995; c=relaxed/simple;
	bh=YWFwjLBkKZQ6s7038RbO9jPnKNsKfv+WAa+aC8xuLa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=edAdk/aIKE1bLvLP1QGmHBAa7BdAainfVpfA97lilHEEDkFU7KjVyRqcZDWRyoM/JiihR5uDZPnLY1+qyZwJ7C7hM9NH0Y4gvKKhhPdx7a9vlVP8s+aCO8Is5ploryelsmCY2A0hn574f4X1pVA3mr7K0uUyvNZjoUW4I1aGub4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JbQS8phl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JbQS8phl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E96F1F000E9;
	Fri,  7 Aug 2026 15:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114994;
	bh=MBZoCO7n58IRN8KTCPo8XQmtDKboNKyRPf6RnrpKkmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JbQS8phlgx2esQN5m0Re+hOCEKmmpY/bCxhDrhRXvy1maC9uaYpRIPy2/N7E3vQQ1
	 SFWmx7q9Xl7LVr7ADGvPnVXssGVDsaJzxze3pFmnXXXb6a/YdnzAQdwAx02bIffugT
	 TnZHZHcjemz6NubNh18z36VZckovy5PIMX7XltTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 120/396] Bluetooth: ISO: fix refcounting of iso_conn
Date: Fri,  7 Aug 2026 16:34:40 +0200
Message-ID: <20260807143426.894530577@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit fdfde532ab1caa165fcd8985001157ac8b4db365 ]

iso_conn_del() and iso_chan_del() have a race that results to double-put
of iso_conn:

    [Task hdev->workqueue]         [Task 2]
    iso_conn_del                   iso_chan_del
      iso_conn_hold_unless_zero      iso_conn_lock
      iso_conn_lock                  conn->sk = NULL
                                     iso_conn_unlock
      sk = iso_sock_hold(conn)  <---------´
      if (!sk) iso_conn_put          iso_conn_put
      iso_conn_put /* UAF */

The extra put for !sk in iso_conn_del() is currently required since
failing iso_chan_add() may leave iso_conn not associated with any sk.

Fix by having iso_pi(sk)->conn own refcount when non-NULL, so
iso_conn_del does not need to put it.  Adjust the iso_conn_add()
refcounting so that conn is put if it does not get associated with an
sk.

Fixes: dc26097bdb86 ("Bluetooth: ISO: Use kref to track lifetime of iso_conn")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index b21627b8e958b..fcf4fd78c7cc9 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -107,9 +107,6 @@ static void iso_conn_free(struct kref *ref)
 
 	BT_DBG("conn %p", conn);
 
-	if (conn->sk)
-		iso_pi(conn->sk)->conn = NULL;
-
 	if (conn->hcon) {
 		conn->hcon->iso_data = NULL;
 		if (!test_and_set_bit(ISO_CONN_DROPPED, conn->flags))
@@ -144,6 +141,14 @@ static struct iso_conn *iso_conn_hold_unless_zero(struct iso_conn *conn)
 	return conn;
 }
 
+static struct iso_conn *iso_conn_hold(struct iso_conn *conn)
+{
+	BT_DBG("conn %p refcnt %u", conn, kref_read(&conn->ref));
+
+	kref_get(&conn->ref);
+	return conn;
+}
+
 static struct sock *iso_sock_hold(struct iso_conn *conn)
 {
 	if (!conn || !bt_sock_linked(&iso_sk_list, conn->sk))
@@ -209,7 +214,6 @@ static struct iso_conn *iso_conn_add(struct hci_conn *hcon)
 			conn->hcon = hcon;
 			iso_conn_unlock(conn);
 		}
-		iso_conn_put(conn);
 		return conn;
 	}
 
@@ -278,10 +282,8 @@ static void iso_conn_del(struct hci_conn *hcon, int err)
 	sk = iso_sock_hold(conn);
 	iso_conn_unlock(conn);
 
-	if (!sk) {
-		iso_conn_put(conn);
+	if (!sk)
 		goto done;
-	}
 
 	iso_sock_disable_timer(sk);
 
@@ -319,7 +321,7 @@ static int __iso_chan_add(struct iso_conn *conn, struct sock *sk,
 		return -EIO;
 	}
 
-	iso_pi(sk)->conn = conn;
+	iso_pi(sk)->conn = iso_conn_hold(conn);
 	conn->sk = sk;
 	clear_bit(ISO_CONN_DROPPED, conn->flags);
 
@@ -426,6 +428,7 @@ static int iso_connect_bis(struct sock *sk)
 	}
 
 	err = iso_chan_add(conn, sk, NULL);
+	iso_conn_put(conn);
 	if (err)
 		goto unlock;
 
@@ -528,6 +531,7 @@ static int iso_connect_cis(struct sock *sk)
 	}
 
 	err = iso_chan_add(conn, sk, NULL);
+	iso_conn_put(conn);
 	if (err)
 		goto unlock;
 
@@ -1228,10 +1232,9 @@ static int iso_listen_bis(struct sock *sk)
 	}
 
 	err = iso_chan_add(conn, sk, NULL);
-	if (err) {
-		hci_conn_drop(hcon);
+	iso_conn_put(conn);
+	if (err)
 		goto unlock;
-	}
 
 unlock:
 	release_sock(sk);
@@ -2461,8 +2464,10 @@ static void iso_connect_cfm(struct hci_conn *hcon, __u8 status)
 		struct iso_conn *conn;
 
 		conn = iso_conn_add(hcon);
-		if (conn)
+		if (conn) {
 			iso_conn_ready(conn);
+			iso_conn_put(conn);
+		}
 	} else {
 		iso_conn_del(hcon, bt_to_errno(status));
 	}
-- 
2.53.0



