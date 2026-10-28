Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207906;
	b=GYnSMsQC7KBDGxdz87LbTnuYg01xGMwqTRiD4EE3FklbDq0ToZvazbYYYB5+KdVCfWvg
	 h2XQVWxmVHzZNqNJurnY5SS4yQIFQUAXNuKEtLQM3KMjaYfFo9VDbixewJkvK2rfajrB/
	 +veU03biRZ8CftcnuscVgHYDqECzrPwoC5MlWtVF1xhZ1jtbh3tsg4JcuY/bgPu0UGZhL
	 sKGDfFHMDbV4g3GpWr5Sk9HNGgjPqdWnUYwQd8bMKWF/Cc6YI2hve7bUl69Zmn0teDaoq
	 gX5E261tVyAagSaHeAbT0Oia9mmujUF3ebD1i6yMcD4NkdyABfgI5lvL0JEGPVE+mdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207906;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hZqyXtnZTz88a116rKtedxPNep676er3ahEZoQAK6DA=;
	b=Sf/OlBXHIC/95Qm75scXRF5mKo23gigNtvF8SY0i7UvxX+geAeFiVkHVl2txOKS0L0NU
	 5LByYKX/dLY4/BSge8lTR+D6xeyMm5gBVuTR6bI3mD/Meg+Xp5Qpl3PjubOIj2TF3ajUO
	 pE+PYK/8KNSLVRm7lHrMkKIysg+KWsAPXlKdoJc8RtpIlnIODmACj22Zh5YqA59Qt07sn
	 7o8xAwCiQAcw2pvVqQhsZEtsr96ftrPXF6kNFXGb5Xf8xeCLuVRFDbnDbWstcE5L4WU/N
	 ryTT1OzxDheiu6esumSYPq3CAuQuodkU+S13XXJGGuZ8WmTO61IMxBHmajSnoLaEg6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="EfFfnH/O";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C12606A31A;
	Wed, 28 Oct 2026 17:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EfFfnH/O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45171F01825;
	Wed, 28 Oct 2026 17:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207906;
	bh=hZqyXtnZTz88a116rKtedxPNep676er3ahEZoQAK6DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EfFfnH/ON/itfXPWkVZpe0qzUJTih0yoplFcy0Vay9L9y6iYSRnspt/iIt495Ry4H
	 mcw2y4KUpRVexSxLSaAynbmqxNdqFQKuOq0ZnR1SAiF5wB5Dp6IX/KfpdT4IO2wBR5
	 zivoDudOZd0nx/qqsvjmAY1Kr5TNdeysXQ0DtW2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 174/247] ax25: read the connections ax25_dev only once when walking ax25_list
Date: Wed, 28 Oct 2026 17:59:37 +0100
Message-ID: <20261028165951.541723205@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

ax25_kill_by_device() detaches a connection from a device that goes
down by setting s->ax25_dev to NULL. It does so after it has dropped
ax25_list_lock, while the connection is still on ax25_list.

__ax25_find_cb() and ax25_find_listener() walk that list and test
s->ax25_dev against NULL before they dereference it, but they load the
pointer a second time for the dereference. ax25_send_to_raw()
dereferences it without any test. If ax25_kill_by_device() clears the
pointer in between, the walker dereferences NULL:

  Oops: general protection fault, probably for non-canonical address
  KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
  RIP: 0010:ax25_find_cb+0x121/0x330 [ax25]
   ax25_send_frame+0xdc/0x980 [ax25]
   rose_send_frame+0xce/0x270 [rose]
   rose_transmit_restart_request+0x1b3/0x260 [rose]
   rose_transmit_link+0x31d/0x560 [rose]
   rose_write_internal+0x3ab/0x15b0 [rose]
   rose_release+0x2b2/0x4b0 [rose]

Load the pointer once in the three walkers and use that value, and add
the missing NULL test to ax25_send_to_raw(). The ax25_dev itself cannot
go away under the walker: ax25_kill_by_device() has to take
ax25_list_lock again, in ax25_cb_del(), before the device teardown gets
as far as freeing it.

