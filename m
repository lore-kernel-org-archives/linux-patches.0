Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D1E34B40F;
	Wed, 20 May 2026 17:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297105; cv=none; b=fTKquR4w7Ilnx2+x64Q84qLVePoNHzznMiZSwDZYwu0kac+w4SKslYmGMw7JqXV11hfYt+l5MGMExrmk6mdzaLw3jhq94pOktBio6snQl2c0ot0DhEpNwfb1MkMrqGsxMR1lzXBtoXsLkeSptNcwJliX09xv4tKSAoV1PaD4WBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297105; c=relaxed/simple;
	bh=IWWYsu1Hv7KLqaWq7NrknnMkNcDX41cRd+kmCbKmcNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jIWSrilLELzrUgWW/zC1M1W4bZkUcjxMs1b9uX+hq72QAgODxV5AQTub1Fz3aKq9aYsyw+A405TMp0p+GS2PWkFVguLT/Yu1ETbm6rLRosEVy7ncSGp8uVV/kjJw+pUHxymE4K1/nrYU6J3ZlYO+eSf9xU4NAHEu4+xBdsbVsQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q1xmaDhG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q1xmaDhG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AC91F000E9;
	Wed, 20 May 2026 17:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297104;
	bh=MaS4Pc+uF+E5JkWkPpX4x7p3fcDgg2Dx9KU4iv80fiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q1xmaDhGFFBIFoduReLNKxMmnqFqnB9Zxg1aFi3midJRCbinsw9lYSSHYvMxhMFNK
	 JihQkBaihSQt+g5CagGMwiD+Jfh/FPP8ttJYBxgLDHj3mMP5oUlzdfNrjP/bjz9Eb3
	 MBdC9G7eqyAU4AfrHuk2dUNDng/ouxhecflYYpZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Xiasong <lixiasong1@huawei.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7.0 1053/1146] netfilter: nft_ct: fix missing expect put in obj eval
Date: Wed, 20 May 2026 18:21:43 +0200
Message-ID: <20260520162212.066451219@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1381,6 +1381,8 @@ static void nft_ct_expect_obj_eval(struc
 
 	if (nf_ct_expect_related(exp, 0) != 0)
 		regs->verdict.code = NF_DROP;
+
+	nf_ct_expect_put(exp);
 }
 
 static const struct nla_policy nft_ct_expect_policy[NFTA_CT_EXPECT_MAX + 1] = {


