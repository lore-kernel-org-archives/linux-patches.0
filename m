Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA0C1D04A8;
	Wed,  2 Oct 2024 14:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878417; cv=none; b=io5oisO9MQOUE03qgfjtmLDJVXP1ez8Jyeyxfzmx1H1O/UEq21r2GAMGr/lnClgaZVIOlOG1n6MPMYuPcO3Lg9jZFDlKDhoYA0SvTi9IB1oElCt4KC1uYoHAyZ4yX5ag6l3Mg5E5NBWfDIhC96pbU7wF9kvKbaiBURGyGnI92W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878417; c=relaxed/simple;
	bh=AwjPcd9cyrbZLX5cE1rqRvFYYlnERK6vcs+QpzeiwV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DwoRIAo6F8vpGbLgP0sowmTwVK20mb/vFyYoqFyQ5IO9OZw4J6VRMxTzUfl0lRC5q07T7FtkEmNbR9MqNnH12mypkJQAxpWThP0ft99SreHDzqGkhcTFC6hO+NbdVNZKYClnGPstniEWARxqfmN3f/7qxEK2AUshVpPOvUDzJ5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WRSvbQyt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WRSvbQyt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA08C4CEC2;
	Wed,  2 Oct 2024 14:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878417;
	bh=AwjPcd9cyrbZLX5cE1rqRvFYYlnERK6vcs+QpzeiwV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WRSvbQytBFE/cs39W6uLa5Wg02ef9c5GJ3uMfdukQwA5n1Wmro76DhdATy++LXcl2
	 CQXPkk7tTCi1kDVv2EkYPnJgGjXmuXlI/ax7JFMx7iO0MJz5LIWKeKbCtdf13nE7Zt
	 mJMo6J8Wz+gHPdKizvB0US0/j7Jnj5TwJcWv4DsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wenglianfa <wenglianfa@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 375/634] RDMA/hns: Fix the overflow risk of hem_list_calc_ba_range()
Date: Wed,  2 Oct 2024 14:57:55 +0200
Message-ID: <20241002125825.900250347@linuxfoundation.org>
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
index 02baa853a76c9..42111f31b3715 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -1041,9 +1041,9 @@ static bool hem_list_is_bottom_bt(int hopnum, int bt_level)
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
 
@@ -1079,7 +1079,7 @@ int hns_roce_hem_list_calc_root_ba(const struct hns_roce_buf_region *regions,
 {
 	struct hns_roce_buf_region *r;
 	int total = 0;
-	int step;
+	u64 step;
 	int i;
 
 	for (i = 0; i < region_cnt; i++) {
@@ -1110,7 +1110,7 @@ static int hem_list_alloc_mid_bt(struct hns_roce_dev *hr_dev,
 	int ret = 0;
 	int max_ofs;
 	int level;
-	u32 step;
+	u64 step;
 	int end;
 
 	if (hopnum <= 1)
@@ -1147,7 +1147,7 @@ static int hem_list_alloc_mid_bt(struct hns_roce_dev *hr_dev,
 		}
 
 		start_aligned = (distance / step) * step + r->offset;
-		end = min_t(int, start_aligned + step - 1, max_ofs);
+		end = min_t(u64, start_aligned + step - 1, max_ofs);
 		cur = hem_list_alloc_item(hr_dev, start_aligned, end, unit,
 					  true);
 		if (!cur) {
@@ -1235,7 +1235,7 @@ static int setup_middle_bt(struct hns_roce_dev *hr_dev, void *cpu_base,
 	struct hns_roce_hem_item *hem, *temp_hem;
 	int total = 0;
 	int offset;
-	int step;
+	u64 step;
 
 	step = hem_list_calc_ba_range(r->hopnum, 1, unit);
 	if (step < 1)
-- 
2.43.0



