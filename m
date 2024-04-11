Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D40145FF0;
	Thu, 11 Apr 2024 10:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830847; cv=none; b=YpsYMDHRRF3oZjOdo10yx/FluZyL/qmBVYY/YxG+BPl9Pf4SsE+DC6DTQyI96Z+YSHnRyaRvQKmNkwROlLB29KKAJmxoh4whtkn9YUPBqwQWNNYdzrjpBznWmrmKXx8F2GCMHzsCu2Ad9gm1OLl7inNTKg0YAcNQis6kF82hhJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830847; c=relaxed/simple;
	bh=tlGAHC1ZiJbewfkldIFTdFjbFEtPi7L0rnlOHIY/qG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Va4tCsDvj+fVCIdKIIeLMlwOtvXc/Kz4aX4h3YX07dVAVMHQrHbDa+SvgtqbvhlV8+Op0h2RDZ5n3Wfmrv2J3FtR8rvoNIx56MYjS/ksrKY701xIq3OxqWYTyDY1SB0HNAb2EFFpkPdnW142dJLf2tgF+iJsq6kcLnMaOik49yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=laYGX+z/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="laYGX+z/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B69AC433F1;
	Thu, 11 Apr 2024 10:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830847;
	bh=tlGAHC1ZiJbewfkldIFTdFjbFEtPi7L0rnlOHIY/qG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=laYGX+z/pvl54B613+PLRTiBS7OrR3yL+SuP7q9YH5uTl1pxWgh+5JlWuMsbav1gK
	 uHL7Kh7fDo+4dXozOaX97oNIjFoNH/R8ZNRSLG6Jp6D0aBGFpIYticYBnirKyzBc8P
	 qTRp/P+VQvvr9RDGdD98GMbarJI7ce/mL8F7icCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Subject: [PATCH 5.4 137/215] netfilter: nf_tables: disallow timeout for anonymous sets
Date: Thu, 11 Apr 2024 11:55:46 +0200
Message-ID: <20240411095429.011513349@linuxfoundation.org>
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

commit e26d3009efda338f19016df4175f354a9bd0a4ab upstream.

Never used from userspace, disallow these parameters.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[Keerthana: code surrounding the patch is different
because nft_set_desc is not present in v4.19-v5.10]
Signed-off-by: Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3816,6 +3816,9 @@ static int nf_tables_newset(struct net *
 		if (!(flags & NFT_SET_TIMEOUT))
 			return -EINVAL;
 
+		if (flags & NFT_SET_ANONYMOUS)
+			return -EOPNOTSUPP;
+
 		err = nf_msecs_to_jiffies64(nla[NFTA_SET_TIMEOUT], &timeout);
 		if (err)
 			return err;
@@ -3824,6 +3827,10 @@ static int nf_tables_newset(struct net *
 	if (nla[NFTA_SET_GC_INTERVAL] != NULL) {
 		if (!(flags & NFT_SET_TIMEOUT))
 			return -EINVAL;
+
+		if (flags & NFT_SET_ANONYMOUS)
+			return -EOPNOTSUPP;
+
 		gc_int = ntohl(nla_get_be32(nla[NFTA_SET_GC_INTERVAL]));
 	}
 


