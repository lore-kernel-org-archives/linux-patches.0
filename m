Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050490;
	b=Ze1puyLEGQxSVFMlPaMPh9QiyMnNZk/SluLGXFMT6XTJAxvCCrUZsZkH2BPGyo50HJF5
	 K5KYNlFx1kbFICKnGIinB/Uw5ByShgQVmf8IRA4nQcllJ+HJXTrdFqKZzSEaavCKapask
	 thYZzKue6lujG7cNqibu1Ggb1JTY+hPb4m/GadLIAy35gQIa9A9RZZCeg0gp84Et4XYrJ
	 ItorE9ImZ4cjMPMY+PdtyINP+BT8SW3RTlwXOlTI7LROQHyToXTZgokCAZbbY7TI6YbGJ
	 eEuuS+KyRHI57/m9qomsVmNoG5+uzjSgn/hQYUoWoUO3uHiMv22CiuuBpds0GFXlTgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050490;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FaZe5dCG6VwU2pd1ZCGIwz7+/VNZ/COPYY15ssEV7wY=;
	b=TrS62vojLPdDhwGBIYlxW3kxfR1uG/Ae5vgJ427ahbSFApzHiSy18G6bmzjNhlOiniQD
	 LKdmxuBspykv1gH/rOr1SAe7biag8mKsf9qpJf5KjxnrZJSq443Ok0wIa6M93ZmMsY6uW
	 smYGpGdLyJGr0hbUZv94UH3uyup/ezG7ZEhGWIkBBlj4GjepYGekapfj80BWHFFaFfScr
	 KBHjZ70cJaxwalP9aGM92/b28QiiYsGno2PW4Sr/DFNAv5zLi/JQ6K1pHnsbcNvDrjNLy
	 wl85Q5UA15P3tVKBanbh6yNhFmqUxmLEY5F7UzYzCnnjpbIj2NKMHRH1S25RltGRmhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NiX5eSvT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AE4606A31C;
	Thu, 19 Nov 2026 01:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NiX5eSvT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542111F000C4;
	Thu, 19 Nov 2026 01:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050489;
	bh=FaZe5dCG6VwU2pd1ZCGIwz7+/VNZ/COPYY15ssEV7wY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NiX5eSvTvVJSG92a34xcIL7HeH+DmNKRfZOUcCmzM1dIyC7GwYqTmJKMOaEfYZ/Fz
	 4EIYLCt5yPwV1C21GdYEsi8ThlaPQ5f1/E92pazI4wPNYGPZxFLrSGpR66SD/k/quN
	 CXN0gAB3iFCfKeuMhlPHQqMygSSTqDwnltMSseYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2727/2857] netlink: fix out-of-bounds bitmap access clearing stale mc groups
Date: Wed, 18 Nov 2026 16:02:41 +0100
Message-ID: <20261118150339.810815836@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit 6430fb7f1cc4e329e386521b7b208df443de92f2 ]

netlink_realloc_groups() sizes nlk->groups to the number of groups
that exist at bind/ADD_MEMBERSHIP time.  When more multicast groups
are registered later (e.g. a new genl family), existing sockets keep
their smaller bitmap.

When clearing a multicast group of a departing family,
__netlink_clear_multicast_users() runs netlink_update_socket_mc() on
each socket on mc_list, which does test_bit()/__assign_bit() on
group - 1 with no regard to nlk->ngroups.  Skip sockets whose bitmap
predates the group: such a socket can never have joined it.

The overflow windows differ per architecture, both needing privileged
module (un)loading.  On 32-bit kernels the ~54 dynamically allocated
genl groups already exceed the initial 32-bit bitmap, so the table
can grow there directly.  On 64-bit kernels the same in-tree set fits
the initial 64-bit bitmap only while allocation stays contiguous:
genl_allocate_reserve_groups() takes the first free contiguous range
and unregister does not compact, so an unload/reload sequence can
fragment the ~59 free IDs until no fitting range remains, forcing
the table past 64 bits and reaching the same stale-bitmap overflow on
the next family teardown.

This issue was discovered by Tencent CodeBuddy Security.

Fixes: 84659eb529b3 ("[NETLIKN]: Allow removing multicast groups.")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 81f4494ed67e2..b755faefdfec6 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2117,8 +2117,12 @@ void __netlink_clear_multicast_users(struct sock *ksk, unsigned int group)
 	struct netlink_table *tbl = &nl_table[ksk->sk_protocol];
 	struct hlist_node *tmp;
 
-	sk_for_each_bound_safe(sk, tmp, &tbl->mc_list)
+	sk_for_each_bound_safe(sk, tmp, &tbl->mc_list) {
+		/* bitmap predates the group, can't be a member */
+		if (group - 1 >= nlk_sk(sk)->ngroups)
+			continue;
 		netlink_update_socket_mc(nlk_sk(sk), group, 0);
+	}
 }
 
 struct nlmsghdr *
-- 
2.53.0



