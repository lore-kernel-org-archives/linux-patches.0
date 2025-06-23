Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533631ACEDA;
	Mon, 23 Jun 2025 21:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713153; cv=none; b=o+8wzqBGBL+dRAbFzO82l4YlzHXLEms+0XS8dqITd6oh5Gt+wEbR4E/hbordhGZ4fztCGHazl8TabGlNAx+Yhpizt9D/4VjXq0uOXdsCJ7cDpg4PGGobK0h5hlhJAK8Lbs6xd+5RFziD7zehEKIwCHAIUVcC5de1T2pwiuhuIow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713153; c=relaxed/simple;
	bh=7Cq9gvQhukfLFmuO6VXj3xXZvm8r58Az7BjGQWfSnW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IGGlaDSOmSJHhLPZBV1Acaq/4ogsB4OxrrEuvT3jiJDGu/KS2hyF18JEdmksq16CyqfJtmkmuVp5tGZUQHeH5TvBC4RiKSYA7u0+4VWmIG+4RXzTXzQbjfQY/sXsX5Sz5puwzvo0zDV0wgegpcIJ9vvOpJyN4KkZwSoTgxhZBkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ddC9zE1/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ddC9zE1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3890C4CEEA;
	Mon, 23 Jun 2025 21:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713153;
	bh=7Cq9gvQhukfLFmuO6VXj3xXZvm8r58Az7BjGQWfSnW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ddC9zE1/3N/ZzdlM1NPQMSJRN3yJutc3I9XZVLRBgYbjPaUs2+RF6BHWkGdtMIkAz
	 GCDzHinbFH8DDky2oDj9Rb7MajVzBVTyPN8C3H0+J2jhjMT3URNnjvQbfJQfM927dI
	 i4bCR4CHqzG9peYTzyTI4PpFG5BfvZMUB/fC+tFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 127/411] seg6: Fix validation of nexthop addresses
Date: Mon, 23 Jun 2025 15:04:31 +0200
Message-ID: <20250623130636.763127420@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 7632fedb266d93ed0ed9f487133e6c6314a9b2d1 ]

The kernel currently validates that the length of the provided nexthop
address does not exceed the specified length. This can lead to the
kernel reading uninitialized memory if user space provided a shorter
length than the specified one.

Fix by validating that the provided length exactly matches the specified
one.

Fixes: d1df6fd8a1d2 ("ipv6: sr: define core operations for seg6local lightweight tunnel")
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250604113252.371528-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6_local.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 0b64cf5b0f267..98af48b3fcce6 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -1123,10 +1123,8 @@ static const struct nla_policy seg6_local_policy[SEG6_LOCAL_MAX + 1] = {
 	[SEG6_LOCAL_SRH]	= { .type = NLA_BINARY },
 	[SEG6_LOCAL_TABLE]	= { .type = NLA_U32 },
 	[SEG6_LOCAL_VRFTABLE]	= { .type = NLA_U32 },
-	[SEG6_LOCAL_NH4]	= { .type = NLA_BINARY,
-				    .len = sizeof(struct in_addr) },
-	[SEG6_LOCAL_NH6]	= { .type = NLA_BINARY,
-				    .len = sizeof(struct in6_addr) },
+	[SEG6_LOCAL_NH4]	= NLA_POLICY_EXACT_LEN(sizeof(struct in_addr)),
+	[SEG6_LOCAL_NH6]	= NLA_POLICY_EXACT_LEN(sizeof(struct in6_addr)),
 	[SEG6_LOCAL_IIF]	= { .type = NLA_U32 },
 	[SEG6_LOCAL_OIF]	= { .type = NLA_U32 },
 	[SEG6_LOCAL_BPF]	= { .type = NLA_NESTED },
-- 
2.39.5



