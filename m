Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCD52E6CA0;
	Wed, 28 Jan 2026 15:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614776; cv=none; b=MyN0+YPJAW+bVvWblThQQr3muTKXCDXYHUJ7/gg++lSxFPrxZwR9AukSvqwlXXvD/K8gOywR7XtQtA176P13LF5QET/y+qFefROyJUAC53FFeds1gaN2oEw7pG0IuaoLxAthQUOa+U1T80qVvt47EJ0GRorqmTJR/hm1rouTYQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614776; c=relaxed/simple;
	bh=V6T7mrc8B6PICpPb6z7zGfWmASvLosrP53kUSfGK4XE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CjxuZhC6GD+HBssfP/6WjZvWsCtkRqx7PbwH8OcWmLZMGL78IhO765EjQy8ZDX7MJoPpP9l6QBHQqe3FImkSl4QSYtX2r0saia3dewOb0LTUVASEM5U/EvknfEF96qUKsCibL6PUvaQy0zusY/Ggnj0apjjAXrWTuntMHZ/ZTEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EMgrYq25; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EMgrYq25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA92C4CEF1;
	Wed, 28 Jan 2026 15:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614776;
	bh=V6T7mrc8B6PICpPb6z7zGfWmASvLosrP53kUSfGK4XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EMgrYq25pWyGpqwtLCca2xHEv+w3gRhKIiCmD7i5o+gtD5FSjU73xCFENW1NxAd6F
	 j57EIWk3/gv7VXeca2WsH7PNExfK5rdFC30JhPbpiVwxUZEiJ4TWFde7tzuOtt62Ao
	 HMXkB4esrpJ6/iYyzOvitSAiKgaEvSr87TE0+2eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+999115c3bf275797dc27@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 211/254] netrom: fix double-free in nr_route_frame()
Date: Wed, 28 Jan 2026 16:23:07 +0100
Message-ID: <20260128145352.385415543@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

From: Jeongjun Park <aha310510@gmail.com>

commit ba1096c315283ee3292765f6aea4cca15816c4f7 upstream.

In nr_route_frame(), old_skb is immediately freed without checking if
nr_neigh->ax25 pointer is NULL. Therefore, if nr_neigh->ax25 is NULL,
the caller function will free old_skb again, causing a double-free bug.

Therefore, to prevent this, we need to modify it to check whether
nr_neigh->ax25 is NULL before freeing old_skb.

Cc: <stable@vger.kernel.org>
Reported-by: syzbot+999115c3bf275797dc27@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69694d6f.050a0220.58bed.0029.GAE@google.com/
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Link: https://patch.msgid.link/20260119063359.10604-1-aha310510@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netrom/nr_route.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -752,7 +752,7 @@ int nr_route_frame(struct sk_buff *skb,
 	unsigned char *dptr;
 	ax25_cb *ax25s;
 	int ret;
-	struct sk_buff *skbn;
+	struct sk_buff *nskb, *oskb;
 
 	/*
 	 * Reject malformed packets early. Check that it contains at least 2
@@ -811,14 +811,16 @@ int nr_route_frame(struct sk_buff *skb,
 	/* We are going to change the netrom headers so we should get our
 	   own skb, we also did not know until now how much header space
 	   we had to reserve... - RXQ */
-	if ((skbn=skb_copy_expand(skb, dev->hard_header_len, 0, GFP_ATOMIC)) == NULL) {
+	nskb = skb_copy_expand(skb, dev->hard_header_len, 0, GFP_ATOMIC);
+
+	if (!nskb) {
 		nr_node_unlock(nr_node);
 		nr_node_put(nr_node);
 		dev_put(dev);
 		return 0;
 	}
-	kfree_skb(skb);
-	skb=skbn;
+	oskb = skb;
+	skb = nskb;
 	skb->data[14]--;
 
 	dptr  = skb_push(skb, 1);
@@ -837,6 +839,9 @@ int nr_route_frame(struct sk_buff *skb,
 	nr_node_unlock(nr_node);
 	nr_node_put(nr_node);
 
+	if (ret)
+		kfree_skb(oskb);
+
 	return ret;
 }
 


