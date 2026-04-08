Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CC837F8C2;
	Wed,  8 Apr 2026 18:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671776; cv=none; b=DAy9G14NzhChRB6dRQQFVFHpg1tzomsPWtMwPQf+GX3TSQaR9FDjUe/FWXpv+iVvMUEs24IC4xn2KQ9k+DS+AParVL9/4xFsXqBV60quXcOCRSiw7iiPU8GTKpxkv84rHGHqPNHxuWrmeZdGnI94a1CSLSTwhBSJvSF1HVZJIc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671776; c=relaxed/simple;
	bh=A8z2x0Alu9IWmhS1PGm9rQfg9gBCzRdIn/YozEATbFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNMQ6pygCT4cmTtD/LnTHVgqqtP0nJvCWk8hmfv/aiTTsE0nRIXO87tNFH86cD63LRkFFgDfXK0GxmX6pL9T1nevrk1fQ0G5H9EXwmlhZkNbVlkogWINOe9mkuGXEEXMGWKFGT0gyHrlATeN1ppM8wuV1V0CoSTHPUckJgzdY8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gToFokmm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gToFokmm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D0FC19421;
	Wed,  8 Apr 2026 18:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671776;
	bh=A8z2x0Alu9IWmhS1PGm9rQfg9gBCzRdIn/YozEATbFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gToFokmmP8Uw1TvsY0ElXp0WsdfI+nqVmrj+WIynNx8ZV0mtf5Js5G8MBtQ2e5biv
	 4TUej0f0RycIpXdmNWFkgG4RIBjunnzJpiUmGX7vjiNUAZLiReDutef7XVmlKsrTd5
	 j2il4DfRiGFRKx7aK57SteyiE1lQO/siyhHzKA8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/312] regmap: Synchronize cache for the page selector
Date: Wed,  8 Apr 2026 19:59:41 +0200
Message-ID: <20260408175936.130905331@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 09e70e4f119ff650d24c96161fd2f62ac7e424b0 ]

If the selector register is represented in each page, its value
according to the debugfs is stale because it gets synchronized
only after the real page switch happens. Hence the regmap cache
initialisation from the HW inherits outdated data in the selector
register.

Synchronize cache for the page selector just in time.

Before (offset followed by hexdump, the first byte is selector):

    // Real registers
    18: 05 ff 00 00 ff 0f 00 00 f0 00 00 00
    ...
    // Virtual (per port)
    40: 05 ff 00 00 e0 e0 00 00 00 00 00 1f
    50: 00 ff 00 00 e0 e0 00 00 00 00 00 1f
    60: 01 ff 00 00 ff ff 00 00 00 00 00 00
    70: 02 ff 00 00 cf f3 00 00 00 00 00 0c
    80: 03 ff 00 00 00 00 00 00 00 00 00 ff
    90: 04 ff 00 00 ff 0f 00 00 f0 00 00 00

After:

    // Real registers
    18: 05 ff 00 00 ff 0f 00 00 f0 00 00 00
    ...
    // Virtual (per port)
    40: 00 ff 00 00 e0 e0 00 00 00 00 00 1f
    50: 01 ff 00 00 e0 e0 00 00 00 00 00 1f
    60: 02 ff 00 00 ff ff 00 00 00 00 00 00
    70: 03 ff 00 00 cf f3 00 00 00 00 00 0c
    80: 04 ff 00 00 00 00 00 00 00 00 00 ff
    90: 05 ff 00 00 ff 0f 00 00 f0 00 00 00

Fixes: 6863ca622759 ("regmap: Add support for register indirect addressing.")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20260302184753.2693803-1-andriy.shevchenko@linux.intel.com
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index bc89790ff0ded..6d8ed7683a387 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1634,6 +1634,7 @@ static int _regmap_select_page(struct regmap *map, unsigned int *reg,
 			       unsigned int val_num)
 {
 	void *orig_work_buf;
+	unsigned int selector_reg;
 	unsigned int win_offset;
 	unsigned int win_page;
 	bool page_chg;
@@ -1652,10 +1653,31 @@ static int _regmap_select_page(struct regmap *map, unsigned int *reg,
 			return -EINVAL;
 	}
 
-	/* It is possible to have selector register inside data window.
-	   In that case, selector register is located on every page and
-	   it needs no page switching, when accessed alone. */
+	/*
+	 * Calculate the address of the selector register in the corresponding
+	 * data window if it is located on every page.
+	 */
+	page_chg = in_range(range->selector_reg, range->window_start, range->window_len);
+	if (page_chg)
+		selector_reg = range->range_min + win_page * range->window_len +
+			       range->selector_reg - range->window_start;
+
+	/*
+	 * It is possible to have selector register inside data window.
+	 * In that case, selector register is located on every page and it
+	 * needs no page switching, when accessed alone.
+	 *
+	 * Nevertheless we should synchronize the cache values for it.
+	 * This can't be properly achieved if the selector register is
+	 * the first and the only one to be read inside the data window.
+	 * That's why we update it in that case as well.
+	 *
+	 * However, we specifically avoid updating it for the default page,
+	 * when it's overlapped with the real data window, to prevent from
+	 * infinite looping.
+	 */
 	if (val_num > 1 ||
+	    (page_chg && selector_reg != range->selector_reg) ||
 	    range->window_start + win_offset != range->selector_reg) {
 		/* Use separate work_buf during page switching */
 		orig_work_buf = map->work_buf;
@@ -1664,7 +1686,7 @@ static int _regmap_select_page(struct regmap *map, unsigned int *reg,
 		ret = _regmap_update_bits(map, range->selector_reg,
 					  range->selector_mask,
 					  win_page << range->selector_shift,
-					  &page_chg, false);
+					  NULL, false);
 
 		map->work_buf = orig_work_buf;
 
-- 
2.53.0



