Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FFF43D4E9;
	Tue, 16 Jun 2026 17:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629895; cv=none; b=AFcuxp9luqdTg7SzcH52qD9Gu7JddkLR2UGupYDXgU9oVyPuwOknwTEP2Ok3nNNGmtQqU2uve6D3gQki3iUtgzdt6t15Wgn8cJvOVXM5EoajoQ9wQ6WjvHDTj9FXyzEurB2GPjz3o/bq3yi2gkUr9+rvUJkAy4mbqeRmnCFQWps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629895; c=relaxed/simple;
	bh=UMeZRaW7sp3WNMhglj8dZAPcrX5BXHzWsjTQIZcATv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQkQq2nRd5IvymlAcZ/cAOV7sFydDyBZoUkgaC0Kde3Z+z5LrT/V2yOfCVQ3cx89blyce5QXvFFTuSpscrvGmnksbBGM4VukYTLV7kg5UD0gTgqYQN0QWavDxVltY1s1hqBm3+xjmqybnjLr2GE5PEudlWFpDcUXxJMq9JK9nrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBGNhVOT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBGNhVOT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE4C1F000E9;
	Tue, 16 Jun 2026 17:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629894;
	bh=Oe02UpJ+RKFP5LW0Ro0Npiqg/bshcSBYknQFkG7fpHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QBGNhVOTPvdKopSzcUfAxpokmeErzs3ETG5vo6ZDIxoyK5WKqaS2dx8Ud+ZoEahDs
	 /8mtL/lqh9+E+0qpOTaDitYo3IOfvhd2nvI65UUmMHEXns52QrkqsP4u4gxuTUR6EV
	 piqIxg8FxN5eYTDtowRgai7tb6opxTrlFIu/iKFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 339/452] net: mv643xx: fix OF node refcount
Date: Tue, 16 Jun 2026 20:29:26 +0530
Message-ID: <20260616145135.117044608@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


