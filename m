Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FCC46D56F;
	Tue, 21 Jul 2026 18:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658737; cv=none; b=QxEgsnY6UYaEcoaWBfH7tr9T4OLWGxJ9YiAg4QHqhL9n058YRggU4QJ2lqrIJHHl+o3LdM5oz2zqKLS5MwtA5XpAe3ep6gw0ATS+rNpAV1YIDbSzSeZpYpHMyIBJZltYSf+PPHLqEus/cVgmuCs7W2205YDSAdpZQiZNoSVNr4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658737; c=relaxed/simple;
	bh=65NbyQPOWGfISvYw3Or55MdtKttTZJ/CDAehsyktW9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBpNY9WNzlAvrDNMZZdUyI7y8hCzizcV38QochJakpXFMhHtQeoiL4ACL9kpbE3kJyRo6EPipI7dh2UwKtxjHjH+2boq5LkxcOPl2ni+FKgUpbxbjTKxsbK1WoS3Fr2GrcOs9fVgw8OLoq7d/6hbNJamxKUu/0fAkcjfFUc16r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GuWmlAyB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GuWmlAyB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE0F1F00A3A;
	Tue, 21 Jul 2026 18:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658736;
	bh=GVfIdeM5Gte0KwnUctZJ8tKDqjSaGeekDAwelbMrYiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GuWmlAyB1ORrQCDBuUhLaEOGcyd1qudVc5e51aaW7ywS6Gib5s8XzUVeJuyyJcJN1
	 k/CsazPB8Xc4C/fREBSes+OS+uFurKwqDRAs2MEI+pI44D3Ht1qs6jj6W88N5oxDma
	 ECVd+5YLXUHhxv1lX0woqsdEMfH/oT5x7cnh+rds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 1212/1611] Bluetooth: SCO: fix sleeping under spinlock in sco_conn_ready
Date: Tue, 21 Jul 2026 17:22:08 +0200
Message-ID: <20260721152542.697096695@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
@@ -1407,26 +1407,24 @@ static void sco_conn_ready(struct sco_co
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
 
@@ -1447,9 +1445,9 @@ static void sco_conn_ready(struct sco_co
 		/* Wake up parent */
 		parent->sk_data_ready(parent);
 
-		release_sock(parent);
-
 		sco_conn_unlock(conn);
+
+		release_sock(parent);
 	}
 }
 


