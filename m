Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D553ACEFB;
	Wed, 30 Sep 2026 15:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783671; cv=none; b=mpnJu5RO76taEUAN7eGH7Xi6glrXVT6mVqMt9+ZP+5JiHQoHOUWdhSXVRRAV5RQqetKnrzwwKcPNPLMZeKncK9Fzj/788tF5cG0YG5rvgrPKUDe1Clz+Y3rdcAngS1UfV6OUKL6fANx6tTLH7xpH3q2aK/d2+hTF8CFYI2RX8BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783671; c=relaxed/simple;
	bh=zwwmY716cHZ7+kR/+51QuBtkaTpCGHweFhjTqtZcDdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aip14G5LOc7FwuJ7OxP75OokiTx6eTvJkdUUtRqSM/uqanKGWOFD1n2vzvKbVN4c+g8ATJdCX14GMspjatWpyQu+5Wp64/gKR+YWXOEzcp6nLYovJeh+tXIQ3aBZrZTcTiR8MEPBu5WJTyhJDg5UgmfzUSuxlBELiN2xU6GbFM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wWYnanZ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wWYnanZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8121C1F000FF;
	Wed, 30 Sep 2026 15:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783668;
	bh=vZroRU3e2yEUieRvzWszt10fjonK6E00TEe2jKIXRd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wWYnanZ7965rqi/eFprsI7V6r9OJPxFBOvqoldU8ZyT0Vwo8laAbygdpY9RlWd34z
	 Yu7LtIxjz6fMt1qr2AaTI133wSXOhSm2KTSDskJOiegHYQ7pWq/AaQldg4MXVHg71n
	 gSaafTLEwb3K4FHlMzhttQgfYjHIrPhSUBsSmaqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Robert Garcia <rob_garcia@163.com>,
	"Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 479/595] SUNRPC: lock against ->sock changing during sysfs read
Date: Wed, 30 Sep 2026 17:26:12 +0200
Message-ID: <20260930152357.989465562@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: NeilBrown <neilb@suse.de>

[ Upstream commit b49ea673e119f59c71645e2f65b3ccad857c90ee ]

->sock can be set to NULL asynchronously unless ->recv_mutex is held.
So it is important to hold that mutex.  Otherwise a sysfs read can
trigger an oops.
Commit 17f09d3f619a ("SUNRPC: Check if the xprt is connected before
handling sysfs reads") appears to attempt to fix this problem, but it
only narrows the race window.

[ Removed the changes about net/sunrpc/sysfs.c, as this file doesn't
exist in 5.10 ]

Fixes: 17f09d3f619a ("SUNRPC: Check if the xprt is connected before handling sysfs reads")
Fixes: a8482488a7d6 ("SUNRPC query transport's source port")
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtsock.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 5dccad3271fe5..4ec6516a53e09 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1666,7 +1666,12 @@ static int xs_get_srcport(struct sock_xprt *transport)
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
 
-- 
2.53.0



