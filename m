Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B97BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:47:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0CFC433EF;
	Tue,  7 Mar 2023 18:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214870;
	bh=m3MQsWTe66P7ir9UaqA+ud0iVKt5VHvZl/tRkCPv41E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OU9Qv6D9EC1uo6w28D8/x8KPbn6FHj2TY1+uHMwpevoOwHonCY5t70c0Z/YGDkEbQ
	 /0iYx41dknyRum65qfmwrXy2LK0UHtc9/dqn8PKftSPvivf7rF8ISq6JiC42DzNyZe
	 Li9vakkCrHHDktLPjrH1Dx5b56m9YUgouJU9sIn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 076/567] wifi: ipw2200: fix memory leak in ipw_wdev_init()
Date: Tue,  7 Mar 2023 17:56:52 +0100
Message-Id: <20230307165909.199810417@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 9fe21dc626117fb44a8eb393713a86a620128ce3 ]

In the error path of ipw_wdev_init(), exception value is returned, and
the memory applied for in the function is not released. Also the memory
is not released in ipw_pci_probe(). As a result, memory leakage occurs.
So memory release needs to be added to the error path of ipw_wdev_init().

Fixes: a3caa99e6c68 ("libipw: initiate cfg80211 API conversion (v2)")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221209012422.182669-1-shaozhengchao@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index df28e4a05e140..bb728fb24b8a4 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -11400,9 +11400,14 @@ static int ipw_wdev_init(struct net_device *dev)
 	set_wiphy_dev(wdev->wiphy, &priv->pci_dev->dev);
 
 	/* With that information in place, we can now register the wiphy... */
-	if (wiphy_register(wdev->wiphy))
-		rc = -EIO;
+	rc = wiphy_register(wdev->wiphy);
+	if (rc)
+		goto out;
+
+	return 0;
 out:
+	kfree(priv->ieee->a_band.channels);
+	kfree(priv->ieee->bg_band.channels);
 	return rc;
 }
 
-- 
2.39.2



