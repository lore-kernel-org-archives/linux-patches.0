Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F111420478;
	Fri,  7 Aug 2026 15:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116927; cv=none; b=qLudsEWHsJ6FlnLpXdSn/pPW5n7KrkudnNqrIvxgZrLlc8SZhkvxzFJLO+0sKOIffNiIMuvM/vKh1KqLsI9YlbeqNh4XXbn9jM9O1FzS8yH5JP6YT2gp5OF3FPtVNSaEEXMfwqkoCdrkOu9DtmI7dl7v51w1zNCnXjKYT+IAvQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116927; c=relaxed/simple;
	bh=QSLjUEzt37xqBQLzXHiVKIslLiP0q0YEO5n2ocZuWjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XvP+sR0qWfiPEETenBe0lXjvKFISjdaolpRHj85ob9DpazzqDohOvdbrK/Ta254AeDwhwKYcb+Ka96y1094FNAFndDrzLhoSRiU2qw2tzU6kX6nPi2t3SbiqZgdkk30MJOBFjxV2JmlP1mmLepgvCzwk5ZZxlu3RVgAvYUnZOXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=utn1piFz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="utn1piFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7AE1F000E9;
	Fri,  7 Aug 2026 15:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116926;
	bh=1PUz0eFe9Xew8bl0TgToiID9xZmpwKfpJVRiPy4HGvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=utn1piFzosOVRwRx0rYpSXj+kfNGVTiO1ME0qkNh30nfRnAQBGE0oNq3BNfehwUz7
	 AgDCuYpv3eBSNumcDzLYO5VLJ622mNp22d6CKH3LJOPfyNhXJOcThTa+Qrl6LiVute
	 5jmOGXzdzxgYYjK7elRLN/gubkU9yD1mRSa9WJik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 139/438] Bluetooth: ISO: fix refcounting of iso_conn
Date: Fri,  7 Aug 2026 16:35:35 +0200
Message-ID: <20260807143430.967751645@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 31ceb1338dc23..3b22193a9ec32 100644
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
 
@@ -1309,10 +1313,9 @@ static int iso_listen_bis(struct sock *sk)
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
@@ -2550,8 +2553,10 @@ static void iso_connect_cfm(struct hci_conn *hcon, __u8 status)
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



