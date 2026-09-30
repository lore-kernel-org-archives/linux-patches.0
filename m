Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE35252BE34;
	Wed, 30 Sep 2026 17:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790513; cv=none; b=Fi+n2hV1S2Fymw4PDX+4+eRkk+vi7M8M1qJXu+AXvnstlWFHdSohTJwGguay8FX5JpoD9ZqbzC0wsm74xq4M5RupyBwcG7QQ0Goh2q37v2PERmhTZYYElU+ULfZU96qOoraTtHG8EG4QUoyB0ekD1Wx7WTrSdn+ojGRT2ucAxBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790513; c=relaxed/simple;
	bh=s0fNWj7zcIk+oMtBUAfHNdt0CLxd5z571VVNGJtxJo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQnsFUFRG6Td38+B3ftu2vuIzTrlcDHKbzWhQBjSerJkfw929LRAde96bEMdtCMr3QElLv0PifjAK3yGoW4JenaWNEKNGY7HR+fj1CWfj3yFirBcI+qR4UJxugWwU9nnpFTuJ3e1aMlp9VuyKSI1p/aD3EbXIb95w/arg3KGkRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=chC7mYO4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="chC7mYO4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568051F000FF;
	Wed, 30 Sep 2026 17:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790511;
	bh=TAMv8EBxMjlRG+JDO1CpFiCV0naAE2SKOE6/a1dLOwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=chC7mYO42A4iAxOCC0aCSfF+5ZTKr/r/HHEbHhPtQe4sKUpXFXEBqMkx/Q1WuRbVO
	 eTyKeRJOKFLOzd0xmzbe35YM2gZSMrGQvuPNP3K9vfXJI5hJ9Iy/pRvvyaDOMW8tzW
	 Ge1SdoFC5yQw62OHD5W+wFZM3+m6+qabac8ryqAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 6.12 855/877] rose: hold loopback neighbour reference across timer callback
Date: Wed, 30 Sep 2026 17:29:26 +0200
Message-ID: <20260930152433.190199487@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

commit d270a7a5793af84555c40dd1eb80f1d497fdf53c upstream.

rose_loopback_timer() dereferences rose_loopback_neigh throughout its
body but holds no reference on it.  A concurrent rose_loopback_clear()
followed by rose_add_loopback_neigh() could free and reallocate the
neighbour while the timer body is running, causing a use-after-free.

Take a reference with rose_neigh_hold() at the start of the callback
(bailing out if the pointer is already NULL) and release it with
rose_neigh_put() at the single exit point.  The neigh cannot be freed
while the callback holds a reference.

Fixes: d860d1faa6b2 ("net: rose: convert 'use' field to refcount_t")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rose/rose_loopback.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/net/rose/rose_loopback.c
+++ b/net/rose/rose_loopback.c
@@ -66,10 +66,15 @@ static void rose_loopback_timer(struct t
 	unsigned int lci_i, lci_o;
 	int count;
 
+	if (rose_loopback_neigh)
+		rose_neigh_hold(rose_loopback_neigh);
+	else
+		return;
+
 	for (count = 0; count < ROSE_LOOPBACK_LIMIT; count++) {
 		skb = skb_dequeue(&loopback_queue);
 		if (!skb)
-			return;
+			goto out;
 		if (skb->len < ROSE_MIN_LEN) {
 			kfree_skb(skb);
 			continue;
@@ -109,6 +114,10 @@ static void rose_loopback_timer(struct t
 			kfree_skb(skb);
 		}
 	}
+
+out:
+	rose_neigh_put(rose_loopback_neigh);
+
 	if (!skb_queue_empty(&loopback_queue))
 		mod_timer(&loopback_timer, jiffies + 1);
 }


