Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE587EEE1;
	Mon,  8 Apr 2024 13:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582261; cv=none; b=E7OeIeUeUnbXiyZqgixjxF7Xnyrupeukngg0Bc+l65lwSSNtOhHBULQzW09tYZi9XfwFGpSj18KtwHp3AhKeXuPsdZnkpMollB6YRmp0C12JTQNg/jvf9BLeVUn98pMt7GcWa4Xxcp4U9CP1yvrf1VpiQnh9sDli3pJESnIftK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582261; c=relaxed/simple;
	bh=kNoZQCXHdIcJLEx+Na3fVs4ukIhvBybD6TPj1c/oZ58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N175yMjcMI+3kz0LNaJtH3pTSm/B1DIMhI+dsZyi3RE7NveO+L8kJlVkwSmMfjUcmFI6MsKDABTJC7+K58EF569pqyG31W3qo3KXtJ3hHjo56+8LMTbm/h409Cf/JayaxpNqmHgLZG+QsBN1m6CF8PmNsLY32916NajhW2Z31Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N9xvUBMh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9xvUBMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A078C433C7;
	Mon,  8 Apr 2024 13:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582261;
	bh=kNoZQCXHdIcJLEx+Na3fVs4ukIhvBybD6TPj1c/oZ58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N9xvUBMh4JTvhzF306imMuMifR9TN9tS5jygluoyeXWZNNscC9GtVkKRW0YlojtYO
	 ad2deJ4921GTBXgChp4UTdbPS1ghuNUqXWltX/lNIEd+7XGFU/JMnLgmd1gArV4vaK
	 KvQC2d3VDYlTzyVAhxN0vwlulTb32E4951hDawUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 120/690] netfilter: nf_tables: reject constant set with timeout
Date: Mon,  8 Apr 2024 14:49:46 +0200
Message-ID: <20240408125403.903362654@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4644,6 +4644,9 @@ static int nf_tables_newset(struct sk_bu
 		if ((flags & (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT | NFT_SET_EVAL)) ==
 			     (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT))
 			return -EOPNOTSUPP;
+		if ((flags & (NFT_SET_CONSTANT | NFT_SET_TIMEOUT)) ==
+			     (NFT_SET_CONSTANT | NFT_SET_TIMEOUT))
+			return -EOPNOTSUPP;
 	}
 
 	desc.dtype = 0;


