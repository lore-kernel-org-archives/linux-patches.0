Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96A61EB5B;
	Sun,  1 Sep 2024 17:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210036; cv=none; b=Cr4XpzdxALR5xJjBDrzX3bbyIDzUcLe+1V9LoD+bppq6LHOYCmnhxg0OXznuhDgC3judf/zoSZxYxkhmcffW6t318jkna1Fpnna/FoIm7eb+TUP8wsytTlzDgkrti+GZ1eiBWk5YcxuISz+mmnuAOBxJdz7ldZXkbY8X+qsGEx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210036; c=relaxed/simple;
	bh=6YVyJJohE3kEXWlAsSnE5MOP7j43i7AusNsYPTufaxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chdbHfWAsz+9aLlXt+50iFuyEUbJHn8JHLgNwSb3w9eGlonQYJL2cljfhz4kuDOnv0/3ZYaQEyzBcboXKUhAEx/wAaPueiyrB5/FoXwUqHWD1VuXzpORvE78WLmMciThSsMKFO0no9mzZFno4pRs7V7va3KokuzfEGholGuQb28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=APiNrq+Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APiNrq+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04253C4CEC3;
	Sun,  1 Sep 2024 17:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210036;
	bh=6YVyJJohE3kEXWlAsSnE5MOP7j43i7AusNsYPTufaxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=APiNrq+Y8oW6qIXwaSaxt8u5KthwpYWfk40CjcugIK+TzcCpb7V6/9+VEunxu4bWK
	 PROHJRJFXS9JaqsvsfPmDTtT6RzAn6hEVflZ58VIPWK8aojJ6mhCQHHYzbpu7QXBgW
	 rIjWnwB9EDsXXBBckjAcj+Y5SmUsDUiuCqmupiHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Hughes <tom@compton.nu>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/215] netfilter: allow ipv6 fragments to arrive on different devices
Date: Sun,  1 Sep 2024 18:15:49 +0200
Message-ID: <20240901160824.747604751@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Hughes <tom@compton.nu>

[ Upstream commit 3cd740b985963f874a1a094f1969e998b9d05554 ]

Commit 264640fc2c5f4 ("ipv6: distinguish frag queues by device
for multicast and link-local packets") modified the ipv6 fragment
reassembly logic to distinguish frag queues by device for multicast
and link-local packets but in fact only the main reassembly code
limits the use of the device to those address types and the netfilter
reassembly code uses the device for all packets.

This means that if fragments of a packet arrive on different interfaces
then netfilter will fail to reassemble them and the fragments will be
expired without going any further through the filters.

Fixes: 648700f76b03 ("inet: frags: use rhashtables for reassembly units")
Signed-off-by: Tom Hughes <tom@compton.nu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 5c47be29b9ee9..2e5b090d7c89f 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -155,6 +155,10 @@ static struct frag_queue *fq_find(struct net *net, __be32 id, u32 user,
 	};
 	struct inet_frag_queue *q;
 
+	if (!(ipv6_addr_type(&hdr->daddr) & (IPV6_ADDR_MULTICAST |
+					    IPV6_ADDR_LINKLOCAL)))
+		key.iif = 0;
+
 	q = inet_frag_find(nf_frag->fqdir, &key);
 	if (!q)
 		return NULL;
-- 
2.43.0



