Received: from smtp134-25.sina.com.cn (smtp134-25.sina.com.cn [180.149.134.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8757D37A498
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 07:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.149.134.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775720681; cv=none; b=EhzmkrAJKHiWsdSbFi8eF0HLDaeNIu1K5v5lN+0aUj3Dhp1KrsVvU05QWlb8Q25o6jFk1RvTcUGIs7n5F1SPuHqyRlUHt5Qt0Fw7vDxICQXtwPblpNmgkPhh5hLNWAhgdPurcmjgl48Pge9BhDjLvIH5hK4PhKY0FjTXbVOkAfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775720681; c=relaxed/simple;
	bh=f0DDryUDANCVJdeh2y1ARDxV4C4xuBi4Rc6Sb9agruM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=unbXQrxDSMzUJ56jgKgP/wmzJGyP6TkPdQYl80YQrh+PSj66w0lwug9b+XFWsp6xMwT0Z+rytaPrkN7jEkjdURvcsvNIZLZBcGKEkKLSRZuYHbd1GHafTsKDFOF0IbszC8j7QXlGR80AaeCcS/ivV+esa1EO3TaRktG8iGCPOjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.cn; spf=pass smtp.mailfrom=sina.cn; dkim=pass (1024-bit key) header.d=sina.cn header.i=@sina.cn header.b=NWP66BLk; arc=none smtp.client-ip=180.149.134.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.cn header.i=@sina.cn header.b="NWP66BLk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.cn; s=201208; t=1775720674;
	bh=N6N2PGq6dFDonMyCZBS+lQxmTRjyaDG+D6z3I54ANUk=;
	h=From:Subject:Date:Message-Id;
	b=NWP66BLkow3gCDFwmvzk0+7NWVQbHUsjNJTSeucOSjG8lPzfGM/eoi9xQ5fel0I/u
	 8GG5SAOQKMYnFSSB+9z5npqyuVHab60tNz4of8ZJdQdV2Nh/tyeMCvUaAQfQ2Nuwgs
	 Mg2jfBlA7UACCkQdoDrI4eZphU+Op7oGsYCgSoNI=
X-SMAIL-HELO: NTT-kernel-dev
Received: from unknown (HELO NTT-kernel-dev)([60.247.85.88])
	by sina.cn (10.185.250.21) with ESMTP
	id 69D758DD00006C49; Thu, 9 Apr 2026 15:44:31 +0800 (CST)
X-Sender: jianqkang@sina.cn
X-Auth-ID: jianqkang@sina.cn
Authentication-Results: sina.cn;
	 spf=none smtp.mailfrom=jianqkang@sina.cn;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=jianqkang@sina.cn
X-SMAIL-MID: 6999273408359
X-SMAIL-UIID: 7E8DE10F63EF47689E1EDF482DBA0A2B-20260409-154431-1
From: Jianqiang kang <jianqkang@sina.cn>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	imv4bel@gmail.com
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	marcel@holtmann.org,
	johan.hedberg@gmail.com,
	luiz.dentz@gmail.com,
	davem@davemloft.net,
	kuba@kernel.org,
	linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org,
	luiz.von.dentz@intel.com
Subject: [PATCH 5.10.y] Bluetooth: SCO: Fix use-after-free in sco_recv_frame() due to missing sock_hold
Date: Thu,  9 Apr 2026 15:44:29 +0800
Message-Id: <20260409074429.740279-1-jianqkang@sina.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
Signed-off-by: Jianqiang kang <jianqkang@sina.cn>
---
 net/bluetooth/sco.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index ce084a184a1c..c441e5225458 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -305,7 +305,7 @@ static void sco_recv_frame(struct sco_conn *conn, struct sk_buff *skb)
 	struct sock *sk;
 
 	sco_conn_lock(conn);
-	sk = conn->sk;
+	sk = sco_sock_hold(conn);
 	sco_conn_unlock(conn);
 
 	if (!sk)
@@ -314,11 +314,15 @@ static void sco_recv_frame(struct sco_conn *conn, struct sk_buff *skb)
 	BT_DBG("sk %p len %d", sk, skb->len);
 
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
2.34.1

