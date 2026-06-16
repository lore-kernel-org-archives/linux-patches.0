Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9541A6803;
	Tue, 16 Jun 2026 16:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628464; cv=none; b=u+kJKLYvX/ZKPbhshiWoYm1q29/Ixgc0a5yiEyQ4LDTGx4o6FnZGFGiOmyVyUMO4KBHRZkbkOkxAlk23pQKQpEUKlDLtuORiWpExNO6Lu1gqoYxcNqI0PixcF5/n96raGX9O2RPNbiCwG4CzSC5cN0DPhemPHXkixiZcSSZLV+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628464; c=relaxed/simple;
	bh=IJu6YiUf2Lm3+j2cEwM56BybHpjNcOJrCMPEFKBCRWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=muiMNgAr5g94dSn2r5ewMAZZhhnHfmL73gs+CgNZP26qqekig55PpJfrLgh/pu81JrD4LcLCZSRpGieM0ZvDt5FTcXJBjLAHPyj32+V0AVH3yrgbHtkblMPmKyQJry9cgfmvJ5IKp6mj27tkzXRepPxTWSl/AGWknSfgQq6F/74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UPbYHYLw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UPbYHYLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B421F000E9;
	Tue, 16 Jun 2026 16:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628463;
	bh=EAeK86Nf7WCaAJ9EoVcZgpwYqkQ40EVVjrCtQCzzqvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UPbYHYLwrG6tui3pgDxVtLJsVysDNN7sKvSti7ElCy2EVUYLRfSLMufIWuXhAAZTn
	 L4/MruBDz2BW5HMWtDizTC8KA8X5FdGyKln4X4AgWVEmrZCzSQFpOEyvS8r7PDk+4F
	 qK72zz8N1aAOOwCKMvW6ScBlsdbrbQQ49SFbl5U8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 100/452] Bluetooth: ISO: fix UAF in iso_recv_frame
Date: Tue, 16 Jun 2026 20:25:27 +0530
Message-ID: <20260616145123.043040790@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Muhammad Bilal <meatuni001@gmail.com>

commit 47f23a259517abbdb8032c057a1e8a6bf3734878 upstream.

iso_recv_frame reads conn->sk under iso_conn_lock but releases the lock
before using sk, with no reference held. A concurrent iso_sock_kill()
can free sk in that window, causing use-after-free on sk->sk_state and
sock_queue_rcv_skb().

Fix by replacing the bare pointer read with iso_sock_hold(conn), which
calls sock_hold() while the spinlock is held, atomically elevating the
refcount before the lock drops. Add a drop_put label so sock_put() is
called on all exit paths where the hold succeeded.

Fixes: ccf74f2390d60a2f9a75ef496d2564abb478f46a ("Bluetooth: Add BTPROTO_ISO socket type")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/iso.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -526,7 +526,7 @@ static void iso_recv_frame(struct iso_co
 	struct sock *sk;
 
 	iso_conn_lock(conn);
-	sk = conn->sk;
+	sk = iso_sock_hold(conn);
 	iso_conn_unlock(conn);
 
 	if (!sk)
@@ -535,11 +535,15 @@ static void iso_recv_frame(struct iso_co
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


