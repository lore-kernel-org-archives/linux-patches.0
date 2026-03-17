Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541232FFDEA;
	Tue, 17 Mar 2026 16:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765925; cv=none; b=DrK0HCq7lD2qhPmuhzkUal/g0qdzLK74jqH6O9Wbe0IWb4PwUZ0OqV1nSHX3fHF3lI6ZI9R7Kj1L+iL9kJnpkU3nG7moihEktRs0xAeDuF/pYRAguqMZJS4QR4D6+jnNDIbe7h7YxvpdOkxWpnNUIcfk1Xe0vSW/U7h3ngq3z0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765925; c=relaxed/simple;
	bh=OlCBrCgrcM8mt3bZvLYuHdJoISquDWT+zoOmOodlskI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bRJhLi5lynoe0kWLC2yodn4YMpJEB6rvAB2rj2uTU6aFB7UTUL3wp2k/+VB00PLU9r0V31C/CcPWXKvkzlEWcfsrPb1afHC8ir7CumIK8hq2fOaW+BAb/WFvMlnGXD9SnoA6Pn/1tc8GD32q4Sq+swFL4kg6ldHcBO85vpWePFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZIULuldk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZIULuldk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5463C4CEF7;
	Tue, 17 Mar 2026 16:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765925;
	bh=OlCBrCgrcM8mt3bZvLYuHdJoISquDWT+zoOmOodlskI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZIULuldknFjw9udpSOY+UhgWuTw/kAOoVljpAaj1CQGI53mVtPt1KSLolsRW/oL06
	 LX1o2SuuBMPe4SySSCfHBmlcOUodq6MTmKIxu3xYJMhDyPHoSq6pGf1ME2TRReZY2W
	 onft8OhAvcfTXEM1I/oaoyhL8utNXVNV1Lcp3L3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 095/378] page_pool: store detach_time as ktime_t to avoid false-negatives
Date: Tue, 17 Mar 2026 17:30:52 +0100
Message-ID: <20260317163010.512852973@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 28b225282d44e2ef40e7f46cfdbd5d1b20b8874f ]

While testing other changes in vng I noticed that
nl_netdev.page_pool_check flakes. This never happens in real CI.

Turns out vng may boot and get to that test in less than a second.
page_pool_detached() records the detach time in seconds, so if
vng is fast enough detach time is set to 0. Other code treats
0 as "not detached". detach_time is only used to report the state
to the user, so it's not a huge deal in practice but let's fix it.
Store the raw ktime_t (nanoseconds) instead. A nanosecond value
of 0 is practically impossible.

Acked-by: Jesper Dangaard Brouer <hawk@kernel.org>
Fixes: 69cb4952b6f6 ("net: page_pool: report when page pool was destroyed")
Link: https://patch.msgid.link/20260310003907.3540019-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/page_pool/types.h | 2 +-
 net/core/page_pool_user.c     | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.h
index 1509a536cb855..fb4f03ccd6156 100644
--- a/include/net/page_pool/types.h
+++ b/include/net/page_pool/types.h
@@ -246,7 +246,7 @@ struct page_pool {
 	/* User-facing fields, protected by page_pools_lock */
 	struct {
 		struct hlist_node list;
-		u64 detach_time;
+		ktime_t detach_time;
 		u32 id;
 	} user;
 };
diff --git a/net/core/page_pool_user.c b/net/core/page_pool_user.c
index c82a95beceff8..ee5060d8eec0e 100644
--- a/net/core/page_pool_user.c
+++ b/net/core/page_pool_user.c
@@ -245,7 +245,7 @@ page_pool_nl_fill(struct sk_buff *rsp, const struct page_pool *pool,
 		goto err_cancel;
 	if (pool->user.detach_time &&
 	    nla_put_uint(rsp, NETDEV_A_PAGE_POOL_DETACH_TIME,
-			 pool->user.detach_time))
+			 ktime_divns(pool->user.detach_time, NSEC_PER_SEC)))
 		goto err_cancel;
 
 	if (pool->mp_ops && pool->mp_ops->nl_fill(pool->mp_priv, rsp, NULL))
@@ -337,7 +337,7 @@ int page_pool_list(struct page_pool *pool)
 void page_pool_detached(struct page_pool *pool)
 {
 	mutex_lock(&page_pools_lock);
-	pool->user.detach_time = ktime_get_boottime_seconds();
+	pool->user.detach_time = ktime_get_boottime();
 	netdev_nl_page_pool_event(pool, NETDEV_CMD_PAGE_POOL_CHANGE_NTF);
 	mutex_unlock(&page_pools_lock);
 }
-- 
2.51.0



