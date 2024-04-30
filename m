Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92648E560;
	Tue, 30 Apr 2024 10:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473901; cv=none; b=oxYrtO3WGthC1mlC2b21l653ac7neo/dS+N44XtBXPa/EGdLB9ogu1n1JMDvHdQclzDTnLAMUlKyJN1lyR9hVLCB+uYmvmyABvBbR3T0IGcFxgaRmUtU6izR7jBzrA4dalnTGFLaYY4zz+thYozr531LzVxCRW5LMRXSup4gVdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473901; c=relaxed/simple;
	bh=gU8l+ODD5Xu6b2D6+w4zdYXkNyUej/zZAPMxNNr2psM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sypEWx+dJx1/p1gv+xGPlOstreId1igEK1JGZMO/xgamgZvB8ZuCKPwbknxCfL8Nud124OqyKIfnO8hNVRcSiJ/CoXQWhLD6jyXlTL9JckCXcL+PeEtve5lmC/JTqck7x9gk9ouxdP/4XdgCUJiKsf9P9dsG1ixINvPh+k+D+oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TGcwuzvI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TGcwuzvI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11EACC2BBFC;
	Tue, 30 Apr 2024 10:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473901;
	bh=gU8l+ODD5Xu6b2D6+w4zdYXkNyUej/zZAPMxNNr2psM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TGcwuzvIWOKIRJanDIwBTugJDu6eRaD7Ds5G1+sENDZGKrI55VDPS1zbldc/Fk5UT
	 OCGwGJjf4KqHT5xCvyGF0epxniSNVCNnqYTdGt7RHeqOt3e/JeIIqC4fL5prW0s6lb
	 4g1HCOB7PH3g1f6pw2seDXwihqU9R1Ow/4/75NbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yick Xie <yick.xie@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 76/77] udp: preserve the connected status if only UDP cmsg
Date: Tue, 30 Apr 2024 12:39:55 +0200
Message-ID: <20240430103043.384537921@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Yick Xie <yick.xie@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/udp.c |    5 +++--
 net/ipv6/udp.c |    5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1001,16 +1001,17 @@ int udp_sendmsg(struct sock *sk, struct
 
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
@@ -1324,9 +1324,11 @@ do_udp_sendmsg:
 		ipc6.opt = opt;
 
 		err = udp_cmsg_send(sk, msg, &ipc6.gso_size);
-		if (err > 0)
+		if (err > 0) {
 			err = ip6_datagram_send_ctl(sock_net(sk), sk, msg, &fl6,
 						    &ipc6);
+			connected = false;
+		}
 		if (err < 0) {
 			fl6_sock_release(flowlabel);
 			return err;
@@ -1338,7 +1340,6 @@ do_udp_sendmsg:
 		}
 		if (!(opt->opt_nflen|opt->opt_flen))
 			opt = NULL;
-		connected = false;
 	}
 	if (!opt) {
 		opt = txopt_get(np);


