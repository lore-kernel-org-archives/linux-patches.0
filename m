Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D9A472071;
	Sat, 12 Sep 2026 11:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211630; cv=none; b=SoGhpd7frR2biLw//K2EMj9yKV0ZipZ+wWcBp8xMmg+G1S3AQErUc1nr7eOp9IcGJx/KXg8LUp5hVdRjV1XGin67IFDEfX9mqzFn8UKpZJF25HNUWK+icpaAEQultdq2wStgRN0TGuQ2CFZyCgSW2O7c8nfgiFEPz5qQ38P/nJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211630; c=relaxed/simple;
	bh=tXR6uC3apF9BZ+3GWza59EluebqtdfaJCEmt9LquF5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ukkx5uakixI8GhUVV6kffetwo1/IExf4Xys2QyktofRTL1l1y0eFT7A054bZHBspqEjrVAnnkOwRa+DPvrOQfrjciy7SsQwUEaVHJvzz1Q6Ntsps7QZHUTJDiu/Qdq2LAI/Z1xy7Kqbv1Gp6ZO7AP7oR2fdyqfFbH3XgHl0nzaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=flhvEMuV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="flhvEMuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0661F00893;
	Sat, 12 Sep 2026 11:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211629;
	bh=umnTvRNqhptZMWZZa+eqIHkv9Q9WIUrlXjwHVRzDZyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=flhvEMuVdvnYuuTyqki4f35X77SVO2DLxewtjQSU2Zwh2GcOXOfxKsykvTFPjkG0o
	 J4WjB5zJsov98GpdECSoS2Du63puCxeO6k/zCkfHzWGljWi3WM2ZrSUkIU+3od4eIV
	 OuYpYNCMDYSmcoy1SGHFnEWPxdQ10NFva4tVzl8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1269/1518] vxlan: vnifilter: enforce exact length of GROUP/GROUP6 attributes
Date: Sat, 12 Sep 2026 08:57:18 +0200
Message-ID: <20260912065652.218754767@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 984f831dda31b3a18f47454cf64989f65402879e ]

The VXLAN VNI filter entry policy declares the GROUP/GROUP6 address
attributes as NLA_BINARY with only a maximum length, so validate_nla()
accepts a payload shorter than the address. The GROUP consumer reads it
with nla_get_in_addr(), an unconditional 4-byte load, so a short
attribute over-reads up to 3 bytes of uninitialised slab data, which are
stored into remote_ip and echoed back via RTM_GETTUNNEL, disclosing
kernel memory.

Switch both entries to NLA_POLICY_EXACT_LEN() so the validator rejects
any GROUP/GROUP6 that is not exactly 4 / 16 bytes; a valid address is
always sent at full width.

Fixes: f9c4bb0b245c ("vxlan: vni filtering support on collect metadata device")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260812215341.763123-1-xmei5@asu.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_vnifilter.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_vnifilter.c b/drivers/net/vxlan/vxlan_vnifilter.c
index 215e82876662d..3f2d2396243a7 100644
--- a/drivers/net/vxlan/vxlan_vnifilter.c
+++ b/drivers/net/vxlan/vxlan_vnifilter.c
@@ -462,10 +462,8 @@ static int vxlan_vnifilter_dump(struct sk_buff *skb, struct netlink_callback *cb
 static const struct nla_policy vni_filter_entry_policy[VXLAN_VNIFILTER_ENTRY_MAX + 1] = {
 	[VXLAN_VNIFILTER_ENTRY_START] = { .type = NLA_U32 },
 	[VXLAN_VNIFILTER_ENTRY_END] = { .type = NLA_U32 },
-	[VXLAN_VNIFILTER_ENTRY_GROUP]	= { .type = NLA_BINARY,
-					    .len = sizeof_field(struct iphdr, daddr) },
-	[VXLAN_VNIFILTER_ENTRY_GROUP6]	= { .type = NLA_BINARY,
-					    .len = sizeof(struct in6_addr) },
+	[VXLAN_VNIFILTER_ENTRY_GROUP]	= NLA_POLICY_EXACT_LEN(sizeof_field(struct iphdr, daddr)),
+	[VXLAN_VNIFILTER_ENTRY_GROUP6]	= NLA_POLICY_EXACT_LEN(sizeof(struct in6_addr)),
 };
 
 static const struct nla_policy vni_filter_policy[VXLAN_VNIFILTER_MAX + 1] = {
-- 
2.53.0



