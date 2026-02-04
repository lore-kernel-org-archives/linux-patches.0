Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD7D4218BC;
	Wed,  4 Feb 2026 14:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217110; cv=none; b=l0rVQBPrxNTw/NNbWIlru+vE4tk2hA90Jv5mYsn1jVxlgH0YOb0opircVrDaUdOiMQaupkhPjoDJb4sB/wz4gGPIK0hhLmEQHVE0HO9rQ11Sxr6pqAgQ4NNsfT9mHPPeoQQp5rQClvYEnaehetnaHE4EhaEvl2YJzkNWE3bBpes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217110; c=relaxed/simple;
	bh=UfuThLJfdr3ACRRSjtecsUWeOr/okClWEKJp5Vn/T7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLHBpEHhmAVhmSZesdEVEJBsbWLZxIsh7rIfqfKSLvYSFZmJA9ry2OWRJg+7w6sxUjd8JI+BW3RpON/2Igluz3B/9BKxwtr8IrbEveayCxWd2Z+Bx2sVBFpFWm1YWWgx2YxIEqqT4fKW8D/+iPv2SnRUp6EngXGL1wtt+HxmfHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HPiKjqU5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HPiKjqU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50079C4CEF7;
	Wed,  4 Feb 2026 14:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217109;
	bh=UfuThLJfdr3ACRRSjtecsUWeOr/okClWEKJp5Vn/T7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HPiKjqU5xoMNlSnqNSlS+h/6li/i7c+GhfKpfG1oTaCCZWA3UrcocrZMJkzHEcUvl
	 tRmPcqtPn5YShkqfrbm9FoJUPp211+6K344U4p6MnAUdwZzOoeopV8UfytPWo1JiOO
	 ip5P7R01+ckHRWi7m0fiP+fjTsXv3tWOReGdmr54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+999115c3bf275797dc27@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 125/206] netrom: fix double-free in nr_route_frame()
Date: Wed,  4 Feb 2026 15:39:16 +0100
Message-ID: <20260204143902.703723606@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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
 


