Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFBF2E92BA;
	Thu, 28 May 2026 20:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001429; cv=none; b=NG1tXvHhJq9O0aHMKJOri/ewsabnvSYsq/3tJKPg10q5LHIhfi/kqza8wvyMoKeZ4/av9DuHFppa0wFSGO7331zHE7YQPsAq9uf19uckIMNSjSqmHHcM5YWJilLFVhjGTNO+FBAE+JYPE2Uug69mFvkmO1yxTt7+Y102nWhFFGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001429; c=relaxed/simple;
	bh=5pmkrRdjzOd2Hj1nstTeFRq9+aan0Ho/9/Ix2QfolWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlyvtApm8hAkoKrSg89KhhWusjyNh7wKyY2jjgxPYbXeemNVaAbjbOF1GqyMjVNgwYyqcnOrAVIWPsEPGKajKE7FKHv7ZTAyJxkiDibgfuzR1hZJbNSdSuGvvk8xloCHgRhi7OcAXLaoOuuzPVnkBjH7RpN35WcPvINGsXN2v08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hghF3olM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hghF3olM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493A31F000E9;
	Thu, 28 May 2026 20:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001428;
	bh=mATd0+p7i+IF6ztpYl/HXy+ZOeKlb01MGcULzNJ/1ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hghF3olMNrI38wJYJoNCNq6KFxA7xgZPPf3JRAJqUaZVd08ywX1CPAtp65AMEFRZy
	 SS4AmSWD7HtOKMKfEhaSN9toqB1FcDqDdgDVBntwO7d/kZVdXBu5FZlvoiJfIkzwN1
	 tSTkF25FInGEKLobyfK/6GGN1EW+gWIxSKdYSaQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 107/186] netfilter: arptables: allow xtables-nft only builds
Date: Thu, 28 May 2026 21:49:47 +0200
Message-ID: <20260528194931.826741634@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f71a7e9a7de6d..070475392236f 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -309,36 +309,34 @@ endif # IP_NF_IPTABLES
 
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



