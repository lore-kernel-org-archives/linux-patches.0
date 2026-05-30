Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5026241C8C;
	Sat, 30 May 2026 18:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165040; cv=none; b=LpEp8jFI1NeLTYQokRl6VJKWbdTO7g/a0GubkzddG9MP3f5U882SATo24FftbLJmDgZ85vQaI43VqsuPKv+RELSrEGVtYGALKSR37urravJf6YeoRbhIjIIILDmv83ENql8LZ5Ab7e5Wx2YEQ6X134y/1fPUU/6/nBsyqr7Yz5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165040; c=relaxed/simple;
	bh=5Xj38wFQA4a6tGLbOayqduXR9v4Zusw/sTuxIVWvHrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LB/txn2uEXCqzdQ2tZkLV0d3Q1IXsU3i6LyskfTM3ZwUkKi/cb0UVBtn+m0bNig7i+eqXlZhe0tGh2ktyZ0KjFAaroJmPB35vDuf0/m1AEakH3nTjiQW25E5vqKApGdNSKR6nUtqtdLonmk7QGRQ/PSVUmQGyKSCCUcDFK2cA9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hpdep3oe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hpdep3oe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265101F00893;
	Sat, 30 May 2026 18:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165038;
	bh=JlQIy3+25tnxLfHz0LZ1q6znkLufIiHVc8bkAQM4Qdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hpdep3oeJY32rEuMcTCkbwi3I42TUp7QsZRAFZWideNdzcRbSnL08NgUTdLr88BQ2
	 mj8SHU2sfpJU1smJGVrBYfU5avbXJ8t3lhYLgG+W/qzmGlZ8BUwIZVX41bf59OagKW
	 a/plYB7Jo+513Hl56qasJ1gdgeqBd3VayxJoEkEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 733/776] netfilter: xtables: allow xtables-nft only builds
Date: Sat, 30 May 2026 18:07:27 +0200
Message-ID: <20260530160258.753567988@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit a9525c7f6219cee9284c0031c5930e8d41384677 ]

Add hidden IP(6)_NF_IPTABLES_LEGACY symbol.

When any of the "old" builtin tables are enabled the "old" iptables
interface will be supported.

To disable the old set/getsockopt interface the existing options
for the builtin tables need to be turned off:

CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_FILTER is not set
CONFIG_IP_NF_NAT is not set
CONFIG_IP_NF_MANGLE is not set
CONFIG_IP_NF_RAW is not set
CONFIG_IP_NF_SECURITY is not set

Same for CONFIG_IP6_NF_ variants.

This allows to build a kernel that only supports ip(6)tables-nft
(iptables-over-nftables api).

In the future the _LEGACY symbol will become visible and the select
statements will be turned into 'depends on', but for now be on safe side
so "make oldconfig" won't break things.

