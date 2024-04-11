Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5259F13E897;
	Thu, 11 Apr 2024 10:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830683; cv=none; b=rpBvFEJWKi5KrIhjwAN/LA0QbTxD3PQN2sJA+pQDNfVMIGnNrGGD2QSkUcKM26lJUnkQHDt43LVEt3V2ZvYnj9C4z/h3+ply70UMEOCtnq0vov63WrYV/v3trUIGZIsV7JPEWDh7ms68qZd6HrUofx9djrZmA75d169MQIltQr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830683; c=relaxed/simple;
	bh=+K0TqwW6UZ7hHFehbXi1ELh+gYjjhMdwgDYrgOlDNmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XB0C2+0VHUDTMNopLTYLv987H0qq0x+OjuabCmBuLSPh+2LsNhTI0ZebojUw07r0Oao3HIPrcA91uRI/mClCWXsddtBAIu0njlEckbWh3b1UF7D1Y8NgJAGhrpEqqVN6szMbl/jTxxVK4p6QavQKoHGggAcAXACzbHE4bBTQ8es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DpgKUt2D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DpgKUt2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E17C43390;
	Thu, 11 Apr 2024 10:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830682;
	bh=+K0TqwW6UZ7hHFehbXi1ELh+gYjjhMdwgDYrgOlDNmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DpgKUt2DXDG5uwbmEQdL22gA8xFyk8Zr0xR+lfwmKG4uGnR1kOvQwqiGEk8un0d5I
	 ms438DywqBARMnDWYgzzZMU8aiSZAXOSXmdLhKqFpBFEIttJBYEYEZmg7bSEg6h6z/
	 6zhlYsP+GmUJ62Kz50CSzBi28snBC3v/kr9PlVDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 083/215] netfilter: nf_tables: reject constant set with timeout
Date: Thu, 11 Apr 2024 11:54:52 +0200
Message-ID: <20240411095427.403173552@linuxfoundation.org>
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
@@ -3772,6 +3772,9 @@ static int nf_tables_newset(struct net *
 		if ((flags & (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT | NFT_SET_EVAL)) ==
 			     (NFT_SET_ANONYMOUS | NFT_SET_TIMEOUT))
 			return -EOPNOTSUPP;
+		if ((flags & (NFT_SET_CONSTANT | NFT_SET_TIMEOUT)) ==
+			     (NFT_SET_CONSTANT | NFT_SET_TIMEOUT))
+			return -EOPNOTSUPP;
 	}
 
 	dtype = 0;


