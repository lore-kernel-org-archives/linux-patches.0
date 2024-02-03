Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4C4FC03;
	Sat,  3 Feb 2024 04:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933461; cv=none; b=WmVxmkjMjgZkcfUQO5kx5uMMxcHrLkvJxc5v4CDpcTp02tYZlnkDUc3mt7D8KV+hJwVHiu36dGtj3jcY2W5Foo6YUssjF9/42bA4RB/zb6KYHqKKlR9x0IALlS6+8d/Uaj+kpMFv716CA6+UZgmMT0A10KsJT5yDbEhKC++Y8Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933461; c=relaxed/simple;
	bh=f0Pypo2ZzZ9GIpGI4JUAbF2ejkjJ/FWHSHUmTDyY81E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kI8pCtOkqrN2ZjK62RiXr7z9gXcP1HyIGOG67mieSeUDUXFo3gF+CekzTEsY+9G0x31DSnfGdlsv6cTSj5ufLY+ZBINiO7CcWeWwASdvJ0YYugmQ9P33QKniBbW01+Gz83dcNOQ9FMoD3nrILBUrgwIe1Yeful1fe6Xl16qfUkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LJD/ghSW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LJD/ghSW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94178C433C7;
	Sat,  3 Feb 2024 04:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933461;
	bh=f0Pypo2ZzZ9GIpGI4JUAbF2ejkjJ/FWHSHUmTDyY81E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LJD/ghSWhOU3eJZBP6sw6KrlQlgeFV+T3tklMo5mA9h0HZtyJRfQuKlQ2dVwFLymn
	 Jxb45gZ2WOToAdg5R1NJX+eTPsNl0Vo7asHouHcoWrvTrdiauuBtn1CrZ0GcmFSBF3
	 AK+CplFVpw8xFjv9LEJEzrMyx7axj4kM9dd2DNSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 199/219] ipv6: Ensure natural alignment of const ipv6 loopback and router addresses
Date: Fri,  2 Feb 2024 20:06:12 -0800
Message-ID: <20240203035345.136648057@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 507a8353a6bd..c008d21925d7 100644
--- a/net/ipv6/addrconf_core.c
+++ b/net/ipv6/addrconf_core.c
@@ -220,19 +220,26 @@ const struct ipv6_stub *ipv6_stub __read_mostly = &(struct ipv6_stub) {
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