Signed-off-by: Florian Westphal <fw@strlen.de>
Stable-dep-of: b4597d5fd7d2 ("netfilter: x_tables: add and use xtables_unregister_table_exit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/Kconfig  | 15 ++++++++++++---
 net/ipv4/netfilter/Makefile |  2 +-
 net/ipv6/netfilter/Kconfig  | 20 ++++++++++++++------
 net/ipv6/netfilter/Makefile |  2 +-
 net/netfilter/Kconfig       | 12 ++++++------
 5 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 5c2cdcb19dba3..7c2b8a652016d 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -10,6 +10,10 @@ config NF_DEFRAG_IPV4
 	tristate
 	default n
 
+# old sockopt interface and eval loop
+config IP_NF_IPTABLES_LEGACY
+	tristate
+
 config NF_SOCKET_IPV4
 	tristate "IPv4 socket lookup support"
 	help
@@ -160,7 +164,7 @@ config IP_NF_MATCH_ECN
 config IP_NF_MATCH_RPFILTER
 	tristate '"rpfilter" reverse path filter match support'
 	depends on NETFILTER_ADVANCED
-	depends on IP_NF_MANGLE || IP_NF_RAW
+	depends on IP_NF_MANGLE || IP_NF_RAW || NFT_COMPAT
 	help
 	  This option allows you to match packets whose replies would
 	  go out via the interface the packet came in.
@@ -181,6 +185,7 @@ config IP_NF_MATCH_TTL
 config IP_NF_FILTER
 	tristate "Packet filtering"
 	default m if NETFILTER_ADVANCED=n
+	select IP_NF_IPTABLES_LEGACY
 	help
 	  Packet filtering defines a table `filter', which has a series of
 	  rules for simple packet filtering at local input, forwarding and
@@ -190,7 +195,7 @@ config IP_NF_FILTER
 
 config IP_NF_TARGET_REJECT
 	tristate "REJECT target support"
-	depends on IP_NF_FILTER
+	depends on IP_NF_FILTER || NFT_COMPAT
 	select NF_REJECT_IPV4
 	default m if NETFILTER_ADVANCED=n
 	help
@@ -220,6 +225,7 @@ config IP_NF_NAT
 	default m if NETFILTER_ADVANCED=n
 	select NF_NAT
 	select NETFILTER_XT_NAT
+	select IP6_NF_IPTABLES_LEGACY
 	help
 	  This enables the `nat' table in iptables. This allows masquerading,
 	  port forwarding and other forms of full Network Address Port
@@ -260,6 +266,7 @@ endif # IP_NF_NAT
 config IP_NF_MANGLE
 	tristate "Packet mangling"
 	default m if NETFILTER_ADVANCED=n
+	select IP_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `mangle' table to iptables: see the man page for
 	  iptables(8).  This table is used for various packet alterations
@@ -283,7 +290,7 @@ config IP_NF_TARGET_CLUSTERIP
 
 config IP_NF_TARGET_ECN
 	tristate "ECN target support"
-	depends on IP_NF_MANGLE
+	depends on IP_NF_MANGLE || NFT_COMPAT
 	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `ECN' target, which can be used in the iptables mangle
@@ -308,6 +315,7 @@ config IP_NF_TARGET_TTL
 # raw + specific targets
 config IP_NF_RAW
 	tristate  'raw table support (required for NOTRACK/TRACE)'
+	select IP_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `raw' table to iptables. This table is the very
 	  first in the netfilter framework and hooks in at the PREROUTING
@@ -321,6 +329,7 @@ config IP_NF_SECURITY
 	tristate "Security table"
 	depends on SECURITY
 	depends on NETFILTER_ADVANCED
+	select IP_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `security' table to iptables, for use
 	  with Mandatory Access Control (MAC) policy.
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index f38fb1368ddb2..d3150ea5b8e57 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -28,7 +28,7 @@ obj-$(CONFIG_NFT_DUP_IPV4) += nft_dup_ipv4.o
 obj-$(CONFIG_NF_FLOW_TABLE_IPV4) += nf_flow_table_ipv4.o
 
 # generic IP tables
-obj-$(CONFIG_IP_NF_IPTABLES) += ip_tables.o
+obj-$(CONFIG_IP_NF_IPTABLES_LEGACY) += ip_tables.o
 
 # the three instances of ip_tables
 obj-$(CONFIG_IP_NF_FILTER) += iptable_filter.o
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index f22233e44ee97..bc51a77fb6c07 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -6,6 +6,10 @@
 menu "IPv6: Netfilter Configuration"
 	depends on INET && IPV6 && NETFILTER
 
+# old sockopt interface and eval loop
+config IP6_NF_IPTABLES_LEGACY
+	tristate
+
 config NF_SOCKET_IPV6
 	tristate "IPv6 socket lookup support"
 	help
@@ -155,7 +159,7 @@ config IP6_NF_MATCH_MH
 config IP6_NF_MATCH_RPFILTER
 	tristate '"rpfilter" reverse path filter match support'
 	depends on NETFILTER_ADVANCED
-	depends on IP6_NF_MANGLE || IP6_NF_RAW
+	depends on IP6_NF_MANGLE || IP6_NF_RAW || NFT_COMPAT
 	help
 	  This option allows you to match packets whose replies would
 	  go out via the interface the packet came in.
@@ -194,6 +198,8 @@ config IP6_NF_TARGET_HL
 config IP6_NF_FILTER
 	tristate "Packet filtering"
 	default m if NETFILTER_ADVANCED=n
+	select IP6_NF_IPTABLES_LEGACY
+	tristate
 	help
 	  Packet filtering defines a table `filter', which has a series of
 	  rules for simple packet filtering at local input, forwarding and
@@ -203,7 +209,7 @@ config IP6_NF_FILTER
 
 config IP6_NF_TARGET_REJECT
 	tristate "REJECT target support"
-	depends on IP6_NF_FILTER
+	depends on IP6_NF_FILTER || NFT_COMPAT
 	select NF_REJECT_IPV6
 	default m if NETFILTER_ADVANCED=n
 	help
@@ -229,6 +235,7 @@ config IP6_NF_TARGET_SYNPROXY
 config IP6_NF_MANGLE
 	tristate "Packet mangling"
 	default m if NETFILTER_ADVANCED=n
+	select IP6_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `mangle' table to iptables: see the man page for
 	  iptables(8).  This table is used for various packet alterations
@@ -238,6 +245,7 @@ config IP6_NF_MANGLE
 
 config IP6_NF_RAW
 	tristate  'raw table support (required for TRACE)'
+	select IP6_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `raw' table to ip6tables. This table is the very
 	  first in the netfilter framework and hooks in at the PREROUTING
@@ -251,6 +259,7 @@ config IP6_NF_SECURITY
 	tristate "Security table"
 	depends on SECURITY
 	depends on NETFILTER_ADVANCED
+	select IP6_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `security' table to iptables, for use
 	  with Mandatory Access Control (MAC) policy.
@@ -262,6 +271,7 @@ config IP6_NF_NAT
 	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
 	select NF_NAT
+	select IP6_NF_IPTABLES_LEGACY
 	select NETFILTER_XT_NAT
 	help
 	  This enables the `nat' table in ip6tables. This allows masquerading,
@@ -270,25 +280,23 @@ config IP6_NF_NAT
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-if IP6_NF_NAT
-
 config IP6_NF_TARGET_MASQUERADE
 	tristate "MASQUERADE target support"
 	select NETFILTER_XT_TARGET_MASQUERADE
+	depends on IP6_NF_NAT
 	help
 	  This is a backwards-compat option for the user's convenience
 	  (e.g. when running oldconfig). It selects NETFILTER_XT_TARGET_MASQUERADE.
 
 config IP6_NF_TARGET_NPT
 	tristate "NPT (Network Prefix translation) target support"
+	depends on IP6_NF_NAT || NFT_COMPAT
 	help
 	  This option adds the `SNPT' and `DNPT' target, which perform
 	  stateless IPv6-to-IPv6 Network Prefix Translation per RFC 6296.
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-endif # IP6_NF_NAT
-
 endif # IP6_NF_IPTABLES
 endmenu
 
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index b85383606df71..7d0a913529891 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -4,7 +4,7 @@
 #
 
 # Link order matters here.
-obj-$(CONFIG_IP6_NF_IPTABLES) += ip6_tables.o
+obj-$(CONFIG_IP6_NF_IPTABLES_LEGACY) += ip6_tables.o
 obj-$(CONFIG_IP6_NF_FILTER) += ip6table_filter.o
 obj-$(CONFIG_IP6_NF_MANGLE) += ip6table_mangle.o
 obj-$(CONFIG_IP6_NF_RAW) += ip6table_raw.o
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index f02ebe4609650..fdfda4b6bff67 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -812,7 +812,7 @@ config NETFILTER_XT_TARGET_AUDIT
 
 config NETFILTER_XT_TARGET_CHECKSUM
 	tristate "CHECKSUM target support"
-	depends on IP_NF_MANGLE || IP6_NF_MANGLE
+	depends on IP_NF_MANGLE || IP6_NF_MANGLE || NFT_COMPAT
 	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `CHECKSUM' target, which can be used in the iptables mangle
@@ -863,7 +863,7 @@ config NETFILTER_XT_TARGET_CONNSECMARK
 config NETFILTER_XT_TARGET_CT
 	tristate '"CT" target support'
 	depends on NF_CONNTRACK
-	depends on IP_NF_RAW || IP6_NF_RAW
+	depends on IP_NF_RAW || IP6_NF_RAW || NFT_COMPAT
 	depends on NETFILTER_ADVANCED
 	help
 	  This options adds a `CT' target, which allows to specify initial
@@ -874,7 +874,7 @@ config NETFILTER_XT_TARGET_CT
 
 config NETFILTER_XT_TARGET_DSCP
 	tristate '"DSCP" and "TOS" target support'
-	depends on IP_NF_MANGLE || IP6_NF_MANGLE
+	depends on IP_NF_MANGLE || IP6_NF_MANGLE || NFT_COMPAT
 	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `DSCP' target, which allows you to manipulate
@@ -890,7 +890,7 @@ config NETFILTER_XT_TARGET_DSCP
 
 config NETFILTER_XT_TARGET_HL
 	tristate '"HL" hoplimit target support'
-	depends on IP_NF_MANGLE || IP6_NF_MANGLE
+	depends on IP_NF_MANGLE || IP6_NF_MANGLE || NFT_COMPAT
 	depends on NETFILTER_ADVANCED
 	help
 	This option adds the "HL" (for IPv6) and "TTL" (for IPv4)
@@ -1074,7 +1074,7 @@ config NETFILTER_XT_TARGET_TPROXY
 	depends on NETFILTER_ADVANCED
 	depends on IPV6 || IPV6=n
 	depends on IP6_NF_IPTABLES || IP6_NF_IPTABLES=n
-	depends on IP_NF_MANGLE
+	depends on IP_NF_MANGLE || NFT_COMPAT
 	select NF_DEFRAG_IPV4
 	select NF_DEFRAG_IPV6 if IP6_NF_IPTABLES != n
 	select NF_TPROXY_IPV4
@@ -1141,7 +1141,7 @@ config NETFILTER_XT_TARGET_TCPMSS
 
 config NETFILTER_XT_TARGET_TCPOPTSTRIP
 	tristate '"TCPOPTSTRIP" target support'
-	depends on IP_NF_MANGLE || IP6_NF_MANGLE
+	depends on IP_NF_MANGLE || IP6_NF_MANGLE || NFT_COMPAT
 	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a "TCPOPTSTRIP" target, which allows you to strip
-- 
2.53.0



