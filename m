Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208415;
	b=lXN2f164p9VOquhXaym0snetlB+ASgMvJu8Cv/97vqF4UyjcoM/0fVViB27JHBXmZmzC
	 GZbojmHIdM2wI0T64symqh5ZMZBOAh4wENc2mbC/0ENx4zeA/+1dGa0zCh/DutHkkMICu
	 YyIkiUpGOcWIMzLwFVSxpyaj5SH4cEoSDCObBgQWKdo9zTW4myexNlZD5m1YFhBp2PIhh
	 Vh8l11A2SgQTJXwO3j2yywlRHLUvJUNIMCO6NQh21yuA9e+s5ZOaH5+zflCUzkS5OhR6G
	 BUMwCICNhIr78jxYVaWYujWhWKNpS0IMLVFRf89HBLo9IHF2M0VoSiKr8Jjbeo6MHiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208415;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w8ZpWsvV/LvTngVtLYz4HJbEg5cUki4zi3LOZhXmmEE=;
	b=2RMApBDTeKkGmMjQa0b0Rh324alr5/c44rVYVvXj/9SS6cn0u1HNCMOm2o1aN9EhdRE/
	 WdmkSZHHyr38BBBhPrLneObsfyyjMvhi+o8Anmd4dXcK0hr8OA2D1NauEjwv4Ls512cHN
	 ZBdXwffdPhYCvkmRC+eMuZf3wNYUoXOuynVK3IqeRqfiST8h27JU4Ky+Vpvpz9rYHAOmf
	 bLCsy0bwmGlC3Ic2/p94mSj7Mby9ylRmPb20JVnoBtNwXwpb+iUpR4DYokbcNIR33mV5b
	 uQgs9DywBJqxmPgH6cPAu+OyeWxgiWD/6s9wsB6aplDSUyismdZipfxL4Ido2qgDMpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cM9bVmvu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC156606A31E;
	Wed, 28 Oct 2026 17:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cM9bVmvu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BD51F01825;
	Wed, 28 Oct 2026 17:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208414;
	bh=w8ZpWsvV/LvTngVtLYz4HJbEg5cUki4zi3LOZhXmmEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cM9bVmvu7VOPaQt8EC/IeDtSOhSWK8r70EjBSO7fETr/HMkISW8mvgMlGlLsLD5P/
	 M1J6tdBcuO/0YkSmdke7gqTLGIe6yBjIfKbQYtylBKMe2bh/RzcDOeamyCGmm0qY59
	 +2v4luD6QPJxAZKm/nWoDbODC9qBNUumSSQ6wceU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Axel Mierczuk <axel.mierczuk@1password.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/516] net: openvswitch: conntrack: fix helper UAF due to extensions realloc
Date: Wed, 28 Oct 2026 17:54:24 +0100
Message-ID: <20261028170006.172165390@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 340f7dde559f5..196e7f7c82e1c 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1038,14 +1038,14 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
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
@@ -1253,6 +1253,12 @@ static int ovs_ct_commit(struct net *net, struct sw_flow_key *key,
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



