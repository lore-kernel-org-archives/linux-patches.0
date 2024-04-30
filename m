Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93649211C;
	Tue, 30 Apr 2024 11:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475623; cv=none; b=Ly36WwaV5mKmz3Q93eW/rqzwJXBikJ//PJ+Pqje9poTGW71hkB3NeQSwvOJJXQ6y84kOnadEOQe39bqLDoaGhh/NKxNF3Em2qlWO7r8JYIbURmC/uNVHbbZZwJ0Jnnib6xvldiUKdMn+naK51JTr0m7ynzT4gS3msPSlmGugdOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475623; c=relaxed/simple;
	bh=h8OLQxdwqei9/gUUBp5duQ4QcugFP57GcrpvUbQIHY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B6QV2SoKQ/MYvj4g25a78I4+M/bIXQyFDNpuuQFGZAUiCDj1skEhAqSZGiNq4eDg3407biLHOhCkVOCD4Fgsq4QwM1HIGNgbzmtiHy9t+ZSfNLESThr8QhamBLjLklmKGDLJd60WC2c5sBq+FwChDufFN4Xgj5HA0EM9uyIbrow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ADcuv9+n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ADcuv9+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F0EC2BBFC;
	Tue, 30 Apr 2024 11:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475623;
	bh=h8OLQxdwqei9/gUUBp5duQ4QcugFP57GcrpvUbQIHY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ADcuv9+nrBBnmTughXdVbvR2xeDi7IbJ1j0T6AmLEUVq5yLiNANtgaKPEA1tx1Nvs
	 9kMMOvH5ZJy4CLpTBtejJhFdq3idc7bttOxCy+Sp1BGSQpSkM3dfsBt9iqJFd0xd8a
	 dX4iquPJMcmByiIfuj6s8KkC0Sc2xhFpnovJEGYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yick Xie <yick.xie@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 152/186] udp: preserve the connected status if only UDP cmsg
Date: Tue, 30 Apr 2024 12:40:04 +0200
Message-ID: <20240430103102.446737715@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yick Xie <yick.xie@gmail.com>

commit 680d11f6e5427b6af1321932286722d24a8b16c1 upstream.

If "udp_cmsg_send()" returned 0 (i.e. only UDP cmsg),
"connected" should not be set to 0. Otherwise it stops
the connected socket from using the cached route.

Fixes: 2e8de8576343 ("udp: add gso segment cmsg")
Signed-off-by: Yick Xie <yick.xie@gmail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20240418170610.867084-1-yick.xie@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/udp.c |    5 +++--
 net/ipv6/udp.c |    5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1124,16 +1124,17 @@ int udp_sendmsg(struct sock *sk, struct
 
 	if (msg->msg_controllen) {
 		err = udp_cmsg_send(sk, msg, &ipc.gso_size);
-		if (err > 0)
+		if (err > 0) {
 			err = ip_cmsg_send(sk, msg, &ipc,
 					   sk->sk_family == AF_INET6);
+			connected = 0;
+		}
 		if (unlikely(err < 0)) {
 			kfree(ipc.opt);
 			return err;
 		}
 		if (ipc.opt)
 			free = 1;
-		connected = 0;
 	}
 	if (!ipc.opt) {
 		struct ip_options_rcu *inet_opt;
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1476,9 +1476,11 @@ do_udp_sendmsg:
 		ipc6.opt = opt;
 
 		err = udp_cmsg_send(sk, msg, &ipc6.gso_size);
-		if (err > 0)
+		if (err > 0) {
 			err = ip6_datagram_send_ctl(sock_net(sk), sk, msg, fl6,
 						    &ipc6);
+			connected = false;
+		}
 		if (err < 0) {
 			fl6_sock_release(flowlabel);
 			return err;
@@ -1490,7 +1492,6 @@ do_udp_sendmsg:
 		}
 		if (!(opt->opt_nflen|opt->opt_flen))
 			opt = NULL;
-		connected = false;
 	}
 	if (!opt) {
 		opt = txopt_get(np);


