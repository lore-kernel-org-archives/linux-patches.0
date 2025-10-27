Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2552D5412;
	Mon, 27 Oct 2025 18:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591097; cv=none; b=SXC0+DGFUAvUlFgz0r9r1ZLBuRjSl9qlijqUNnX+BgxlXs1FgrZSmpwJUPvNkndjN/++rW9/vEcT6NhK2ZFtCTCRDELyJfv05SDBSoqqbqfWZLqhe0ePbE6cywxw/5dSxfPN4mXzRzo/dOQVI/3+b+ORzeBfUj55XM5udP3NSo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591097; c=relaxed/simple;
	bh=hNl5jo/f150nL2LvalS/xxqzwoiiG7xEWrEYxUQUBIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1t6M8NNWRIE1wp4HoeBa5aV67sF9KWe+ICCYgn4LqSNW26rc+AFujEjh96LBKKNfPq2hu+61EDkFSkTqHrdEmapx7WRrCuRfXv+NY7cDd0bs3Oethj0wUCRh8WDLgQMhdQ2qhel5vQnSaIxcfUSJqtHo1KOjqy4TCi4nHMtRHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fd5Zu1TP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fd5Zu1TP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C5AC4CEF1;
	Mon, 27 Oct 2025 18:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591096;
	bh=hNl5jo/f150nL2LvalS/xxqzwoiiG7xEWrEYxUQUBIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fd5Zu1TPMUse/svdflmwDMuLjvKah17a6/TDZs+B4evaWowZqKT9mWHxzd6zb6A1t
	 b/HAJNRJqU/f4i/vkUnBkiKAYgbX7EJc1aKPXGsbSmDcyDGNL5gxtpFqn75zsrVwvL
	 77g5eMryHewBaOkHl611dkQz4sK60dikGbibIcV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Dumitrescu <vdumitrescu@nvidia.com>,
	Mark Zhang <markzhang@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/332] IB/sa: Fix sa_local_svc_timeout_ms read race
Date: Mon, 27 Oct 2025 19:31:58 +0100
Message-ID: <20251027183526.335008147@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Dumitrescu <vdumitrescu@nvidia.com>

[ Upstream commit 1428cd764cd708d53a072a2f208d87014bfe05bc ]

When computing the delta, the sa_local_svc_timeout_ms is read without
ib_nl_request_lock held. Though unlikely in practice, this can cause
a race condition if multiple local service threads are managing the
timeout.

Fixes: 2ca546b92a02 ("IB/sa: Route SA pathrecord query through netlink")
Signed-off-by: Vlad Dumitrescu <vdumitrescu@nvidia.com>
Reviewed-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Link: https://patch.msgid.link/20250916163112.98414-1-edwards@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/sa_query.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index de88f472eaad2..4f42bab1a9643 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -1036,6 +1036,8 @@ int ib_nl_handle_set_timeout(struct sk_buff *skb,
 	if (timeout > IB_SA_LOCAL_SVC_TIMEOUT_MAX)
 		timeout = IB_SA_LOCAL_SVC_TIMEOUT_MAX;
 
+	spin_lock_irqsave(&ib_nl_request_lock, flags);
+
 	delta = timeout - sa_local_svc_timeout_ms;
 	if (delta < 0)
 		abs_delta = -delta;
@@ -1043,7 +1045,6 @@ int ib_nl_handle_set_timeout(struct sk_buff *skb,
 		abs_delta = delta;
 
 	if (delta != 0) {
-		spin_lock_irqsave(&ib_nl_request_lock, flags);
 		sa_local_svc_timeout_ms = timeout;
 		list_for_each_entry(query, &ib_nl_request_list, list) {
 			if (delta < 0 && abs_delta > query->timeout)
@@ -1061,9 +1062,10 @@ int ib_nl_handle_set_timeout(struct sk_buff *skb,
 		if (delay)
 			mod_delayed_work(ib_nl_wq, &ib_nl_timed_work,
 					 (unsigned long)delay);
-		spin_unlock_irqrestore(&ib_nl_request_lock, flags);
 	}
 
+	spin_unlock_irqrestore(&ib_nl_request_lock, flags);
+
 settimeout_out:
 	return 0;
 }
-- 
2.51.0



