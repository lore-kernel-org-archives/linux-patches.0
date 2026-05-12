Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F7A3955DD;
	Tue, 12 May 2026 17:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608309; cv=none; b=Ks4AFJTKmsDJtFHxG0q1jF3iNLdI0D8m8lFBmPrKX3lGvUDwgyS7OHakBeisDg6oCn6A2CZmR+xQM2CbuUObZCxOHnH284RZLcG4lZ9f8RSCE36b94CwwlWS6RaTF8guJ7URwlGk1nWGhV3MdRzAr3xqTlBuwDa1RKr+YYOEP4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608309; c=relaxed/simple;
	bh=o5b5frwb3u0MwSPRkhW5WlwCubQzXLmMXaTXRap+JPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrGZwqIOZ1y5RfQoyZCjDaP7Q1/cezFqoGJl2uWjeqRp2ftyOM489MiZJ609Z2kYLTtYN6Nn8lJ0E7MloxeNsYYXZBCaHdLBmUb3iODIkCVBON7WE5e1GNOebwoAGwAS+Wg+ya9Lu5rSMsP6cDOI9D2TXVtpVp7ZLUOOy7YQzHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FlXAbIPF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FlXAbIPF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C072EC2BCF6;
	Tue, 12 May 2026 17:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608309;
	bh=o5b5frwb3u0MwSPRkhW5WlwCubQzXLmMXaTXRap+JPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FlXAbIPFYhyOKXWoyFG98y4dn5Ev6h8CAbHxt6NKGdnkr1YQHpOLWbDXm6tBEF2G2
	 q2mGp1uHBZXT568hUig3PmSIln0do3Eg3ciQAb5X8P2BT+1Tg3q5+HsZauddmPXIye
	 SpkUMMM9SO1R6LMwB/HxNF6Rnx52+YaEmsOxt3ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Zhou <quan.zhou@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.18 029/270] wifi: mt76: mt7921: fix ROC abort flow interruption in mt7921_roc_work
Date: Tue, 12 May 2026 19:37:10 +0200
Message-ID: <20260512173939.071081380@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -387,10 +387,11 @@ void mt7921_roc_work(struct work_struct
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


