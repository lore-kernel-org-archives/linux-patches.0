Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE7E29B799;
	Sat, 30 May 2026 18:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164891; cv=none; b=Zf9EEaWwDZj0+f+ONX4KhB2j3z5t+SCqFbwZLqsiQeFx8i+qz7Q7v4qIDTabTax9le3weXBQMMjO0rNpbjdx99gFjpcGLV/4oJQRyl+4CHeEJ0Nk8zrvKdOmPNkJMvi6aialTRUeGQP0J73gtzYhTotEwTJkFrCYWmFBIkQCOXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164891; c=relaxed/simple;
	bh=+AAfeS6dr4Og/oTKn6nPZUfKJCghsb/dBv4YtJVolcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5FF+FbIsMD+t5JEZ/+Zh1mGzCSFGnjE9k6yrTtXi1duZDSKuoezpSYN05rgFgvk3e+TGXIKVRXJnE1vGGZlMtIUUpt5i37aGY+yYP7YC51pGH+yK9aD+aYjBauruAEgVW3CkSqzdwwG4JlwODFQ9y0d5VZqvpCdSD/qVnNYVys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vWxEcHgw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vWxEcHgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B423D1F00893;
	Sat, 30 May 2026 18:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164890;
	bh=ynYYAvzS7+qKxo0hvuMC3+2K3tFRt5dYiG5PycIs/NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vWxEcHgwlDmujXaEXhawqSknL2BWbXxRdXG4XQw7tq310/cRirbH2cblwR47KffZI
	 KBspLXXFtRBbrL0K6Jxi3PV20u067Qqpz5wVtxTAmbbSmjnHug3lVLnE56vkirDGoa
	 J6l3xiUTBCqgOqcRFeFMRmB+/4CGBHJFatjNK4lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Xiasong <lixiasong1@huawei.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 650/776] netfilter: nft_ct: fix missing expect put in obj eval
Date: Sat, 30 May 2026 18:06:04 +0200
Message-ID: <20260530160256.722610988@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Xiasong <lixiasong1@huawei.com>

commit 19f94b6fee75b3ef7fbc06f3745b9a771a8a19a4 upstream.

nft_ct_expect_obj_eval() allocates an expectation and may call
nf_ct_expect_related(), but never drops its local reference.

Add nf_ct_expect_put(exp) before return to balance allocation.

Fixes: 857b46027d6f ("netfilter: nft_ct: add ct expectations support")
Cc: stable@vger.kernel.org
Signed-off-by: Li Xiasong <lixiasong1@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_ct.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1299,6 +1299,8 @@ static void nft_ct_expect_obj_eval(struc
 
 	if (nf_ct_expect_related(exp, 0) != 0)
 		regs->verdict.code = NF_DROP;
+
+	nf_ct_expect_put(exp);
 }
 
 static const struct nla_policy nft_ct_expect_policy[NFTA_CT_EXPECT_MAX + 1] = {


