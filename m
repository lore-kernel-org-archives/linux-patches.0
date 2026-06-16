Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CE53D8105;
	Tue, 16 Jun 2026 18:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634248; cv=none; b=nIdLj5NjJTukghSM2uWedkrP5KP1llJe/Vl5af3pZmAaYQc5zODgk3HoYEvK24CQtdwff/M15tUx9CZRygMNx6dkce1i6lBqWezs6SOLAkS3peuoa341YpO2Ecd8OxisieiH2mGnRQJOiufX7/lXCrQIPDuhM+0p9exTlo82tCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634248; c=relaxed/simple;
	bh=aQNayC/zveSorb0LYeB5brxvZfiw+HSVtqz3mVT7CKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ugqSNBrK0NyrNNGYIALfCS9gbfgkUrzBrIUMyoSy8/vos0uv6/pV86ukKtzjS8IDDVVUzoQBEbnIWMRUrTqQwjwh0Omd9XIaCRQaaOaXrnz1uEndd+YgrPFF+W/6QD+tFv6PrLs6rp48L52IjCAOJ3mhb6sWICNwhD9F56BsfJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VnZORjhD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VnZORjhD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9C81F000E9;
	Tue, 16 Jun 2026 18:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634247;
	bh=fTynyGwwnLBsvwS10xHKHYRQWRaWcRO6hB7sCdcMsxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VnZORjhDUUyjmnAy8dKBBn9HeL5Jb73r8PYtDybRfeVaWNa4NH2JJAUJM2gGI6ZMT
	 8BxUYuHYi+kh8xJsw3lNLNRtSd+MTDy/zgEEmOt7fvhY/K53SSX5nUUuWLjhJXvIld
	 nsFHBeL+hFtm/jg6KSLj6lvo+vvWihElG+inQR5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 230/411] net: mv643xx: fix OF node refcount
Date: Tue, 16 Jun 2026 20:27:48 +0530
Message-ID: <20260616145113.051788621@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2777,7 +2777,7 @@ static int mv643xx_eth_shared_of_add_por
 		goto put_err;
 	}
 	ppdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
-	ppdev->dev.of_node = pnp;
+	ppdev->dev.of_node = of_node_get(pnp);
 
 	ret = platform_device_add_resources(ppdev, &res, 1);
 	if (ret)


