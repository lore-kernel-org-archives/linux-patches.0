Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BE2423A7C;
	Tue, 31 Mar 2026 16:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975906; cv=none; b=Zmtz7QtqxhBL4ATmlUw9z760vJ8ldKQXLrYQyr4IPy20JEHJTb3xAQFt9aa8QoDYADw4WV/Bjaz89ahJTAZYU3oVsNUY5TeK/wt8mjFEnhBPEKRnKLqqqOeFs8KWadZmfFJiu/fxDVl4sKYkZ7aOyS0imQOPI1FxYkT5wCiN0MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975906; c=relaxed/simple;
	bh=9/Q81TkgHLZyTSSZ0lbVRmqyTnMtY3TrtA6Yx4tDJVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KEA+ySVX9yaM15WkopxcQFUF8xAnyIMuaOFs2hXRWHO6jqo8nx8kVoNJ5p+YmgdGvqKJQFc+03LBj7bRxfsgvCIZFMqW+/w0EXMEEIGfDlUmH51br+Dqs5C1zUexKBPxIX5aOm6Tlp8XfyQbW+tVRhvz3b/M/zHQQiPzJIwjeks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qzbpycy5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qzbpycy5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579ACC19423;
	Tue, 31 Mar 2026 16:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975906;
	bh=9/Q81TkgHLZyTSSZ0lbVRmqyTnMtY3TrtA6Yx4tDJVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qzbpycy5x/wuj7Q6frY4amMZt77AH3IV0MqWV7/xxlk2EqbwxuPxV2MYdiDRAE+hy
	 52qHV1pI6e9PTByLx2mQUQEA7gWL0rQ3d1GP5mppaCo9UJr46DjS8XWt3XiVM8WCcf
	 1azUBkRc3xgZEr6+DBCGKZBe4WpEN0S2rfhTv6NQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 105/244] regmap: Synchronize cache for the page selector
Date: Tue, 31 Mar 2026 18:20:55 +0200
Message-ID: <20260331161745.548160556@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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
index 70cde1bd04000..3b2e27af91fe6 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1544,6 +1544,7 @@ static int _regmap_select_page(struct regmap *map, unsigned int *reg,
 			       unsigned int val_num)
 {
 	void *orig_work_buf;
+	unsigned int selector_reg;
 	unsigned int win_offset;
 	unsigned int win_page;
 	bool page_chg;
@@ -1562,10 +1563,31 @@ static int _regmap_select_page(struct regmap *map, unsigned int *reg,
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
@@ -1574,7 +1596,7 @@ static int _regmap_select_page(struct regmap *map, unsigned int *reg,
 		ret = _regmap_update_bits(map, range->selector_reg,
 					  range->selector_mask,
 					  win_page << range->selector_shift,
-					  &page_chg, false);
+					  NULL, false);
 
 		map->work_buf = orig_work_buf;
 
-- 
2.53.0



