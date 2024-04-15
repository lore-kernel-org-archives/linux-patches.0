Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B290381B9;
	Mon, 15 Apr 2024 14:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192163; cv=none; b=Sro57lTCHRz7+pZlEOUwiRA4hf68O5y0xQYLZq1sKDatcYG3ydakkTeclBiB5xT4MZK0vhTDf5xSz8B0+8IyERYWnhYqJjBxfHVIRKbc48d0wdrxFAx4oA5DPKmY6F9R7SI5gZRIAySeNDGKKXWiI2IWiNc0Oj1973ODVbzepOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192163; c=relaxed/simple;
	bh=CU2H4J4ToVfeqU9Bgj/QQf0vsdaAwIFV1xcjjWkwIiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mSO4/3LQTV6T00vRm+L8ugsbItGLIGFzaVKo9O2dY6S5c9Y9vpzomV3T2HcSCE4KDvu2+7L5Ekuylg9OtSt5lk8+jNYvxVjVhxQzwG6h5o9GQ7u01zGX7ii3P35DwZtKNHq2kT0VxtRbW7aqdR5OHkaP5yD9M1EEbzNW00w4OGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JiVHSNEJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JiVHSNEJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D868FC113CC;
	Mon, 15 Apr 2024 14:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192163;
	bh=CU2H4J4ToVfeqU9Bgj/QQf0vsdaAwIFV1xcjjWkwIiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JiVHSNEJI5D+qahzxjl4auMzwjPM/7xokRJM3Vsuqq/Q5EUnr3XvIXyoMsbDCAEMr
	 epaANc7LMY+S+J/c7i/EpXQ5aviG8iJaXWUI2achJ2FPbPHbPuxK0A3/NQCXT/4Rb2
	 wqNEde64/4IdesAOhlkRWovPSHplcwsqb2zwN9cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 18/45] netfilter: complete validation of user input
Date: Mon, 15 Apr 2024 16:21:25 +0200
Message-ID: <20240415141942.792039769@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141942.235939111@linuxfoundation.org>
References: <20240415141942.235939111@linuxfoundation.org>
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
index 07ecb16231cd0..a9d5a1973224a 100644
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
index 1e1e7488d6bf1..aee7cd584c926 100644
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
index b17990d514ee9..afd22ea9f555b 100644
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



