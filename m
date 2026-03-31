Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B3330E0DC;
	Tue, 31 Mar 2026 16:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974366; cv=none; b=mMBeaRMosyfDy+UV0Nemqp0tr59zeEtmAPL14zlj1Ke8dgifxQtZ2iiybSBccCIkKLr8Wky55rPrkE5o7+m8Ckx8DI7Bs3xBULG+orznWFwLEdVCpJB9U+pB++5F75Qj3yjiyEUzPjjCANYaE+9HDLpS+hhGXtzTeSFcJn2AplA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974366; c=relaxed/simple;
	bh=17y2iXvaiXJok5j2ux3C15Z/fLj0gvtpRkSHANnJZVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abPYuj0V8Iyp/BQMBQrT0jwkp/lFCLcfxCVyRclkCH+jjDJeGhVhx521sVAjGF3YbA6vrFNRYlMeCH6ZzDit1tD6Egg/+I/JeYAcV1Ie75dpjXAqq4B/pGUHI5oVdfsBMYSZS6zXOwlyTDSYTyzERHY7gzmsFq4B3p4elHcgM+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jgd5Upe5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jgd5Upe5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF1FC19423;
	Tue, 31 Mar 2026 16:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974366;
	bh=17y2iXvaiXJok5j2ux3C15Z/fLj0gvtpRkSHANnJZVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jgd5Upe5I6SO+OSSXMNJxa9GDZAxrf+Si+42Vjq2pCJSRAKOymcLHvhzhHthzm6EJ
	 K94jeR95ixXTrF8rzeX3V7gdkatF7usnzJHmZf9HoWy5Art2gpzuNaI3RWn055sMfj
	 zimOCscnUti/hyjPitb701sitK7we7gqMmtdFdfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/175] Bluetooth: SCO: Fix use-after-free in sco_recv_frame() due to missing sock_hold
Date: Tue, 31 Mar 2026 18:20:24 +0200
Message-ID: <20260331161731.258873213@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit 598dbba9919c5e36c54fe1709b557d64120cb94b ]

sco_recv_frame() reads conn->sk under sco_conn_lock() but immediately
releases the lock without holding a reference to the socket. A concurrent
close() can free the socket between the lock release and the subsequent
sk->sk_state access, resulting in a use-after-free.

Other functions in the same file (sco_sock_timeout(), sco_conn_del())
correctly use sco_sock_hold() to safely hold a reference under the lock.

Fix by using sco_sock_hold() to take a reference before releasing the
lock, and adding sock_put() on all exit paths.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/sco.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 6635d155e360b..56a146515df9e 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -338,7 +338,7 @@ static void sco_recv_frame(struct sco_conn *conn, struct sk_buff *skb)
 	struct sock *sk;
 
 	sco_conn_lock(conn);
-	sk = conn->sk;
+	sk = sco_sock_hold(conn);
 	sco_conn_unlock(conn);
 
 	if (!sk)
@@ -347,11 +347,15 @@ static void sco_recv_frame(struct sco_conn *conn, struct sk_buff *skb)
 	BT_DBG("sk %p len %u", sk, skb->len);
 
 	if (sk->sk_state != BT_CONNECTED)
-		goto drop;
+		goto drop_put;
 
-	if (!sock_queue_rcv_skb(sk, skb))
+	if (!sock_queue_rcv_skb(sk, skb)) {
+		sock_put(sk);
 		return;
+	}
 
+drop_put:
+	sock_put(sk);
 drop:
 	kfree_skb(skb);
 }
-- 
2.51.0



