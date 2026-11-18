Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032976;
	b=d+PfyAc3C8AAKX1QyxO+vUr+GzvpJklFCxF9KBWA9dxCuDYaMJBF3Ix4QQQ0vqOZBEis
	 Pp47CgwcI6TwOx2obJWUUePdoL+Qw1OwYI6gubpMfvaLbAJzGre8IGxwpvO0ATS4bmTGq
	 jCbq9dYsWcKryJe+U8I0hHQol0+qXfgRcRw2JmSmBW0MR9761YqdvpjVzCZa5+ULrUX/n
	 IWRX/sqwqfpO0m3tptoL60Wx877+tn2+VrAzyOQtEtzfgba4WfOO+zIC4yMN/JeeqJtmD
	 C3y1rSx57rdYIo9tzD4sVnT0N0UmNMXL4CcdHBhTcOSthRWANKpAtO1sq4Jq7fxuN7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=paq3caMLswffa2KVtRgwd/TUzY+wy7fQU1j6iSu6ja4=;
	b=0Su8Qn/eoTFw35tmu0eo4T8JssBgSNXO1jeLAkdG+5BPeY5YEqqNepVpYQAfZeWW02rA
	 d2Jy97QugVq/Ar0Vi4wq9mgeJCPkCMjjwqlbE4ryps1iD6kGL4sU6y8I9uGaMUdyQ0ZLg
	 Fm4VWCc14IdYoTSXNIWSndsyQtfO7YtJrox1F0aPugsDJ11e2+lwknCReI9BGLuzntssX
	 bwrTX2KJRZLeGNHiWyQC9wqFP1mC23CfR51qM5+ia2qu8tG8ynsnxdGkJlBEdNxmI6A30
	 ZqfbaNILNxDnzfp+RySJi0VKwU3SdIX1E5HZhD5xlH8FKkBua52bYAJu+rGLBDux+6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ivIpAC79;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743E0606A31C;
	Wed, 18 Nov 2026 20:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ivIpAC79
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9881F000C4;
	Wed, 18 Nov 2026 20:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032976;
	bh=paq3caMLswffa2KVtRgwd/TUzY+wy7fQU1j6iSu6ja4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ivIpAC79Xt2AMdEw8uwMUSJLa2J7PZ6YhX3Cf5z7WWI4jqZqksXIhwJAz08guh1hl
	 Y4jVONEV3ZwKlHf6eRzuVYNC8GFDPfWvfV/XEFwPpeb2PJnK7PlL4cxSjxabhob+R4
	 H6ul27tRwGRohJXtyCXtLWOzb2DVEPT5cLDbpHQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1562/1756] netlink: fix out-of-bounds bitmap access clearing stale mc groups
Date: Wed, 18 Nov 2026 16:01:29 +0100
Message-ID: <20261118150111.650615221@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7e1c087a98647..fb84eaa63d0ac 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2135,8 +2135,12 @@ void __netlink_clear_multicast_users(struct sock *ksk, unsigned int group)
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



