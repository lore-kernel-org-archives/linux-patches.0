Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98081CBEAA;
	Mon, 13 Oct 2025 15:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368490; cv=none; b=jO7QrRdP77HtIA4McGoryP0tXGNf32ib7yZckN9aFWli7Af45eY2WiT92stvxk5wDWf6iAnyc4/zVWE9XX7p1OqlYL+pf1jqOy4DMt0VuSMnmd3PC+2+9cvJOwk7lHGRDJECo5S+sWb5rXlHq4tmL18bqsctEdhiJ9co5MxFN3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368490; c=relaxed/simple;
	bh=D5iwSav7aP+pvUngOMTls0I6KDJrFb1v5Gr4u6V+3Q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HRPYWzTWvFqHBaWDTKHncEmUtbZcsbXSsz/BAutRC+Y+vmCFLbrr9aSpgXEd1XvtMxArLW7uTrKCMVOzCgqabrc9DyDLhX5gCtnfTKXxS9cHr023pUunSPMMk3qu4IBnOmVNfaN/YpF/IRQqJ1gPrk3gd9AJhllb9fIRgGAq9Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IyB+StN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IyB+StN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621DAC4CEE7;
	Mon, 13 Oct 2025 15:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368490;
	bh=D5iwSav7aP+pvUngOMTls0I6KDJrFb1v5Gr4u6V+3Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IyB+StN0g+bSxDMzZjqVof7MabjRgl8YaSHD0KvY1oIIkK9EIw12iBI2CrqWDVfqQ
	 WGUd5pH5e1clFRwhPIeuX9dTO2du3MM/QHz3qOFr+guIKpQ6B7R5mR9hytrAPfklg/
	 wtk6VzkGQ7ZWHiUZwRb07HPgnpVz/MBwUnb8YBkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 147/262] wifi: mt76: fix potential memory leak in mt76_wmac_probe()
Date: Mon, 13 Oct 2025 16:44:49 +0200
Message-ID: <20251013144331.416221906@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Abdun Nihaal <abdun.nihaal@gmail.com>

[ Upstream commit 42754b7de2b1a2cf116c5e3f1e8e78392f4ed700 ]

In mt76_wmac_probe(), when the mt76_alloc_device() call succeeds, memory
is allocated for both struct ieee80211_hw and a workqueue. However, on
the error path, the workqueue is not freed. Fix that by calling
mt76_free_device() on the error path.

Fixes: c8846e101502 ("mt76: add driver for MT7603E and MT7628/7688")
Signed-off-by: Abdun Nihaal <abdun.nihaal@gmail.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://patch.msgid.link/20250709145532.41246-1-abdun.nihaal@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/soc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/soc.c b/drivers/net/wireless/mediatek/mt76/mt7603/soc.c
index ec02148a7f1f7..2ee8a6e1e310e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/soc.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/soc.c
@@ -48,7 +48,7 @@ mt76_wmac_probe(struct platform_device *pdev)
 
 	return 0;
 error:
-	ieee80211_free_hw(mt76_hw(dev));
+	mt76_free_device(mdev);
 	return ret;
 }
 
-- 
2.51.0



