Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C161441CB2E;
	Mon, 31 Aug 2026 13:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183679; cv=none; b=Z4/4Ly/69tfYkob/ZbkR7I49+0e0DSyc4VHswQg9uUApKzWzi2Dqyy75LdUvQEykVP83N/DabkwOOmVyc0x0dMBpuPVir8nNszBXu4ZWU9j2M1dv8E3jsQEE2TOKBA56y4S4TG5y3qhcAvVRaDHSk/1Wku45yhiOHzl+bdgXnfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183679; c=relaxed/simple;
	bh=K8xPMbhzmRtpEj62XEuUY0Wmx0+jOh4rxE9BAGeWMlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4iiCrNQ2jApfm9rV4mvZM6ac1+lnXejeuG3MBiDr27QWN6umgv25Jm52SqjkqPVS+vRfQqyP53lmmT45P9mAnwppzLHJidhWHVn6tJ8aha6MTVGI4FGPw4XAiKbfpPVoPI8XRydBLz2EH8Xy36YmACyWUzeWcJTt2a2ZoYF+ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FYYAIbnI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FYYAIbnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78D21F000E9;
	Mon, 31 Aug 2026 13:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183676;
	bh=S8xqf/m/Op66FaWH1L+iT8RlMGU4wuS7nioSOYPR5bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FYYAIbnIXKy9+aUoXOOUbQkRMkzA8n9mUFIaje6he0Ys8xn0sFBgigl4sVnju/yz/
	 AcyKHGXqtF8tdhP5W1iSjavhKP0frj3QnqsV/gA5YnYRkoWCO+N0qR6v6/8xJDIswB
	 OZMo9ZSNzjkgZ/6Z5A1Rfi/F16d0hBjd/UxM6Yqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7.2 45/71] netfilter: nft_set_pipapo_avx2: add missing vzeroupper
Date: Mon, 31 Aug 2026 15:34:10 +0200
Message-ID: <20260831133401.567942788@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 55dd20f0f4b1be5c9c8a0275d8d763c86563eac2 upstream.

Since pipapo_get_avx2() uses YMM registers, execute vzeroupper before
returning from it.  This is needed to avoid degrading the performance of
any later SSE code that may happen to be executed.

Fixes: 7400b063969b ("nft_set_pipapo: Introduce AVX2-based lookup implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_pipapo_avx2.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1134,6 +1134,7 @@ struct nft_pipapo_elem *pipapo_get_avx2(
 	struct nft_pipapo_scratch *scratch;
 	const struct nft_pipapo_field *f;
 	unsigned long *res, *fill, *map;
+	struct nft_pipapo_elem *e;
 	bool map_index;
 	int ret = 0;
 	int i;
@@ -1207,14 +1208,11 @@ struct nft_pipapo_elem *pipapo_get_avx2(
 next_match:
 		if (ret < 0) {
 			scratch->map_index = map_index;
-			kernel_fpu_end();
-			__local_unlock_nested_bh(&scratch->bh_lock);
-			return NULL;
+			e = NULL;
+			goto out;
 		}
 
 		if (last) {
-			struct nft_pipapo_elem *e;
-
 			e = f->mt[ret].e;
 			if (unlikely(__nft_set_elem_expired(&e->ext, tstamp) ||
 				     !nft_set_elem_active(&e->ext, genmask))) {
@@ -1224,9 +1222,7 @@ next_match:
 			}
 
 			scratch->map_index = map_index;
-			kernel_fpu_end();
-			__local_unlock_nested_bh(&scratch->bh_lock);
-			return e;
+			goto out;
 		}
 
 		map_index = !map_index;
@@ -1234,9 +1230,12 @@ next_match:
 		data += NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
 	}
 
+	e = NULL;
+out:
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 	__local_unlock_nested_bh(&scratch->bh_lock);
-	return NULL;
+	return e;
 }
 
 /**


