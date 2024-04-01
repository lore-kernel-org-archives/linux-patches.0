Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8721DC129;
	Mon,  1 Apr 2024 16:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988607; cv=none; b=hxdpK4Um+/gilDKXcnc8FZooBAxTnRuqORRVdHuhpM+nKVPg6vm6Z9lhGf0tv2LlhH1Al15eirUyJDdLp82tuhrNslLH2rc9i69JutiIgR3YefzWHI5V9t8emxE1yqOoxaoiLjUOlzKlzpnDHnT84c7qEYbjkjeoBCrvPvsvusY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988607; c=relaxed/simple;
	bh=3+NE2ndaQxTs3wPX+W9ztobtnT4yxHAKWc4TLGJJF+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Up+PDB73F7eEbuQd85IV4xwlXVw6gmM1IWxS0JZfl5hirtbRZuVdgPFGt6Cw0/hDHhSHbfsuome9V1szLQnbnidI/Dqphj3hbL2IAj9365P3FuAyUiOuKRLW/NBKo88aMCBxF+54kZLNlK3uda5/G0kqiQPHCgDX2hATKcSaLUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvagbn01; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvagbn01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BEFC433F1;
	Mon,  1 Apr 2024 16:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988607;
	bh=3+NE2ndaQxTs3wPX+W9ztobtnT4yxHAKWc4TLGJJF+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jvagbn013JFMi3Pn2nu1//WD37QXKcOr1841ll86gdI08OhOX1xsKN92k2pKN5WNf
	 rbJK6UeHlQ1Zk9H7/AS3FB/TnHPxdWphaC0cxawLtHnPHCXn2JwDhHMOHiYTvOTdTV
	 mucIZWBzekdWz5L7GJhtirZa09IJphNwfxeNddYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.7 236/432] netfilter: nf_tables: reject constant set with timeout
Date: Mon,  1 Apr 2024 17:43:43 +0200
Message-ID: <20240401152600.178588198@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5003,6 +5003,9 @@ static int nf_tables_newset(struct sk_bu
 		if ((flags & (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT | NFT_SET_EVAL)) ==
 			     (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT))
 			return -EOPNOTSUPP;
+		if ((flags & (NFT_SET_CONSTANT | NFT_SET_TIMEOUT)) ==
+			     (NFT_SET_CONSTANT | NFT_SET_TIMEOUT))
+			return -EOPNOTSUPP;
 	}
 
 	desc.dtype = 0;


