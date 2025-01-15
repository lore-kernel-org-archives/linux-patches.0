Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97A8248BB2;
	Wed, 15 Jan 2025 10:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938006; cv=none; b=GsW+D3j0Sz7ByswHfwFl+prmpse4xFfc12XaE7Z/toFL+e8Gez4nq9/w4P50eUcUMMWxUVZJDGTGetivmANhK6SSA10WESPSuYEcECrW0QfB3h7cKoJkm/+Nq0tsoBoYDujVgBQTLkLPySMouS7miEDCDFYEb+9q9mxz4EVD/18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938006; c=relaxed/simple;
	bh=MetEY3y/fYwFqdSxYqg+zi2U9x19CKS6PsJ1rt1eoe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9RY36MQbjfbBqi7sLuuXYJa+vyQBBkJrYoSc5Rna9Bl0qgE1UJ9SVFON300CRRKuCPbUo6ygbYutlMNuAw9hiaHdPkrdw6uZixkLSMJ2YbmSi/WnCgwgUWdsQAt6OhocbbA4kl+ZgDbGLbQ37s0J/kx8xasH0r8lKf405dr4F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gxpdFZF1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gxpdFZF1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44229C4CEDF;
	Wed, 15 Jan 2025 10:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938006;
	bh=MetEY3y/fYwFqdSxYqg+zi2U9x19CKS6PsJ1rt1eoe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gxpdFZF1OTzLQRui+8vuxhVjHE23zeBjim9EpiguMeel+DzRYQBPjf9kQFFnbFDJU
	 tLpDH759g2GxMOJJD+++3I1acSIC0gK4sHKa+K3MhQWgkagCOnkb0Yb/GCjqg76lnO
	 Mx8QRz2hk46DymoZ5CwwCtiKa2rN9Gs/l0swvh0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 055/189] netfilter: conntrack: clamp maximum hashtable size to INT_MAX
Date: Wed, 15 Jan 2025 11:35:51 +0100
Message-ID: <20250115103608.549892511@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9db3e2b0b1c3..456446d7af20 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2517,12 +2517,15 @@ void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls)
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



