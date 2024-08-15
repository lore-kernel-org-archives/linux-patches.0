Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4A437703;
	Thu, 15 Aug 2024 00:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723683326; cv=none; b=fYcftXjAWES/ppjsl/djdmZIhJu25dgOx77hwvdnIyIug+2AvUJGH0N+JlzzSfFWPFNR8uH7KdW3k0zwjRyslrkHFanSHTiuB3dw94/Zrp1fLy1yjH7LJO38cBzvwxWjSYI2ih2MjX4WvzvTE2dkAikRoCSgZ/nysWl7+CgvfQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723683326; c=relaxed/simple;
	bh=CUXMU5RNONvX+dWQJlri36R6b12h6vceVMEZgEMo35M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g4QTct9VFBoTZXxv4BmL97dtCRlGmgz/JI8j/5vQgD5ZGCltAY2RY6bi+GPkat7erLDgUXQIx7N0i7hTu9eo8CT5pVEG25xnFq+2qSSdbrYQWzvH+Vz2a34tQMDWh9s0wIOGTZYefGLYnexjLXFefCQJOTKtGBvNwTmjpV801nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KOPo9N/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KOPo9N/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216CFC116B1;
	Thu, 15 Aug 2024 00:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723683326;
	bh=CUXMU5RNONvX+dWQJlri36R6b12h6vceVMEZgEMo35M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KOPo9N/WtWzGld6aEUf8WUOcFtCMRPcXCsE0cReM6Q0IvgB5ePo0OO6oflHXg7K3N
	 UsvvK87/zX/X6s50Auff9KsQzAp2vAlQG2F3MrJNt1Xc218SWfXjP5kcJhasuzGmBn
	 kzcsyr7kyNWS2DBfChx0jRQoGtHTChAZzlybC/7mayZEq3s9AE0OBRLPUYlv+CxkH0
	 sD8xyWbjaupVRHaN7ybR3GSDRJiIGCXjuz9TESmwyTIbSCXAGQ0axia7cv8lfJUABc
	 MkCNloXFQnysttX/JpU9TuLFbTfAHDpdSpTiPSSRgPXlcgAZQ1sK1FhRPu0OCakWP0
	 o+EhI+S5UHccg==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 09/12] clk: Prevent unregistered clk_hw from being reinserted into clk tree
Date: Wed, 14 Aug 2024 17:55:15 -0700
Message-ID: <20240815005520.1192374-10-sboyd@kernel.org>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
In-Reply-To: <20240815005520.1192374-1-sboyd@kernel.org>
References: <20240815005520.1192374-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The clk framework removes the clk_core from the clk tree by deleting the
'child_node' hlist for a clk_hw when it is unregistered in
clk_unregister(). This removes the clk from the clk tree, but a call to
clk_set_parent() will allow the clk to be added right back into the clk
tree, undoing all the work done in clk_unregister() to remove it from
the tree and orphan all descendants. This results in a double hlist
delete as well, because clk_reparent() deletes the 'child_node' hlist
before adding the clk to either the orphan list or the clk tree.

The 'clk_nodrv_ops' have a set_parent clk_op that returns failure, but
that still won't save us even if we fix the clk_reparent() code to
operate on an empty list. That's because we'll reparent the clk back to
the original parent when the clk_op returns an error, effectively
putting the clk back into the clk tree.

Force the number of parents to be zero in clk_unregister() so that
clk_set_parent() can't get past the part where it figures out which
index to use to call the clk_op with.

Cc: Nuno Sá <nuno.sa@analog.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Fixes: fcb0ee6a3d33 ("clk: Implement clk_unregister")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/clk/clk.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index a0c275e156ad..d99d2d4dd411 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -4611,6 +4611,11 @@ void clk_unregister(struct clk *clk)
 	clk_core_evict_parent_cache(clk->core);
 
 	hlist_del_init(&clk->core->child_node);
+	/*
+	 * Prevent clk from being reinserted into the clk tree via
+	 * clk_set_parent()
+	 */
+	clk->core->num_parents = 0;
 
 	if (clk->core->prepare_count)
 		pr_warn("%s: unregistering prepared clock: %s\n",
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

