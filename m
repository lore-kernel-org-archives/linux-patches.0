Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD29C1482F6;
	Thu, 11 Apr 2024 10:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831773; cv=none; b=XjeRhmgXLximWj4ls+BCc9wEBH4yIK0+b9OcPuk4wk8FKLsfk8E0pWCIeOm2HyeQQr94lJC7F+69ZiaZqdAlNvR/T8SBbqKya3IwYwzdMZc8cXrbeXffFmZgNqo6EAbei8s5YVX9Qx17H0KwC/Arrw/EvIlEo+s7ugUU7jGb/Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831773; c=relaxed/simple;
	bh=JeTX065VFqyODGCKWFgkjGgC3a0KMSkMh5qiMaXvuVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNAkvlYkP9R2ICIZPT1wSDvnE59gBK5Q531BQZZ1rTjIpu6dvYtFBSC+LsT16NU0iqnz8SOmd8jB9ls9X389u4JM/uLSRkVXZDqDbG/Lir69Og8Y/5FWyOAzOCzwsm2JpKEy+ts4BmAYKw3bel+LAYLtY2G+6ur1rG2qWGSQO5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tI4G1Kg/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tI4G1Kg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D367C433C7;
	Thu, 11 Apr 2024 10:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831773;
	bh=JeTX065VFqyODGCKWFgkjGgC3a0KMSkMh5qiMaXvuVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tI4G1Kg/5KkqiEklsEdJ36+yhdEMiwMhqqWKYzTT415H4qU5SVc7rBSNKqTenOBJT
	 7Gjs+ESYfiuxVqX1250F7F3mL06i+3yDZEy36IR3nvRAYgVqTexuwIsRjTdmE/3Jf1
	 FgpoL84IBNiP082Lo6iZ0ikFOtDk9ImHo25XLu8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 121/294] netfilter: nf_tables: reject constant set with timeout
Date: Thu, 11 Apr 2024 11:54:44 +0200
Message-ID: <20240411095439.309916680@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4413,6 +4413,9 @@ static int nf_tables_newset(struct net *
 		if ((flags & (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT | NFT_SET_EVAL)) ==
 			     (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT))
 			return -EOPNOTSUPP;
+		if ((flags & (NFT_SET_CONSTANT | NFT_SET_TIMEOUT)) ==
+			     (NFT_SET_CONSTANT | NFT_SET_TIMEOUT))
+			return -EOPNOTSUPP;
 	}
 
 	dtype = 0;


