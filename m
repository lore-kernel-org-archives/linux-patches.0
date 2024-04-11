Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9042EAE5;
	Thu, 11 Apr 2024 10:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829691; cv=none; b=gUB/v02IeZZRaOqhwjUPgcrpGkZe94qlNRS24550FycVTdl/00UgDhnxsi/eZKK8OykdjSckK1IU4vZGIbT5m2wVjM5OVzlr0ShekaWui7Z/bRvp+y9tZ9XIEq5DYeakURaj6Xeh45aqGPHMkI5TECy7hk27s0B4wpO+aC15QwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829691; c=relaxed/simple;
	bh=riXYv17jC8rrELGT+PrGobHZS5ZcDceK9rFBn9qbOBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C64ijgH0rZz8lubWM1Vv0MTYXe14kMRCmYKkSJnM0HYmintOFKFYBOMQb7DZRwsrR3O+GfseNQzvmOBh1HxF7tpLwFVTq2QB/nflNsd7v1l6OciA9bsLwYAlKhnZMfut7tDwZS1FBi19FIFOPGiu+rWFCctB3rJwoJ8iDzhNiT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3kdWEEP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3kdWEEP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744A9C433C7;
	Thu, 11 Apr 2024 10:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829690;
	bh=riXYv17jC8rrELGT+PrGobHZS5ZcDceK9rFBn9qbOBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w3kdWEEP2b5tp6kSi+7OhfIQpRAQk9PBAgu4hl3yKOLgpUtQSTx2P9GjUjunAfM/z
	 BTSzdxuR1u/334swruxsaokPD+6onMo0iPlSIjpZ8PMA9iumP9jiQfpw9JXwWIXLzh
	 1n9Imnv8mfyTUO+KI3bv/lC6ij/3qCpGnh3pjX6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 071/175] netfilter: nf_tables: reject constant set with timeout
Date: Thu, 11 Apr 2024 11:54:54 +0200
Message-ID: <20240411095421.702140689@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3563,6 +3563,9 @@ static int nf_tables_newset(struct net *
 		if ((flags & (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT | NFT_SET_EVAL)) ==
 			     (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT))
 			return -EOPNOTSUPP;
+		if ((flags & (NFT_SET_CONSTANT | NFT_SET_TIMEOUT)) ==
+			     (NFT_SET_CONSTANT | NFT_SET_TIMEOUT))
+			return -EOPNOTSUPP;
 	}
 
 	dtype = 0;


