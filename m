Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E16E1C93B0;
	Tue, 27 Aug 2024 14:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770637; cv=none; b=gR+C5Abt6Q5a3XGAFt5rXfwjBQUuMKVO5g+ZWyLjVLAD7Txzv+y+zMup2c+xF0E1T6zwygqCeqebxwi/XI0ia21HBxOevI0WsklRI6M7yT9gEnmKHFjZQzktUiWyYXhRqzkMqFDwb1nc33EwzNOV0ApAkB/Zg7hJ1NVqDdQagUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770637; c=relaxed/simple;
	bh=hv0e5Qd+v3WQ8gOc4ehnRzQYUENIqjXeHf3asPdBuK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LAekt+FmT+wQJ2FaVFBEeolKHzF4Ti56MweNPGgPNhYD3X/XftTh0E1VN+z0SvKaxeFyVI12an57CgZ3kmyUNTIVOgDrFZT+Ym5yD7sunjr/yObJiP+emNqv6K0Tu8xp+19x5jfajNqI+BpOmfmLsayw1GmlRPEn0w3XqqlxMxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rw6rAYGZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rw6rAYGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821EAC4FE02;
	Tue, 27 Aug 2024 14:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770637;
	bh=hv0e5Qd+v3WQ8gOc4ehnRzQYUENIqjXeHf3asPdBuK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rw6rAYGZEbEE251dcdDSnowQg8d3HFDvPa/mLvU+KsX68AbvZN5ZbrrugiKzXd/T4
	 Ly7LiBQZwRzQAH+SlY8ka9WVBUXZ7xACzWmlnH0xlvzh+2PBfgWUVlC9TPyV+zc/U2
	 sjdNoVPQGkdEm99xsTvw2obwdVJlngJRqKq8khOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 257/341] bonding: fix null pointer deref in bond_ipsec_offload_ok
Date: Tue, 27 Aug 2024 16:38:08 +0200
Message-ID: <20240827143853.186708836@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b4f8f5112edd5..a6eb907a9a273 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -604,6 +604,8 @@ static bool bond_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *xs)
 	bond = netdev_priv(bond_dev);
 	rcu_read_lock();
 	curr_active = rcu_dereference(bond->curr_active_slave);
+	if (!curr_active)
+		goto out;
 	real_dev = curr_active->dev;
 
 	if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP)
-- 
2.43.0



