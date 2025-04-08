Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84853267B77;
	Tue,  8 Apr 2025 11:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110134; cv=none; b=QCMoJFXBMnn/zYToZqjvh40Ags1ICgXagL7muQp+QphWqGu5NyzYQrmdkJYhHZaIDk9+Mqepyxb/okYb2typN3NXmYz2WqBDlmHIAsNPTTxp01J1WkTadQxHCLVCVtNm5nPC5EqBWr29GFTSIgn7wUKcIkI01wYZxK9RZT8Hoj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110134; c=relaxed/simple;
	bh=JGyhzWwDdTnpFO0Sr/ZJVW1CZCGIRV6AMJSjRdeZoR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iILlgVFb1d6wBawaM3RhdjyoTZ+xts3J234yw3by7/a4WcDrTkE+k5fKXKVtr0NsnVldUJrXRcJ24HhyeQXnx8TlHsjNnsk/6qsF1SkOKVFJlHGIX1Tl3XczdK8ju/ISCMbisdc1jBc+WZOjzs4AcKdCqFf9uQN5UKh4o5iXJAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T+WefixP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+WefixP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168E6C4CEE5;
	Tue,  8 Apr 2025 11:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110134;
	bh=JGyhzWwDdTnpFO0Sr/ZJVW1CZCGIRV6AMJSjRdeZoR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T+WefixPh72pTFX1Pv8+mj3awaLHAx5RX8vpTArUH6QBpb+UQoYOcZH9P+Bdbp4mP
	 SIX0bo3FzPKyBQ8mAqV5uzydBi1WTUJxFfwRbXBDyVu/btcFa2WgljRQpMcA+kZXkR
	 egpDWgbdBZtOSg6kQr1jeMfMz0G9+bUFsSViMl+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 181/227] wifi: iwlwifi: fw: allocate chained SG tables for dump
Date: Tue,  8 Apr 2025 12:49:19 +0200
Message-ID: <20250408104825.740672560@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 7774e3920029398ad49dc848b23840593f14d515 ]

The firmware dumps can be pretty big, and since we use single
pages for each SG table entry, even the table itself may end
up being an order-5 allocation. Build chained tables so that
we need not allocate a higher-order table here.

This could be improved and cleaned up, e.g. by using the SG
pool code or simply kvmalloc(), but all of that would require
also updating the devcoredump first since that frees it all,
so we need to be more careful. SG pool might also run against
the CONFIG_ARCH_NO_SG_CHAIN limitation, which is irrelevant
here.

Also use _devcd_free_sgtable() for the error paths now, much
simpler especially since it's in two places now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250209143303.697c7a465ac9.Iea982df46b5c075bfb77ade36f187d99a70c63db@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 86 ++++++++++++++-------
 1 file changed, 58 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 79d08e5d9a81c..558caf78a56da 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -619,41 +619,71 @@ static void iwl_dump_prph(struct iwl_fw_runtime *fwrt,
 }
 
 /*
- * alloc_sgtable - allocates scallerlist table in the given size,
- * fills it with pages and returns it
+ * alloc_sgtable - allocates (chained) scatterlist in the given size,
+ *	fills it with pages and returns it
  * @size: the size (in bytes) of the table
-*/
-static struct scatterlist *alloc_sgtable(int size)
+ */
+static struct scatterlist *alloc_sgtable(ssize_t size)
 {
-	int alloc_size, nents, i;
-	struct page *new_page;
-	struct scatterlist *iter;
-	struct scatterlist *table;
+	struct scatterlist *result = NULL, *prev;
+	int nents, i, n_prev;
 
 	nents = DIV_ROUND_UP(size, PAGE_SIZE);
-	table = kcalloc(nents, sizeof(*table), GFP_KERNEL);
-	if (!table)
-		return NULL;
-	sg_init_table(table, nents);
-	iter = table;
-	for_each_sg(table, iter, sg_nents(table), i) {
-		new_page = alloc_page(GFP_KERNEL);
-		if (!new_page) {
-			/* release all previous allocated pages in the table */
-			iter = table;
-			for_each_sg(table, iter, sg_nents(table), i) {
-				new_page = sg_page(iter);
-				if (new_page)
-					__free_page(new_page);
-			}
-			kfree(table);
+
+#define N_ENTRIES_PER_PAGE (PAGE_SIZE / sizeof(*result))
+	/*
+	 * We need an additional entry for table chaining,
+	 * this ensures the loop can finish i.e. we can
+	 * fit at least two entries per page (obviously,
+	 * many more really fit.)
+	 */
+	BUILD_BUG_ON(N_ENTRIES_PER_PAGE < 2);
+
+	while (nents > 0) {
+		struct scatterlist *new, *iter;
+		int n_fill, n_alloc;
+
+		if (nents <= N_ENTRIES_PER_PAGE) {
+			/* last needed table */
+			n_fill = nents;
+			n_alloc = nents;
+			nents = 0;
+		} else {
+			/* fill a page with entries */
+			n_alloc = N_ENTRIES_PER_PAGE;
+			/* reserve one for chaining */
+			n_fill = n_alloc - 1;
+			nents -= n_fill;
+		}
+
+		new = kcalloc(n_alloc, sizeof(*new), GFP_KERNEL);
+		if (!new) {
+			if (result)
+				_devcd_free_sgtable(result);
 			return NULL;
 		}
-		alloc_size = min_t(int, size, PAGE_SIZE);
-		size -= PAGE_SIZE;
-		sg_set_page(iter, new_page, alloc_size, 0);
+		sg_init_table(new, n_alloc);
+
+		if (!result)
+			result = new;
+		else
+			sg_chain(prev, n_prev, new);
+		prev = new;
+		n_prev = n_alloc;
+
+		for_each_sg(new, iter, n_fill, i) {
+			struct page *new_page = alloc_page(GFP_KERNEL);
+
+			if (!new_page) {
+				_devcd_free_sgtable(result);
+				return NULL;
+			}
+
+			sg_set_page(iter, new_page, PAGE_SIZE, 0);
+		}
 	}
-	return table;
+
+	return result;
 }
 
 static void iwl_fw_get_prph_len(struct iwl_fw_runtime *fwrt,
-- 
2.39.5



