Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B361CEAD3;
	Tue, 27 Aug 2024 15:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772624; cv=none; b=aPz5xmm5iAIem+JozUtCmX7LISZPI9FRwTmmZem/nb3tTD8OxssqX5tFPn+VvVCqiTpbYoUBPCkW8KyIuwrWmn9JD7TLgPTk7HUEbWiNQAR9oqlNhKyRqtInwNVUTubcQYYlouyHwKAX30YyToJ9hvTfBxa12GBGu/G8fpVQ7eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772624; c=relaxed/simple;
	bh=MZ60MQz/2H2UZVPKZTTAvEKJXLpIVCkxYCxIBgQegcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sy4Dia226R8yp/am9uoqKfS1gU4gNh8MNd2wusYUAmGrD5e7o/uYAmsBkDf52gVcE8X0uY9mYwA5vLshEpgfKmoFm15UECCWSVBhuuMZWQ8o2guFdlzsZ2aixxICWVXiFXWph30H6m80iDdEZ6y1RUcnHSVMNxjByMN5iy3gZjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MA2mocZz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MA2mocZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25BAC4AF65;
	Tue, 27 Aug 2024 15:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772624;
	bh=MZ60MQz/2H2UZVPKZTTAvEKJXLpIVCkxYCxIBgQegcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MA2mocZzRohyaba1A5PFsUcFHjDVJwvqBHWJfRiKonpMAfGwKTcolyL5aPJak8KeK
	 high+XFP/ja96Mx6w1UDsg6arq6AIRy9LitGj0tBiIumXyKyUNOOw6SgZmehgYDAdj
	 7tA4AWM8+FxLp+aKpkSsxtiWwY8AaHZN4o5BMR40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 239/321] bonding: fix null pointer deref in bond_ipsec_offload_ok
Date: Tue, 27 Aug 2024 16:39:07 +0200
Message-ID: <20240827143847.335214491@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit 95c90e4ad89d493a7a14fa200082e466e2548f9d ]

We must check if there is an active slave before dereferencing the pointer.

Fixes: 18cb261afd7b ("bonding: support hardware encryption offload to slaves")
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 5c7b249a1bcfa..2414861e04eb0 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -600,6 +600,8 @@ static bool bond_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *xs)
 	bond = netdev_priv(bond_dev);
 	rcu_read_lock();
 	curr_active = rcu_dereference(bond->curr_active_slave);
+	if (!curr_active)
+		goto out;
 	real_dev = curr_active->dev;
 
 	if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP)
-- 
2.43.0