The oops above was obtained on 6.12.94 with KASAN, after 382 seconds of
the syzbot C reproducer of the ax25_find_cb() use-after-free report,
with the interface brought up again in a loop, while testing an earlier
version of the next patch. With this series the same test runs for 600
seconds without an oops.

Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 3696f3cf8690e335a2cc7e8103f018bc205de738)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/af_ax25.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 9f7bda3b511e3..0a5cd835d289d 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -91,7 +91,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 			if (!sk) {
 				spin_unlock_bh(&ax25_list_lock);
 				ax25_disconnect(s, ENETUNREACH);
-				s->ax25_dev = NULL;
+				WRITE_ONCE(s->ax25_dev, NULL);
 				ax25_cb_del(s);
 				spin_lock_bh(&ax25_list_lock);
 				goto again;
@@ -100,7 +100,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 			spin_unlock_bh(&ax25_list_lock);
 			lock_sock(sk);
 			ax25_disconnect(s, ENETUNREACH);
-			s->ax25_dev = NULL;
+			WRITE_ONCE(s->ax25_dev, NULL);
 			if (sk->sk_socket) {
 				netdev_put(ax25_dev->dev,
 					   &s->dev_tracker);
@@ -172,6 +172,7 @@ void ax25_cb_add(ax25_cb *ax25)
 struct sock *ax25_find_listener(ax25_address *addr, int digi,
 	struct net_device *dev, int type)
 {
+	ax25_dev *ax25_dev;
 	ax25_cb *s;
 
 	spin_lock(&ax25_list_lock);
@@ -181,7 +182,8 @@ struct sock *ax25_find_listener(ax25_address *addr, int digi,
 		if (s->sk && !ax25cmp(&s->source_addr, addr) &&
 		    s->sk->sk_type == type && s->sk->sk_state == TCP_LISTEN) {
 			/* If device is null we match any device */
-			if (s->ax25_dev == NULL || s->ax25_dev->dev == dev) {
+			ax25_dev = READ_ONCE(s->ax25_dev);
+			if (ax25_dev == NULL || ax25_dev->dev == dev) {
 				sock_hold(s->sk);
 				spin_unlock(&ax25_list_lock);
 				return s->sk;
@@ -226,14 +228,16 @@ static ax25_cb *__ax25_find_cb(const ax25_address *src_addr,
 			       ax25_address *dest_addr, ax25_digi *digi,
 			       struct net_device *dev)
 {
+	ax25_dev *ax25_dev;
 	ax25_cb *s;
 
 	ax25_for_each(s, &ax25_list) {
 		if (s->sk && s->sk->sk_type != SOCK_SEQPACKET)
 			continue;
-		if (s->ax25_dev == NULL)
+		ax25_dev = READ_ONCE(s->ax25_dev);
+		if (ax25_dev == NULL)
 			continue;
-		if (ax25cmp(&s->source_addr, src_addr) == 0 && ax25cmp(&s->dest_addr, dest_addr) == 0 && s->ax25_dev->dev == dev) {
+		if (ax25cmp(&s->source_addr, src_addr) == 0 && ax25cmp(&s->dest_addr, dest_addr) == 0 && ax25_dev->dev == dev) {
 			if (digi != NULL && digi->ndigi != 0) {
 				if (s->digipeat == NULL)
 					continue;
@@ -293,15 +297,17 @@ ax25_cb *ax25_cb_add_unique(ax25_cb *ax25)
 
 void ax25_send_to_raw(ax25_address *addr, struct sk_buff *skb, int proto)
 {
+	ax25_dev *ax25_dev;
 	ax25_cb *s;
 	struct sk_buff *copy;
 
 	spin_lock(&ax25_list_lock);
 	ax25_for_each(s, &ax25_list) {
+		ax25_dev = READ_ONCE(s->ax25_dev);
 		if (s->sk != NULL && ax25cmp(&s->source_addr, addr) == 0 &&
 		    s->sk->sk_type == SOCK_RAW &&
 		    s->sk->sk_protocol == proto &&
-		    s->ax25_dev->dev == skb->dev &&
+		    ax25_dev && ax25_dev->dev == skb->dev &&
 		    atomic_read(&s->sk->sk_rmem_alloc) <= s->sk->sk_rcvbuf) {
 			if ((copy = skb_clone(skb, GFP_ATOMIC)) == NULL)
 				continue;
-- 
2.53.0



