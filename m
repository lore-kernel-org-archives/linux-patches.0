Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3717F4E0B66;
	Wed, 30 Sep 2026 16:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786272; cv=none; b=E8kBew4rGTh7gn882AQrdytAqlI9MxGLRQyESboz9Xifc8FZyNTJpmxjprErEnXUZBdabW/S+F0aq8Mo6YRkQC9I2tfvX4OLyTa4mmGNR//i5a1YcNE+6X3b2hly1KaJMD0Xz8Z/V8m9Yf15WPMJxaDRO5oFlp17cJ9MLKFPO9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786272; c=relaxed/simple;
	bh=HiFIEK0IzavYtgYYUEj+XGiUVaJ+wnN4V1+I2D6a+W0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqfSgZBq3MgcJ3eBA2oo/W9K24MFxPLqq/dJ7u6g52BmxcWuDH4rboRZUespsEn/qNfTpFkZasVizzAveoXvgl2J52Br7sWf4T7TEh6hOj9mY0/GDa7bqLbewabuIstIPQdkPK0iE/i4Aoa36W5O/lZZd5fB+hYwzRNjW5BR4vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OIPro2MW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OIPro2MW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915C41F000FF;
	Wed, 30 Sep 2026 16:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786271;
	bh=8qOz5chFu8nDfh8EyEymKsFS7Q/ago9uqk92ylt3vhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OIPro2MWpFABHFzlZ7Af0H1HNyfYFOg5LLFfOJjijDDh3e/XwVmQoRlcYP3mYNa4u
	 43Qt10XKCFCevn7lqbljKL2d8jfuPyVRpsDIjLsTMbJ3MIxks0xQi0Y6g0lO0fP7cM
	 yQlo79qPStnj2Ys9o3G3kkXgcZFpLmdbaZyA58Bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Kalle Valo <kvalo@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 803/982] wifi: rtw88: delete timer and free skb queue when unloading
Date: Wed, 30 Sep 2026 17:25:39 +0200
Message-ID: <20260930152434.004364989@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 634fcbcaa4062db39aeb5ac6ed1bc1feb8dd5216 ]

Fix possible crash and memory leak on driver unload by deleting
TX purge timer and freeing C2H queue in 'rtw_core_deinit()',
shrink critical section in the latter by freeing COEX queue
out of TX report lock scope.

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230628072327.167196-1-dmantipov@yandex.ru

[ Backport to 6.1.y: the source change is unchanged; only hunk locations
  in rtw_core_deinit() differ. The target-only Fixes trailer names the
  initial rtw88 driver commit, which introduced this lifetime. ]
Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 8f486152fbd9f..53c61758d57a0 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -2135,10 +2135,12 @@ void rtw_core_deinit(struct rtw_dev *rtwdev)
 		release_firmware(wow_fw->firmware);
 
 	destroy_workqueue(rtwdev->tx_wq);
+	timer_delete_sync(&rtwdev->tx_report.purge_timer);
 	spin_lock_irqsave(&rtwdev->tx_report.q_lock, flags);
 	ieee80211_purge_tx_queue(rtwdev->hw, &rtwdev->tx_report.queue);
-	skb_queue_purge(&rtwdev->coex.queue);
 	spin_unlock_irqrestore(&rtwdev->tx_report.q_lock, flags);
+	skb_queue_purge(&rtwdev->coex.queue);
+	skb_queue_purge(&rtwdev->c2h_queue);
 
 	list_for_each_entry_safe(rsvd_pkt, tmp, &rtwdev->rsvd_page_list,
 				 build_list) {
-- 
2.53.0



