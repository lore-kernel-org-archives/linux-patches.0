Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC090156644;
	Wed, 15 Jan 2025 10:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938556; cv=none; b=teURyPVHZkxVpz0zjg8brcs3KQmIZHpDz7C9AWqjvZsYcLEDvFIi3yEAbTgAVP+OcACjFmcAY4rABA4gGMrbjaQOl8U2an35+bd3lqq6oCRWa/+zmk2v/Y59gnBy9I+NHGmUiZAqpNDT7tGtY43Tlu/YTtABepOLdvuKFw0HqiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938556; c=relaxed/simple;
	bh=irjRTGArn+iqGZHCFBz1NB0HdqzE26TqgySZwnNnIvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYbRH6x4fBB3EP/1e5roEzncJQewbXdZWQqks0XzXhaHrKr9Hh/OzSqobTFWY7JEUkXwr4+AATqcH6jMZ4lNZb0URfnY1B1b5T/AA8LEu0xkpQO1b9dvaeST7cMAkB+5OnfWVm4GKnrDrz+m/l6ybLP7awFDz42Zv6C/8PXWOUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lWuV0qnZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lWuV0qnZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC11C4CEDF;
	Wed, 15 Jan 2025 10:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938556;
	bh=irjRTGArn+iqGZHCFBz1NB0HdqzE26TqgySZwnNnIvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lWuV0qnZWmGUma30PXkwZq9dX33LKbEplbXdJILqk9yaV5q4PG9tj4XN6jYT+q+/X
	 MUQhxg7JyixNypAo5zDCgwGXx8c6g4D+F+RbM78I9SM3bpd3YCe4SlWUAofO/+BEwL
	 34WyXhda9XLJKNvP5tULB/IEQ30APd14KlivTY10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anumula Murali Mohan Reddy <anumula@chelsio.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/129] cxgb4: Avoid removal of uninserted tid
Date: Wed, 15 Jan 2025 11:36:42 +0100
Message-ID: <20250115103555.448301690@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anumula Murali Mohan Reddy <anumula@chelsio.com>

[ Upstream commit 4c1224501e9d6c5fd12d83752f1c1b444e0e3418 ]

During ARP failure, tid is not inserted but _c4iw_free_ep()
attempts to remove tid which results in error.
This patch fixes the issue by avoiding removal of uninserted tid.

Fixes: 59437d78f088 ("cxgb4/chtls: fix ULD connection failures due to wrong TID base")
Signed-off-by: Anumula Murali Mohan Reddy <anumula@chelsio.com>
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
Link: https://patch.msgid.link/20250103092327.1011925-1-anumula@chelsio.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index b215ff14da1b..3989c9491f0f 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -1799,7 +1799,10 @@ void cxgb4_remove_tid(struct tid_info *t, unsigned int chan, unsigned int tid,
 	struct adapter *adap = container_of(t, struct adapter, tids);
 	struct sk_buff *skb;
 
-	WARN_ON(tid_out_of_range(&adap->tids, tid));
+	if (tid_out_of_range(&adap->tids, tid)) {
+		dev_err(adap->pdev_dev, "tid %d out of range\n", tid);
+		return;
+	}
 
 	if (t->tid_tab[tid - adap->tids.tid_base]) {
 		t->tid_tab[tid - adap->tids.tid_base] = NULL;
-- 
2.39.5



