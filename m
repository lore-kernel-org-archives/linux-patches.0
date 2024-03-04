Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6CC1C6AB;
	Mon,  4 Mar 2024 21:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589176; cv=none; b=HEhvLTmDr1RAqkU4FHfFG6WY0JsbRdNCjO+haPhiBDTJ7lDz2SXJvdHdjmmbvhMaKWCERL/x/GosOM7rSgyd7o89OaFwkNU5Gi8weBDtZ4SNR9mDABdb75fmszqmjE6B1Wnlz92WS8zPNWQ7/IVVXSqrLQFeKvxnlUxRy/k49gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589176; c=relaxed/simple;
	bh=lvwWW0pE8GnZgPKOUzmA3aMV2HDyJQ2xKSNFMohQdeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bi/LpAgMSSw0ABqn+eCsFpeBQB97mT4pmTOxcQmzyj/oMVJuZ4xhSnvgv3Xtnm9kTR44TY/h1Oj1NKEKLlgj7+uU4xtyROHyJr5ngq8zsh8lA71i4/oeONPS4Ez3dnkhPL4KFCGU8zmNL6PM3m8wL4XrtwtjzRe6azRNaH58Qig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e3yD/+pP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e3yD/+pP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0D4C433F1;
	Mon,  4 Mar 2024 21:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589176;
	bh=lvwWW0pE8GnZgPKOUzmA3aMV2HDyJQ2xKSNFMohQdeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e3yD/+pPK5tfGaA4WjK3hl5UY5mF0MW3DvehdICs0zgZ9QkKL/7oZFc+mZxLQJmBx
	 ZAxlObrKwqpidVbFR8nsN4+3OeZ4ISrrdbplQpaX/Gi62bMRh9LZx7gc6pV1bCJvsq
	 Xip/VIWXJNRGDn64d4E7WIO7m7DwF2wTr64UcvQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 01/84] netfilter: nf_tables: disallow timeout for anonymous sets
Date: Mon,  4 Mar 2024 21:23:34 +0000
Message-ID: <20240304211542.384534173@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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

commit e26d3009efda338f19016df4175f354a9bd0a4ab upstream.

Never used from userspace, disallow these parameters.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4682,6 +4682,9 @@ static int nf_tables_newset(struct sk_bu
 		if (!(flags & NFT_SET_TIMEOUT))
 			return -EINVAL;
 
+		if (flags & NFT_SET_ANONYMOUS)
+			return -EOPNOTSUPP;
+
 		err = nf_msecs_to_jiffies64(nla[NFTA_SET_TIMEOUT], &desc.timeout);
 		if (err)
 			return err;
@@ -4690,6 +4693,10 @@ static int nf_tables_newset(struct sk_bu
 	if (nla[NFTA_SET_GC_INTERVAL] != NULL) {
 		if (!(flags & NFT_SET_TIMEOUT))
 			return -EINVAL;
+
+		if (flags & NFT_SET_ANONYMOUS)
+			return -EOPNOTSUPP;
+
 		desc.gc_int = ntohl(nla_get_be32(nla[NFTA_SET_GC_INTERVAL]));
 	}
 


