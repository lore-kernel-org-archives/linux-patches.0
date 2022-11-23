Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E831C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD37AC433D7;
	Wed, 23 Nov 2022 09:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195688;
	bh=4wo/w9JKvQ1JwILnmjIRqQEkvwcUj/vMy/ZQWq6SqMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VzpFGmP0vd2saPgi+9OFCionjTOf8VoDpHlv9GaTHvvZ1OJUK6c1uyf4u/bWWFVig
	 QAvL2/r83xwtu4KGTASQ9AiTSaRkcI2qu1QP9XTyLzu7LBih6pZfVREbTR8UmR8n2A
	 VNjadyx2U0RZ+Mi7v9PZmxO8bu6fpsqEiHE5LQio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 132/149] net: use struct_group to copy ip/ipv6 header addresses
Date: Wed, 23 Nov 2022 09:51:55 +0100
Message-Id: <20221123084602.677943392@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 58e0be1ef6118c5352b56a4d06e974c5599993a5 ]

kernel test robot reported warnings when build bonding module with
make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/bonding/:

                 from ../drivers/net/bonding/bond_main.c:35:
In function ‘fortify_memcpy_chk’,
    inlined from ‘iph_to_flow_copy_v4addrs’ at ../include/net/ip.h:566:2,
    inlined from ‘bond_flow_ip’ at ../drivers/net/bonding/bond_main.c:3984:3:
../include/linux/fortify-string.h:413:25: warning: call to ‘__read_overflow2_field’ declared with attribute warning: detected read beyond size of f
ield (2nd parameter); maybe use struct_group()? [-Wattribute-warning]
  413 |                         __read_overflow2_field(q_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In function ‘fortify_memcpy_chk’,
    inlined from ‘iph_to_flow_copy_v6addrs’ at ../include/net/ipv6.h:900:2,
    inlined from ‘bond_flow_ip’ at ../drivers/net/bonding/bond_main.c:3994:3:
../include/linux/fortify-string.h:413:25: warning: call to ‘__read_overflow2_field’ declared with attribute warning: detected read beyond size of f
ield (2nd parameter); maybe use struct_group()? [-Wattribute-warning]
  413 |                         __read_overflow2_field(q_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This is because we try to copy the whole ip/ip6 address to the flow_key,
while we only point the to ip/ip6 saddr. Note that since these are UAPI
headers, __struct_group() is used to avoid the compiler warnings.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: c3f8324188fa ("net: Add full IPv6 addresses to flow_keys")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://lore.kernel.org/r/20221115142400.1204786-1-liuhangbin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip.h          | 2 +-
 include/net/ipv6.h        | 2 +-
 include/uapi/linux/ip.h   | 6 ++++--
 include/uapi/linux/ipv6.h | 6 ++++--
 4 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index c5822d7824cd..4b775af57268 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -545,7 +545,7 @@ static inline void iph_to_flow_copy_v4addrs(struct flow_keys *flow,
 	BUILD_BUG_ON(offsetof(typeof(flow->addrs), v4addrs.dst) !=
 		     offsetof(typeof(flow->addrs), v4addrs.src) +
 			      sizeof(flow->addrs.v4addrs.src));
-	memcpy(&flow->addrs.v4addrs, &iph->saddr, sizeof(flow->addrs.v4addrs));
+	memcpy(&flow->addrs.v4addrs, &iph->addrs, sizeof(flow->addrs.v4addrs));
 	flow->control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
 }
 
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 60601896d474..89ce8a50f236 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -842,7 +842,7 @@ static inline void iph_to_flow_copy_v6addrs(struct flow_keys *flow,
 	BUILD_BUG_ON(offsetof(typeof(flow->addrs), v6addrs.dst) !=
 		     offsetof(typeof(flow->addrs), v6addrs.src) +
 		     sizeof(flow->addrs.v6addrs.src));
-	memcpy(&flow->addrs.v6addrs, &iph->saddr, sizeof(flow->addrs.v6addrs));
+	memcpy(&flow->addrs.v6addrs, &iph->addrs, sizeof(flow->addrs.v6addrs));
 	flow->control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
 }
 
diff --git a/include/uapi/linux/ip.h b/include/uapi/linux/ip.h
index e42d13b55cf3..d2f143393780 100644
--- a/include/uapi/linux/ip.h
+++ b/include/uapi/linux/ip.h
@@ -100,8 +100,10 @@ struct iphdr {
 	__u8	ttl;
 	__u8	protocol;
 	__sum16	check;
-	__be32	saddr;
-	__be32	daddr;
+	__struct_group(/* no tag */, addrs, /* no attrs */,
+		__be32	saddr;
+		__be32	daddr;
+	);
 	/*The options start here. */
 };
 
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index 13e8751bf24a..766ab5c8ee65 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -130,8 +130,10 @@ struct ipv6hdr {
 	__u8			nexthdr;
 	__u8			hop_limit;
 
-	struct	in6_addr	saddr;
-	struct	in6_addr	daddr;
+	__struct_group(/* no tag */, addrs, /* no attrs */,
+		struct	in6_addr	saddr;
+		struct	in6_addr	daddr;
+	);
 };
 
 
-- 
2.35.1



