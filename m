Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A391F2DF73;
	Mon,  8 Apr 2024 13:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581665; cv=none; b=QZs64urGK8Dbmm4BZxtrFAyVkOTIYxqOoDDfJEwgH79loY3zJm3rgYr6STDDKCr+jYOFJxkDqss0AbbjQgdprfBaDGGnBuvdTykTFD9nwvc9sLSLztZyM7cJA8zgSD1iSujqKKoc6kwJup9Bab+i63jAM7RPVIWhufWlgFSgMi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581665; c=relaxed/simple;
	bh=kTS1yH+O4ga5knILrZ1annxfQcwEP7vkLcJCC+27ON4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAt18flcevMVFXeTC4cTrsye0RV9cXu21XoEumFcJuQgAJaWVFkFVkXRWlQla5VKWzuBC6P+F6K+v28Xy+g29QOKoKMc8EKAYxAB18fOLI/P9QdplZK30OnnKJKfIP3XO/pyEZj8QGBsHgEqLZiUdkISoOAiEF0RKEa7Mo0uQ8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=taUusbAk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="taUusbAk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2B6C433C7;
	Mon,  8 Apr 2024 13:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581665;
	bh=kTS1yH+O4ga5knILrZ1annxfQcwEP7vkLcJCC+27ON4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=taUusbAkgMjmQhUVXlV74BVRCoujokjOhpAhx5S4p0cMIBIp5uFy0OQHU7I9k/DcL
	 26QP1ngO7735ncBmTJCBZHs3g/xG2/FV32+5oBVz/7DrlhK4D/YtUO/gdVPjsQppGy
	 R9WTm7bdqJX+pXTFczeHO0WJ35l9wCJrxqMIwZ2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyang Xuan <william.xuanziyang@huawei.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.1 042/138] netfilter: nf_tables: Fix potential data-race in __nft_flowtable_type_get()
Date: Mon,  8 Apr 2024 14:57:36 +0200
Message-ID: <20240408125257.537747327@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7841,11 +7841,12 @@ static int nft_flowtable_parse_hook(cons
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
@@ -7857,9 +7858,13 @@ nft_flowtable_type_get(struct net *net,
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


