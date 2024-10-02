Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0361D0956;
	Wed,  2 Oct 2024 14:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880023; cv=none; b=tf+IYcrEhqecmm2eWS9mWc2nUThRx02pb3OECant70FPwGBB6n/4sgUrjibiRFq35E47Q4az0vwTJlLdl7nb9d4QRjKGHVrwv2G5Y8+ryALV7jANwj4btwoL72Xjain2RARUeBo4Ht7IAGsGaIJ/JwEG6p/urVpDsbdm1FMjOJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880023; c=relaxed/simple;
	bh=v/C9FIwEah9JewY9emLrWCFTEr4mPf8GGG2DDZmIuW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDJeOmTK7Sth3yT8j+xJP5BzoiUgT2Pu+bhxPUICp7v4tLlJDNotjI40jwRp+dEw1jNFkRztif5n18V9bgG9v57NKy8GU8FMGatQpKfx0ULko1xUcGOH8wKjM/G22Bdg20qMwnrYHKhS9+Gt4Xh/l1clQ/q/SbDSAgbCQJF+7VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FOl2NJg0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FOl2NJg0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30478C4CECD;
	Wed,  2 Oct 2024 14:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880023;
	bh=v/C9FIwEah9JewY9emLrWCFTEr4mPf8GGG2DDZmIuW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FOl2NJg0C0iGCWjtmRG8hBHf3IHWNYThfdwRGZg0REuLwQfmL7Xhz01u7BI8FuaDI
	 /aeOLkq1Weq2LHK4BYEP157kT6nxjxWAMFVIq0lATocO6m/7g3kckHw0lbWS9cOZPZ
	 iFvADuA+sbpSBBuduoooTu2VPSK7Pbndu3ChCyI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wenglianfa <wenglianfa@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 317/538] RDMA/hns: Fix the overflow risk of hem_list_calc_ba_range()
Date: Wed,  2 Oct 2024 14:59:16 +0200
Message-ID: <20241002125804.940999974@linuxfoundation.org>
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

From: wenglianfa <wenglianfa@huawei.com>

[ Upstream commit d586628b169d14bbf36be64d2b3ec9d9d2fe0432 ]

The max value of 'unit' and 'hop_num' is 2^24 and 2, so the value of
'step' may exceed the range of u32. Change the type of 'step' to u64.

Fixes: 38389eaa4db1 ("RDMA/hns: Add mtr support for mixed multihop addressing")
Signed-off-by: wenglianfa <wenglianfa@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20240906093444.3571619-5-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hem.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index c4ac06a338696..a429d95a387cd 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -1098,9 +1098,9 @@ static bool hem_list_is_bottom_bt(int hopnum, int bt_level)
  * @bt_level: base address table level
  * @unit: ba entries per bt page
  */
-static u32 hem_list_calc_ba_range(int hopnum, int bt_level, int unit)
+static u64 hem_list_calc_ba_range(int hopnum, int bt_level, int unit)
 {
-	u32 step;
+	u64 step;
 	int max;
 	int i;
 
@@ -1136,7 +1136,7 @@ int hns_roce_hem_list_calc_root_ba(const struct hns_roce_buf_region *regions,
 {
 	struct hns_roce_buf_region *r;
 	int total = 0;
-	int step;
+	u64 step;
 	int i;
 
 	for (i = 0; i < region_cnt; i++) {
@@ -1167,7 +1167,7 @@ static int hem_list_alloc_mid_bt(struct hns_roce_dev *hr_dev,
 	int ret = 0;
 	int max_ofs;
 	int level;
-	u32 step;
+	u64 step;
 	int end;
 
 	if (hopnum <= 1)
@@ -1204,7 +1204,7 @@ static int hem_list_alloc_mid_bt(struct hns_roce_dev *hr_dev,
 		}
 
 		start_aligned = (distance / step) * step + r->offset;
-		end = min_t(int, start_aligned + step - 1, max_ofs);
+		end = min_t(u64, start_aligned + step - 1, max_ofs);
 		cur = hem_list_alloc_item(hr_dev, start_aligned, end, unit,
 					  true);
 		if (!cur) {
@@ -1293,7 +1293,7 @@ static int setup_middle_bt(struct hns_roce_dev *hr_dev, void *cpu_base,
 	struct hns_roce_hem_item *hem, *temp_hem;
 	int total = 0;
 	int offset;
-	int step;
+	u64 step;
 
 	step = hem_list_calc_ba_range(r->hopnum, 1, unit);
 	if (step < 1)
-- 
2.43.0



