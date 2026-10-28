Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210681;
	b=Zt2tEeROI3QauOymxroGiTyEFQRZv270vQxXjhUn9Iw1JdVNA7f2QnCUvtrRcTMvzUu2
	 5M6BrvqHO7YNT8SeR/d/aUeQwsMPrLVaGy9UG7704vNckhUTGrfzMHKd40YFhExMTI2zM
	 0dMH8fCzEUZgpyrZ0z2rr+VuQFJGOE5taoPGhrx5z0UJEAfvXMFBrPZN/+nND46ntyk7E
	 nrHDKZ0/6DRJJxU27M+ruY82Id/H9jOOeONKB3h/UMRrqo96rfM7VWCOFubCzBuWomwJB
	 H2hLrfmQ5XPv5CWndWAOMcP/OC0AYXN2NF+mByztASr/JvmXZksECOeUiGy7rcqJOgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210681;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nTUkmUy7NSUuBnzBSpGtiVuhB91Dv0shXNbsc7qAGGQ=;
	b=YTeVUrlL45Xf8CM/R3LZAvlxFzCxg3wbaw3pUt7MlguH8N+WlRJtdCr8HXy4lhoZwbYR
	 yll+VjIPJQcGrcru2TTYcrmVkM9crubnC8uxnaj7BecOh7QIm5XdS6dvm6gcohfkIgHYz
	 uFLdDn7mJ+1+8ugwlwTAQe+62p34qPloYz1thU+n+KkQFQ14xEIf7k90MCQYFgEF/BM5M
	 JoKbCxHWI7K45BgQOfQvCypGd5k+K3TPL8dZKGzT4tAQOFRLjtqSV6LTNXLCGQ25wbGE3
	 J9gpWFWNDYPfWQZqlRiILoXRLzbKjq3HIdG9BbUlaRyLnbIU7oeskm+Yn5PYh6uZLBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=scccmZAr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6394606A31A;
	Wed, 28 Oct 2026 18:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=scccmZAr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016AC1F01825;
	Wed, 28 Oct 2026 18:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210680;
	bh=nTUkmUy7NSUuBnzBSpGtiVuhB91Dv0shXNbsc7qAGGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=scccmZArN3KUmgfTF2ZP6g5NnRFRL0h930aBHq/jLKtEHkMFtpH4iSwH1ka2wWwox
	 1QCPQ3yp0vPKZB10FTpvYIoN+0q5GAskIJ/qtA0EcX9rMN1ZE1IVkBpeOrFcLsAqlw
	 sVDj/6XNxd1bNXcsEkawECLRwYJT6QEd3vhHWqD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Axel Mierczuk <axel.mierczuk@1password.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 110/571] net: openvswitch: conntrack: fix helper UAF due to extensions realloc
Date: Wed, 28 Oct 2026 17:54:17 +0100
Message-ID: <20261028170010.631315646@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Maximets <i.maximets@ovn.org>

[ Upstream commit 1a4151e6be57b098b7a5ebfbde58585e83200cdc ]

While calling the helpers, a raw pointer to the extensions area is
wired into expectations list:

  -> nf_ct_helper()
   -> helper->help()
    -> nf_ct_expect_related_report()
     -> nf_ct_expect_insert()
      -> hlist_add_head_rcu(&exp->lnode, &master_help->expectations)

In case the connection is not confirmed yet, more extensions can be
added afterwards with *_ext_add() calls reallocating the extension
space and leaving the now invalid pointer in the expectations list
that is later accessed while removing the expectation.

Make sure that helpers are called at the end after all the other
extensions are already added.

Note that the helper rejection now leaves the mark and labels set,
but that's not different from how the NAT was handled before or how
the mark and the labels were handled on confirmation failure.  And
there are no atomicity guarantees provided by the API anyway.

Fixes: cae3a2627520 ("openvswitch: Allow attaching helpers to ct action")
Cc: stable@vger.kernel.org
Reported-by: Axel Mierczuk <axel.mierczuk@1password.com>
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Link: https://patch.msgid.link/20260921145655.3167436-4-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ adapted nf_ct_helper() calls to the existing ovs_ct_helper() API. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/conntrack.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index ee42c9357dffd..f0f0204a0e2b6 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1051,14 +1051,14 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 			}
 		}
 
-		/* Call the helper only if:
-		 * - nf_conntrack_in() was executed above ("!cached") or a
-		 *   helper was just attached ("add_helper") for a confirmed
-		 *   connection, or
-		 * - When committing an unconfirmed connection.
+		/* Call the helper only if nf_conntrack_in() was executed
+		 * above ("!cached") or a helper was just attached ("add_helper").
+		 *
+		 * For unconfirmed connections it will be called later during
+		 * commit as we need to have all the other extensions allocated
+		 * before the call.
 		 */
-		if ((nf_ct_is_confirmed(ct) ? !cached || add_helper :
-					      info->commit) &&
+		if (nf_ct_is_confirmed(ct) && (!cached || add_helper) &&
 		    ovs_ct_helper(skb, info->family) != NF_ACCEPT) {
 			return -EINVAL;
 		}
@@ -1274,6 +1274,12 @@ static int ovs_ct_commit(struct net *net, struct sw_flow_key *key,
 					 &info->labels.mask);
 		if (err)
 			return err;
+
+		/* Call the helpers now.  We couldn't do this before as
+		 * all the extensions must be allocated before the call.
+		 */
+		if (ovs_ct_helper(skb, info->family) != NF_ACCEPT)
+			return -EINVAL;
 	} else if (IS_ENABLED(CONFIG_NF_CONNTRACK_LABELS) &&
 		   labels_nonzero(&info->labels.mask)) {
 		err = ovs_ct_set_labels(ct, key, &info->labels.value,
-- 
2.53.0



