Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0B01D0951;
	Wed,  2 Oct 2024 14:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880035; cv=none; b=Mmtdzk+A3K98qthPuTio1C3FL8lWdnAc6xAgPMRmSgZR5U8SWB7nMK5AULvXiYIVqQ1NBfYwi/Kszk79w8FHwgVKUPTwxrRD26neDeJy0wNQje5azCdp/dj8m07xdPLh1XelVG75quRddtrsOF5Qavs0Oga7d3nh1aAHbmAC2+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880035; c=relaxed/simple;
	bh=oUdvzIcr1Q+6E4cA6KR0qBNnSq/DH1LUmUIbbvMRFII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8ilja9xm6W8xHI0O5eLZxXW0JsYmPJ8lkoGr9ZLNvtuwu2Bi6J6FOsBmqCVlCOlzV4L5gxFPo27hEf1LOd8spMJHKqTPlBLC+Aqao/KiJfQuS1JQPvMc5BqWxAbMo+Tr4uIAP2WAPj2nr6GY+sGJ4/ImeX7vbtCU7wvSGR2RMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C4tlrPzn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C4tlrPzn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3B5C4CEC2;
	Wed,  2 Oct 2024 14:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880035;
	bh=oUdvzIcr1Q+6E4cA6KR0qBNnSq/DH1LUmUIbbvMRFII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C4tlrPznBQyeyOjKq7GhBVdW7+I1zSWOVFqetjj57hOBbq9qcbmPGikye03grDsFe
	 V/hBPboloE7/2SDsm9kDUcdIMHPjdiorpIyye5AiF+JBxRNB8xbyoNdZvhXs0mROD8
	 87+4nyOF/EyE8yeav84pjqo+z4MFWtpiOFmSxcFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 321/538] RDMA/hns: Optimize hem allocation performance
Date: Wed,  2 Oct 2024 14:59:20 +0200
Message-ID: <20241002125805.099306890@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit fe51f6254d81f5a69c31df16353d6539b2b51630 ]

When allocating MTT hem, for each hop level of each hem that is being
allocated, the driver iterates the hem list to find out whether the
bt page has been allocated in this hop level. If not, allocate a new
one and splice it to the list. The time complexity is O(n^2) in worst
cases.

Currently the allocation for-loop uses 'unit' as the step size. This
actually has taken into account the reuse of last-hop-level MTT bt
pages by multiple buffer pages. Thus pages of last hop level will
never have been allocated, so there is no need to iterate the hem list
in last hop level.

Removing this unnecessary iteration can reduce the time complexity to
O(n).

Fixes: 38389eaa4db1 ("RDMA/hns: Add mtr support for mixed multihop addressing")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20240906093444.3571619-9-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hem.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index a429d95a387cd..7ebf80504fd12 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -1191,10 +1191,12 @@ static int hem_list_alloc_mid_bt(struct hns_roce_dev *hr_dev,
 
 	/* config L1 bt to last bt and link them to corresponding parent */
 	for (level = 1; level < hopnum; level++) {
-		cur = hem_list_search_item(&mid_bt[level], offset);
-		if (cur) {
-			hem_ptrs[level] = cur;
-			continue;
+		if (!hem_list_is_bottom_bt(hopnum, level)) {
+			cur = hem_list_search_item(&mid_bt[level], offset);
+			if (cur) {
+				hem_ptrs[level] = cur;
+				continue;
+			}
 		}
 
 		step = hem_list_calc_ba_range(hopnum, level, unit);
-- 
2.43.0



