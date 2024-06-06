Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2BA19923C;
	Thu,  6 Jun 2024 14:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683726; cv=none; b=DfuYA1xiNJZSqSSjX0OnsjZH06aFquNOgsIU5TFpePwu4Grf4pzrZnKB/fEm4HfEGl6q5eTJSLJY2ntWhx9OROEdG2ZVPKUZmo2FeylCklaAw0TBUGQY3umRIknaSJj2RIfSkpG+1X3DYOVovu8HQDXd7CeOgNJCxBficHAHLn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683726; c=relaxed/simple;
	bh=yRV1no8GW3NVJgX/S6H6k+JILoeOO5nFd4H4I6OJVQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bRxfPpXs+p2g3B00qSbGu7e5mb2+Gni1Qh27u8hXYBR32KeMFDUHqPlNXXJDYKQbqqqFFgO7X6PtSRUhLTOKZHQRp49CafsOfpb/TJpSUn4P+BzGV2cloDehwWgu+0LeMupns8+V8xR/Tcwebffsf+x60JM1YN/esUUAFoZSGTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mYUP7otx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mYUP7otx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E72C2BD10;
	Thu,  6 Jun 2024 14:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683726;
	bh=yRV1no8GW3NVJgX/S6H6k+JILoeOO5nFd4H4I6OJVQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mYUP7otxMlOF6tfX0yMOQbQl+5er33C6UTij8k7iEkB/SeP+x8sST8Iwbp6O7wpVm
	 PFDRRMba/QzlP4vgoGxafqgvXKeXp00/EOZIzY3veAoxSUDIjsixf6qzZ6GugQ29Lz
	 nDQp2EJ8CYgV1Akz0QVa07kf1A1Rpb91oDn04wXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Maltsev <keltar.gw@gmail.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 673/744] netfilter: ipset: Add list flush to cancel_gc
Date: Thu,  6 Jun 2024 16:05:45 +0200
Message-ID: <20240606131754.075616057@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Maltsev <keltar.gw@gmail.com>

[ Upstream commit c1193d9bbbd379defe9be3c6de566de684de8a6f ]

Flushing list in cancel_gc drops references to other lists right away,
without waiting for RCU to destroy list. Fixes race when referenced
ipsets can't be destroyed while referring list is scheduled for destroy.

Fixes: 97f7cf1cd80e ("netfilter: ipset: fix performance regression in swap operation")
Signed-off-by: Alexander Maltsev <keltar.gw@gmail.com>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_list_set.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 6c3f28bc59b32..54e2a1dd7f5f5 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -549,6 +549,9 @@ list_set_cancel_gc(struct ip_set *set)
 
 	if (SET_WITH_TIMEOUT(set))
 		timer_shutdown_sync(&map->gc);
+
+	/* Flush list to drop references to other ipsets */
+	list_set_flush(set);
 }
 
 static const struct ip_set_type_variant set_variant = {
-- 
2.43.0



