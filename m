Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7872F41687C;
	Sat, 12 Sep 2026 15:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225813; cv=none; b=nyCGbq2kOGIJhqMDq+3CPIw47ku9VPhyhzPJicL9iMbE6WPpw8ANJlNuX8GRNXAfkPmtrkiWbDmep7ngywRFVxEaGGXONQD8p5c7Yz5V8E8nLAAvIarPnxuqtwkeufGb0qUOCYDqBQpGLTzoBMGUJNN3kOpuio4WOd/h0IgM7Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225813; c=relaxed/simple;
	bh=DZpL8cUrHT+jjjHIpwqBZumG4stlz+3wEH5E5UP+JMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0CCKYfHPk9St6BPvCnRbBqozlqjCJ6KLy6jCbZmC/phs3HYcbitlPJAA39B8uSWVVRjLIaV3aNdqJkW8WT15tc0itbtbGt0HraEUmi/tWxHYPRKUT5umLcoJD7ILzC5mvszPjMj86+r+ijSX9mM3iMVp/2rJ+TcQGNDH0dWNZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dNK7W1Pk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dNK7W1Pk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0601F000FF;
	Sat, 12 Sep 2026 15:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225808;
	bh=A3l90cCPyseN3tNmSA8DiCm05fGihJc0W5+JhZ9so40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dNK7W1Pkx+YZ+BD+8Sz2T91Tu+wk0xxnG7ZCEr0mTsdcdyy6y7i9Pv5rdGbGgfi1S
	 7X4iO1iaGk/45gLSz1+bavk5kE7TWD8LMk8RXsVO/Nauli/pS8+e06ghk/wpF6D7VC
	 FLtibtnf0ZLFjVz1HjbtbPHTv6PUSK5VbNuxCJHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1271/1424] vxlan: vnifilter: enforce exact length of GROUP/GROUP6 attributes
Date: Sat, 12 Sep 2026 09:01:43 +0200
Message-ID: <20260912065635.742630091@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 272fa31ef0745..b5854aceddf9d 100644
--- a/drivers/net/vxlan/vxlan_vnifilter.c
+++ b/drivers/net/vxlan/vxlan_vnifilter.c
@@ -467,10 +467,8 @@ static int vxlan_vnifilter_dump(struct sk_buff *skb, struct netlink_callback *cb
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



