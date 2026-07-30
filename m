Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82318373C1A;
	Thu, 30 Jul 2026 15:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426233; cv=none; b=tp+jFw85Hxx7xrQgF+dk4k8hPSe1pPw3SzN2LR/1nEQGvKlWNw05ivI1yhQBIvuSFBk8yW2ZSLFSneDxQiszrzPz8DDwu/zK2yFbPBbkSaBap7TmeHHqRx/baBG0v8YsJs1ANAqzcMkUg96BBOAMpeHSAbFXFfAcbxqnrX4fw68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426233; c=relaxed/simple;
	bh=oP4IGst5BZq1aIZxVP2b28Rt8piFsdH1pp6ZxwxcdLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G9t0HtehvFhoEamPVF3wIO8gRIxNajAkTLUeOGSk/cD6UQg4LUbtaWX7ph6fTun6Df6c8Ix+mXYh0v3s4o9D4BSNLAyo4v8crCuWuxRHZK7xlnOi+XxiaFBvcjDsAuZGCf4ssai4ZkWxOzCexMEAovEEqLiZyGBnWgzGWW7anvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=io2a1lEa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="io2a1lEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1C81F000E9;
	Thu, 30 Jul 2026 15:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426232;
	bh=LHv8JfkjcvQs9Dhi/PtAOMWai1CJ8RY1VWCNAAtgXFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=io2a1lEaEgLQ2n6sEh4J6eg7xkKfS45vY4T2ggsmJ4nFEOCbEHBhWOwT0gQjN/Mqj
	 aeGKNP0QQq0FVghNASPw+N47zGERB+n/R8FFLpbD/bo8/Faq7/B+KgHc9o+jb2BNBP
	 KK8NmITYC680z6sYbDfmCUx1pidpVf8RTL3b+jxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 347/602] wifi: mwifiex: fix NULL dereference when the AP has HT-cap but no HT-oper
Date: Thu, 30 Jul 2026 16:12:19 +0200
Message-ID: <20260730141443.251998192@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doruk Tan Ozturk <doruk@0sec.ai>

commit c3d68e294cbb6a4090bb219d3dcaca85a011809b upstream.

mwifiex_tdls_add_ht_oper() gates its follow-the-AP-bandwidth path on
bss_desc->bcn_ht_cap being present, but then dereferences a different
pointer, bss_desc->bcn_ht_oper:

	if (ISSUPP_CHANWIDTH40(priv->adapter->hw_dot_11n_dev_cap) &&
	    bss_desc->bcn_ht_cap &&
	    ISALLOWED_CHANWIDTH40(bss_desc->bcn_ht_oper->ht_param))

bcn_ht_cap and bcn_ht_oper are populated independently while parsing the
associated AP's beacon in mwifiex_update_bss_desc_with_ie(): an AP that
advertises an HT Capabilities element but no HT Operation element leaves
bcn_ht_cap non-NULL and bcn_ht_oper NULL. Setting up a TDLS link to a
peer while associated to such an AP then dereferences the NULL
bcn_ht_oper and crashes the kernel. Every other bcn_ht_oper user in the
driver NULL-checks it first.

Guard on the pointer that is actually dereferenced.

Found by 0sec automated security-research tooling (https://0sec.ai).

Fixes: 396939f94084 ("mwifiex: add HT operation IE in TDLS setup confirm")
Cc: stable@vger.kernel.org
Assisted-by: 0sec:multi-model
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://patch.msgid.link/20260716103042.88469-1-doruk@0sec.ai
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/tdls.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/marvell/mwifiex/tdls.c
+++ b/drivers/net/wireless/marvell/mwifiex/tdls.c
@@ -215,7 +215,7 @@ mwifiex_tdls_add_ht_oper(struct mwifiex_
 
 	/* follow AP's channel bandwidth */
 	if (ISSUPP_CHANWIDTH40(priv->adapter->hw_dot_11n_dev_cap) &&
-	    bss_desc->bcn_ht_cap &&
+	    bss_desc->bcn_ht_oper &&
 	    ISALLOWED_CHANWIDTH40(bss_desc->bcn_ht_oper->ht_param))
 		ht_oper->ht_param = bss_desc->bcn_ht_oper->ht_param;
 


