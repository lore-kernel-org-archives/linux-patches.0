Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CB4285059;
	Tue, 17 Jun 2025 16:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179027; cv=none; b=S3pp1FboWDaOUe1BnQjqqgZLmwqf7G5Eryphhy7t+dNWbibnN5YFzcOCTMngmrsAG5sO3yzILdUquyEWzVVg5MPVQF2oXuH4CUmaiOxI3bLyFf8yZzTM3fnunXexCVX1QlvBtSryVejpkxvCvuuXbZLrS8b/br6nkZftkrJ47X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179027; c=relaxed/simple;
	bh=/pZhvcBat39raKEwMyzITJqnYKu9SYyqO3XPsGN33QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OG+2cju5DJr5UhLAcV7cutO08C75eDKoOVwgaNnnABXac2mf4TkVPjpSD3dq+/fJRBstExF0G7nslttk/WrUgcrgST6/bGVVK1PjOddaj4cIUxwweeGAGtJYGSKJIxCUyWWkw+Q72iMs3o0f0OAOBoT8rkOe2TLI/uQ6Hx6Gp4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kGZGOwCf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kGZGOwCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A8DC4CEE3;
	Tue, 17 Jun 2025 16:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179027;
	bh=/pZhvcBat39raKEwMyzITJqnYKu9SYyqO3XPsGN33QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kGZGOwCfpfeAbDWQyZP6d0NUzqws1SZxRvTnr+jDPMKtZuKXRDleWHeZwLmq677e3
	 fSbL9IGYFseR3gtqoiml7rPSzO1OBFxkOIRlYR3FE99VSgaWjqCtEARkG525ow+WWf
	 wtRZMn9g/zDymty898w7FGK6F6WVt/XWsewccpj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 625/780] seg6: Fix validation of nexthop addresses
Date: Tue, 17 Jun 2025 17:25:33 +0200
Message-ID: <20250617152516.929770334@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index ac1dbd492c22d..a11a02b4ba95b 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -1644,10 +1644,8 @@ static const struct nla_policy seg6_local_policy[SEG6_LOCAL_MAX + 1] = {
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



