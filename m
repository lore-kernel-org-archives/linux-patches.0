Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045E7522A;
	Wed,  5 Feb 2025 14:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765673; cv=none; b=P0hvmw9Gj1+QgD7BdtAdui6fwxEUaK9T07Z+rxWq6vS3SEYXieXHqSvjnHplI+aG+Uug1x88Grk2RbUdrxzQFwmJKIQf7zO7f1p52QVT4M5gfBmyXWlTN9oaPzsz920UusyOnfzjOYlAE7PBynOm/0B+EsoloeOWQb5RUHi7goQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765673; c=relaxed/simple;
	bh=5WYzwRmXB3e1+SG1vAFwDvM8aayFKCBT368H+DHJ3u8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pT57w7/t2BvNk10WjjgsVfE++Ssz55BVhN0xfvYI/zrlEKAi9J39l5toBr62E2gNyuTZKKzVE9YDJzhWXTuTTmWWc/YD5p7rBqzVuFKx9Solr/+gRB0F9BEjG7PwsKeY7qdsnm37xJ1RxxgMXt74+Y5JAu8kg5ZavleMlC2xJHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cH1KRRqX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cH1KRRqX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F27C4CED1;
	Wed,  5 Feb 2025 14:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765672;
	bh=5WYzwRmXB3e1+SG1vAFwDvM8aayFKCBT368H+DHJ3u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cH1KRRqXA2sIRGicN21v8tjIaNhESfvRWg48SyRSRPNCU+LMOvp1zP09aCcYwgreH
	 1b2Q36AiBLhQaFlvniEbCLHutMa618DvjT/5uxzJmy0LOHAyEh4CwfS3Ng8iqMy1xb
	 RHintJExwVI78fKHsTQJSYUhY9Cbd0h1Dyh58uqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 203/623] wifi: mt76: mt7996: fix rx filter setting for bfee functionality
Date: Wed,  5 Feb 2025 14:39:05 +0100
Message-ID: <20250205134503.996015496@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 858fd2a53877b2e8b1d991a5a861ac34a0f55ef8 ]

Fix rx filter setting to prevent dropping NDPA frames. Without this
change, bfee functionality may behave abnormally.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Link: https://patch.msgid.link/20241230194202.95065-5-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 2b34ae5e0cb57..cc4c010d28b83 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -496,8 +496,7 @@ static void mt7996_configure_filter(struct ieee80211_hw *hw,
 
 	MT76_FILTER(CONTROL, MT_WF_RFCR_DROP_CTS |
 			     MT_WF_RFCR_DROP_RTS |
-			     MT_WF_RFCR_DROP_CTL_RSV |
-			     MT_WF_RFCR_DROP_NDPA);
+			     MT_WF_RFCR_DROP_CTL_RSV);
 
 	*total_flags = flags;
 	mt76_wr(dev, MT_WF_RFCR(phy->mt76->band_idx), phy->rxfilter);
-- 
2.39.5



