Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDEA481DA;
	Mon,  1 Apr 2024 16:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989944; cv=none; b=s6uCVaBkP9OyInRPUW2ODxVEu29P++jPOEUCSZiPuQx0IvqidDraA6bjpu0BljxD+1i72fCzhcue8+j2grj9CxUil9BReNqPCq/qdzTZGPIYlazp3LXHxnXdELb3rMCuYM2PjjHMUs6/0BjJiZ006rJci6Y5cagJaqoFEMOQsdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989944; c=relaxed/simple;
	bh=QvTqWfOkL6mxHm6qlhHkU95z4tIv8GZMAo6wDewa+FA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/2OXryGag2BqOEaMDQG9Y3lYVs6GWh6gib4MNYHH9UeLhVbhJIKqQ0gakyjYfr0gwAxp2hBLvdO8VeDG/I/obFU4/J4YzFwpp+kwanDwgvcuQHBG97Li2Ol7NSMv8F284R6vhcp2+cUI7thEpXiqCVfZ3vGcEeRIEJKnxYAlaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hxsL3wX3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hxsL3wX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889CAC433C7;
	Mon,  1 Apr 2024 16:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989944;
	bh=QvTqWfOkL6mxHm6qlhHkU95z4tIv8GZMAo6wDewa+FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hxsL3wX3a1/SKAjwHpGZu4/vGop62IhL4t0RZkdAdNNpdKZTJR10af7T4uyOVuf1F
	 DwkFV8zDtC+sdUMAKo99qMKgDZjxTfMqD4SRE7o+y0pn3GhO1hyLkuPCPS4d5muFhD
	 NwOmbpjSQD+/RKr4krgEt5tdevOCsRiSQ/n1gqe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.6 199/396] netfilter: nf_tables: reject constant set with timeout
Date: Mon,  1 Apr 2024 17:44:08 +0200
Message-ID: <20240401152553.866618964@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 5f4fc4bd5cddb4770ab120ce44f02695c4505562 upstream.

This set combination is weird: it allows for elements to be
added/deleted, but once bound to the rule it cannot be updated anymore.
Eventually, all elements expire, leading to an empty set which cannot
be updated anymore. Reject this flags combination.

Cc: stable@vger.kernel.org
Fixes: 761da2935d6e ("netfilter: nf_tables: add set timeout API support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4945,6 +4945,9 @@ static int nf_tables_newset(struct sk_bu
 		if ((flags & (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT | NFT_SET_EVAL)) ==
 			     (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT))
 			return -EOPNOTSUPP;
+		if ((flags & (NFT_SET_CONSTANT | NFT_SET_TIMEOUT)) ==
+			     (NFT_SET_CONSTANT | NFT_SET_TIMEOUT))
+			return -EOPNOTSUPP;
 	}
 
 	desc.dtype = 0;


