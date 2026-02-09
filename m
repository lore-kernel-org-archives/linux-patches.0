Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553E228312F;
	Mon,  9 Feb 2026 14:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648826; cv=none; b=OjyMFmJY5Qcg7sfGA885tHCMnxs91JAoPd8WyH3PgQDqdQfckxeEp3zsSn/0t2+YYm5/bOFSHPjDgHj+YEEARJn7VpmDfORi8fFxB6fk7PjrUcUJWONvFdcKSA23IWpgQ539D59jO4k74dbyh6pF9L3hdBRoEc6g7rGGWMJB6iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648826; c=relaxed/simple;
	bh=O7IxVPvVrwyb0KuKybMeTdhkDNNp2xQ4SM6+pDcBarw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IH+USopjng2mhelQ/p3S3hAFFXMiGAaH8t2sqUrSlmfgAYCr9H5xdHmkAQs8x1MuEmJ8qT5jlJT5DTJpRCmyq0G+U6oIfjj+CnxSbn9PQ2D+YLYdziK2Fvm1KTJ6NOj1ZlX/y3nRoKXbwtopzrqqXDuwWur2BI3L3ne7sDesgMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tx485DBy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tx485DBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07C6C116C6;
	Mon,  9 Feb 2026 14:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648826;
	bh=O7IxVPvVrwyb0KuKybMeTdhkDNNp2xQ4SM6+pDcBarw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tx485DByy4C1UJKD91zdVnk3mq8EFW4NV3Ez1kExsXhH0jJFQ3C1oVTaaSxoBZxy+
	 JdPT+6WQD/EvPqDOA4p5B1YdgkLWwV++s14uBCP94luNqIBxbFwqP9Q/f44TLeXslK
	 vV7oA5XfbnkLj4bDisglS1uNZMbVOlbKt/nv+ZgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Subject: [PATCH 5.15 07/75] netfilter: nft_set_pipapo: clamp maximum map bucket size to INT_MAX
Date: Mon,  9 Feb 2026 15:24:04 +0100
Message-ID: <20260209142302.104585833@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
References: <20260209142301.830618238@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1360,6 +1365,9 @@ static struct nft_pipapo_match *pipapo_c
 		       src->bsize * sizeof(*dst->lt) *
 		       src->groups * NFT_PIPAPO_BUCKETS(src->bb));
 
+		if (src->rules > (INT_MAX / sizeof(*src->mt)))
+			goto out_mt;
+
 		dst->mt = kvmalloc(src->rules * sizeof(*src->mt), GFP_KERNEL);
 		if (!dst->mt)
 			goto out_mt;


