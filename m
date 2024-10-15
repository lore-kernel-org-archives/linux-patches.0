Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1FE1AF0B1;
	Tue, 15 Oct 2024 13:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997425; cv=none; b=TBWeWYgGNTddeBvqg4HVFoju5GaqmqreqrPdh58ECrUd6s7AxbcLpmpYnctYkDW8DFbeDtEFEiVzNQLBEDp93uS7huLA1rhTfvVJlIavpM2L7FzYp+AaNIMQjt7uRF+ZHcYY9PPEO+8x9VgNXgmdbjz3Dy2WE4JpIDQjzQeXAs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997425; c=relaxed/simple;
	bh=D4imY7HFfV3fyFkIRkhKItgCpQXZt4C9iD9pqVqttIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XwgJUJ9WEH/e5I8IghBFZC+q0VxMK9hftha1GBuOvEf21do26kwZvdm7KywfuAxLDya7iwwXQd8PH14+IqZMWPiAMZf5bjCAiIkYlJXmrovJRSEOmysZc5vlWmgMxNkEZsNOfBGDFk+g4ftc+dYPHg3VdvKVBM1AzePfGXgeWQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mv76WCry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mv76WCry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E532EC4CEC6;
	Tue, 15 Oct 2024 13:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997425;
	bh=D4imY7HFfV3fyFkIRkhKItgCpQXZt4C9iD9pqVqttIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mv76WCry851GmKTYZyOaSXVZsJz6RXMPGYwFE7h7KKgpt47Dp9B+fxp27pCMqeRGH
	 4WhRACQmzZXRN1G6uAjA2N+y0JRTclwBQwA7wZlvg0JfWDeMs+79VlzD4DjalW9TQZ
	 a1OdLw3R1wC+PpZ1e6onDFO756AKT072qLOZhuyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 179/518] RDMA/hns: Optimize hem allocation performance
Date: Tue, 15 Oct 2024 14:41:23 +0200
Message-ID: <20241015123923.900345037@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6c875ffed83ac..61ec96b3a89d5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -1172,10 +1172,12 @@ static int hem_list_alloc_mid_bt(struct hns_roce_dev *hr_dev,
 
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



