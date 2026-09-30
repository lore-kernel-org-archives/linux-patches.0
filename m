Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C877251DDE9;
	Wed, 30 Sep 2026 18:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793634; cv=none; b=pKsmWf2yqYppQe9d2f/qGipu28vPRotFVc4zAGfjZpgZ+3RB5rVaK46IQ8O3/rlVEf+tZDiazfBDb9Icvy3JyFzNuFEiMBJ8gNp9h8EmNPoKUzbJsUfnYRUGT8YkkBICyJJxDI1wtsDxYTWBUu/oiWmDFXOxWYhz/OcC52JZAm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793634; c=relaxed/simple;
	bh=IqQCP0BQVEotmB4uGtZ2JTCmWANq8hrEsB4q4I2swMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yt/Dci5Az4u/RaIwPW1n6z9xgHdY31WkwweBoVPbrHUtyMIIwEaSL+f7WpVTlK/rT3akSegDlnyKNeNsAbGMLUDrhmSB03qtR8HIF/KjoYT7v1ssWi7pMQteQEFAsXiV6weGiu6udF+Up3aiLkZA1YNYXHMmJrPOp+rOWAcjAlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xqSRojr+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xqSRojr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342861F000FF;
	Wed, 30 Sep 2026 18:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793633;
	bh=eXHqwM9rrctxSzobd35CQyOTkoZnrSG110xJwybS1cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xqSRojr+sSmc0uzGYg2FU282FKu5S9rAblSiKqRLslXMWAFUGr8awQ7rja0TYu5o+
	 yzDcjtrVmKF7RbFShpSj1SdsHnh5UOvL3E4lRZhMhcFZVQqL+hBuwVxNjnJ7QTEB7c
	 r/TUdIjWzFWOdcnbQfgF5dnxXh/D0dtV/zno+EB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 325/395] Bluetooth: ISO: release unused CIS holds after channel attach
Date: Wed, 30 Sep 2026 17:29:47 +0200
Message-ID: <20260930152347.709968335@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit 0fcd4dad555c96e0bd3a1b8c569f989be85c7341 upstream.

hci_bind_cis() and hci_connect_cis() return one hci_conn hold for the
ISO layer.  A new channel association consumes that hold, which is
eventually released by iso_conn_free().

There are two cases where iso_chan_add() does not create an association:
it returns success when the socket is already attached to the same
iso_conn, and it returns -EBUSY when another socket is attached.  The
hold returned for the current call is unused in both cases.  This occurs
when deferred setup calls iso_connect_cis() again for its existing
socket, or when another socket attempts to reuse the CIS.

Detect the idempotent case while the connection is locked and release
the unused hold after iso_chan_add().  Also release it on -EBUSY.  Do not
drop it for other errors: a newly allocated iso_conn releases the
transferred hold when its last temporary reference is put.

Fixes: 69997d50ec57 ("Bluetooth: ISO: handle bound CIS cleanup via hci_conn")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/iso.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -460,6 +460,7 @@ static int iso_connect_cis(struct sock *
 	struct hci_dev  *hdev;
 	bdaddr_t src, dst;
 	u8 src_type;
+	bool already_attached;
 	int err;
 
 	lock_sock(sk);
@@ -530,8 +531,14 @@ static int iso_connect_cis(struct sock *
 		goto unlock;
 	}
 
+	iso_conn_lock(conn);
+	already_attached = iso_pi(sk)->conn == conn && conn->sk == sk;
+	iso_conn_unlock(conn);
+
 	err = iso_chan_add(conn, sk, NULL);
 	iso_conn_put(conn);
+	if (already_attached || err == -EBUSY)
+		hci_conn_drop(hcon);
 	if (err)
 		goto unlock;
 


