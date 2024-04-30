Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494387464;
	Tue, 30 Apr 2024 10:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474716; cv=none; b=kExyGcPuKr1rfebb55j99ahHz0eUb6HuL9gRBIRciRUlvr9j9pcrOvzU7KfuyMdS8EQFMVvVFbXQYAbqAiiBbdqZnimmeYMCKyWzvW5PMOfmvJAfGjPPKhUTn1Ev5JTDs37lpd0VORl0sKPBsXo+FFPKzW2MzdySe665oRU11KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474716; c=relaxed/simple;
	bh=y+0CakNk45QuvNGH/5HYSPWkt/Sr42nuJ+z825LhVCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TzXnzqcRqBGRaHtgDjGHtatnhCnjwL+RJyAF24N/h5qIeK6pK6eGWnl2rcFTsd3+5Ncy2jcGPXLvdtI1TZ+mtxG0VVZzgdKjjKzv3qiut/wgjlbjmicURKp+rf3HFM4KcGW7+7zxq6TDoc6IBX3CVe0ixtNqlRBAqWfrlpJHfqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lb0Z0NM4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lb0Z0NM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BE1C2BBFC;
	Tue, 30 Apr 2024 10:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474716;
	bh=y+0CakNk45QuvNGH/5HYSPWkt/Sr42nuJ+z825LhVCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lb0Z0NM4jh0HX+FV97AuyICvwkuY8/QOTEVrA5n2piQzomka7cKEatM9opCkZMh9C
	 GZRoRNfOF2dw7x9yA4P7iOAruYYO4ZgpK2EF+2Li/9+SWz7MikEJVP5hSQsrY2UnYT
	 ltPP9TUO3KXJb65qWKVnqmeP3EKcrvyHC3obkaqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/138] netfilter: complete validation of user input
Date: Tue, 30 Apr 2024 12:38:19 +0200
Message-ID: <20240430103049.845645451@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 65acf6e0501ac8880a4f73980d01b5d27648b956 ]

In my recent commit, I missed that do_replace() handlers
use copy_from_sockptr() (which I fixed), followed
by unsafe copy_from_sockptr_offset() calls.

In all functions, we can perform the @optlen validation
before even calling xt_alloc_table_info() with the following
check:

if ((u64)optlen < (u64)tmp.size + sizeof(tmp))
        return -EINVAL;

Fixes: 0c83842df40f ("netfilter: validate user input for expected length")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
Link: https://lore.kernel.org/r/20240409120741.3538135-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/arp_tables.c | 4 ++++
 net/ipv4/netfilter/ip_tables.c  | 4 ++++
 net/ipv6/netfilter/ip6_tables.c | 4 ++++
 3 files changed, 12 insertions(+)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 48c6aa3d91ae8..5823e89b8a734 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -965,6 +965,8 @@ static int do_replace(struct net *net, sockptr_t arg, unsigned int len)
 		return -ENOMEM;
 	if (tmp.num_counters == 0)
 		return -EINVAL;
+	if ((u64)len < (u64)tmp.size + sizeof(tmp))
+		return -EINVAL;
 
 	tmp.name[sizeof(tmp.name)-1] = 0;
 
@@ -1265,6 +1267,8 @@ static int compat_do_replace(struct net *net, sockptr_t arg, unsigned int len)
 		return -ENOMEM;
 	if (tmp.num_counters == 0)
 		return -EINVAL;
+	if ((u64)len < (u64)tmp.size + sizeof(tmp))
+		return -EINVAL;
 
 	tmp.name[sizeof(tmp.name)-1] = 0;
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index b46d58b9f3fe4..22e9ff592cd75 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1119,6 +1119,8 @@ do_replace(struct net *net, sockptr_t arg, unsigned int len)
 		return -ENOMEM;
 	if (tmp.num_counters == 0)
 		return -EINVAL;
+	if ((u64)len < (u64)tmp.size + sizeof(tmp))
+		return -EINVAL;
 
 	tmp.name[sizeof(tmp.name)-1] = 0;
 
@@ -1505,6 +1507,8 @@ compat_do_replace(struct net *net, sockptr_t arg, unsigned int len)
 		return -ENOMEM;
 	if (tmp.num_counters == 0)
 		return -EINVAL;
+	if ((u64)len < (u64)tmp.size + sizeof(tmp))
+		return -EINVAL;
 
 	tmp.name[sizeof(tmp.name)-1] = 0;
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index d013395be05fc..df7cd3d285e4f 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1137,6 +1137,8 @@ do_replace(struct net *net, sockptr_t arg, unsigned int len)
 		return -ENOMEM;
 	if (tmp.num_counters == 0)
 		return -EINVAL;
+	if ((u64)len < (u64)tmp.size + sizeof(tmp))
+		return -EINVAL;
 
 	tmp.name[sizeof(tmp.name)-1] = 0;
 
@@ -1515,6 +1517,8 @@ compat_do_replace(struct net *net, sockptr_t arg, unsigned int len)
 		return -ENOMEM;
 	if (tmp.num_counters == 0)
 		return -EINVAL;
+	if ((u64)len < (u64)tmp.size + sizeof(tmp))
+		return -EINVAL;
 
 	tmp.name[sizeof(tmp.name)-1] = 0;
 
-- 
2.43.0



