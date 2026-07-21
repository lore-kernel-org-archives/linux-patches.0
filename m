Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7621046D0AF;
	Tue, 21 Jul 2026 19:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663635; cv=none; b=dkN6md1OoSOg7yhXraCgYUPJOY3UYmnFSFtLgYfI1g8NCL5b2Ff2H4yAs/bjmQepwMSKj9qNLomvEXmjYjFLLtLocXlz+rABASORf5yJSuIvPxhJWTTmW5fX0UV7nO3DRfEhUvpoaXByQ20YC4knQ+eDqEq4zaQP8+/boyJOaP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663635; c=relaxed/simple;
	bh=SmMMs4hZb0y7EkraHCEsC8CiM/jXVrIe2Btl9B10oRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQiI+u5EgCQA7DAr8DmoX3rvc07rSqYOAiYp1Anmi5DhDo3/1wk2Pbxm7B8OjcqBN6VnIXCNeaoDimrQ4zj4iIxhDsGyQ+TphLH0bmsc+S+e499puyjc9CRhOt1r8dCEKo3kxodF/GsixUi/pDZ0BT/Vb+j1qZzKJj2brVGsoh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rkP9dzrM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rkP9dzrM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7141F000E9;
	Tue, 21 Jul 2026 19:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663634;
	bh=ahwdGh4MguvbyndYP7N7bW5N8HhXi4yPcrNCOG7PwlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rkP9dzrMkFDbj8BWrKT9j9BIwAQrBVODZ+0wI/30lRdQYhwwFs1+mTRKZJ2DiJ+kV
	 uCqeD4z3iOj/fQ3hv60SBtR6PyEnGqm8LLmQZw4TTtktohMwrnvi7zLWBB6F9sWj/u
	 u/42EGA3mpDynHs/O7bd/wObhJNfM3MHyZSlCBR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 0897/1276] Bluetooth: SCO: fix sleeping under spinlock in sco_conn_ready
Date: Tue, 21 Jul 2026 17:22:20 +0200
Message-ID: <20260721152506.117517540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
@@ -1317,26 +1317,24 @@ static void sco_conn_ready(struct sco_co
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
 
@@ -1356,9 +1354,9 @@ static void sco_conn_ready(struct sco_co
 		/* Wake up parent */
 		parent->sk_data_ready(parent);
 
-		release_sock(parent);
-
 		sco_conn_unlock(conn);
+
+		release_sock(parent);
 	}
 }
 


