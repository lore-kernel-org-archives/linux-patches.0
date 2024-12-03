Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5121F7583;
	Tue,  3 Dec 2024 15:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239565; cv=none; b=OzeVhbfJeTVoT3ZbM5tlvGbHoYakoDcpKJJzBtU0zbNLIaZiyGKQKrFaua8p7tD7+MUtYBHEsTWLF7WSfoANSIUxLH6am6FTJICfqbJq3pj7HSTPZoYEjKVpt5YzUpIrs6yxTgeTBqBYIVzWMx0a22OC0c4zTGAjY74Ywwk3tZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239565; c=relaxed/simple;
	bh=qFvJlvz5NUahhFE6Z5u1zhp9PPUL+YykXkUc0vn2w7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=soYrg9jFEVZcbaBStqpdjz/PBn/J+Q6vBskRBTQoWG2muHW0Q0IFPFtPtqwqZXlD1qkAo9hXrJ7arMlISOuGxnbUwCKUQ7mZvObiWaieIvd6gtCfMZCHksRhEO28uvtb7g2K9CJyARekZHY+m8k5fMIVue2ymt6Wv8sQyzUtQsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SrBj40H/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SrBj40H/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47DFC4CECF;
	Tue,  3 Dec 2024 15:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239565;
	bh=qFvJlvz5NUahhFE6Z5u1zhp9PPUL+YykXkUc0vn2w7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SrBj40H/f6qfdv+c9DyrjVsbhMe1nH75LEMMCyTAR6IooolRJO9b0bhkTmoUd7TYO
	 rd1HDTAsUv/WgiFfDjDUVq9Sq3h5UfAhtsjmwGpB36thCtSIFkIU1jogqRBJEBgRM8
	 KA35lE6guQxaUcErtJFAl9Lsu2/UxHQ1CmMWF7tI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.11 658/817] clk: clk-loongson2: Fix memory corruption bug in struct loongson2_clk_provider
Date: Tue,  3 Dec 2024 15:43:50 +0100
Message-ID: <20241203144021.643077128@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/clk/clk-loongson2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk-loongson2.c b/drivers/clk/clk-loongson2.c
index 820bb1e9e3b7..e99ba79feec6 100644
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
-- 
2.47.1



