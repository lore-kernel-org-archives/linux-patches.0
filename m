Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DDC12C462;
	Tue, 30 Apr 2024 10:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474549; cv=none; b=d6wnqvG/QWLp4ayQsC+c0fhwOdz9QdtfpHfzowGzRPlId3FMrrdJt8QG1Bxzp+czdQyf5unCIWo6D4OiYReRv/VHb+B1WOowVRzXgdXnr7QsuWk9+JLe6sjkCovtd/WGQJm6y5fIoef9uvoe230V5iO3L26QHRcRtAi975dGL18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474549; c=relaxed/simple;
	bh=I57b3cwvCNdi5XKb/ysa6mULLbFU61OS+W6uiMS1COI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i6utRnbWBjvBK3odQPnKQDPZ9jXip7U0dl2jHTAD4t77WQ7gMpeeok05vnAg9xkdo82iOJ5vS7u2JyCwIyks0IAsT0IEtUfTwo+zppFcWnqFk+Fe1imd9KYL/J15CoAePd+cu+S+Axi12I1g6eGD09xKGD0lbJzG9ff7/kbo5VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ch+V0mIc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ch+V0mIc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E59BC2BBFC;
	Tue, 30 Apr 2024 10:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474549;
	bh=I57b3cwvCNdi5XKb/ysa6mULLbFU61OS+W6uiMS1COI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ch+V0mIcy4ZB2z1kPrCdpZ903wfAsiiZhLkTHflBirGII0ow6RXiHbO15qbsfsINF
	 Zq0+qY8cUpifSRSk7XUX2sXl1BFaDk4xHfKJDMGY0wxYW6bflJ5gxoPLDRlYqIzz5n
	 QGvjZLwH0gRXHJFoeWTe3MmSOZTB++KGyzy4S9AI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yick Xie <yick.xie@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.8 192/228] udp: preserve the connected status if only UDP cmsg
Date: Tue, 30 Apr 2024 12:39:30 +0200
Message-ID: <20240430103109.339867059@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1125,16 +1125,17 @@ int udp_sendmsg(struct sock *sk, struct
 
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


