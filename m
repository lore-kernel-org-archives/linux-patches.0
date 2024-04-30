Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2D78801;
	Tue, 30 Apr 2024 11:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476206; cv=none; b=IDAkjFXMTeemEQUF1M/tpT2iLuk2FWID0JIUm4Uh8d52FhJ7wqXx9wv2H6WL+q8+Nybr02YOV+oKcHI5aghT5iqixHdx8G2LiZ70npXWnC1W06WyiDTzpWhQ+6GknFFcGJgjIlfl2ilqWHWXey3D1HE7p9Rn9his2GJCSERNB/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476206; c=relaxed/simple;
	bh=IwZBmOGJA0hsJvwJLTJ8dI9hHTsc8g2oAhY+VxLjBYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzc4gGrv9wF4c78kUcobi+dMSVnOmdkfW01xXt8ZbyVA+9GBp7TAILpfYWbFdoIxjqnGxtzJUtA5hkRPjh1rcshqsaC9niU3qbfbxk7N5g3M79Y6f35DgEbMcLDoepGABPEBf7CCtY1/BSMU1SVMQQmzEgMdvl4o3bKAotSTyvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zhDwYA8H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zhDwYA8H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B707EC2BBFC;
	Tue, 30 Apr 2024 11:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476206;
	bh=IwZBmOGJA0hsJvwJLTJ8dI9hHTsc8g2oAhY+VxLjBYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zhDwYA8HbKnag9hQLdmkwtG7bgM9ZgutgRNd+vpzc2b53XzKrrT9Ruump59SZUFFI
	 tAj63yAlGvSQctm5VsGpnUQu4tQ0DAt2o4inmEV1E3DopMJFnsxeaIiqguT7xeNQtR
	 D95keE0R5EhQOUHuuC7ae2bkxePeoULnEDS12zXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Eric Dumazet <edumazet@google.com>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 067/107] net: openvswitch: Fix Use-After-Free in ovs_ct_exit
Date: Tue, 30 Apr 2024 12:40:27 +0200
Message-ID: <20240430103046.633944575@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <v4bel@theori.io>

[ Upstream commit 5ea7b72d4fac2fdbc0425cd8f2ea33abe95235b2 ]

Since kfree_rcu, which is called in the hlist_for_each_entry_rcu traversal
of ovs_ct_limit_exit, is not part of the RCU read critical section, it
is possible that the RCU grace period will pass during the traversal and
the key will be free.

To prevent this, it should be changed to hlist_for_each_entry_safe.

Fixes: 11efd5cb04a1 ("openvswitch: Support conntrack zone limit")
Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Link: https://lore.kernel.org/r/ZiYvzQN/Ry5oeFQW@v4bel-B760M-AORUS-ELITE-AX
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/conntrack.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 90c5f53007281..48522c688c3e6 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1897,9 +1897,9 @@ static void ovs_ct_limit_exit(struct net *net, struct ovs_net *ovs_net)
 	for (i = 0; i < CT_LIMIT_HASH_BUCKETS; ++i) {
 		struct hlist_head *head = &info->limits[i];
 		struct ovs_ct_limit *ct_limit;
+		struct hlist_node *next;
 
-		hlist_for_each_entry_rcu(ct_limit, head, hlist_node,
-					 lockdep_ovsl_is_held())
+		hlist_for_each_entry_safe(ct_limit, next, head, hlist_node)
 			kfree_rcu(ct_limit, rcu);
 	}
 	kfree(ovs_net->ct_limit_info->limits);
-- 
2.43.0



