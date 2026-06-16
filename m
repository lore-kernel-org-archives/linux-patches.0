Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4E746AF15;
	Tue, 16 Jun 2026 16:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627506; cv=none; b=LO+OnKlFQHc+tMFziM/Zvw29VP8mUPG/K1429kRcjh4sMz2hB7TPlq5sFXgxffDM2m8LRZLMc4f3cGgS09dWME3iI+yE29KYTdl/gnY7ulHDT8W2Rn8jbJIAV6TUFal4+cHnt6Gm0va6OhndojyF35p1K80WL+iHrkfmfriNiAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627506; c=relaxed/simple;
	bh=i8cvVW8BlxvAzliU2kcZTBH+GI+KtTcW2m46ReNpgJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VIvyrhg+zq+9mdNHx7Ome3JU/K8ZI6Qt/vGnFMOtUtg/r6+GaXpCb/NhpXk9K6UiIVsOvf6nrQOaX7psdQPNwTLgYlN1+QlpP3d0/qD/gzvWuI95j7JfzQNSTjDj5KvFO5M8tD3Qjx/UD8IjsOZWT+0Y0knM9Btqrakl6ndswtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zDxnIqxB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zDxnIqxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0643B1F000E9;
	Tue, 16 Jun 2026 16:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627505;
	bh=zyPCbiA2eEzZLque7W+2llVs+kMl7hn3k4+GAKxWLBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zDxnIqxBqwdOljvvabnXgd0TZQlbBvJKBn2sq6x+hFNDV0pCUac1dXSsLY+58AK0e
	 Pq2y8hL1OG8P/rRCyvxyGgJhZp4IEWcM5XXZlrINVg5P/vjnsPxMpRUMdHGWpnCctW
	 5uYWNcXQN1bUILwCP137cys1W1XZamQHtV0nvmSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 184/261] net: mv643xx: fix OF node refcount
Date: Tue, 16 Jun 2026 20:30:22 +0530
Message-ID: <20260616145053.596107873@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit 4aacf509e537a711fa71bca9f234e5eb6968850e upstream.

Platform devices created with platform_device_alloc() call
platform_device_release() when the last reference to the device's
kobject is dropped. This function calls of_node_put() unconditionally.
This works fine for devices created with platform_device_register_full()
but users of the split approach (platform_device_alloc() +
platform_device_add()) must bump the reference of the of_node they
assign manually. Add the missing call to of_node_get().

Cc: stable@vger.kernel.org
Fixes: 76723bca2802 ("net: mv643xx_eth: add DT parsing support")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260602073414.22500-1-bartosz.golaszewski@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mv643xx_eth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2784,7 +2784,7 @@ static int mv643xx_eth_shared_of_add_por
 		goto put_err;
 	}
 	ppdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
-	ppdev->dev.of_node = pnp;
+	ppdev->dev.of_node = of_node_get(pnp);
 
 	ret = platform_device_add_resources(ppdev, &res, 1);
 	if (ret)


