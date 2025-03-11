Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688A625D8E8;
	Tue, 11 Mar 2025 15:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705924; cv=none; b=BcsUeXKlwSohrExWkSsbLqy4hT0qfpL7NoxWYv4L7mfO5mnHKajCe5cP1StJENhCent41aeNOS/V4ZeEJ97MJEb4An5bmW4VHljuypGD1NydaXiudKSMng+V81hziIEJxiQWr2oLNz1y7gbPXMui32mOeOdP6WjjF6856RYJ01A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705924; c=relaxed/simple;
	bh=8Au0xJNj998sZmg/8D9Xt2xbONpZwdo5DTiNFMrRZlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MxQUVmnb90ZlvWQQ2NMahAqZP97FQ3ddZX2tOHM5SfSHkW99luPOdxppvGVhs6g4dGx0HHqm7svNbL0JnCFGWCzz9ctdhFOj+s+oOeJ1vN1/DbgATuXgLu2XLIOvYZTsQwrD6oLsEtOJ0833Y0EkNX4kytd1iP/8iDQVvXHXG+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N03hRhNU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N03hRhNU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2B0C4CEE9;
	Tue, 11 Mar 2025 15:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705923;
	bh=8Au0xJNj998sZmg/8D9Xt2xbONpZwdo5DTiNFMrRZlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N03hRhNU52PMsO3fl74Hfo+09GMmPbVVJJhWeffm/bMyXn/nKSKsC1rFmhLUYmEib
	 YdMF9kEwbzyF9jilYvj6rT63WeBSUNmDPr8kVKc6EyebFsRze11dUh+FXlWopiMBUz
	 D2f4TYhaz4OVy2hnZmMoY8ALJI4k8GBsfVJpFa28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 201/328] net: treat possible_net_t net pointer as an RCU one and add read_pnet_rcu()
Date: Tue, 11 Mar 2025 15:59:31 +0100
Message-ID: <20250311145722.891533337@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 0d61b452b9082..6ce0ec2dd2032 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -310,21 +310,30 @@ static inline int check_net(const struct net *net)
 
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



