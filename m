Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523B91E98F3;
	Thu, 30 Jan 2025 14:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246908; cv=none; b=UCvFaBDfkuqlDNAEceF6KjHPyjEAJ5MnaAvDQmyPrnYZsMRqZJUTeQHN/LHBPvuGLXR400H6/UR/ziXAbEGDQwIa1rBZD00D6lcPER4UNg4vUcwDQKEfitLaCfT8Tzl4se3rWttCA5deWBihZswVsIMqAQQhoNTxHmWBy/jPGnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246908; c=relaxed/simple;
	bh=0AoZ8BsCCGtpGulPDvixgQhTnjXIhgqCCR6GZNv40+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=osJRH6GvzAq7gLoXvXiTcXRcHPY5HcrtiQ8/apspbhLQXqfcyG3EZ4ugruPHRFYC3iLjbaKEIbduOP0DF7+B2R8fX3oh/hr5kf0CCPNOCsqVlXa71mBBjPx15L3R9A6ld3iGTNzqmn0xSCfrkG6HWYNmMJjipx4Swuq5tnSUC3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJMWsVfM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJMWsVfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7A2C4CED2;
	Thu, 30 Jan 2025 14:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246908;
	bh=0AoZ8BsCCGtpGulPDvixgQhTnjXIhgqCCR6GZNv40+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJMWsVfM7rStZUjGqn3LN+iUSMzqTx0KJ+KWb0MVpwQPKwA6dWJ8+mPFu8MtzYfD2
	 Hm3zfU4enBJF/P0ROteCWJRA6aGjQMDgyPDFsFHI/SrjkFIdfaC9b3gmCfXIpUIhoR
	 AVD79SVQII+UAvaRxEPUmakNcSKdXMDFkIKoN4Jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 017/133] netfilter: conntrack: clamp maximum hashtable size to INT_MAX
Date: Thu, 30 Jan 2025 15:00:06 +0100
Message-ID: <20250130140143.200888790@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f82a234ac53a..99d5d8cd3895 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2435,12 +2435,15 @@ void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls)
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



