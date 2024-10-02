Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16DE1D0412;
	Wed,  2 Oct 2024 14:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878335; cv=none; b=mCtHIsHfjs9mrM8aQ1a5VtZVohYGQH4r5sVb71btnHcezzgWuZqKCF2KWBnDn5MREQnu57qE1BMpViiIizJwnI4iGjtcmmbGG3SGSFVQotcokm3TYJyzed4AnV19nIRqw9vzoYTewlSNQ+VimEySYEEtNNgAPjd7VppCDvmh8Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878335; c=relaxed/simple;
	bh=ccK/WnBL5HMxknVm6j1RWdird7K9sUi7hF3ifhsVxiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HSMDcQJPE7MKMk8Q//vv3gciiQbfh7yfHqGcKoj2hhYrP7XTAXplHd+FVgdOob5+RW+CTxkLcUJA/PbBPs6A20PcfUMrj1Fm2sL6YWRUJF1sG/Ep35tZ3q70tR1bemknANJ5a2wFNAqwImYNFtu0GlpzhlkgaKE/CPN9KbffbXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d6H0BixU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d6H0BixU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D69AC4CEC2;
	Wed,  2 Oct 2024 14:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878334;
	bh=ccK/WnBL5HMxknVm6j1RWdird7K9sUi7hF3ifhsVxiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d6H0BixUwnS850795UU8IcTriQvC98RjMMpFfYN9R6mzv2BdFPmebT9bQT+BLaaXX
	 pMUBi5dXNMaDS8TlAAm418txukpDn1sTaT+PK/OhY722pTYZr+bntxZY8pCnXlUjvC
	 Brya8taDBA6lCybxGE9W3V9ZKAbMEoxetyd3MXsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 379/634] RDMA/hns: Optimize hem allocation performance
Date: Wed,  2 Oct 2024 14:57:59 +0200
Message-ID: <20241002125826.058540633@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 42111f31b3715..c7c167e2a0451 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -1134,10 +1134,12 @@ static int hem_list_alloc_mid_bt(struct hns_roce_dev *hr_dev,
 
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



