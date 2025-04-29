Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F539221DA7;
	Tue, 29 Apr 2025 17:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948831; cv=none; b=nEpLkBcR/rZJxPpmg4+5kxmRhi0Mc+ZoPXAYRQUrPJtpNjym9XkG9DGKdv15TQkJNstdbtHwtfq4OvWVnPB7lEvqaZwCDl3sWvFLH49+wCRyCrUXRX4nCLDHHSm5yonJPmNXRy3BrrNayrSreS381Lcr6KsAYILeICj6RqIjSx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948831; c=relaxed/simple;
	bh=QjJe3PCLPRiBtmMBmU1KE3MTtGewLXlKUxPHfLyYerw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SjVaBZ+jCfNDSBPlXFqTcs+mou0GKRJ9i40VUhVpZQosuF5f1tbU93CgoCdc+chJtxXjd0w+1Fcqv9mpRxXKk6igkKeIw5S8au1dlShWmVU6jZ2oYaqvwKzkVMGtPd0QSE2Z5xvPmoV1m4Isgv7e4N01Pt79sXevK5Df04KwqJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i1eI+VPv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i1eI+VPv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D098C4CEE3;
	Tue, 29 Apr 2025 17:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948830;
	bh=QjJe3PCLPRiBtmMBmU1KE3MTtGewLXlKUxPHfLyYerw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i1eI+VPvci4K5ib/enip5w0seKrb6DjJ78he1uVgsYdVZ/+zrQ4ZqM8DlXGu4D2Wn
	 jaig6/66JKOX0S2rWcXICKo22A3U7RCB249wvGjuqUISpzpLa6TgNgG/9OYU1KTMD6
	 xWGIgMo1gr5zTgK1QfU1WcmvbhizBl9iTsEzCWD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Michael Nemanov <michael.nemanov@ti.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 130/373] wifi: wl1251: fix memory leak in wl1251_tx_work
Date: Tue, 29 Apr 2025 18:40:07 +0200
Message-ID: <20250429161128.516026947@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <abdun.nihaal@gmail.com>

[ Upstream commit a0f0dc96de03ffeefc2a177b7f8acde565cb77f4 ]

The skb dequeued from tx_queue is lost when wl1251_ps_elp_wakeup fails
with a -ETIMEDOUT error. Fix that by queueing the skb back to tx_queue.

Fixes: c5483b719363 ("wl12xx: check if elp wakeup failed")
Signed-off-by: Abdun Nihaal <abdun.nihaal@gmail.com>
Reviewed-by: Michael Nemanov <michael.nemanov@ti.com>
Link: https://patch.msgid.link/20250330104532.44935-1-abdun.nihaal@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wl1251/tx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl1251/tx.c b/drivers/net/wireless/ti/wl1251/tx.c
index 98cd39619d579..5771f61392efb 100644
--- a/drivers/net/wireless/ti/wl1251/tx.c
+++ b/drivers/net/wireless/ti/wl1251/tx.c
@@ -342,8 +342,10 @@ void wl1251_tx_work(struct work_struct *work)
 	while ((skb = skb_dequeue(&wl->tx_queue))) {
 		if (!woken_up) {
 			ret = wl1251_ps_elp_wakeup(wl);
-			if (ret < 0)
+			if (ret < 0) {
+				skb_queue_head(&wl->tx_queue, skb);
 				goto out;
+			}
 			woken_up = true;
 		}
 
-- 
2.39.5



