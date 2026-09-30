Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9143AEF2E;
	Wed, 30 Sep 2026 18:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793148; cv=none; b=aWhlq15jITvdiitz0DgXZlURqXXL554o24WeOUYgHUq/mPwh6L4g4a1bPPdF2JdbP6eMN8da4UkV0VjO+iQD9vyBLKyBSZEp3XKHk7jetw3qxYQDAFL/wQm9klib0h6qw1qNvtqTKcYRFS9G2CcQ1kLm02EpSsa0plPo1HtwGS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793148; c=relaxed/simple;
	bh=kv4McdVRnmHilhDXF6g/itqf4GRIVOci9pgPqhdTrYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZBMisrW5Dy3p+sOZ5NxudN9AyEHYYO8IrMh8nkii7nhX/Ed0PW1qC2Uo3JBYmiSp9SHgQt+qJ5c9/tIbvg1rybKEEkI5ME5SeK8qA9PWIVY4T1NgcjkYd9o2dcpellcMT67kF3mM7OS/rmCZPlgtA+MlnUtL7AKTnjdE7f3uxzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fGzrNyVU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fGzrNyVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5931F000FF;
	Wed, 30 Sep 2026 18:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793147;
	bh=VQ/fLVGeQ9fX0QLXH8uIV7h0yeewVBem38HSKcsrYiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fGzrNyVUC2ml4GwvUZBhqZLIBtIShM0a5V22wmkJgREsrB6nPzZ4kmjYeu0Xz/P4m
	 tp6R5WwUdZmY3p8kw5unccnaudQxOnE19wgn5V5j2CUYd00jx4sqMk5tRmVMUeqPZV
	 bjru0xzAtlO1wopmgrd6GH4y7ZJFjzUGjwsr3G7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Coia Prant <coiaprant@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 125/395] net: pcs: xpcs: fix clock reference leak on xpcs_init_clks failure
Date: Wed, 30 Sep 2026 17:26:27 +0200
Message-ID: <20260930152343.356132598@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Coia Prant <coiaprant@gmail.com>

[ Upstream commit 9892d71cf0ce3ff3d4fed2d9a3968fd4feb1c918 ]

xpcs_init_clks() takes references with clk_bulk_get_optional() and then
enables them with clk_bulk_prepare_enable(). If the enable step fails,
the function returns without dropping the references.

xpcs_create() handles the failure through out_free_data, which calls
xpcs_free_data() but never xpcs_clear_clks(), so the clk references are
leaked.

Add the missing clk_bulk_put() on the enable failure path. The
prepare/enable side is already rolled back by
clk_bulk_prepare_enable() itself.

Fixes: f6bb3e9d98c2 ("net: pcs: xpcs: Add Synopsys DW xPCS platform device driver")
Signed-off-by: Coia Prant <coiaprant@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260919172021.2336748-1-coiaprant@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pcs/pcs-xpcs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 14c4b10fee74c..495068c3642c6 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -1430,8 +1430,10 @@ static int xpcs_init_clks(struct dw_xpcs *xpcs)
 		return dev_err_probe(dev, ret, "Failed to get clocks\n");
 
 	ret = clk_bulk_prepare_enable(DW_XPCS_NUM_CLKS, xpcs->clks);
-	if (ret)
+	if (ret) {
+		clk_bulk_put(DW_XPCS_NUM_CLKS, xpcs->clks);
 		return dev_err_probe(dev, ret, "Failed to enable clocks\n");
+	}
 
 	return 0;
 }
-- 
2.53.0



