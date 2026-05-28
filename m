Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A067A15B998;
	Thu, 28 May 2026 19:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998364; cv=none; b=qzNTQK3tKhnoN/gTgz0D6LxTobUSMUP6TEVIRjbBhDohQDNZKo6r0LyBYalk7PId6zSQ3jkIl5a8tmRZbj1s315n6KWkxbpySKzuV0FGvMDwnMYqaoS1M/Px5ukE8SgAcIQwVZedn7BITz7zI+SuOePVHyRX5dJYz9DECJLSFOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998364; c=relaxed/simple;
	bh=MUfBz8CFjLuKNh4mn2/NoUTs2goeiQHPOKn3vCrMwcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1QOwwcOZgTtL75KyFavxbq+jvryKDraihtNZhcl9bolRC4rXmaVQMG1pF6OaMoUGucyWTHCtFZqGmhg/+2E7vf5+gezhJGcLwm/K/n5ugxQDFNr4V7lvB1F36HBANgUCoyttKnNP1NoXK5t3iebzA5nhXs86BfS217Jp7q05ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zHZV2b4i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zHZV2b4i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100931F000E9;
	Thu, 28 May 2026 19:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998363;
	bh=tQtAG/XjCQpcgsFH/fLK/6i7vEbHktY3zjPO+ZzFbMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zHZV2b4igjwTKRCnmzhjzCU8vgQf0RzPk/zc6p7JwQsAeI4ri7QLQP5y9JNfjEFCj
	 9jexAMysKVpybDu6ICHLkUrKl7r88SA6LyppWaSrzMPS3jXIBsJvJoYcUysIp6rJTt
	 JTvP4cyDSNYPPzR3PlISGIdTwAksf9RqvpetQU4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ruijie Li <ruijieli51@gmail.com>,
	Zhanpeng Li <lzhanpeng2025@lzu.edu.cn>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 7.0 146/461] batman-adv: clear current gateway during teardown
Date: Thu, 28 May 2026 21:44:35 +0200
Message-ID: <20260528194651.243620548@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruijie Li <ruijieli51@gmail.com>

commit a340a51ed801eab7bb454150c226323b865263cc upstream.

batadv_gw_node_free() removes the gateway list entries during mesh teardown,
but it does not clear the currently selected gateway. This leaves stale
gateway state behind across cleanup and can break a later mesh recreation.

Clear bat_priv->gw.curr_gw before walking the gateway list so the selected
gateway reference is dropped as part of teardown.

Fixes: 2265c1410864 ("batman-adv: gateway election code refactoring")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Ruijie Li <ruijieli51@gmail.com>
Signed-off-by: Zhanpeng Li <lzhanpeng2025@lzu.edu.cn>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/gateway_client.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/batman-adv/gateway_client.c
+++ b/net/batman-adv/gateway_client.c
@@ -478,10 +478,14 @@ void batadv_gw_node_delete(struct batadv
  */
 void batadv_gw_node_free(struct batadv_priv *bat_priv)
 {
+	struct batadv_gw_node *curr_gw;
 	struct batadv_gw_node *gw_node;
 	struct hlist_node *node_tmp;
 
 	spin_lock_bh(&bat_priv->gw.list_lock);
+	curr_gw = rcu_replace_pointer(bat_priv->gw.curr_gw, NULL, true);
+	batadv_gw_node_put(curr_gw);
+
 	hlist_for_each_entry_safe(gw_node, node_tmp,
 				  &bat_priv->gw.gateway_list, list) {
 		hlist_del_init_rcu(&gw_node->list);


