Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B61384232;
	Sat, 12 Sep 2026 19:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241733; cv=none; b=A10mM9y6TEj6agi6cI5Aim6SoTn5gBfBssbIEHQK+wwaWVYcntzRGvKbNKeW/S8UwDdtkhXWKIWiVWSiOa2p8CvETfsy33fBE/IE/fFKytW3pq2U8lRcYrodxelkq7kx8BuMAGgA/WI0eBnSwKtTH8cDwvcPRozE1GmpXArp7Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241733; c=relaxed/simple;
	bh=qLn6Ib4ynLZCBG2oECz1VnrTm3WD2Bs+2JefwCzKQJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQPP/7VLv02sGU2PuIvH+YPT56Wk9FNVQeaXX1fjBqxO7+XGd1PzGRfzLq9d2KB7YO0hjiWGXUArRv8HsbRyoxZtoF376/TMZMh5cn+o1KYTdyY5mrRXEuCiECtbrdxn2G5Lrm6wpWWxmSL1+4qEw54zPySGIboqJQ/ZCXd3a60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q1aCXyeE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q1aCXyeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2991F1F000FF;
	Sat, 12 Sep 2026 19:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241731;
	bh=XzShHQFQg7Sdh3/M8bDrod68ModKJWvkyXpNxwJaeQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q1aCXyeEsEz+BEMtNbKXl5+nifm5XVXYI66CZ3FONqTOx1QHQzzYvAiSUpMoTaAPe
	 SL4BkVG98HePLzv8aWbqKdGQ1vMDgp5O8eUa+Ubtc7jLJtHlaMJS8Rf3sN82D18oEW
	 ITg7Fe/qFyScIRijslX71DWPsVCaRZIS+yJ2XM5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Bryam Vargas <hexlabsecurity@proton.me>
Subject: [PATCH 5.10 153/798] net/iucv: filter frames in afiucv_hs_rcv() by ingress device
Date: Sat, 12 Sep 2026 08:56:21 +0200
Message-ID: <20260912065520.514231416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandra Winter <wintera@linux.ibm.com>

commit 80230a18c164a4b5bbc048fe2768b219ac17bc5a upstream.

afiucv_hs_rcv() selects a socket from iucv_sk_list by matching four 8-byte
name fields in the transport header alone. No check is made against the
net_device the frame arrived on.

This can cause a frame arriving on any netdev to be delivered to an AF_IUCV
socket. Three problems follow.

First, a frame arriving over HiperSockets can be delivered to a socket
bound to the classic z/VM IUCV transport, which has iucv->hs_dev == NULL.
iucv_sock_bind() takes the classic path whenever the requested userid
matches iucv_userid, even on a guest that also has a HiperSockets device
carrying the same identifier. The child socket created by
afiucv_hs_callback_syn() for such a match inherits hs_dev = NULL and
transport = AF_IUCV_TRANS_HIPER, so the first send() on it returns -ENODEV.
The socket delivered to accept() is unusable.

Second, a frame arriving on one netdev can be delivered to a socket bound
to a different IQD device. Which can lead to
- Accept-queue exhaustion (DoS)
- Attacker-controlled peer identity in the child socket
- Data injection into existing sockets
- Fabric noise on the IQD fabric, where bogus replies are sent
- killing established connections

Third, all AF_IUCV sockets live in init_net, as iucv_sock_alloc() calls
sk_alloc(&init_net, ...). But even frames arriving on netdev devices in a
namespace can be delivered to an IUCV socket. So a process in an
unprivileged user and network namespace holding only the CAP_NET_RAW
capability valid within that namespace can send a raw ETH_P_AF_IUCV frame
on its own lo device and have it matched against init_net sockets.

Fix all three by skipping any socket whose hs_dev does not match the
ingress device. A classic z/VM IUCV socket has hs_dev == NULL; the ingress
dev is never NULL, so classic sockets are skipped automatically. An unbound
HIPER socket also has hs_dev == NULL and is skipped. A bound HIPER socket
is only reachable from the exact IQD device it was bound to. Because hs_dev
is always a device in init_net (iucv_sock_bind() scans
for_each_netdev_rcu(&init_net, ...) exclusively), a frame whose ingress
device belongs to another namespace never matches any socket.

Note that AF_IUCV over HiperSockets provides no per-connection
authentication: no sequence numbers, no TLS, no nonce. The four name fields
identifying a connection are exchanged in plaintext on the shared
HiperSockets segment (VCHID). Any host on the same HiperSockets segment
could spoof any frame type against an existing connection. That is a
protocol-level property unchanged by this patch. The fix reduces the attack
surface to peers present on the same HiperSockets segment.

Fixes: 3881ac441f64 ("af_iucv: add HiperSockets transport")
Cc: stable@vger.kernel.org
Co-developed-by: Bryam Vargas <hexlabsecurity@proton.me>
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Link: https://patch.msgid.link/20260821125501.3718748-1-wintera@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/iucv/af_iucv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -2073,6 +2073,8 @@ static int afiucv_hs_rcv(struct sk_buff
 	sk = NULL;
 	read_lock(&iucv_sk_list.lock);
 	sk_for_each(sk, &iucv_sk_list.head) {
+		if (iucv_sk(sk)->hs_dev != dev)
+			continue;
 		if (trans_hdr->flags == AF_IUCV_FLAG_SYN) {
 			if ((!memcmp(&iucv_sk(sk)->src_name,
 				     trans_hdr->destAppName, 8)) &&


