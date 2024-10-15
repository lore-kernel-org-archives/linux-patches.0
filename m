Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B7B1D4154;
	Tue, 15 Oct 2024 11:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992905; cv=none; b=cZCAH7LYz0OCFNd6c5y0HtDRUOTDy4m5DA0SN5Idz3Fp7/njgy+V1NERESMIt4L6FW/ruujgFAE0UH3Kci6h5GCEMFnw2a6oxLwXzMVnORu3L35YyzZtqwVlhdq3ZRmlwv9jgGbNy4dN0s8upRixybFZaX5xiMluJiBsWO1q8Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992905; c=relaxed/simple;
	bh=OgakBZ4/YbY4sE3rr4dLXhm5p8YbHK8jzbUwr4qT5PY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GoSCLG8b3ZeQeXWI0fJ+ENoMECaovvQDyohoSlcQgxxQlPPtkVW96aIaZcEoJwAyXuW++20C4QP92t6LnepaiNO9KzNh8oRlrhAMNThowhJZ+y1QP7TcWEzKgFcIhbHDQoEjkOikYdTB5y4v9dfkPS4oo3oku6/66JhGDLfy6BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUfL7UKf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUfL7UKf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D55C4CECE;
	Tue, 15 Oct 2024 11:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992905;
	bh=OgakBZ4/YbY4sE3rr4dLXhm5p8YbHK8jzbUwr4qT5PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tUfL7UKfMDWNrv7uY+9W9OsuDHgSwFPbqeMnJbaKJ8vC2/bMGFogBlD+uv2cZ5pYI
	 16TXMCzAit3pUfN77pwD4mXxw5SMhAZKtG75/MCuQ/2VPauU7L585vjHx+KCJltAjN
	 NfGhRJZpLBErBsG0yqp2OheWFWbYoGb8GuYmgkic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 254/691] RDMA/hns: Optimize hem allocation performance
Date: Tue, 15 Oct 2024 13:23:22 +0200
Message-ID: <20241015112450.433280831@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5f2b434541a2d..ce2ace2c850dc 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -1182,10 +1182,12 @@ static int hem_list_alloc_mid_bt(struct hns_roce_dev *hr_dev,
 
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



