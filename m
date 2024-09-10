Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FD918C347;
	Tue, 10 Sep 2024 09:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962034; cv=none; b=QBlGMnbI29l2oIA2dX4ftbKT/HHGIxSMu+Z7UB1QdOVHRd45CwsDFZ+w4YjMRz3hI3kOIkPLPjclNvZoC7ujMZjjMMTywD2rMEkFMLL5hqFstLNl/ExFDSDhtkVDf9K6lMEIuHduHU9XXgi59lQlKCOGHbOxfOQ2ns2YPklx5JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962034; c=relaxed/simple;
	bh=5uFF/TJuFz8lDbKG6MwTTnVK5ZxF/p2p8fxgEmQU3GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VMVrFpzhBIoIZIRcmUSRXfrIYR9wsnDdJc7vZWz+8bGKbxp2vR1Mn7PVXJl22xhAz8i+Kk8EO7gcPSR2Pp+eIb6oOQ+l7LATraog7KhEKF5GIHSMGFmHV7AUbZDjvtSLO3bj6VEdcPVe8/NYO/E2RY43H36xyBDgBgfEqt7eMOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=whVtLuwo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="whVtLuwo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B9EC4CECD;
	Tue, 10 Sep 2024 09:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962034;
	bh=5uFF/TJuFz8lDbKG6MwTTnVK5ZxF/p2p8fxgEmQU3GQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=whVtLuwoFTZue9HnhA2xjj5sMt2JlkETka0Gy8thgLlEph3DB97otw5l+Ws2POA9i
	 i2AM3Oa2EdOgvll2ELJ5c1082yQmzOIhmrv7IbhFvSCE5epVxWw9O7QojSqEacmU87
	 UHyRHddlmSvnaBEunRAxRk1U1FHBJ1Y016thSvpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang Wang <wangpeiyang1@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 272/375] net: hns3: void array out of bound when loop tnl_num
Date: Tue, 10 Sep 2024 11:31:09 +0200
Message-ID: <20240910092631.694890256@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

From: Peiyang Wang <wangpeiyang1@huawei.com>

[ Upstream commit 86db7bfb06704ef17340eeae71c832f21cfce35c ]

When query reg inf of SSU, it loops tnl_num times. However, tnl_num comes
from hardware and the length of array is a fixed value. To void array out
of bound, make sure the loop time is not greater than the length of array

Signed-off-by: Peiyang Wang <wangpeiyang1@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index e132c2f09560..cc7f46c0b35f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1598,8 +1598,7 @@ static void hclge_query_reg_info_of_ssu(struct hclge_dev *hdev)
 {
 	u32 loop_para[HCLGE_MOD_MSG_PARA_ARRAY_MAX_SIZE] = {0};
 	struct hclge_mod_reg_common_msg msg;
-	u8 i, j, num;
-	u32 loop_time;
+	u8 i, j, num, loop_time;
 
 	num = ARRAY_SIZE(hclge_ssu_reg_common_msg);
 	for (i = 0; i < num; i++) {
@@ -1609,7 +1608,8 @@ static void hclge_query_reg_info_of_ssu(struct hclge_dev *hdev)
 		loop_time = 1;
 		loop_para[0] = 0;
 		if (msg.need_para) {
-			loop_time = hdev->ae_dev->dev_specs.tnl_num;
+			loop_time = min(hdev->ae_dev->dev_specs.tnl_num,
+					HCLGE_MOD_MSG_PARA_ARRAY_MAX_SIZE);
 			for (j = 0; j < loop_time; j++)
 				loop_para[j] = j + 1;
 		}
-- 
2.43.0



