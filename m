Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC1F30675C;
	Wed, 20 May 2026 17:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299835; cv=none; b=sKm+Vlce9n8vNDf8HjED5LVyawNcHZKTxfNCRfopaggRcDF63PIrhze/KMtgpTq7aIUSfq7xn3wSz9kGe/5R3H4SCFxHwqq+NXiG6xnHfq9YWT8ZInfNFDkKpzyn0xTKeHwwT1VrcrVx7ifCdo4qmHVsr/kqJQIazLoTaAbGyCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299835; c=relaxed/simple;
	bh=7Do49goFwFvsaEPY/wW18sPnPAlv21fzIhX4eupPCbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pS/HhIugf1BDe1TAXeSnBybFsy6xnL9ZvhqYoqGHk2ABoG6BALC1g0moftgqODxTqYZnt0Xac2jbvcm9fmjMDgZMyXO2sozQUUWXiuXhI4nD2+ynGJfhA2AurFTI6WG2qA3+mKwUlUPRY2t7s6zb4rKhvu1HD+KJudmXPBhws9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZM98WaU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZM98WaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B23C1F000E9;
	Wed, 20 May 2026 17:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299833;
	bh=/TY45QGM2zCIrpQTVQk0HsGOrAo4r9KwQXj0HhH1z+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zZM98WaUaGMzDnll4lR4veQ7dYco9i7WDf9Riny9xi/RpvBjE3FOvggNNqcVt22wT
	 XVh7DeSq0cl7PWkGFzVXxSDOhIu3vssrcfZSMxOpDlVmxP/Yxs5fbTjRzyyZawpFgj
	 irk4SWlxKDHweWAXqZv65MkNzUe1jRnfCbqHsPBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jianmin Lv <lvjianmin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Myeonghun Pak <mhun512@gmail.com>
Subject: [PATCH 6.18 904/957] drm/loongson: Use managed KMS polling
Date: Wed, 20 May 2026 18:23:07 +0200
Message-ID: <20260520162154.179821325@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit 0a9c56dd387605d17dabeedd9fdd2c4c1d0bab7b upstream.

lsdc_pci_probe() initializes KMS polling before setting up vblank support,
requesting the IRQ and registering the DRM device. If any of those later
steps fails, probe returns without finalizing polling. The driver also
never finalizes polling on regular removal.

Use drmm_kms_helper_poll_init() so polling is tied to the DRM device
lifetime and automatically finalized on probe failure and device removal.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: f39db26c5428 ("drm: Add kms driver for loongson display controller")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Acked-by: Jianmin Lv <lvjianmin@loongson.cn>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260513065706.23803-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/loongson/lsdc_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/loongson/lsdc_drv.c
+++ b/drivers/gpu/drm/loongson/lsdc_drv.c
@@ -291,7 +291,7 @@ static int lsdc_pci_probe(struct pci_dev
 
 	vga_client_register(pdev, lsdc_vga_set_decode);
 
-	drm_kms_helper_poll_init(ddev);
+	drmm_kms_helper_poll_init(ddev);
 
 	if (loongson_vblank) {
 		ret = drm_vblank_init(ddev, descp->num_of_crtc);


