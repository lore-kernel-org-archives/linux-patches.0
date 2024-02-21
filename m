Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE51878B7C;
	Wed, 21 Feb 2024 14:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525557; cv=none; b=Am1yaGN3thE9wgeN0u0aa5fg4Wfcww5d5lNJcE9TRM2iXbbdZvL/fVcBtQQVzooaqiHhcRti2dsu1G9sqrwXLJUB5rQmOK4O4fEXjLFfCmCly0Yc3d69kMAh+iN0ZYWVTHwzuQYxkcJgVkaSDJL1KTRy1YuHpO2IhOXG9YRCSIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525557; c=relaxed/simple;
	bh=lVw2ift45b0EW3IVIoo93rgF2AMcOJWjJ6Sinf/62QM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mq8oj6XuhIO4y1ddZmU43Lul8M/8YbJC7BSPVMH2frA252+jMsUwGxOS1MV8le41GgxS/GS9ad82WLHWHa98fQ6l1C/Ej8aoJ3HdStANm/IvPuCH1UYlbTgvbXVnVJ/BB9b/c2wBfzkZYq0PUscOdWxM8WtO/aHo66A5dxNqOjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sL6TNTsf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sL6TNTsf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2B7C43390;
	Wed, 21 Feb 2024 14:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525556;
	bh=lVw2ift45b0EW3IVIoo93rgF2AMcOJWjJ6Sinf/62QM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sL6TNTsfSkDDx4wRwQkjPl8SDopndb1Xnv5v6OeL1HYUISDgPH0rCQs9XJEaU0cCs
	 v0yEsEEwjtH8/i5Ys1rPX0Kuf6fREjVkW4s6FC48sz+y3AnVm7mAbNu2XfyaGMMAvo
	 VRIai5EMlrmBZP/ywRlGThztm0013PdoVZvUN5h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 165/267] ipv6: Ensure natural alignment of const ipv6 loopback and router addresses
Date: Wed, 21 Feb 2024 14:08:26 +0100
Message-ID: <20240221125945.290794393@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@kernel.org>

[ Upstream commit 60365049ccbacd101654a66ddcb299abfabd4fc5 ]

On a parisc64 kernel I sometimes notice this kernel warning:
Kernel unaligned access to 0x40ff8814 at ndisc_send_skb+0xc0/0x4d8

The address 0x40ff8814 points to the in6addr_linklocal_allrouters
variable and the warning simply means that some ipv6 function tries to
read a 64-bit word directly from the not-64-bit aligned
in6addr_linklocal_allrouters variable.

Unaligned accesses are non-critical as the architecture or exception
handlers usually will fix it up at runtime. Nevertheless it may trigger
a performance penality for some architectures. For details read the
"unaligned-memory-access" kernel documentation.

The patch below ensures that the ipv6 loopback and router addresses will
always be naturally aligned. This prevents the unaligned accesses for
all architectures.

Signed-off-by: Helge Deller <deller@gmx.de>
Fixes: 034dfc5df99eb ("ipv6: export in6addr_loopback to modules")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/ZbNuFM1bFqoH-UoY@p100
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf_core.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/addrconf_core.c b/net/ipv6/addrconf_core.c
index ea00ce3d4117..8494ee9679b4 100644
--- a/net/ipv6/addrconf_core.c
+++ b/net/ipv6/addrconf_core.c
@@ -204,19 +204,26 @@ const struct ipv6_stub *ipv6_stub __read_mostly = &(struct ipv6_stub) {
 EXPORT_SYMBOL_GPL(ipv6_stub);
 
 /* IPv6 Wildcard Address and Loopback Address defined by RFC2553 */
-const struct in6_addr in6addr_loopback = IN6ADDR_LOOPBACK_INIT;
+const struct in6_addr in6addr_loopback __aligned(BITS_PER_LONG/8)
+	= IN6ADDR_LOOPBACK_INIT;
 EXPORT_SYMBOL(in6addr_loopback);
-const struct in6_addr in6addr_any = IN6ADDR_ANY_INIT;
+const struct in6_addr in6addr_any __aligned(BITS_PER_LONG/8)
+	= IN6ADDR_ANY_INIT;
 EXPORT_SYMBOL(in6addr_any);
-const struct in6_addr in6addr_linklocal_allnodes = IN6ADDR_LINKLOCAL_ALLNODES_INIT;
+const struct in6_addr in6addr_linklocal_allnodes __aligned(BITS_PER_LONG/8)
+	= IN6ADDR_LINKLOCAL_ALLNODES_INIT;
 EXPORT_SYMBOL(in6addr_linklocal_allnodes);
-const struct in6_addr in6addr_linklocal_allrouters = IN6ADDR_LINKLOCAL_ALLROUTERS_INIT;
+const struct in6_addr in6addr_linklocal_allrouters __aligned(BITS_PER_LONG/8)
+	= IN6ADDR_LINKLOCAL_ALLROUTERS_INIT;
 EXPORT_SYMBOL(in6addr_linklocal_allrouters);
-const struct in6_addr in6addr_interfacelocal_allnodes = IN6ADDR_INTERFACELOCAL_ALLNODES_INIT;
+const struct in6_addr in6addr_interfacelocal_allnodes __aligned(BITS_PER_LONG/8)
+	= IN6ADDR_INTERFACELOCAL_ALLNODES_INIT;
 EXPORT_SYMBOL(in6addr_interfacelocal_allnodes);
-const struct in6_addr in6addr_interfacelocal_allrouters = IN6ADDR_INTERFACELOCAL_ALLROUTERS_INIT;
+const struct in6_addr in6addr_interfacelocal_allrouters __aligned(BITS_PER_LONG/8)
+	= IN6ADDR_INTERFACELOCAL_ALLROUTERS_INIT;
 EXPORT_SYMBOL(in6addr_interfacelocal_allrouters);
-const struct in6_addr in6addr_sitelocal_allrouters = IN6ADDR_SITELOCAL_ALLROUTERS_INIT;
+const struct in6_addr in6addr_sitelocal_allrouters __aligned(BITS_PER_LONG/8)
+	= IN6ADDR_SITELOCAL_ALLROUTERS_INIT;
 EXPORT_SYMBOL(in6addr_sitelocal_allrouters);
 
 static void snmp6_free_dev(struct inet6_dev *idev)
-- 
2.43.0



