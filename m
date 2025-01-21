Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062731F543F;
	Tue, 21 Jan 2025 18:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482815; cv=none; b=GyCHfTOVpjlwJBDwQdPv66nwy5vJYsooBsrjPXVSoYdfkoxOKrqc1GbGBB7+rtfRb0rK3dG4Hhdi0paelp/OXcV0nUqeWl1jNVPFoyBz6eVxBXbgsFSMDaM5OWGgLgTHc1LqmgGA3ItHcpXpibmygPqYDKOLb8sJ3npH+Y39pVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482815; c=relaxed/simple;
	bh=gYDnXxhjroIFCS6Dlw5a6jqprzTm3b8PajVn8HEocm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qluP70GR+2KnP2a6DmArcSNNsitnpUcftk5FmgH64zxZKmmOAOvXXek50qzzWw/oPb4/GdE2RScmh5poFswxs3tsSWiqQezR+8/DrDnnxsf3SS9ruyGsJSObun7+4FX+17PUH1h1KJYGhniG4haWLjggzpoUuMNzofBh1Qr2rUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tV41eqgo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tV41eqgo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D1FC4CEDF;
	Tue, 21 Jan 2025 18:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482814;
	bh=gYDnXxhjroIFCS6Dlw5a6jqprzTm3b8PajVn8HEocm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tV41eqgo7+igMccKuaKeEO28PYh6PLwS0/5HGD/KA+OY+cGQrgTS6lkmmR68p9/u6
	 +iJniUl8RcZ9+UPwVx50lEz35RDNuxmy2aRb/34rXiAhhPdW+yhMUtEw+wGTe3nxJK
	 DVTuqbS4rxX8VkGQpgk+OoBd4yVa01hTUbROhSLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 018/127] netfilter: conntrack: clamp maximum hashtable size to INT_MAX
Date: Tue, 21 Jan 2025 18:51:30 +0100
Message-ID: <20250121174530.375677325@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit b541ba7d1f5a5b7b3e2e22dc9e40e18a7d6dbc13 ]

Use INT_MAX as maximum size for the conntrack hashtable. Otherwise, it
is possible to hit WARN_ON_ONCE in __kvmalloc_node_noprof() when
resizing hashtable because __GFP_NOWARN is unset. See:

  0708a0afe291 ("mm: Consider __GFP_NOWARN flag for oversized kvmalloc() calls")

Note: hashtable resize is only possible from init_netns.

Fixes: 9cc1c73ad666 ("netfilter: conntrack: avoid integer overflow when resizing")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index be6031886f94..00a97743507d 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2589,12 +2589,15 @@ void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls)
 	struct hlist_nulls_head *hash;
 	unsigned int nr_slots, i;
 
-	if (*sizep > (UINT_MAX / sizeof(struct hlist_nulls_head)))
+	if (*sizep > (INT_MAX / sizeof(struct hlist_nulls_head)))
 		return NULL;
 
 	BUILD_BUG_ON(sizeof(struct hlist_nulls_head) != sizeof(struct hlist_head));
 	nr_slots = *sizep = roundup(*sizep, PAGE_SIZE / sizeof(struct hlist_nulls_head));
 
+	if (nr_slots > (INT_MAX / sizeof(struct hlist_nulls_head)))
+		return NULL;
+
 	hash = kvcalloc(nr_slots, sizeof(struct hlist_nulls_head), GFP_KERNEL);
 
 	if (hash && nulls)
-- 
2.39.5



