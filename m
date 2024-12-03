Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BD23BB24;
	Tue,  3 Dec 2024 14:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236567; cv=none; b=TAlLrv2OP5uBwiirS/U2Z9jgTSVUHV3kBWLNvrpa00qIo1HdIIXwuyraZFG8WwVdPk3B0sX6SYmxovufuuleFaLZgOlazhkLHc3aje1UdZPVMf84J6XNcLM48lI7cTfQVi/QltibSeP4mdXq4BsrfRsBzfTwzHSKrJy6/ALYCzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236567; c=relaxed/simple;
	bh=GoPszE0VJaWo/sTMhD5E1gBeedIKqd7xNm1Uj+RiFxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jh34a/Vqb5p2u73bgCv8CulbVxZ0bK3p7b2W0O+YncVA26Rgt19q2aP4IEbZrqujtFWL3boUSn4QlZQUMKHUtXHqv0CDuLo6TjfZb/wOQdrVyJfW+MZyh12rvhsJtj0Cp0P2KlWstaScbFMKlS/2lCoTpZhbZtA3jctc9qxx7Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WGYLQwqz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WGYLQwqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B38C4CECF;
	Tue,  3 Dec 2024 14:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236567;
	bh=GoPszE0VJaWo/sTMhD5E1gBeedIKqd7xNm1Uj+RiFxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WGYLQwqzGN9e5O2oukPioqlflZPKlBanr4OV4Iu+Q1dn3tq0ALIMVP1RVE+Yb5jbO
	 yL8z5966TMrFICxoWA0YLIf1hRyoOOM9+hdLnG9+CiSldWZU5KWJfS6DrBf2/VJQ1V
	 nIFdMs5kb3mPFYzc17AX598juAr6RGgQlmTzGhr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 057/138] netpoll: Use rcu_access_pointer() in netpoll_poll_lock
Date: Tue,  3 Dec 2024 15:31:26 +0100
Message-ID: <20241203141925.740526722@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit a57d5a72f8dec7db8a79d0016fb0a3bdecc82b56 ]

The ndev->npinfo pointer in netpoll_poll_lock() is RCU-protected but is
being accessed directly for a NULL check. While no RCU read lock is held
in this context, we should still use proper RCU primitives for
consistency and correctness.

Replace the direct NULL check with rcu_access_pointer(), which is the
appropriate primitive when only checking for NULL without dereferencing
the pointer. This function provides the necessary ordering guarantees
without requiring RCU read-side protection.

Fixes: bea3348eef27 ("[NET]: Make NAPI polling independent of struct net_device objects.")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Link: https://patch.msgid.link/20241118-netpoll_rcu-v1-2-a1888dcb4a02@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netpoll.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netpoll.h b/include/linux/netpoll.h
index 3ef82d3a78db5..c47f74e6bd2cb 100644
--- a/include/linux/netpoll.h
+++ b/include/linux/netpoll.h
@@ -80,7 +80,7 @@ static inline void *netpoll_poll_lock(struct napi_struct *napi)
 {
 	struct net_device *dev = napi->dev;
 
-	if (dev && dev->npinfo) {
+	if (dev && rcu_access_pointer(dev->npinfo)) {
 		int owner = smp_processor_id();
 
 		while (cmpxchg(&napi->poll_owner, -1, owner) != -1)
-- 
2.43.0



