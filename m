Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F92F1DFD1;
	Sun,  1 Sep 2024 16:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209625; cv=none; b=p7iFRCLrULr65HeSnFhbfge8QsCw9UPZU3S88WjQY3GCXldTuT6Nd+CX+CjZYwcVoKO34cI9rNQ4fr5iSQsEGpEuyyMQKGYrqHKfN4B+iLfmh/CGhB//4I21CpfNBlImOdApe+pQMUpdN4sVddPxRpU7g+5jGuIp+cLaiM8B58A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209625; c=relaxed/simple;
	bh=Rj6NvGoeIyU20J0Re8Kkuzg/l2OVp4lNqtMgiDfb4Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VypMXUfqme749VlSOLsiDazMKOGvsiiQD6b9Ae8WmHyMYWg6fhpaRDAiq+Ak2G2n4Tv+RSe4r7ExN95e6+U3JEo4ORa8Mzs3Ivby3rRZ6VORyqQStkjekb3uO4UaD9MVkREAZMUNwRqiWIfPi7HFQBOim/A0WDLf94w9DI36mro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uv9KahEc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uv9KahEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F450C4CEC3;
	Sun,  1 Sep 2024 16:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209625;
	bh=Rj6NvGoeIyU20J0Re8Kkuzg/l2OVp4lNqtMgiDfb4Fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uv9KahEcU+QKfBRegYCHeIFOIW4aBIq6yeexfIKU/gGtkfiYQ8R0YcPuRKvvuLc4X
	 8dl9ge5jgcOCPv/tMCgBRs86fGO4Suc8ARZOWrcIJu4Z62d1F/+3fpAG1Ii2Y0jp6o
	 Ju/RDAMXvDptXyUZpDnv7ecdIps+ArZrp6P5qdgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 093/151] bonding: fix null pointer deref in bond_ipsec_offload_ok
Date: Sun,  1 Sep 2024 18:17:33 +0200
Message-ID: <20240901160817.614584726@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 349f1c9dd5881..bd74b2d64ad48 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -562,6 +562,8 @@ static bool bond_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *xs)
 	bond = netdev_priv(bond_dev);
 	rcu_read_lock();
 	curr_active = rcu_dereference(bond->curr_active_slave);
+	if (!curr_active)
+		goto out;
 	real_dev = curr_active->dev;
 
 	if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP)
-- 
2.43.0



