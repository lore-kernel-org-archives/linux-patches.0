Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B19D1494DB;
	Thu,  5 Sep 2024 10:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530699; cv=none; b=Pl0P5lEvvarLvMaJAYKNtoLQcXGesN3kY08dgJ17EmfeMdyGErYkzZpJe3VeCajb/JSjSy8S151ecxIGWYY8unxqNw8SHzdnUVjNtW5Vx8f2VNNpB/gPXDtjHTLOyPo4P5oxA84XfAVcXAnoCXKc1FWHroF2vHKgj0N+UfpHYCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530699; c=relaxed/simple;
	bh=qN2/EINIaFt5TBmYit86ba1EvOS0xto3eFVXkCNsulE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEb/e+mIu+8Pl/0QOFWmSKxoEuIKzI7y6g8nBNtrHId9aDFX/Qnyq3E4hpb/wVtfzpZkW5AKxNHfuKQJEcG7HYjSJPRL09OMaAGqwHx8UE5oy9I6gPCYS6bbOe7anzWpgxBzdTr02N4v5tbBM5vYoy9Jab1sYxvGyqkOjH+ZVIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ziOPXBR/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ziOPXBR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E11C4CEC3;
	Thu,  5 Sep 2024 10:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530699;
	bh=qN2/EINIaFt5TBmYit86ba1EvOS0xto3eFVXkCNsulE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ziOPXBR//pYIKCIFXnGKLRKjdvmx8WB8PKLMlyjZQZPluUYuP9266BmvNQsNQSomo
	 43jN17FBAYQGrUoJA30ajOB2JX1jZjeGnDVBulgCyBqODwW8Fb1eb2Dr/YGrAu8U02
	 nSPqAfbw6UX8nHVE+qc4hv+0GPxB0tXiEKn5V1tU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 096/101] Bluetooth: SCO: fix sco_conn related locking and validity issues
Date: Thu,  5 Sep 2024 11:42:08 +0200
Message-ID: <20240905093719.877944417@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Pauli Virtanen <pav@iki.fi>

commit 3dcaa192ac2159193bc6ab57bc5369dcb84edd8e upstream.

Operations that check/update sk_state and access conn should hold
lock_sock, otherwise they can race.

The order of taking locks is hci_dev_lock > lock_sock > sco_conn_lock,
which is how it is in connect/disconnect_cfm -> sco_conn_del ->
sco_chan_del.

Fix locking in sco_connect to take lock_sock around updating sk_state
and conn.

sco_conn_del must not occur during sco_connect, as it frees the
sco_conn. Hold hdev->lock longer to prevent that.

sco_conn_add shall return sco_conn with valid hcon. Make it so also when
reusing an old SCO connection waiting for disconnect timeout (see
__sco_sock_close where conn->hcon is set to NULL).

This should not reintroduce the issue fixed in the earlier
commit 9a8ec9e8ebb5 ("Bluetooth: SCO: Fix possible circular locking
dependency on sco_connect_cfm"), the relevant fix of releasing lock_sock
in sco_sock_connect before acquiring hdev->lock is retained.

These changes mirror similar fixes earlier in ISO sockets.

Fixes: 9a8ec9e8ebb5 ("Bluetooth: SCO: Fix possible circular locking dependency on sco_connect_cfm")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/sco.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -130,8 +130,11 @@ static struct sco_conn *sco_conn_add(str
 	struct hci_dev *hdev = hcon->hdev;
 	struct sco_conn *conn = hcon->sco_data;
 
-	if (conn)
+	if (conn) {
+		if (!conn->hcon)
+			conn->hcon = hcon;
 		return conn;
+	}
 
 	conn = kzalloc(sizeof(struct sco_conn), GFP_KERNEL);
 	if (!conn)
@@ -272,21 +275,21 @@ static int sco_connect(struct sock *sk)
 		goto unlock;
 	}
 
-	hci_dev_unlock(hdev);
-	hci_dev_put(hdev);
-
 	conn = sco_conn_add(hcon);
 	if (!conn) {
 		hci_conn_drop(hcon);
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto unlock;
 	}
 
-	err = sco_chan_add(conn, sk, NULL);
-	if (err)
-		return err;
-
 	lock_sock(sk);
 
+	err = sco_chan_add(conn, sk, NULL);
+	if (err) {
+		release_sock(sk);
+		goto unlock;
+	}
+
 	/* Update source addr of the socket */
 	bacpy(&sco_pi(sk)->src, &hcon->src);
 
@@ -300,8 +303,6 @@ static int sco_connect(struct sock *sk)
 
 	release_sock(sk);
 
-	return err;
-
 unlock:
 	hci_dev_unlock(hdev);
 	hci_dev_put(hdev);


