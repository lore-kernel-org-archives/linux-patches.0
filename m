Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B08A25DB1C;
	Mon,  9 Feb 2026 14:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648354; cv=none; b=n8qJz2l1TTgUVUWrUv0oiCDV+fvFTMbCZeFtMlem5xXpqP9fORVCQTwGMeL1UllZcN+o7APR3XYz9lkZUp3922DH/04pJu455Zipdkklw5UnEH5z3MjZSEPkcFqeWSw8nmPQAq5sDGIeNuZHBtVP/ARbHMKj4JVyk6a//X5nZi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648354; c=relaxed/simple;
	bh=5JTXuoIwW1pspNy+mDG4w85hQK7du3gZ1hnWdrVbyWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMmYPDmYOsHDCQDjblL9uJllQhyjXM2icuJcRA2DQXItGH98gvXaLVPgUx23OGK0VPPSjO1kOvhT6Eg7ko6yVeSXy8e6OqLeleUcJ0AYvrXxxcXet/g+1jFA39tCyhK6cvCQFn1RZQYB80lhjVGLZnibeBS6U/ndJvU53OyyZv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0R7T9zi5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0R7T9zi5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B317EC116C6;
	Mon,  9 Feb 2026 14:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648354;
	bh=5JTXuoIwW1pspNy+mDG4w85hQK7du3gZ1hnWdrVbyWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0R7T9zi5HjTFF0sBKXjmSeFZjavVqCrMVjT+Kz6n/H0kMKgtIHYkCDT/uVdqE/67X
	 6m0cOx6mHe2Mjg4Q4d9GvjlkjE3g0+Hgos/sQf5QCEvHqoxeUPuhc2VrHROwAY7FN8
	 yxCynFqt/4cENV8LNvoqYiAbocLA/ACAyqUi10Po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Subject: [PATCH 6.6 13/86] netfilter: nft_set_pipapo: clamp maximum map bucket size to INT_MAX
Date: Mon,  9 Feb 2026 15:23:36 +0100
Message-ID: <20260209142305.256789021@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit b85e3367a5716ed3662a4fe266525190d2af76df upstream.

Otherwise, it is possible to hit WARN_ON_ONCE in __kvmalloc_node_noprof()
when resizing hashtable because __GFP_NOWARN is unset.

Similar to:

  b541ba7d1f5a ("netfilter: conntrack: clamp maximum hashtable size to INT_MAX")

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[ Keerthana: Handle freeing new_lt ]
Signed-off-by: Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_set_pipapo.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -667,6 +667,11 @@ static int pipapo_resize(struct nft_pipa
 	}
 
 mt:
+	if (rules > (INT_MAX / sizeof(*new_mt))) {
+		kvfree(new_lt);
+		return -ENOMEM;
+	}
+
 	new_mt = kvmalloc(rules * sizeof(*new_mt), GFP_KERNEL);
 	if (!new_mt) {
 		kvfree(new_lt);
@@ -1359,6 +1364,9 @@ static struct nft_pipapo_match *pipapo_c
 		       src->bsize * sizeof(*dst->lt) *
 		       src->groups * NFT_PIPAPO_BUCKETS(src->bb));
 
+		if (src->rules > (INT_MAX / sizeof(*src->mt)))
+			goto out_mt;
+
 		dst->mt = kvmalloc(src->rules * sizeof(*src->mt), GFP_KERNEL);
 		if (!dst->mt)
 			goto out_mt;


