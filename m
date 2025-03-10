Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F642236E4;
	Mon, 10 Mar 2025 18:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629750; cv=none; b=JX20B1iqtl4AFchkZVXSi1sMj3JXs/x1lK06y+NUcKoyrnltrXREf0v2tARQNJhvsF3NUPGvFhJWdIbn3xZsEsSXlfE6MKQGGC3T2Rd419wVt3IvnOGibRG2PakKrkX6OeP1F8BKKblBwcfIsE720osNCOtBp6zNj0KJbbvnchY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629750; c=relaxed/simple;
	bh=PJCT3bDTmPr/9aeEtlqCMj/CpBzma2UYkL5sBAbSXfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ByGBwLqInHk7VL9TW6nWw2vP2Ip4KT1HKJSIsZ5tOVuMwjKVGc+lDcHQNuTjNHapq7/HaQV2fVH0odtrVWvXbnDCkVRsPBynz/7Sr4Et5bP5nIfTSs5to0sxYxRhDNU3p+pOzZp0yJ9OMxSCABcJuI5gTM80Y8ok2HMuCRXuerc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FHqHncsh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FHqHncsh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B22AC4CEE5;
	Mon, 10 Mar 2025 18:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629750;
	bh=PJCT3bDTmPr/9aeEtlqCMj/CpBzma2UYkL5sBAbSXfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FHqHncshmZsTv6VJIJ2A1TBwZtGmS/ultRoLIC0uBzrgdQp+rbx9BtAend/z8ZLYR
	 TiHpze2bmCIuOrTUyQAAGIKDh7G8T7YHiYm2YZflt5r/qZ3eyDI2WGEVTq/4ms7SnD
	 qYs6lty9pkXE7ZfpnSerkaNusFGHzwv1zpUmXBNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 393/620] net: treat possible_net_t net pointer as an RCU one and add read_pnet_rcu()
Date: Mon, 10 Mar 2025 18:03:59 +0100
Message-ID: <20250310170601.105612011@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: dd205fcc33d9 ("ipv4: use RCU protection in rt_is_expired()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/net_namespace.h | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index d184b832166b6..0b6bea456fce6 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -316,21 +316,30 @@ static inline int check_net(const struct net *net)
 
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



