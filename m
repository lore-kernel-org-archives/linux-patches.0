Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA43B848D
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E94C433D2;
	Fri, 10 Mar 2023 14:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458483;
	bh=aarenZCgKYC32aWVmx3zSbR6K/XJxyvTwApO0LXrttA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqS+Rb4ccApjGKinOS97vAyXmHfaOxmYu+Su6cSFbevab/cZekrcx7OQZyd+zswT4
	 jOCINYESdlSv4BoYMaLwmXDY7ZJ6TzeEWjru3WygIVg9g34id++20lHgRR81C1mvf1
	 EIQfdE8Nq0IUULq8dy9bRsMg8U9Azet3fCcMCEig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 041/357] wifi: ipw2200: fix memory leak in ipw_wdev_init()
Date: Fri, 10 Mar 2023 14:35:30 +0100
Message-Id: <20230310133735.812373051@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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
index b2f7736a79f85..5ce1a4d8fcee7 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -11414,9 +11414,14 @@ static int ipw_wdev_init(struct net_device *dev)
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



