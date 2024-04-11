Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DE31465BF;
	Thu, 11 Apr 2024 10:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831017; cv=none; b=A5YXjx8U2IMIRfvt2c2YCXDSEi2LlIcFThWLhQtl1Rwy78LS65jQrMGkuRubzASrXx1D7c8qha3X8llDQzLiNzhEMcglIE1rZZUCdveOynOrb+6AyQEA5u+HHEoh4ODoyCdKkUf7DMeSekQSsM1+Le3UXs39xKW7GHUWdFb5fMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831017; c=relaxed/simple;
	bh=0UexDH6L7kNaeV20GrV04CgxJANkyG1t1QfwPOXPf4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFJxg3gT69G9g8b3M4p0sg2aAhJXspG+k6h1Rf4eWJFasyH1bRm/UjMk32Lhx/H5iP3IDYcYf7XO/kBkiCUAr5u1i1svliNI6iZWx0XizSxdKllsW1VdEqA+7Sa/EDYqqrpYjY3xIz2YYJLuYkpZeM4zyTHn2qMhsm/vpYtn4Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v7L34Tn4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v7L34Tn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EEBFC433F1;
	Thu, 11 Apr 2024 10:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831016;
	bh=0UexDH6L7kNaeV20GrV04CgxJANkyG1t1QfwPOXPf4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v7L34Tn43XFL0UPFqW2Fwbab4C3mCBfIOfbEs2yXZSeYI9HtwV4skgw7JqgX0aObG
	 HJYXRxPcni5Pl1mZCUnyWultZEhN494OjBNZr9gLULKFACLOxzD5VLt2AI28K8GwU7
	 hpgzLaLLeP0LLADh0ktZweWEgSsia7h8tKYDSiBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyang Xuan <william.xuanziyang@huawei.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 147/215] netfilter: nf_tables: Fix potential data-race in __nft_flowtable_type_get()
Date: Thu, 11 Apr 2024 11:55:56 +0200
Message-ID: <20240411095429.306811298@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

From: Ziyang Xuan <william.xuanziyang@huawei.com>

commit 24225011d81b471acc0e1e315b7d9905459a6304 upstream.

nft_unregister_flowtable_type() within nf_flow_inet_module_exit() can
concurrent with __nft_flowtable_type_get() within nf_tables_newflowtable().
And thhere is not any protection when iterate over nf_tables_flowtables
list in __nft_flowtable_type_get(). Therefore, there is pertential
data-race of nf_tables_flowtables list entry.

Use list_for_each_entry_rcu() to iterate over nf_tables_flowtables list
in __nft_flowtable_type_get(), and use rcu_read_lock() in the caller
nft_flowtable_type_get() to protect the entire type query process.

Fixes: 3b49e2e94e6e ("netfilter: nf_tables: add flow table netlink frontend")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6041,11 +6041,12 @@ static int nf_tables_flowtable_parse_hoo
 	return err;
 }
 
+/* call under rcu_read_lock */
 static const struct nf_flowtable_type *__nft_flowtable_type_get(u8 family)
 {
 	const struct nf_flowtable_type *type;
 
-	list_for_each_entry(type, &nf_tables_flowtables, list) {
+	list_for_each_entry_rcu(type, &nf_tables_flowtables, list) {
 		if (family == type->family)
 			return type;
 	}
@@ -6057,9 +6058,13 @@ nft_flowtable_type_get(struct net *net,
 {
 	const struct nf_flowtable_type *type;
 
+	rcu_read_lock();
 	type = __nft_flowtable_type_get(family);
-	if (type != NULL && try_module_get(type->owner))
+	if (type != NULL && try_module_get(type->owner)) {
+		rcu_read_unlock();
 		return type;
+	}
+	rcu_read_unlock();
 
 	lockdep_nfnl_nft_mutex_not_held();
 #ifdef CONFIG_MODULES


