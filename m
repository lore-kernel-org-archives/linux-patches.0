Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB52145353;
	Thu, 11 Apr 2024 10:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830680; cv=none; b=lxOvI4zF5KsWo40ghXNIu4ox1I4TFft5t9RoYjU/BYmHII96gZX/rTYPptxXiCJnzmOtwiodkXLr1os59aL0PWRE1P1ORIR03Sk7AUT5xYLlytIB4l0Z5Y5Wl3UHrcDbsMUGs3zpGSMoKsCYncKv5O11krGjO7pWCtxd3E79FCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830680; c=relaxed/simple;
	bh=ZjTc+/dY+3mre5ucNVgmgmDahZj4abuaHML8evF71gU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDpdGdUT+eKjIGA04FDv/cKzPiYe7mcYnl/9Y46BjvNtDWhPxYoopZ8OpYlfr1c+mBCTqftYIuVCYXRsAjhPFHs3bG0cSJX4AiPIw8z2N/+AH21PrJ+pTLQYbPLbaGdZIXVPifOKEM1sOfMkwfl9BdQfW8OfXQ32VeRf5E4v83o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=abuMOmfP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="abuMOmfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18FADC433C7;
	Thu, 11 Apr 2024 10:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830679;
	bh=ZjTc+/dY+3mre5ucNVgmgmDahZj4abuaHML8evF71gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=abuMOmfPTHm2c9LqfUJF4mi9UVsA8AsYwyw/EJ+hI+WNYuM6LWBKZHUpzcA3KaYsc
	 U2nUJWH1E6m8RxhIb4g+GBLkV965ZNwJHOxkYgLaec/0G+iOmvnhRz61XxU7t4bYz7
	 G+ErSOchIXoBaSQIqkNiuGVf7iS2idn5qV1JIb6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lonial con <kongln9170@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 082/215] netfilter: nf_tables: disallow anonymous set with timeout flag
Date: Thu, 11 Apr 2024 11:54:51 +0200
Message-ID: <20240411095427.373504289@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 16603605b667b70da974bea8216c93e7db043bf1 upstream.

Anonymous sets are never used with timeout from userspace, reject this.
Exception to this rule is NFT_SET_EVAL to ensure legacy meters still work.

Cc: stable@vger.kernel.org
Fixes: 761da2935d6e ("netfilter: nf_tables: add set timeout API support")
Reported-by: lonial con <kongln9170@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3769,6 +3769,9 @@ static int nf_tables_newset(struct net *
 		if ((flags & (NFT_SET_EVAL | NFT_SET_OBJECT)) ==
 			     (NFT_SET_EVAL | NFT_SET_OBJECT))
 			return -EOPNOTSUPP;
+		if ((flags & (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT | NFT_SET_EVAL)) ==
+			     (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT))
+			return -EOPNOTSUPP;
 	}
 
 	dtype = 0;


