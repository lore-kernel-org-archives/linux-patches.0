Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5204E1F76AD;
	Tue,  3 Dec 2024 16:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242265; cv=none; b=BvRXYJ76tPJiHN2jKVlRZdnWhe6Li1Nfaxm6K5rEFuNHez27yXpKxF2OBnB3Nm7icHqAGcT4AuND92ZTc2SYB7mIuJfMYX2t9NC5Hu0+kjgEanUyM0Vp1MTRzWZYSyygNcBEI5CkOj7uoyBNhbghX/05HerjbC3LURxfbemmxTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242265; c=relaxed/simple;
	bh=R0MAHwOaYNnGV1q9W4oHRq5TPT9/SGTShumxk3K9pD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/v47oO3dtvbMHUy3vu0tpZToNc1Ky0Rgox4nWnRISO4eSLKUTR4t7+hyd2nJ4/6FibT4UGxIL0MpHgi94N/DT5atOqRWX7HzfPOKc9/xYqJPU/HqnH4zRPMoPDTo2smzTgY3jOYb3fJ79DYTn1mPz4hoKmgtMXA0HgDbc7fHMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TF/zOxki; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TF/zOxki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA74BC4CECF;
	Tue,  3 Dec 2024 16:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242265;
	bh=R0MAHwOaYNnGV1q9W4oHRq5TPT9/SGTShumxk3K9pD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TF/zOxkiKkCqK8EuGe2J6gDmUO/u6+LRmQkFRKgequUAH5K06Ox/IlMh7bB9eu8VY
	 ujU5ChNa7jQ5oCntNM+q1J52SllfG0QzmVbkhpmXd0tTUgkQ/0Hhy3sfGphkMTzxti
	 +JFOlUPS1fTKzrfA6iBw2DvsxC5SQ8T4TyG30bPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.12 656/826] clk: clk-loongson2: Fix memory corruption bug in struct loongson2_clk_provider
Date: Tue,  3 Dec 2024 15:46:23 +0100
Message-ID: <20241203144809.344093107@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo A. R. Silva <gustavoars@kernel.org>

commit 6e4bf018bb040955da53dae9f8628ef8fcec2dbe upstream.

Some heap space is allocated for the flexible structure `struct
clk_hw_onecell_data` and its flexible-array member `hws` through
the composite structure `struct loongson2_clk_provider` in function
`loongson2_clk_probe()`, as shown below:

289         struct loongson2_clk_provider *clp;
	...
296         for (p = data; p->name; p++)
297                 clks_num++;
298
299         clp = devm_kzalloc(dev, struct_size(clp, clk_data.hws, clks_num),
300                            GFP_KERNEL);

Then some data is written into the flexible array:

350                 clp->clk_data.hws[p->id] = hw;

This corrupts `clk_lock`, which is the spinlock variable immediately
following the `clk_data` member in `struct loongson2_clk_provider`:

struct loongson2_clk_provider {
	void __iomem *base;
	struct device *dev;
	struct clk_hw_onecell_data clk_data;
	spinlock_t clk_lock;	/* protect access to DIV registers */
};

The problem is that the flexible structure is currently placed in the
middle of `struct loongson2_clk_provider` instead of at the end.

Fix this by moving `struct clk_hw_onecell_data clk_data;` to the end of
`struct loongson2_clk_provider`. Also, add a code comment to help
prevent this from happening again in case new members are added to the
structure in the future.

This change also fixes the following -Wflex-array-member-not-at-end
warning:

drivers/clk/clk-loongson2.c:32:36: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

Fixes: 9796ec0bd04b ("clk: clk-loongson2: Refactor driver for adding new platforms")
Cc: stable@vger.kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/ZzZ-cd_EFXs6qFaH@kspp
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/clk-loongson2.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/clk/clk-loongson2.c
+++ b/drivers/clk/clk-loongson2.c
@@ -29,8 +29,10 @@ enum loongson2_clk_type {
 struct loongson2_clk_provider {
 	void __iomem *base;
 	struct device *dev;
-	struct clk_hw_onecell_data clk_data;
 	spinlock_t clk_lock;	/* protect access to DIV registers */
+
+	/* Must be last --ends in a flexible-array member. */
+	struct clk_hw_onecell_data clk_data;
 };
 
 struct loongson2_clk_data {


