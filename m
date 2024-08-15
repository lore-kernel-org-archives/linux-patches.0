Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD6D1AC893;
	Thu, 15 Aug 2024 14:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732798; cv=none; b=cvX9MoAqzqXUSLoFewgw26llPswysngJqojK1Cw+KcdUrfjREkSS/ggj9qCsJ0oVHU5WGWd9KrvKhNkJK4wo+6Yk3vov9k+MZulFlhXjXpOtmb7U7Olq99K7PxVLNeSOGFGxTJ2RpVeOt/BH9jq8yr3clwdQSMdSmgPOoxwCRbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732798; c=relaxed/simple;
	bh=QPwGoGtUPFGUpN2N4eiA0OZmBPQqkHr1ccNnYNU50nA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSC2C0RcgvwoWhKr1xBZHuAf4cGRPsLqM/avtt4bbQnK75YIK5mkgpmDzTxRv+mQD4s31NJXgPjjizXXiJI7uHsIc15e5HMyJjuO7CiyTMTiKg9QcAw0x6AmxXcLTQvj5A1+mYsqPFEXJrOCs0rCDLBfy8wTwlTwWZrxo+K/FBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1lK3mRD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1lK3mRD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1FB9C32786;
	Thu, 15 Aug 2024 14:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732798;
	bh=QPwGoGtUPFGUpN2N4eiA0OZmBPQqkHr1ccNnYNU50nA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U1lK3mRD6UYTasc7YjkgcmSJwqUkxENWhXc9+SN0FJTsmw660ga+/piRK5rzhYqeN
	 q7Bm9CqRgzgJc94MbWwLQLafE+4T0uH7hHviFZowoVfqKSk8zoIEv2kynyZ/rOFZ4w
	 DfEqVLXRTTYlgnP2HU5E5tWKLzvNMCGKz3zr9tuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Maltsev <keltar.gw@gmail.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 248/352] netfilter: ipset: Add list flush to cancel_gc
Date: Thu, 15 Aug 2024 15:25:14 +0200
Message-ID: <20240815131929.023017151@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e839c356bcb56..902ff2f3bc72b 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -547,6 +547,9 @@ list_set_cancel_gc(struct ip_set *set)
 
 	if (SET_WITH_TIMEOUT(set))
 		del_timer_sync(&map->gc);
+
+	/* Flush list to drop references to other ipsets */
+	list_set_flush(set);
 }
 
 static const struct ip_set_type_variant set_variant = {
-- 
2.43.0



