Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409392BEFF5;
	Tue, 21 Jul 2026 20:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667174; cv=none; b=Z30NNXc++ULZVHQWVpjhHU+VDIq4DDNP/bYUcxY8hRFPqEWuBk1MNhaJnSgCSef+/z5TZJjv1aES/pCyfgNlAjb7bwzs+issDl93oKlGr8YqGdTxm9bF+HKqFbXt2ElvG/trgNXGqRkrl/qj9xc1+SwDU8RviNjd7GxlFaV1Clw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667174; c=relaxed/simple;
	bh=ggvakjtuhOAL3Ph/X7muWf9o6JmZi6JH4f/YHDiYH+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WDL7ZX5cCR9zlAxOpdq6TI0GaYGDuo7xatoi4nC2hBqmDIYJBByjDbiiv2Tj+Mc1kscIScyxibpfdfyzsElZj+wiHYm2arZjq3hk98lIwg8YQoVrgZ8ZWEhe822iuxoKz//h1IrpuZIxsvoyjfSLGL9Zj/y5rWFupPQHOv2VmDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xjacwu0v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xjacwu0v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A635A1F000E9;
	Tue, 21 Jul 2026 20:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667173;
	bh=8EUT83/NkeTPrpBCVU6LHxyr6MLztazLG1dvEPzZqms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xjacwu0v6LREQKlF97Bd0y1wsM9u+GHZPOzRJKgBZfnVAYDU2YWO+Xu463hg82nli
	 usZcld4idPk8MogvwZNJ5nhf90+e2MBQeGbeKakH20d2kYTT/C9D7Hd+1d9T2jJiGa
	 TTqrb5JVtTB74L4PlmeRnx/dUuCWOtIPt/YKCW6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 0959/1266] Bluetooth: SCO: fix sleeping under spinlock in sco_conn_ready
Date: Tue, 21 Jul 2026 17:23:16 +0200
Message-ID: <20260721152503.287571453@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

commit b819db93d73f4593636299e229914052b89e3ef2 upstream.

sco_conn_ready calls sleeping functions under conn->lock spinlock.

The critical section can be reduced: conn->hcon is modified only with
hdev->lock held. It is guaranteed to be held in sco_conn_ready, so
conn->lock is not needed to guard it.

Move taking conn->lock after lock_sock(parent). This also follows the
lock ordering lock_sock() > conn->lock elsewhere in the file.

Fixes: 27c24fda62b60 ("Bluetooth: switch to lock_sock in SCO")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/sco.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -1314,26 +1314,24 @@ static void sco_conn_ready(struct sco_co
 		sk->sk_state_change(sk);
 		release_sock(sk);
 	} else {
-		sco_conn_lock(conn);
-
-		if (!conn->hcon) {
-			sco_conn_unlock(conn);
+		if (!conn->hcon)
 			return;
-		}
+
+		lockdep_assert_held(&conn->hcon->hdev->lock);
 
 		parent = sco_get_sock_listen(&conn->hcon->src);
-		if (!parent) {
-			sco_conn_unlock(conn);
+		if (!parent)
 			return;
-		}
 
 		lock_sock(parent);
 
+		sco_conn_lock(conn);
+
 		sk = sco_sock_alloc(sock_net(parent), NULL,
 				    BTPROTO_SCO, GFP_ATOMIC, 0);
 		if (!sk) {
-			release_sock(parent);
 			sco_conn_unlock(conn);
+			release_sock(parent);
 			return;
 		}
 
@@ -1353,9 +1351,9 @@ static void sco_conn_ready(struct sco_co
 		/* Wake up parent */
 		parent->sk_data_ready(parent);
 
-		release_sock(parent);
-
 		sco_conn_unlock(conn);
+
+		release_sock(parent);
 	}
 }
 


