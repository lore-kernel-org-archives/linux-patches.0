Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5CA3BBFAE;
	Sat, 17 Oct 2026 17:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257131; cv=none; b=H4ipvfXtAGTInJW1TtpHylt/jEac6DqekhVMJV6h8TfV0UJ1FkhlOgCMRA/N172HBvoX5WJ16NbWlYgNG1gvGoGMvHemG7Vl3g+t3vSmG8r+sNHpj8P+0enOctnsdN6kH6SFUiWFHpSukxoZU8mOf1IN7Bc3VVPYv/yLlYppvKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257131; c=relaxed/simple;
	bh=3q5HYOeVlDiOHEbBfDhKY0TwRfKnJWCG344zxpeuCw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Byfx9a46QXK9ZgOc1HhN9joNdDyk+ohl5S8SiDsy7Ckl5E2ilj6vqXlMbNMtQzk+SXQNNEvxaXDnpIMzlgEmdp4on10p9RdXeG8i0NTXwlzV9HvWOwFx8obcr1iaBog3wTiDnUJPaNyOB866PCj5dFSJvUagFnZq1fDFcml93yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U/mIsE37; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U/mIsE37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD081F000C4;
	Sat, 17 Oct 2026 17:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257130;
	bh=8Kqa0tzxM6nbnjdkI17dFtXchWJ0qTDl/SLVBOdpcRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U/mIsE37LaIZTxSQVyKml3pkScpGiUiEWlV4S2P8SStr/dfAB4enqtudM7nnWzj8x
	 9nIVCL0PIm3t9iXSsZ6VTBbEdOaUQj9BLhw1m3uQspPRSh1E1mj2c6xrugKMtAbBPg
	 RKngkmFckBnSFnbDbC1/Hfo2pHVzDPVihX/iF3Sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0461/1674] netfilter: nft_set_pipapo: restore cloned mapping table memcg accounting
Date: Sat, 17 Oct 2026 17:45:33 +0200
Message-ID: <20261017160442.951627071@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

The 6.6.y backport of commit 69e687cea79f
("netfilter: nf_tables: missing objects with no memcg accounting")
changed the pipapo_clone() mapping-table allocation to
GFP_KERNEL_ACCOUNT.

The later stable backport of commit 07ace0bbe03b ("netfilter:
nft_set_pipapo: do not rely on ZERO_SIZE_PTR") rewrote this allocation
and changed the flag back to GFP_KERNEL. Upstream applied the
ZERO_SIZE_PTR change before the memcg accounting change and retains
GFP_KERNEL_ACCOUNT after both.

nft_pipapo_deactivate() clones a populated set before looking up an
element to delete. If the element is absent, priv->dirty remains false
and the clone is retained. Its mapping tables therefore remain allocated
without being charged to the requesting memory cgroup.

Restore GFP_KERNEL_ACCOUNT for the cloned mapping table.

Fixes: 32bad10de347 ("netfilter: nft_set_pipapo: do not rely on ZERO_SIZE_PTR")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_pipapo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index b9d9218cb2ee3..cfdea0e65af60 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1465,7 +1465,7 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 				goto out_mt;
 
 			dst->mt = kvmalloc_array(src->rules, sizeof(*src->mt),
-						 GFP_KERNEL);
+						 GFP_KERNEL_ACCOUNT);
 			if (!dst->mt)
 				goto out_mt;
 
-- 
2.53.0



