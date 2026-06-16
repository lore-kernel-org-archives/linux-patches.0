Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8CA47DD58;
	Tue, 16 Jun 2026 18:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636238; cv=none; b=NRVD9kCBV1fpcMALI9o36hr6YNOT8wL0iD8/emkBBHWPLu4y3u8X58z0cS5i8JDNtKuYAHTpWQiiabUTzBZrzriLT7RLq2TXQp8FtZsbh4saVeGvAj4HaBPHQ+Cubn/RrO8oy9pt0bHaE5wevco92wPQIpoTrjQMwGzvt08yAFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636238; c=relaxed/simple;
	bh=955/2Cz5MwYx2ltpIBfKJYixQUwIFVUj71E+SgdIKS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CIAM9jejMQMwZyiiczr68ocygJjoxRqChUdC7DSJdaF3in5oLYhWuY9P2uK2Le62ekYGgjXIzvi071BtmqzP4ScwVjFris+XxJKquRMK6ipsIiek5SRgkpM8H/5LQmCy5+XdYknsKe3NnrhXoBHGYDIOio3ir2Ue2WoSEHSFfWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+e87rA7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+e87rA7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EC01F000E9;
	Tue, 16 Jun 2026 18:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636236;
	bh=8Jq3IpzODHYaAIqtwxNHyVB93ZYSJDjOXxLbAhGxPMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A+e87rA7a7l57vpIK402MPTmVwJfiDezVPcVnReHDpcLTePIbyw4v0ZbvBHDZELAg
	 U39YTK2bc5aDp+KikGOBN1DJpY7EYyA4g/qEonF6vSYnLUxBFD7LCAT0wbVh/eFHQo
	 Llu47S07hRgmCiKyoArDXsDd90fBnfj14rjUY6mY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 201/342] net: mv643xx: fix OF node refcount
Date: Tue, 16 Jun 2026 20:28:17 +0530
Message-ID: <20260616145057.559885043@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2754,7 +2754,7 @@ static int mv643xx_eth_shared_of_add_por
 	if (!ppdev)
 		return -ENOMEM;
 	ppdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
-	ppdev->dev.of_node = pnp;
+	ppdev->dev.of_node = of_node_get(pnp);
 
 	ret = platform_device_add_resources(ppdev, &res, 1);
 	if (ret)


