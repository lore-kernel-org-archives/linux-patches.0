Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFB0612D7;
	Tue, 20 Feb 2024 21:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463258; cv=none; b=FM8OjA3hXgqavohvTsay88mJwCorOajLIn3jTSA+BAO21GdE7Go48ZvH8INJPyunc0rSoh+GSUNOtdGU+B5w9OF0AwtxQVZyySQcTVX/6FyS5iKavcCjwTr0/uFY3SEW12dY0+8aT69Q8LYpar3iYmABuBUgveEuayb3FtbZClM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463258; c=relaxed/simple;
	bh=+BGqk7qGvLtnjJAUe1wi8C53/4dzgjvMYV6GVTxv2qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fM0JayDO3mbVSUCQXF7fSgpLKRkIz+mUnXj1s1i6WFEYcJUFD+RQifzMMDX1YGf+xgefjSF5vBrWvAw4zBKBOKw+TMCpm3gQwMwVSSAuIuu2SBHVxPAQlJ6QDGDllSAIKFx5/nKDClsKAxvMuus7GyTpCpASOMvupnTDxoQlHg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Krh0XV00; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Krh0XV00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEDC6C433F1;
	Tue, 20 Feb 2024 21:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463258;
	bh=+BGqk7qGvLtnjJAUe1wi8C53/4dzgjvMYV6GVTxv2qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Krh0XV00+8rcsM0cEFnC/efjR4esbH8/XmXkK8hz+ZnAl0DcggPm/9xuKl+d0XDyF
	 1hHCpGhtmaJ9qtWqG32v4pvXGwKb8K1AnaIsEb/gP0qw3oiI1AZdUhZr6yOlEjUDLw
	 WK89v2BktQnepOGnjJ8tX1PAuCt30cypA7S+oHBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+52bbc0ad036f6f0d4a25@syzkaller.appspotmail.com,
	Brad Spengler <spender@grsecurity.net>,
	=?UTF-8?q?=D0=A1=D1=82=D0=B0=D1=81=20=D0=9D=D0=B8=D1=87=D0=B8=D0=BF=D0=BE=D1=80=D0=BE=D0=B2=D0=B8=D1=87?= <stasn77@gmail.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.1 185/197] netfilter: ipset: Missing gc cancellations fixed
Date: Tue, 20 Feb 2024 21:52:24 +0100
Message-ID: <20240220204846.611852296@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1156,6 +1156,7 @@ static int ip_set_create(struct sk_buff
 	return ret;
 
 cleanup:
+	set->variant->cancel_gc(set);
 	set->variant->destroy(set);
 put_out:
 	module_put(set->type->me);
@@ -2380,6 +2381,7 @@ ip_set_net_exit(struct net *net)
 		set = ip_set(inst, i);
 		if (set) {
 			ip_set(inst, i) = NULL;
+			set->variant->cancel_gc(set);
 			ip_set_destroy_set(set);
 		}
 	}
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -419,7 +419,7 @@ mtype_ahash_destroy(struct ip_set *set,
 	u32 i;
 
 	for (i = 0; i < jhash_size(t->htable_bits); i++) {
-		n = __ipset_dereference(hbucket(t, i));
+		n = (__force struct hbucket *)hbucket(t, i);
 		if (!n)
 			continue;
 		if (set->extensions & IPSET_EXT_DESTROY && ext_destroy)
@@ -439,7 +439,7 @@ mtype_destroy(struct ip_set *set)
 	struct htype *h = set->data;
 	struct list_head *l, *lt;
 
-	mtype_ahash_destroy(set, ipset_dereference_nfnl(h->table), true);
+	mtype_ahash_destroy(set, (__force struct htable *)h->table, true);
 	list_for_each_safe(l, lt, &h->ad) {
 		list_del(l);
 		kfree(l);


