Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021847;
	b=jTfVyRxoRzRX2oeOwbRVqaQoXRdsKweu4SmWLHUQc0w5ZYFlh5wvNHqNZhtW/jJHsbj8
	 9W6H+ia4ZDogLOPYRYEGJzWVmo6SwWYg6sUf1EgiAVzJpM2RKDE6j30Gl3qanQQnqyuSz
	 GjFYStiTPp53D8lyojRM6sqJasHCm5iu5BNwk3d+EuQVJCkLeLsIjPE7XqiadbQA2u1st
	 rsLsonWd9v2QEXFkmOYpIqrjB2dBbNL2ZViG0KbAC0ivrgOR1M4t9612ZOVSDHQSmxtkD
	 LaEBecbICSZ3anGsL6qwzvycGHE64Z4vOsLYOHUjgPwkUJ2eeKRbss/7MDZvp1Kbgyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021847;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VvvJ6nc7wG5gpfxZ0/Vo/+H9I90r9YIzG5D/k4k7WmQ=;
	b=PnsUt8ZqQEbfFpVv4v5KKHe6fk6frcDmDlP40rTCMAOxn+8vSKE8/25SeVLB0c3UFCLV
	 5IkoITWht7eaRfZD5DOLmU0vNJ6lzmvIbICpjc1aiP5W2OH5tajHRebG9xoXww3PrKXyS
	 TIdk+VLaZrn7d6sGZsXgd3IhBnNVhEE59WHUyv+8PCrCjct6wZTTu/2UpanPUC4wIPZ8L
	 QNh+J4ZKCS/ovvbCk7j8PEBm98W30C7GfKn0VDQrVM0FvhfRg28HgA9l6hqdP021OGfuB
	 NPEzK4nrtwDhXscd5Pctzvg/MkiigHk+cWErC3smEdTs2L1/2tUKBpv/Rn4Ns2U2xOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yISoWuyi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549DE606A31C;
	Wed, 18 Nov 2026 17:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yISoWuyi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43511F000C4;
	Wed, 18 Nov 2026 17:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021847;
	bh=VvvJ6nc7wG5gpfxZ0/Vo/+H9I90r9YIzG5D/k4k7WmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yISoWuyijMihLoZ5Cx+iJU6SYU0MqV78ltrijGvtpDp7h2TIIACmDXSmaV922bWSK
	 M5c2F9lCIQaxcv/7Nj68lvd7dfIHzdpFWwVvLmm+zlBOnE8UWJ17G+76d/Wae43x2h
	 lryIBT1Gf/DRCdqgItSGfWYoyVN5wHyoYRzyRNdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2411/2651] netlink: fix out-of-bounds bitmap access clearing stale mc groups
Date: Wed, 18 Nov 2026 16:00:51 +0100
Message-ID: <20261118150412.100699852@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 3029894edad11..aecd0332b90fd 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2160,8 +2160,12 @@ void __netlink_clear_multicast_users(struct sock *ksk, unsigned int group)
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



