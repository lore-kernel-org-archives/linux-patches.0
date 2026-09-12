Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D590D36167B;
	Sat, 12 Sep 2026 15:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227953; cv=none; b=rdeSgRUjSGLGsHXnoTSoXnHKkHhePWUNsPopZm1o6yIilK/S5VX39JQaOMZbhSCeuxPNDpPz/1GmH73SDgx3p7XNPxPOZG8nw4e/JF53B5/pSnUqJqH38kMNLiFeOQqKQLQ4g5QCtVhjT+zpVd3duhEYS0FT11+sc97S30fWC54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227953; c=relaxed/simple;
	bh=ZyeGG6Tt10VAotPE3gYEMnoMoHhOZso4pMK6GRdMVAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Djz6nE8CP9D7/UtsXC1/BAtu0hHC27W2gcxi5Yh8k3YKnGiOyF9Ej7sE+vMziLNaCZxHSleDUbzeEe76LiQd5+JjDDPow+b8JnHdFOqdtzeQG62+iFYCB+tiLQii+KMLKR0IIFxV9Mnn+OaskL4bv/nN2rmPeiZg2z6Z6rurQo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GPIkI/QM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GPIkI/QM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C3721F000FF;
	Sat, 12 Sep 2026 15:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227951;
	bh=ydwIV46bThmeFDFz7zGZPttGy9nZcTcRJC7WrIZRb+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GPIkI/QMDHDEByiXneu3TMlYWL76Siapjd3i9/2K6dMtlLfmh1JMrmiLLJuBY950e
	 YjuBC6o8kiI/BMtUFp41vFgxNa+W7/n9VJAp3VvANKwEFQyytUrkBBEC1CGEXO87Sk
	 MYVbDk2JRVG3y8hRZ5wTT+XKnCoPF7ZWhQDAi5Hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zi Yan <ziy@nvidia.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	William Kucharski <william.kucharski@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 0244/1191] xarray: honor XA_FLAGS_ACCOUNT in xas_split_alloc()
Date: Sat, 12 Sep 2026 08:49:32 +0200
Message-ID: <20260912065553.694563957@linuxfoundation.org>
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

From: Zi Yan <ziy@nvidia.com>

commit 789763523fb43cdc328de5cb5dcd19240ccf90d8 upstream.

XArray operations that allocate xa_nodes, such as xas_nomem() and
xas_alloc(), add __GFP_ACCOUNT when the array has XA_FLAGS_ACCOUNT set.
This charges the allocated memory and avoids the workingset convergence
issue described by commit 7b785645e8f13 ("mm: fix page cache convergence
regression").

xas_split_alloc() does not add _GFP_ACCOUNT when XA_FLAGS_ACCOUNT is
present.  Fix it.

Link: https://lore.kernel.org/20260804-add-gfp_account-to-xas_split_alloc-v3-2-38cb3ff325c5@nvidia.com
Fixes: 6b24ca4a1a8d ("mm: Use multi-index entries in the page cache")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/xarray.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1014,6 +1014,9 @@ void xas_split_alloc(struct xa_state *xa
 	if (xas->xa_shift + XA_CHUNK_SHIFT > order)
 		return;
 
+	if (xas->xa->xa_flags & XA_FLAGS_ACCOUNT)
+		gfp |= __GFP_ACCOUNT;
+
 	do {
 		unsigned int i;
 		void *sibling = NULL;


