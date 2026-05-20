Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336433F4DD7;
	Wed, 20 May 2026 17:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297158; cv=none; b=ICk2qpJJB6NbhJNcjUZbTwMCOT/1TDOQbOw0C1pe1ugvbqj5kFp1IQRc6YoL5/OtJZFHdWXiT0hW8KHOvN3cLK672WbPgNyb6TI7VbL73QOkSNZDJuDNTTR1EtWu7+nD7ESMbGAiJf/VbxpdXFK2zyQ0ORJvHrx+c8GADIS+7XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297158; c=relaxed/simple;
	bh=MivRvTScXENJK23Fi9coDEv8bKAFjrzf6Is8C6GrRdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0FSYYhWuvBE1vIyJEkDA1smzFo4ZuBJlAygxjSpLO50RIw9U6NyODW5g6F2PPhhF3MZEmlFg98fdZPOuOcsujcqqEM74bJAcCJjNRcSxtP+PmkXj3Xu0N69qfw5iOdeKscfNn2WEQ/yUuFS40Bc1ulp/DM/2sVAuWgwN7a2CYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CDDC8QqH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CDDC8QqH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6CD1F000E9;
	Wed, 20 May 2026 17:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297157;
	bh=+ZxKbEkV2T1/DIkIebAMj1nZoAQImpldWRC4VwC9xVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CDDC8QqHtZ77IY5qi5tkDH2fF1AEXbYQcGwZFeDzq0inEQ3DRZc6lDX/8qX7gfhOa
	 BFjcszUDBTO/wX5MK0HRgLxI4ZQ+oF6vl+NWVYOV1VO6NrSCRCiPwd4ADvQtYrpqZl
	 zZmFIKoc9U8ck1gyMZ/MxXZFFwy/7VEMUd5CCS7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jianmin Lv <lvjianmin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Myeonghun Pak <mhun512@gmail.com>
Subject: [PATCH 7.0 1072/1146] drm/loongson: Use managed KMS polling
Date: Wed, 20 May 2026 18:22:02 +0200
Message-ID: <20260520162212.492472680@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -292,7 +292,7 @@ static int lsdc_pci_probe(struct pci_dev
 
 	vga_client_register(pdev, lsdc_vga_set_decode);
 
-	drm_kms_helper_poll_init(ddev);
+	drmm_kms_helper_poll_init(ddev);
 
 	if (loongson_vblank) {
 		ret = drm_vblank_init(ddev, descp->num_of_crtc);


