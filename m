Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF7C32D7F8;
	Sat, 12 Sep 2026 18:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237040; cv=none; b=hrh4BQrEEbiRcZqS6IiOQ8j3+jpZW9Uyf9Zf/Zw8YdUSxpCUeebW4m3X4AEQWx74ChC8sdDCu4sCmMHQwU/OXZCuZ6v02BgPeWo/01Ov1EYkPVgYBFeyrLu4ZI3DfZVYUyWLqClNLuoHKWVBBMAY5pwvCOq4KIqesHvGFwIn9cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237040; c=relaxed/simple;
	bh=KDl3OAXZfadtR5ihENj3TbAQFJ2WAmkigRU/NhvVIfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IrPZjAh9z68XvQS1/6s8FuJ5lTKby9y9ndtqYbkYRkrN0ch9hxmLh7JnUjqciVTo9VpQqOHB7mKfTmBQwwwaW1B9hYlQB3Yl7SpzbLY8DhMAr1agRnAp4UIha1K81k8w4Sl2TyMHtov6gD/38h92MhG4I8hM5LM9emFagKZsXkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=su/4IMpn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="su/4IMpn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4397F1F000FF;
	Sat, 12 Sep 2026 18:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237039;
	bh=NlAbUcziJF2qzLdNC+QXcQyBBEqQ6N6ZXZ/92v2i1vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=su/4IMpnEIS7zpo5H7v3D5Lulqfolxnar+AMBDP9cl93IFVvHYCNVQY2Z/srFiCzU
	 Y3lYxOJ/85BQU7WCuGmc1FHJYkqvIueyORnzHei5h0MYX5QIKdCyaA8wKuppIxNdGq
	 g7FZoNqk9JTWLk0G9nB2mSMV4lCCwlABa5DtMg30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 179/935] net: openvswitch: fix nf_connlabels leak in ovs_ct_init
Date: Sat, 12 Sep 2026 08:53:29 +0200
Message-ID: <20260912065530.923911269@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

commit f9de5db270a4c2641de87ee558c16a9bc6eb4cd8 upstream.

ovs_ct_init() acquires a connlabels reference before initializing the
conntrack limit state. If ovs_ct_limit_init() fails, its error is returned
directly. The pernet core does not invoke the exit callback for the
operation whose initialization failed, so ovs_ct_exit() cannot drop the
reference.

This leaves labels_used elevated when Open vSwitch pernet registration
fails for an existing network namespace. Subsequent conntrack entries in
that namespace may allocate label extensions even though Open vSwitch
failed to register.

Drop the connlabels reference before returning a conntrack limit
initialization error. ovs_ct_limit_init() already releases its partial
state, and the original error remains unchanged.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: 11efd5cb04a1 ("openvswitch: Support conntrack zone limit")
Cc: stable@vger.kernel.org
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Link: https://patch.msgid.link/20260815151729.3757984-1-ruoyuw560@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/conntrack.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -2301,6 +2301,7 @@ int ovs_ct_init(struct net *net)
 {
 	unsigned int n_bits = sizeof(struct ovs_key_ct_labels) * BITS_PER_BYTE;
 	struct ovs_net *ovs_net = net_generic(net, ovs_net_id);
+	int err = 0;
 
 	if (nf_connlabels_get(net, n_bits - 1)) {
 		ovs_net->xt_label = false;
@@ -2310,10 +2311,11 @@ int ovs_ct_init(struct net *net)
 	}
 
 #if	IS_ENABLED(CONFIG_NETFILTER_CONNCOUNT)
-	return ovs_ct_limit_init(net, ovs_net);
-#else
-	return 0;
+	err = ovs_ct_limit_init(net, ovs_net);
+	if (err && ovs_net->xt_label)
+		nf_connlabels_put(net);
 #endif
+	return err;
 }
 
 void ovs_ct_exit(struct net *net)


