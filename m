Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AE52C190;
	Sun,  1 Sep 2024 17:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210378; cv=none; b=Jc9KSrIjjVpCqzNtlHUi+ahDrONDmWnUJFdXjJ/h9Z/MGHDkkD6kjl+1Bn1EvPHPFZiRT5E2jxZ85xxTBT06/JH658K0IgA8i4NKJwYKpobEikS+1W4rNebPrkVKhWXCLUurEOQzFG9whpS68+Hc2S3639uTH2vAOev+nlGzVHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210378; c=relaxed/simple;
	bh=HY8vF2n7tvbgMTBgJVpq9KTyol677Hyla3OJH21V4GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYTScgztoV7a/NEztLWjeQD/CBZQH3oVLQyXOHulSuoLB2ZUCDGZZkBI897pIUbINszS5RT+eaZnuEYIvTqnd23Lk5Iwp+/gWxomuDPdzJ4aZR8vhC58Kof2/bipE/vkrb4dQhaIKWwbLFLfQ0FQHsfq3QTeuSkOpRsPPb9ABNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rx91MOAr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rx91MOAr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997F4C4CEC3;
	Sun,  1 Sep 2024 17:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210378;
	bh=HY8vF2n7tvbgMTBgJVpq9KTyol677Hyla3OJH21V4GQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rx91MOArpIq95rPN+jqGNq7SRlDJUgefK+pq00isvsCkNrml4mb6C6r8q0gH0GoOH
	 nz60haSXMxV7XpBZfGk7vocjvJz4bQwjzL7rjADg0QoBme7rhrqClrDQRd8T10u+Bb
	 6M+t/I3DKp2/BhytB69esBqE6bKwqvQQ5Uh4l7UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 140/215] bonding: fix null pointer deref in bond_ipsec_offload_ok
Date: Sun,  1 Sep 2024 18:17:32 +0200
Message-ID: <20240901160828.658624379@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 61ff4bb22e647..177c90e9a4685 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -597,6 +597,8 @@ static bool bond_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *xs)
 	bond = netdev_priv(bond_dev);
 	rcu_read_lock();
 	curr_active = rcu_dereference(bond->curr_active_slave);
+	if (!curr_active)
+		goto out;
 	real_dev = curr_active->dev;
 
 	if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP)
-- 
2.43.0



