Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8462B368968;
	Wed, 20 May 2026 18:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301711; cv=none; b=qbtM9NdjbGwqn2+XdTKFnnnJ5zZa9EWAFb/8aupzKrSijKUSsKY4HUn13lLiA7/2bv5VOhRx/FVVv+ABr+K8HrcjTNeyH/2FSs+JzinCM1mLkCcakG0O1UAj7Y3Q1513m4EBkWnTnq/lcorv7caGSEY6nRTXMuNGb6jIjG9RvOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301711; c=relaxed/simple;
	bh=xSs+ZZFxa11VCWBoSRTyJiNSqJVExE6FIchfGD9G+Ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nnAFlTfWdg5qdqBY+6lTC1IXRgwjiza/rvcN6+FEfxXWikRBAHSKVRKWMRW25Hd395sSLPccv66wAIRwGBPRKM7rH56R78VL5IUVI+/rQAXBGFVtQ/Z4/3yXqtTM0ewTRzz78BH58ZpbthMCOVG9r4sDLUSzNyiaSj6JeQHVlU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L9Qm+4/D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L9Qm+4/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B524F1F000E9;
	Wed, 20 May 2026 18:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301710;
	bh=onP7+XwP5fGfaVbwFlhChO68o75tnaXRziHf0ieQytk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L9Qm+4/DETc2eDCsG4O+IrI9F+wF5yOqpGLKCa62DOPAYzSVqRZ7qYMUm8uVnkQAf
	 TpBQOQARAbXgEaqmJJJMENq0eqL7CXmso+MR6CkTz0/yFNYQ/0BB1MB29dOr4gAKN8
	 W34AQzOW7hIwCYpihM6ThHvdTDLGwNmci6RbhHkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Xiasong <lixiasong1@huawei.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.12 616/666] netfilter: nft_ct: fix missing expect put in obj eval
Date: Wed, 20 May 2026 18:23:47 +0200
Message-ID: <20260520162124.622755825@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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
@@ -1363,6 +1363,8 @@ static void nft_ct_expect_obj_eval(struc
 
 	if (nf_ct_expect_related(exp, 0) != 0)
 		regs->verdict.code = NF_DROP;
+
+	nf_ct_expect_put(exp);
 }
 
 static const struct nla_policy nft_ct_expect_policy[NFTA_CT_EXPECT_MAX + 1] = {


