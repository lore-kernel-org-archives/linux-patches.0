Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB8823392B;
	Sat, 30 May 2026 17:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163093; cv=none; b=VUNU1GIYNydOCo3JNSxmjStoR68xaFimsqWzCXCSf54kYw095TJEWgF7XuBMCgZbMScjzlwCv8c6/vPXfuNC+fWiRz8bT1813tkswztYy7WOb1+8/FUeQzJWh6uWk8srpgufW1TdNlEJX4FXa11jmSz5udoXds6wXwiWlSW8Srk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163093; c=relaxed/simple;
	bh=YpZgZJxZFrvyr2hoqqQFdF8+d6ByAd3N8Dc7HHYA/iI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bA1nOA9GBz2+Qw4+3zvsa2HdJPLsXWRyihVPAx2RJCZSinnhwA9aR44aUYdph4cFL1542xD4RnY+UnBtjw87/a+kDAlvfpPF679/nnF8VoPORhWUsBtPkUlM/ek2pxttDTrFYX6Qft7hADJoWs224lv34WmL/g6VsKcCxrN1f9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r8EoBuG9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r8EoBuG9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1F21F00893;
	Sat, 30 May 2026 17:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163092;
	bh=pt2/lySzc5z3Z0ouZLGCsW1ngVpSqH5W0xXZflO9pwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r8EoBuG9eSbtlXm/3BTK1iZXnOg605iwB82PLzerwjsP+ZPyp0WrD/iamVpQ/yu9e
	 etRrobWXCYEd9HM+ZqvntCBTsf77Ab6tWtkZHi+XW+Jy7CmQoe/GfGP9Bg0SEtWiTj
	 b4Q0LDcp350P+Q26MEhuKBbrFYr5kjkZqv7otIlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	"stable@vger.kernel.org, Johannes Berg" <johannes.berg@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Robert Garcia <rob_garcia@163.com>
Subject: [PATCH 5.15 152/776] SUNRPC: lock against ->sock changing during sysfs read
Date: Sat, 30 May 2026 17:57:46 +0200
Message-ID: <20260530160244.388216418@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit b49ea673e119f59c71645e2f65b3ccad857c90ee ]

->sock can be set to NULL asynchronously unless ->recv_mutex is held.
So it is important to hold that mutex.  Otherwise a sysfs read can
trigger an oops.
Commit 17f09d3f619a ("SUNRPC: Check if the xprt is connected before
handling sysfs reads") appears to attempt to fix this problem, but it
only narrows the race window.

Fixes: 17f09d3f619a ("SUNRPC: Check if the xprt is connected before handling sysfs reads")
Fixes: a8482488a7d6 ("SUNRPC query transport's source port")
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/sysfs.c    |    5 ++++-
 net/sunrpc/xprtsock.c |    7 ++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/net/sunrpc/sysfs.c
+++ b/net/sunrpc/sysfs.c
@@ -113,11 +113,14 @@ static ssize_t rpc_sysfs_xprt_srcaddr_sh
 		return 0;
 
 	sock = container_of(xprt, struct sock_xprt, xprt);
-	if (kernel_getsockname(sock->sock, (struct sockaddr *)&saddr) < 0)
+	mutex_lock(&sock->recv_mutex);
+	if (sock->sock == NULL ||
+	    kernel_getsockname(sock->sock, (struct sockaddr *)&saddr) < 0)
 		goto out;
 
 	ret = sprintf(buf, "%pISc\n", &saddr);
 out:
+	mutex_unlock(&sock->recv_mutex);
 	xprt_put(xprt);
 	return ret + 1;
 }
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1680,7 +1680,12 @@ static int xs_get_srcport(struct sock_xp
 unsigned short get_srcport(struct rpc_xprt *xprt)
 {
 	struct sock_xprt *sock = container_of(xprt, struct sock_xprt, xprt);
-	return xs_sock_getport(sock->sock);
+	unsigned short ret = 0;
+	mutex_lock(&sock->recv_mutex);
+	if (sock->sock)
+		ret = xs_sock_getport(sock->sock);
+	mutex_unlock(&sock->recv_mutex);
+	return ret;
 }
 EXPORT_SYMBOL(get_srcport);
 


