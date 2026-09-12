Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBAE47D451;
	Sat, 12 Sep 2026 16:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231709; cv=none; b=J7/DTMaBL0Ez9qg2YoxVpInhND0JwuEbt/G/1G6j0U5VNeY3jMH4+2UranO8k1vMk6q1lfl4BEKP6uV+OTC6S7WrNSUP7K5LZky2qJfsTI1rQ0c+e5cJpkDUYxkCKeu2sGBIsaoYuXMvN96lwk44XQ7CG9M046pwjxFiYhlHREM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231709; c=relaxed/simple;
	bh=92uhxFgXO5HzC5pzEKsqFRZ9En9Jg6CByOanI2pprXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCRywKdUd+2zkqnrxrZEPmNCcF1Nd88DKDnLVoF/GB7jfCWMuw6BAhxFKK4b4lv0EaDB1AMppmWRKpzB17jTwm6uz4WTHiS1Lk7BfUwMu2FynBPjXCjuWDD2n2ashafaZAithwAFhlZG14SBVTo5mv2eDR1kujyQcRDWVbbMVdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k0IwLklQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k0IwLklQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C068E1F000FF;
	Sat, 12 Sep 2026 16:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231707;
	bh=e3XUKmFY21gHAxsnC9RVv0EB63emNH0MimXv+p9tvdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k0IwLklQZsNxeu9BxcIJXyxB8CHmkM+EpgFfotoKpXY45SMMQZUqI1mAI1XmDUFjL
	 1y79UzZwm1qoJob0VVogvom2rVIovO3oY9QvXtyUQPyYAHO+zrNEOqnNkFNqN3MxDm
	 Q2535KSYBOclTuS9sdzg7uNLta5AHXagCc9aVlv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1052/1191] vxlan: vnifilter: enforce exact length of GROUP/GROUP6 attributes
Date: Sat, 12 Sep 2026 09:03:00 +0200
Message-ID: <20260912065611.803582554@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index abf96d60eb30d..14431f75e8389 100644
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



