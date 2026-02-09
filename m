Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179B637997A;
	Mon,  9 Feb 2026 14:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648690; cv=none; b=lt8pmf6RvrI+Frk9hiZX2Dd9CGLMDN1qSuzfrIGSradpgYrqqav2DyjobragTMKinLeYwjsXXLv2lPjF9ACK97zQxvuooumqilYP8C9W/lihTWqCwr3xle4bBkwXgp6/d3alEy9HtPEz7vcaOtNbhsOMRuJkMnB1y9Q7At9NNdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648690; c=relaxed/simple;
	bh=HwmnS5u86/vUvBM7Nl1sVhhcHK9Y16Tv18sv+ZdJqc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mji5twVQeNDj1UMW2G/yyaURutUrn9LEFTPTyA+xbTUW8QmT3IeI4NCP22036Jn4hgrbMhFvthYv/7Y6Otk4E42Ne8zH49xGFbXJmeTYJMUlPN+/xq+ua2QniYuQL+hdpRsuhDjcGWqNJ/Tbf3SbVbNzbByTBIE3Eg6GpASw4jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tmGCd3R1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tmGCd3R1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB8CC116C6;
	Mon,  9 Feb 2026 14:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648690;
	bh=HwmnS5u86/vUvBM7Nl1sVhhcHK9Y16Tv18sv+ZdJqc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tmGCd3R1ToYRC2GBw0PAdlay3KujqgblH7N+XnKPgoyyWz7zo1dvPs/Wq7oVHyotp
	 HadkwlbnGXP7idPoO5VIXPugT7QccWgOZLFy/hEY9PwEwbpI/idpjt4Z1Xf/nvG8gj
	 zXeDaJTKLfRlPrA/DaivxYkdj8mnZLjEtRX4PQJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Subject: [PATCH 5.10 04/41] netfilter: nft_set_pipapo: clamp maximum map bucket size to INT_MAX
Date: Mon,  9 Feb 2026 15:24:25 +0100
Message-ID: <20260209142256.961207448@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142256.797267956@linuxfoundation.org>
References: <20260209142256.797267956@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -665,6 +665,11 @@ static int pipapo_resize(struct nft_pipa
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
@@ -1358,6 +1363,9 @@ static struct nft_pipapo_match *pipapo_c
 		       src->bsize * sizeof(*dst->lt) *
 		       src->groups * NFT_PIPAPO_BUCKETS(src->bb));
 
+		if (src->rules > (INT_MAX / sizeof(*src->mt)))
+			goto out_mt;
+
 		dst->mt = kvmalloc(src->rules * sizeof(*src->mt), GFP_KERNEL);
 		if (!dst->mt)
 			goto out_mt;


