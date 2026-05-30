Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF6432F770;
	Sat, 30 May 2026 18:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165037; cv=none; b=X16UyTJfs7q9vsdkSDKpmc1m7YgbehFOGx3g0WhjPqLjw8uZ6oyh84/NUGPB3EE4qY+MnuwLbmgC3udOc0aGM9nXVSDbqHdQtCawOi8rII2W6S5vqdRyyWK/4+rg+n7Y+Uv5lK0bZCmr9bKlxxTjK/aH+fug4rMA8UDuV6Fyr18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165037; c=relaxed/simple;
	bh=IdTQPJ/xSxT6JCttNRSyYUg1XYcagmZ2XZr4+CnYMG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNO4+iyjV6oxZpik60UNpf+DGXht7LN+hbF3VvYKIeNtRm8LbkXqZ8HEAK11t9nQ4MUfx0+lUjO5tszkgHQ9uO69u7ZDIiC1ngU96zfF3mjVqdFrxRN+8sRd/hclCBc81N68sdUAHAyrTCkc+pxNopxjbmuS5tHPuBvwec5wYsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZMfrpgCn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZMfrpgCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11FB1F00893;
	Sat, 30 May 2026 18:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165035;
	bh=fBkIiMMUc3t8+LW5lnbpVDJnywG/9BKeQ19H4cRemNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZMfrpgCn5jrvfdMum9MXC0+RFM+jIJOMNQaqYzcboCWoHW58mqb2XXFgMc/QbMkF1
	 GpoRjZBe8C/21Mqo5BGE2h5m/0AiMGj/dHT/x4DAjPgTqNEWlIoC29VxLedGDs6TJP
	 d/jd+fy3xoNpgfVI9N2CmnfX3xj2YpAu4QcEU8To=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 732/776] netfilter: arptables: allow xtables-nft only builds
Date: Sat, 30 May 2026 18:07:26 +0200
Message-ID: <20260530160258.730105716@linuxfoundation.org>
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

[ Upstream commit 4654467dc7e111e84f43ed1b70322873ae77e7be ]

Allows to build kernel that supports the arptables mangle target
via nftables' compat infra but without the arptables get/setsockopt
interface or the old arptables filter interpreter.

IOW, setting IP_NF_ARPFILTER=n will break arptables-legacy, but
arptables-nft will continue to work as long as nftables compat
support is enabled.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Phil Sutter <phil@nwl.cc>
Stable-dep-of: b4597d5fd7d2 ("netfilter: x_tables: add and use xtables_unregister_table_exit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/Kconfig | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 63cb953bd0196..5c2cdcb19dba3 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -331,36 +331,34 @@ endif # IP_NF_IPTABLES
 
 # ARP tables
 config IP_NF_ARPTABLES
-	tristate "ARP tables support"
-	select NETFILTER_XTABLES
-	select NETFILTER_FAMILY_ARP
-	depends on NETFILTER_ADVANCED
-	help
-	  arptables is a general, extensible packet identification framework.
-	  The ARP packet filtering and mangling (manipulation)subsystems
-	  use this: say Y or M here if you want to use either of those.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
+	tristate
 
-if IP_NF_ARPTABLES
+config NFT_COMPAT_ARP
+	tristate
+	depends on NF_TABLES_ARP && NFT_COMPAT
+	default m if NFT_COMPAT=m
+	default y if NFT_COMPAT=y
 
 config IP_NF_ARPFILTER
-	tristate "ARP packet filtering"
+	tristate "arptables-legacy packet filtering support"
+	select IP_NF_ARPTABLES
 	help
 	  ARP packet filtering defines a table `filter', which has a series of
 	  rules for simple ARP packet filtering at local input and
-	  local output.  On a bridge, you can also specify filtering rules
-	  for forwarded ARP packets. See the man page for arptables(8).
+	  local output.  This is only needed for arptables-legacy(8).
+	  Neither arptables-nft nor nftables need this to work.
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config IP_NF_ARP_MANGLE
 	tristate "ARP payload mangling"
+	depends on IP_NF_ARPTABLES || NFT_COMPAT_ARP
 	help
 	  Allows altering the ARP packet payload: source and destination
 	  hardware and network addresses.
 
-endif # IP_NF_ARPTABLES
+	  This option is needed by both arptables-legacy and arptables-nft.
+	  It is not used by nftables.
 
 endmenu
 
-- 
2.53.0



