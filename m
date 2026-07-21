Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457F5471257;
	Tue, 21 Jul 2026 19:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663018; cv=none; b=pHkjiNYad3GsVI/JdIU2z8x2lc+oaCVxjH5Z1CiUvk+83qIeob0iM5uFXy8M+lv5tqeRmhlHDf4WuCd5rEYx3tqYVDFBlfT910dXxXIT92k8/SfIBf/+JvbY/HBfO8tvvWThqIfHXS8VvMaWBFC8rakjvUOSxQiUn9DbGBpHJnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663018; c=relaxed/simple;
	bh=EUo+/Mix8M904cNHkCFLwSA6HKmlakLYbAyHHZqWaww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3mcAkH7BZH4qcr8EmsdCYNx7b64dVVxncn+MsQ525jrI5rlgOToz6k2K6D9Phot4oeEUsfKMPugtk3Z5sAaWfAT69FI/CiTBmc3WlgtKTeQAnEtgqY4cA0hQvJo2VUhRv2YCyaN1KZF3zK3sLj1RhMDtn6lDYmMnINfyfwkwm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mu8xN8LQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mu8xN8LQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C901F000E9;
	Tue, 21 Jul 2026 19:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663017;
	bh=TaSHVxAj5o31vU9iuZkCf/fJd/Mve76e1gZCeqrLMj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mu8xN8LQqEoNEslP/OrC9aQ2Rw2EYNxtC7kgxPn722tt+svly/z/C8mNIxPyCiO4e
	 WSBo6hSoyPFeXT5pTVxBb4e5hwQlbWYsEVdmB8nGau3x6toI351TGLsxGWTuhWcLC6
	 CGzUxIIKJoVumiSwXkp5Hva1LpOvltDDR3LTr1yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0664/1276] ipv6: Add __in6_dev_get_rtnl_net().
Date: Tue, 21 Jul 2026 17:18:27 +0200
Message-ID: <20260721152500.963917551@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit f7a6082b5e4c15f34fd766cf0960f7e082009c54 ]

We will convert rtnl_lock() with rtnl_net_lock(), and we want to
convert __in6_dev_get() too.

__in6_dev_get() uses rcu_dereference_rtnl(), but as written in its
comment, rtnl_dereference() or rcu_dereference() is preferable.

Let's add __in6_dev_get_rtnl_net() that uses rtnl_net_dereference().

We can add the RCU version helper later if needed.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250115080608.28127-2-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 17dc3b245de4 ("ipv6: fix missing notification for ignore_routes_with_linkdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/addrconf.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index 779a1049fa1b98..d503b9d93a6327 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -330,6 +330,11 @@ static inline struct inet6_dev *__in6_dev_get(const struct net_device *dev)
 	return rcu_dereference_rtnl(dev->ip6_ptr);
 }
 
+static inline struct inet6_dev *__in6_dev_get_rtnl_net(const struct net_device *dev)
+{
+	return rtnl_net_dereference(dev_net(dev), dev->ip6_ptr);
+}
+
 /**
  * __in6_dev_stats_get - get inet6_dev pointer for stats
  * @dev: network device
-- 
2.53.0



