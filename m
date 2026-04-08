Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A193A16A0;
	Wed,  8 Apr 2026 18:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672742; cv=none; b=APg2eY97nRij/1UZ9TnpOWWkIOFBvigRZZB4dye1shQOfQ5sgQEPbKATx+FzgQdJDwHxM+xCamlWYh0jeQdzyv4UntpUhK0JOM6qnUio0Cp5NSibKpG+nqDktMIyu3o1t8agx/yU4H9dAN/kXgxwy9t/v4nR4LwZ8KMNTw+9Oqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672742; c=relaxed/simple;
	bh=7/6aCxOf6/gXcRIOBWIRR7lI7cM4Ux9QEyNyy6GE7Y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DnQpzUMwhqv2/QOEF13QpBze1yOOcWMCmAMIuxUovqzLnEbKoKA2Rzef9PioWLl8ZNFuFpO62oT+0DfNBUeT/g1LcTNKEUDU8Sdls83HqGKr1nbpbD5Jt55MDkPYOiEeBGhzSA33KS9tIXTLwXi1bL+muV4NFh/qE+rBj3hQwzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7MGlSlU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7MGlSlU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C169CC19421;
	Wed,  8 Apr 2026 18:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672742;
	bh=7/6aCxOf6/gXcRIOBWIRR7lI7cM4Ux9QEyNyy6GE7Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e7MGlSlUkMRtBJXJhcHq7JJyugFloTcmkxxwQfleOd6Pb2f6JSSVMxeqN7XdRByw2
	 9J1wNZgrnbYgoSoK2jaa6xiYouW/C7+Hqh1JE/RjKuoCf10h1aip0R2dzWgaKxVS3v
	 6Nq4zvhNPpYcMWPxXtBw81Jt9kFnoKv9NCb/jwfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <dstsmallbird@foxmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.6 124/160] netfilter: ipset: drop logically empty buckets in mtype_del
Date: Wed,  8 Apr 2026 20:03:31 +0200
Message-ID: <20260408175917.820490815@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

From: Yifan Wu <yifanwucs@gmail.com>

commit 9862ef9ab0a116c6dca98842aab7de13a252ae02 upstream.

mtype_del() counts empty slots below n->pos in k, but it only drops the
bucket when both n->pos and k are zero. This misses buckets whose live
entries have all been removed while n->pos still points past deleted slots.

Treat a bucket as empty when all positions below n->pos are unused and
release it directly instead of shrinking it further.

Fixes: 8af1c6fbd923 ("netfilter: ipset: Fix forceadd evaluation path")
Cc: stable@vger.kernel.org
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <dstsmallbird@foxmail.com>
Signed-off-by: Yifan Wu <yifanwucs@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Reviewed-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1098,7 +1098,7 @@ mtype_del(struct ip_set *set, void *valu
 			if (!test_bit(i, n->used))
 				k++;
 		}
-		if (n->pos == 0 && k == 0) {
+		if (k == n->pos) {
 			t->hregion[r].ext_size -= ext_size(n->size, dsize);
 			rcu_assign_pointer(hbucket(t, key), NULL);
 			kfree_rcu(n, rcu);


