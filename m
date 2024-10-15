Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2451E1A35;
	Tue, 15 Oct 2024 12:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994328; cv=none; b=sanIz6DCmv3f6npmyyUEDxzuLjLUr3VPK0sCJoHnd5qvn6EOoyvoLhi71IBJ1Z3OM7wAVRRQ5n1NUeJf01Q0PIvji1Ut4wImJKHS6rJ/4vXXrFAUpK6isfBxuV4KzPQADzjvom5nxb8gwrU8yGfhX6DeU1MHkgiVga5BV83EOt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994328; c=relaxed/simple;
	bh=1BPT0pQMk0LYMR2yf0qd6Sw8dCZnF3yUbiNhUQn7AxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DBCpEicIHSzOpEjlq4gw060uzQaFPA8Lc1lRgX3g1FxKiza4o1846/mymCElekq4odYz5L/X+89fi1+QRphi+w18CAXKNKIDUtyYHTeb+fapjh1DV3hcD0j9SX7tI0ErSByyb4nhGLm9nFENBq0k/eaVInXpsvSjDberU7DfBxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBTUtisb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBTUtisb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4376C4CEC6;
	Tue, 15 Oct 2024 12:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994328;
	bh=1BPT0pQMk0LYMR2yf0qd6Sw8dCZnF3yUbiNhUQn7AxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBTUtisbGP+d9Vr1zaS2s9aiq+B7Z1wDPto0NhGFbd2NZCZdc103h7LgvozQGcZOB
	 DvWTkccZ2vBu0EDK4j6kmXQVMlhS6j04Uf23wEjAzuKrBivAMkNyotGnDPmWFCJp/l
	 +nRycaqXTL4DZLO4Zri9yikpT9+l+ugvV3FtzgCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ignat Korchagin <ignat@cloudflare.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 673/691] net: explicitly clear the sk pointer, when pf->create fails
Date: Tue, 15 Oct 2024 13:30:21 +0200
Message-ID: <20241015112507.034415638@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ignat Korchagin <ignat@cloudflare.com>

commit 631083143315d1b192bd7d915b967b37819e88ea upstream.

We have recently noticed the exact same KASAN splat as in commit
6cd4a78d962b ("net: do not leave a dangling sk pointer, when socket
creation fails"). The problem is that commit did not fully address the
problem, as some pf->create implementations do not use sk_common_release
in their error paths.

For example, we can use the same reproducer as in the above commit, but
changing ping to arping. arping uses AF_PACKET socket and if packet_create
fails, it will just sk_free the allocated sk object.

While we could chase all the pf->create implementations and make sure they
NULL the freed sk object on error from the socket, we can't guarantee
future protocols will not make the same mistake.

So it is easier to just explicitly NULL the sk pointer upon return from
pf->create in __sock_create. We do know that pf->create always releases the
allocated sk object on error, so if the pointer is not NULL, it is
definitely dangling.

Fixes: 6cd4a78d962b ("net: do not leave a dangling sk pointer, when socket creation fails")
Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
Cc: stable@vger.kernel.org
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241003170151.69445-1-ignat@cloudflare.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/socket.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/socket.c
+++ b/net/socket.c
@@ -1484,8 +1484,13 @@ int __sock_create(struct net *net, int f
 	rcu_read_unlock();
 
 	err = pf->create(net, sock, protocol, kern);
-	if (err < 0)
+	if (err < 0) {
+		/* ->create should release the allocated sock->sk object on error
+		 * but it may leave the dangling pointer
+		 */
+		sock->sk = NULL;
 		goto out_module_put;
+	}
 
 	/*
 	 * Now to bump the refcnt of the [loadable] module that owns this


