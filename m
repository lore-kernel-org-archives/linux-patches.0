Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2A7151CFA;
	Tue, 20 Feb 2024 21:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465327; cv=none; b=EbuFb4SM/T4gpF4ZpEMNLMsin3vzvVlOvtaF+XHnqvHIbWlsFt7j11B1PGJr0mbooaTi+FQedcIP/8S9C2uvYOnwn2ZteegMMbO4N4L27SFg9wVwK6ouf9UHxSEwAbhlKvDoYQqls6ADCqqOagTSbUF1Gd9Pxitpk1YAgf3zMbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465327; c=relaxed/simple;
	bh=CIqnrB2wQxkRrgzPOLyf7r7fZ/1LU6A8aH4IM6aODUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mU9qKHPOIKCu9TFL4kuo7jqXEERQnBggLmWI3viyOWPxCR2BgZbmRs5pD7MxKYPg55yLDZxcz9/HxTiOliowc34qLA6fIS+7NjOaXXGE3Bbh0Np4no7UZuF4dg15mLOO46GAbImP5k/sF9SdTTDb2x6rEmsW1ly9DZ6zizzZkF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G61ycAha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G61ycAha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E387BC433F1;
	Tue, 20 Feb 2024 21:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465327;
	bh=CIqnrB2wQxkRrgzPOLyf7r7fZ/1LU6A8aH4IM6aODUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G61ycAhaY0nkT5XrLD0hWZwX4f/TDwZf2h8KA/dsx/6nAVptAiZ/uzvCSxigQjwRV
	 xt+cmwzMgufc/4OYHf5XzgS4/o0hr56ejdRQ51TswnsKeoTjlNF1f48gPNBVEQ8r55
	 y5tqLRbsdRbVfAflnzrRzPH4+8Tq31XbLPjmgvCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+52bbc0ad036f6f0d4a25@syzkaller.appspotmail.com,
	Brad Spengler <spender@grsecurity.net>,
	=?UTF-8?q?=D0=A1=D1=82=D0=B0=D1=81=20=D0=9D=D0=B8=D1=87=D0=B8=D0=BF=D0=BE=D1=80=D0=BE=D0=B2=D0=B8=D1=87?= <stasn77@gmail.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.7 308/309] netfilter: ipset: Missing gc cancellations fixed
Date: Tue, 20 Feb 2024 21:57:47 +0100
Message-ID: <20240220205642.744057680@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jozsef Kadlecsik <kadlec@netfilter.org>

commit 27c5a095e2518975e20a10102908ae8231699879 upstream.

The patch fdb8e12cc2cc ("netfilter: ipset: fix performance regression
in swap operation") missed to add the calls to gc cancellations
at the error path of create operations and at module unload. Also,
because the half of the destroy operations now executed by a
function registered by call_rcu(), neither NFNL_SUBSYS_IPSET mutex
or rcu read lock is held and therefore the checking of them results
false warnings.

Fixes: 97f7cf1cd80e ("netfilter: ipset: fix performance regression in swap operation")
Reported-by: syzbot+52bbc0ad036f6f0d4a25@syzkaller.appspotmail.com
Reported-by: Brad Spengler <spender@grsecurity.net>
Reported-by: Стас Ничипорович <stasn77@gmail.com>
Tested-by: Brad Spengler <spender@grsecurity.net>
Tested-by: Стас Ничипорович <stasn77@gmail.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipset/ip_set_core.c     |    2 ++
 net/netfilter/ipset/ip_set_hash_gen.h |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1154,6 +1154,7 @@ static int ip_set_create(struct sk_buff
 	return ret;
 
 cleanup:
+	set->variant->cancel_gc(set);
 	set->variant->destroy(set);
 put_out:
 	module_put(set->type->me);
@@ -2378,6 +2379,7 @@ ip_set_net_exit(struct net *net)
 		set = ip_set(inst, i);
 		if (set) {
 			ip_set(inst, i) = NULL;
+			set->variant->cancel_gc(set);
 			ip_set_destroy_set(set);
 		}
 	}
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -431,7 +431,7 @@ mtype_ahash_destroy(struct ip_set *set,
 	u32 i;
 
 	for (i = 0; i < jhash_size(t->htable_bits); i++) {
-		n = __ipset_dereference(hbucket(t, i));
+		n = (__force struct hbucket *)hbucket(t, i);
 		if (!n)
 			continue;
 		if (set->extensions & IPSET_EXT_DESTROY && ext_destroy)
@@ -451,7 +451,7 @@ mtype_destroy(struct ip_set *set)
 	struct htype *h = set->data;
 	struct list_head *l, *lt;
 
-	mtype_ahash_destroy(set, ipset_dereference_nfnl(h->table), true);
+	mtype_ahash_destroy(set, (__force struct htable *)h->table, true);
 	list_for_each_safe(l, lt, &h->ad) {
 		list_del(l);
 		kfree(l);


