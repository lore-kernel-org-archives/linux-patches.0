Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB381DEFD8;
	Wed, 19 Feb 2025 09:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957477; cv=none; b=egQTTRWPrHMBPFM1QtlIB/RD5r98uPLJbaiLcZNK3478+Kx2km7ISo1VuHP271WZTabPAtWfN/3MD1Dl/MLKVFQHEKcTQJPAAGkSqUsGgsdtn/wSeVpezjLqNg15+9tBiONwOp3ev+Xjhc0IRUhli/h3oV6ipeDX+Lsnv0mkc0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957477; c=relaxed/simple;
	bh=k0vmsSy1UUBCrBwxgW64eLWC/OnRU+Mwig0AZOAJdmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTXqan6mbPqsQobUPqnqMfkG3AeIFdq/ze0yWYZ/ftYFNZjuD5dT4E5Y8MPuMJL+UbVXAUf8d9M2nRBpjK75RoY++T8O+YuRY0Ye2EpdFtUmgUuqP2/gEkhhphIRAwjevHX/EGrm74CqgVA0ndvWjMpSUseM4zcllYogHJE9aCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vTZ7LwL5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vTZ7LwL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87CAAC4CED1;
	Wed, 19 Feb 2025 09:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957476;
	bh=k0vmsSy1UUBCrBwxgW64eLWC/OnRU+Mwig0AZOAJdmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vTZ7LwL5z60tH/H/yDaGsLdtnRcL0XiX9t8Ymn1bwTTqaNI+HeaCPI20EuHtI5SsE
	 F10duK2uDQpY7DluZWZrfQBXpjRFJ2OSVXYt5blPAkFUlnIc2J4gQQFa7gFe1txCPu
	 tp3KYoT0slnufDIXZJPtFKhWcEE20N+neaZYFxB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 539/578] net: treat possible_net_t net pointer as an RCU one and add read_pnet_rcu()
Date: Wed, 19 Feb 2025 09:29:03 +0100
Message-ID: <20250219082714.174648929@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jiri Pirko <jiri@nvidia.com>

[ Upstream commit 2034d90ae41ae93e30d492ebcf1f06f97a9cfba6 ]

Make the net pointer stored in possible_net_t structure annotated as
an RCU pointer. Change the access helpers to treat it as such.
Introduce read_pnet_rcu() helper to allow caller to dereference
the net pointer under RCU read lock.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 71b8471c93fa ("ipv4: use RCU protection in ipv4_default_advmss()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/net_namespace.h | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 17c7a88418345..3ffcc1b02a590 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -353,21 +353,30 @@ static inline void put_net_track(struct net *net, netns_tracker *tracker)
 
 typedef struct {
 #ifdef CONFIG_NET_NS
-	struct net *net;
+	struct net __rcu *net;
 #endif
 } possible_net_t;
 
 static inline void write_pnet(possible_net_t *pnet, struct net *net)
 {
 #ifdef CONFIG_NET_NS
-	pnet->net = net;
+	rcu_assign_pointer(pnet->net, net);
 #endif
 }
 
 static inline struct net *read_pnet(const possible_net_t *pnet)
 {
 #ifdef CONFIG_NET_NS
-	return pnet->net;
+	return rcu_dereference_protected(pnet->net, true);
+#else
+	return &init_net;
+#endif
+}
+
+static inline struct net *read_pnet_rcu(possible_net_t *pnet)
+{
+#ifdef CONFIG_NET_NS
+	return rcu_dereference(pnet->net);
 #else
 	return &init_net;
 #endif
-- 
2.39.5



