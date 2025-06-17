Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A512F2355;
	Tue, 17 Jun 2025 16:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176341; cv=none; b=DdnE6nYn/q/e07ylnDPhiKPbC0uX6h87m7YcxXNrfnwQDCnrhuuHybYyb1ZL+a8JwDbpebHm/5smUVaAvlXIndLmnH58Zt4M8L0NwP5T/MUxEAPEiBeDwYZ9N8h9ruNf2lGMUeioJAM9wSRbEclOXH5fFYsOwWJzqHw5mjZcLKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176341; c=relaxed/simple;
	bh=vD5MnLwrv3SPQLdmkmI9tcBQiFDxnFmVzKBv4ApBy/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVIUoooc7mxUSL05M2aHjO+hFdCJRLuXxxZIbr6SNfW05Hs1h/rFKc/oS7xpY6u6WtG/CfLErZoS5iq9x01/8CZoyp5Asbys0JhmV5/J1+RGTR313uhq9XJGB0uc/0+Qf6ym29ghCflkmaN3Zu6HrktBgNoWkvd210nUOskZbxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C3p2ZPyL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C3p2ZPyL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA84C4CEE3;
	Tue, 17 Jun 2025 16:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176341;
	bh=vD5MnLwrv3SPQLdmkmI9tcBQiFDxnFmVzKBv4ApBy/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C3p2ZPyLOhptZoncE+svdpkM/N9bRMnmbv+GVGjOLJ/srwv4NXmyKr2qJ7YS4Fk7u
	 TYHCK2ToseKh/+B9pqxSYz5/QECVzVj52nt8IfmWw1AJqdK/oo6WZXNON9UIocDD2g
	 JDgrGz1+WMdpH8wyAyi9TLodeKZaPcWVLukU1Ylk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 268/356] seg6: Fix validation of nexthop addresses
Date: Tue, 17 Jun 2025 17:26:23 +0200
Message-ID: <20250617152348.993645605@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c434940131b1d..7f295b9c13744 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -1638,10 +1638,8 @@ static const struct nla_policy seg6_local_policy[SEG6_LOCAL_MAX + 1] = {
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



