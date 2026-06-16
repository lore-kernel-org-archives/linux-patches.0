Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492D01E8320;
	Tue, 16 Jun 2026 16:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625963; cv=none; b=Dcg6ycfsBO/IVqM8o+LVa5NtHFjj6wnW+h3Q3fk+MP8khRT4gjbfzQ5Ma8QGxtgnGDKYyOQAKgTJP5gs44A4AYOEjCGS2eT7dF+OwBdMX/z/5U9xtwAvcm6gqDCIbKTotcC/+VKKILuD1RRVTibTWDpluX7YugOIYI3bQLjJwvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625963; c=relaxed/simple;
	bh=Zjuc2OLa9ctFcTf1k15pxU5+lyl0pEP+uevx0cxBZwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R209A75a+ts+QKuX2qeQlQs9CFgZ74ceZoz2x8IFixtwQsTgr85blCT0GN25ugepiqBRgHMpQ4SWxsv2l6DHV5A35tH/cDhVmkEeqH/Ga2Rb8IIuPrdGdiP1C/BC0aDIaJ7FtC2/L4r89sYwWF6P1Mtnpe1m5sjR9+lIKiGk0Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SLQDqa18; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SLQDqa18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 422641F000E9;
	Tue, 16 Jun 2026 16:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625962;
	bh=BzMV5uf8SQb0zhJCeQIvGx9TLI1GvisFAda4xVZtpw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SLQDqa18lUS2BcwGVWI9qV0RXWfOcAkWARgdNUEDd/gQgrLXvaLGxFzzsEDD4dKIj
	 MvqYOVUWAyhFeUPCbc37LN43WY8fDdLbT1bBQBTIECFhaEEJkjGeJu//dcGBHhpl8l
	 2iHF1PQiQDZ5d6GwSJyyRO8dmX9CiQTEdulx+RGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 239/325] net: mv643xx: fix OF node refcount
Date: Tue, 16 Jun 2026 20:30:35 +0530
Message-ID: <20260616145110.356569746@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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
@@ -2781,7 +2781,7 @@ static int mv643xx_eth_shared_of_add_por
 		goto put_err;
 	}
 	ppdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
-	ppdev->dev.of_node = pnp;
+	ppdev->dev.of_node = of_node_get(pnp);
 
 	ret = platform_device_add_resources(ppdev, &res, 1);
 	if (ret)


