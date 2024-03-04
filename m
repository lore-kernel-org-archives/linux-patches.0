Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986857868F;
	Mon,  4 Mar 2024 21:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588557; cv=none; b=C3sUywkbbNAHsF5neCQ8xTlQY7FjR1lvXs5ou9dsPdOPY0qwxi17Wf0qXNUPOjIrW+TGuejKHVWS0NHnstswv0z0GidofnzgHm8hhJWb4sTsojrwvRVyvld5Jl2O9okX1FaXDNV33u7QNXTAxc1OdtHRjXRwYCdz7ua5as49yr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588557; c=relaxed/simple;
	bh=xQifYyR6YVaXRGob2JEoJD+PsWZ9SGlF1UKn3xNYc6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPe9bWlWRsvMwB3279UNmKR9D8XJXBCw6RzLLQQINwpyLenE5UwhhsEQB7IqzkDrvpxRvvUTniAg4y/keT9ItSyg7Mp/YZ2/rc400G8YmIFLj62wixiWSz8FNRkEWOqkJnwDSNBfcqDbhRYkbKjolxnK/AmwqXeRGz7rSMRSuQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mRbt9uyj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mRbt9uyj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A36C433F1;
	Mon,  4 Mar 2024 21:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588557;
	bh=xQifYyR6YVaXRGob2JEoJD+PsWZ9SGlF1UKn3xNYc6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mRbt9uyjsSI+1fd4/5f6jP85ruXnyvWtPmz61nXmCDtbSCJj6eyf20uEj0l+ZOdhQ
	 HOCRlQv+1kLNZ9KYpHgs5ILTdgCRlyeUnPVK/iJJyxJ1spLGzep7fIzE8NX5tjgIBn
	 43EmG3aV3nGVqLb38/vXYK++pZjrlRQr3fTYO+oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.1 001/215] netfilter: nf_tables: disallow timeout for anonymous sets
Date: Mon,  4 Mar 2024 21:21:04 +0000
Message-ID: <20240304211557.045931635@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit e26d3009efda338f19016df4175f354a9bd0a4ab upstream.

Never used from userspace, disallow these parameters.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4752,6 +4752,9 @@ static int nf_tables_newset(struct sk_bu
 		if (!(flags & NFT_SET_TIMEOUT))
 			return -EINVAL;
 
+		if (flags & NFT_SET_ANONYMOUS)
+			return -EOPNOTSUPP;
+
 		err = nf_msecs_to_jiffies64(nla[NFTA_SET_TIMEOUT], &desc.timeout);
 		if (err)
 			return err;
@@ -4760,6 +4763,10 @@ static int nf_tables_newset(struct sk_bu
 	if (nla[NFTA_SET_GC_INTERVAL] != NULL) {
 		if (!(flags & NFT_SET_TIMEOUT))
 			return -EINVAL;
+
+		if (flags & NFT_SET_ANONYMOUS)
+			return -EOPNOTSUPP;
+
 		desc.gc_int = ntohl(nla_get_be32(nla[NFTA_SET_GC_INTERVAL]));
 	}
 


