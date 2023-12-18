Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4594FF94;
	Mon, 18 Dec 2023 14:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2kMa9MdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B2CC433C7;
	Mon, 18 Dec 2023 14:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908010;
	bh=FLoKPZz+YHlpNg7eri2OZjVhqb3/dnJ2RskbMRnk0x4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2kMa9MdXTs8B5aB6l8Pmta8xHT7mkIJ6YTPIWITxjPkPie3szuyzRZG9qw0Hlx2kJ
	 xYeKmyMznDGLEg0Qn2hft0EOHDuIKGQH7/JdGjO9BE/NyqH0RAXtfEWnQ9oC+Awl/Y
	 lquzYJHozQbnpBuYhySqTA/sCbHQBwtHLK/f1S6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Lorenzo Colitti <lorenzo@google.com>,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/166] net: ipv6: support reporting otherwise unknown prefix flags in RTM_NEWPREFIX
Date: Mon, 18 Dec 2023 14:49:46 +0100
Message-ID: <20231218135105.840712260@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Żenczykowski <maze@google.com>

[ Upstream commit bd4a816752bab609dd6d65ae021387beb9e2ddbd ]

Lorenzo points out that we effectively clear all unknown
flags from PIO when copying them to userspace in the netlink
RTM_NEWPREFIX notification.

We could fix this one at a time as new flags are defined,
or in one fell swoop - I choose the latter.

We could either define 6 new reserved flags (reserved1..6) and handle
them individually (and rename them as new flags are defined), or we
could simply copy the entire unmodified byte over - I choose the latter.

This unfortunately requires some anonymous union/struct magic,
so we add a static assert on the struct size for a little extra safety.

Cc: David Ahern <dsahern@kernel.org>
Cc: Lorenzo Colitti <lorenzo@google.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/addrconf.h | 12 ++++++++++--
 include/net/if_inet6.h |  4 ----
 net/ipv6/addrconf.c    |  6 +-----
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index 82da55101b5a3..61ebe723ee4d5 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -31,17 +31,22 @@ struct prefix_info {
 	__u8			length;
 	__u8			prefix_len;
 
+	union __packed {
+		__u8		flags;
+		struct __packed {
 #if defined(__BIG_ENDIAN_BITFIELD)
-	__u8			onlink : 1,
+			__u8	onlink : 1,
 			 	autoconf : 1,
 				reserved : 6;
 #elif defined(__LITTLE_ENDIAN_BITFIELD)
-	__u8			reserved : 6,
+			__u8	reserved : 6,
 				autoconf : 1,
 				onlink : 1;
 #else
 #error "Please fix <asm/byteorder.h>"
 #endif
+		};
+	};
 	__be32			valid;
 	__be32			prefered;
 	__be32			reserved2;
@@ -49,6 +54,9 @@ struct prefix_info {
 	struct in6_addr		prefix;
 };
 
+/* rfc4861 4.6.2: IPv6 PIO is 32 bytes in size */
+static_assert(sizeof(struct prefix_info) == 32);
+
 #include <linux/ipv6.h>
 #include <linux/netdevice.h>
 #include <net/if_inet6.h>
diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index c8490729b4aea..31bf475eca762 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -22,10 +22,6 @@
 #define IF_RS_SENT	0x10
 #define IF_READY	0x80000000
 
-/* prefix flags */
-#define IF_PREFIX_ONLINK	0x01
-#define IF_PREFIX_AUTOCONF	0x02
-
 enum {
 	INET6_IFADDR_STATE_PREDAD,
 	INET6_IFADDR_STATE_DAD,
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 0b6ee962c84e2..b007d098ffe2e 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -6137,11 +6137,7 @@ static int inet6_fill_prefix(struct sk_buff *skb, struct inet6_dev *idev,
 	pmsg->prefix_len = pinfo->prefix_len;
 	pmsg->prefix_type = pinfo->type;
 	pmsg->prefix_pad3 = 0;
-	pmsg->prefix_flags = 0;
-	if (pinfo->onlink)
-		pmsg->prefix_flags |= IF_PREFIX_ONLINK;
-	if (pinfo->autoconf)
-		pmsg->prefix_flags |= IF_PREFIX_AUTOCONF;
+	pmsg->prefix_flags = pinfo->flags;
 
 	if (nla_put(skb, PREFIX_ADDRESS, sizeof(pinfo->prefix), &pinfo->prefix))
 		goto nla_put_failure;
-- 
2.43.0



