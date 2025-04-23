Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687B2175BF;
	Wed, 23 Apr 2025 14:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419984; cv=none; b=RUA+BFX2dFlQsv7hQpYnY5vY+W2Se8BehR+fazy/ZPCPYuvePa6mWMdqHaLL+1Zy4YxYCZRYKYEoSed82ZiKnj2zI9ErTcdylgldh+xeDM3mJhWw5RKubPNI5quNv+cmHwCXwJh3OO2RHNcX+4oRvDXfdvo8ma8DVSugbKqnQ+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419984; c=relaxed/simple;
	bh=1Oxi5BNjmjWG0PVj+PsY1ns8njgpB3kaoYz1vIX0ScI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qo2w58zkw73J7W7gDrorYgGAfRHw5VtlxfRSFmAKpq9FKBljn/7pO4WIIYgIowGy3Fynh0ZLo74wvEfYyKcoUrHZJldNml84HZCYnrsEuLtGEJc2ZcwkEwInxM5xMSheJl47zRvkafhZS7LeuHawVLeqrm+e77c4Rq+WDkcQeqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wGrNBE9W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGrNBE9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0050C4CEE3;
	Wed, 23 Apr 2025 14:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419984;
	bh=1Oxi5BNjmjWG0PVj+PsY1ns8njgpB3kaoYz1vIX0ScI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wGrNBE9WKr+qJSJrlSI+TZnHe6oxi9V+8Kzs43jy8DvOniDjLt02S5zPTU00JgPdd
	 BEbH0G5Yiy18chvt7xGPlCaZiBf/VQDJDvatSxmqb6vfS+aPHh+RiFODx5WuQMn2Uj
	 mRvi3IcPOgRDGabUbIPad+FkasZ8O1u3m7XRgxPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 049/241] net: hibmcge: fix wrong mtu log issue
Date: Wed, 23 Apr 2025 16:41:53 +0200
Message-ID: <20250423142622.512459425@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jijie Shao <shaojijie@huawei.com>

[ Upstream commit 4e4ac53335de54bcb9d26842df0998cfd8fcaf90 ]

A dbg log is generated when the driver modifies the MTU,
which is expected to trace the change of the MTU.

However, the log is recorded after WRITE_ONCE().
At this time, netdev->mtu has been changed to the new value.
As a result, netdev->mtu is the same as new_mtu.

This patch modifies the log location and records logs before WRITE_ONCE().

Fixes: ff4edac6e9bd ("net: hibmcge: Implement some .ndo functions")
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250410021327.590362-5-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hibmcge/hbg_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hibmcge/hbg_main.c b/drivers/net/ethernet/hisilicon/hibmcge/hbg_main.c
index bb0f25ac97600..4d20679b2543a 100644
--- a/drivers/net/ethernet/hisilicon/hibmcge/hbg_main.c
+++ b/drivers/net/ethernet/hisilicon/hibmcge/hbg_main.c
@@ -198,12 +198,12 @@ static int hbg_net_change_mtu(struct net_device *netdev, int new_mtu)
 	if (netif_running(netdev))
 		return -EBUSY;
 
-	hbg_hw_set_mtu(priv, new_mtu);
-	WRITE_ONCE(netdev->mtu, new_mtu);
-
 	dev_dbg(&priv->pdev->dev,
 		"change mtu from %u to %u\n", netdev->mtu, new_mtu);
 
+	hbg_hw_set_mtu(priv, new_mtu);
+	WRITE_ONCE(netdev->mtu, new_mtu);
+
 	return 0;
 }
 
-- 
2.39.5



