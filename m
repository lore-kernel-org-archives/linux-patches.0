Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212419;
	b=goWYuWDPIeLH8rznntUDhRwQnXJVhWXHQiA62TnxYvgUN1qscRI7Wqqw5dDfhtA2d+oP
	 060Jm4C2p/tyKeBy0X8FTs4LZpXUZ9JIC0FfddlvDd+aoJu3EL+zmkeVl/xqutprUs5VB
	 dO1WlqTbrcgw743yhqHZVFD9FSrhisghcovA9gYCeuwHnEzDzm93/4HhE3fGg2K9SsF4A
	 Ag+LXSPyKvMFEl3se3zFgi9WpACfF1n5tHkJMr4oQHyylTvZ8LCAAEs82zO1pnPvJS9eD
	 Z2WRLFP4sioxhkhl6WlJNw6Ga1B16Kpzs+d05FIv7qVnxF+9j7TLRI7u3KX6jS9kW0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212419;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0xQKFFiHEW8fS277p3VRz+cwKigDIdvwK4mD7j33ljw=;
	b=ujBdT9X4B9ln6wcd90IhBx7WOH1ks+Blt0VraE0C66GP+489EUM7gAeENsy0nlPd85iB
	 PBdGflB9z4QecRDl+vHVDOyeYrAwvtvlbTt8K2bB53iYTqmLxP08o89P5iDUaijfl4EXf
	 JXvMxbiLrCVStnRJviclsHpB6GZ30Y+HAhak40Z4/KXonfPJKGfMkQoJDuKX0A/zGy5FX
	 nIdbj/wXoAl7261GjnH+qUtBMcXYhITMFTGKt9y+nDSz6fCnpwX2TWRsWcNxv0pwvVFYN
	 ir7YEZsBS6HWKuld/GsD2/g0ZtgfDmEEb9YMczWxRn4RGS+pMEsTbTeBswkyB8eQvLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I4ZkGWkm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085C7606A31D;
	Wed, 28 Oct 2026 18:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I4ZkGWkm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5927C1F031E1;
	Wed, 28 Oct 2026 18:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212418;
	bh=0xQKFFiHEW8fS277p3VRz+cwKigDIdvwK4mD7j33ljw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I4ZkGWkmHuTiwAWZPFi9e/DVoZtCfpJR6Y0CXKh++Iyor4LyhQYaCkSwgsSvS4KY4
	 03zMoRz0JH4OtxEQ11+3Kuc8VqORy5qZ+dbLpwnLRMZ6Oz9dB5WqYUHT4H8ra769TF
	 VDIUP0qGGtwfGLOEuC5z6fLPxmbYoYtTEVTI5/ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Axel Mierczuk <axel.mierczuk@1password.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0146/1887] net: openvswitch: conntrack: fix helper UAF due to extensions realloc
Date: Wed, 28 Oct 2026 17:37:22 +0100
Message-ID: <20261028170502.558461657@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/conntrack.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 8c5f6602af44a..9407fdcbb52a7 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1063,11 +1063,14 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 			}
 		}
 
-		/* Call the helper only if:
-		 * - nf_conntrack_in() was executed above ("!cached"), or
-		 * - When committing an unconfirmed connection.
+		/* Call the helper only if nf_conntrack_in() was executed
+		 * above ("!cached").
+		 *
+		 * For unconfirmed connections it will be called later during
+		 * commit as we need to have all the other extensions allocated
+		 * before the call.
 		 */
-		if ((nf_ct_is_confirmed(ct) ? !cached : info->commit)) {
+		if (nf_ct_is_confirmed(ct) && !cached) {
 			int err = nf_ct_helper(skb, ct, ctinfo, info->family);
 
 			err = verdict_to_errno(err);
@@ -1290,6 +1293,14 @@ static int ovs_ct_commit(struct net *net, struct sw_flow_key *key,
 			return err;
 
 		nf_conn_act_ct_ext_add(skb, ct, ctinfo);
+
+		/* Call the helpers now.  We couldn't do this before as
+		 * all the extensions must be allocated before the call.
+		 */
+		err = nf_ct_helper(skb, ct, ctinfo, info->family);
+		err = verdict_to_errno(err);
+		if (err)
+			return err;
 	} else if (IS_ENABLED(CONFIG_NF_CONNTRACK_LABELS) &&
 		   labels_nonzero(&info->labels.mask)) {
 		err = ovs_ct_set_labels(ct, key, &info->labels.value,
-- 
2.53.0



