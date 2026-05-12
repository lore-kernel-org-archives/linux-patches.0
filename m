Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C093B1EE2;
	Tue, 12 May 2026 17:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607779; cv=none; b=b+GRtJudPyiRxnBL/Uu0GbIyTyLNQCXkz/Z2QHyhrOgDe/15GE7uV8WW87ud7PEQu7P9CLdoaA6og15iL3KB1fnMy+FSE2mIvX0lDshzlx+1IVkUJTjj7c+cyvlkPftdF2uckSKVlwUHsBSFyJPjQ3VsqLKbXuhXSHGRetp2VUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607779; c=relaxed/simple;
	bh=DntsLyeDp39ceh+OpwQAbfiPA4X5aDzQpbcIYX4xEMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4nu2T7l3GmL0rJgdIYXKCIg960jmSd+0ZqVAbfNR1OnYCQf7jkMRnPugdEJWYHnu8YMhHAwA5qS1p2o4FRHqxd50dWY2Pr5nDhSYKJ0/s0SRAKylnsfC1nJBnhVTCERDE1ULs79b86jqUOOb+Auq38EY9OpiM/MPyaHlDk8dj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rWCYFY6P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rWCYFY6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF93C2BCB0;
	Tue, 12 May 2026 17:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607779;
	bh=DntsLyeDp39ceh+OpwQAbfiPA4X5aDzQpbcIYX4xEMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rWCYFY6PJHSUEYKpHqJMPOc0ZjfHs4l7aLKiS5sIWucJybsjAOi/CwTvQaSQ43gYq
	 dCaSCO7d2Mh+L8jxWw1YcxAE26z8UQ9YLI+T/K4bnXaX4eSDaD8nxug/Upt3amm66c
	 xaBvVFYwC6Z4VOaMlxMBBi/GcbueovQO7tIX9A3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Zhou <quan.zhou@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.12 032/206] wifi: mt76: mt7921: fix ROC abort flow interruption in mt7921_roc_work
Date: Tue, 12 May 2026 19:38:04 +0200
Message-ID: <20260512173933.509675795@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quan Zhou <quan.zhou@mediatek.com>

commit fdfa39f9f4fbae532b162da913a67b2410caf38f upstream.

The mt7921_set_roc API may be executed concurrently with mt7921_roc_work,
specifically between the following code paths:

- The check and clear of MT76_STATE_ROC in mt7921_roc_work:
    if (!test_and_clear_bit(MT76_STATE_ROC, &phy->mt76->state))
        return;

- The execution of ieee80211_iterate_active_interfaces.

This race condition can interrupt the ROC abort flow, resulting in
the ROC process failing to abort as expected.

To address this defect, the modification of MT76_STATE_ROC is now
protected by mt792x_mutex_acquire(phy->dev). This ensures that
changes to the ROC state are properly synchronized, preventing
race conditions and ensuring the ROC abort flow is not interrupted.

Fixes: 034ae28b56f1 ("wifi: mt76: mt7921: introduce remain_on_channel support")
Cc: stable@vger.kernel.org
Signed-off-by: Quan Zhou <quan.zhou@mediatek.com>
Reviewed-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/2568ece8b557e5dda79391414c834ef3233049b6.1769133724.git.quan.zhou@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -381,10 +381,11 @@ void mt7921_roc_work(struct work_struct
 	phy = (struct mt792x_phy *)container_of(work, struct mt792x_phy,
 						roc_work);
 
-	if (!test_and_clear_bit(MT76_STATE_ROC, &phy->mt76->state))
-		return;
-
 	mt792x_mutex_acquire(phy->dev);
+	if (!test_and_clear_bit(MT76_STATE_ROC, &phy->mt76->state)) {
+		mt792x_mutex_release(phy->dev);
+		return;
+	}
 	ieee80211_iterate_active_interfaces(phy->mt76->hw,
 					    IEEE80211_IFACE_ITER_RESUME_ALL,
 					    mt7921_roc_iter, phy);


