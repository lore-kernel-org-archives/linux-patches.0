Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592421C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE984C43443;
	Mon, 20 Mar 2023 15:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324956;
	bh=AObmnfC8udOvlyc05tcfi8EbulzijvAyF4oKP9wXM0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jsbzOk+FIVzfnOZGDtdvKHUqPN2S0/zkVIR1V95hvGEoiW7+ptOL9ZyIKEe1zd7V9
	 kRb0F9gF1KIBs8JM9pH0cR2mXAC7Kx6dxdftUHb53+/DZI1mUOieS5DaKEO565OKx6
	 GUVgNjHpOdz8sjAajtpy/jbyGwnacPQqci61PGGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/198] fbdev: chipsfb: Fix error codes in chipsfb_pci_init()
Date: Mon, 20 Mar 2023 15:52:23 +0100
Message-Id: <20230320145507.675403035@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 77bc762451c2dc72bdbea07b857c916c9e7f4952 ]

The error codes are not set on these error paths.

Fixes: 145eed48de27 ("fbdev: Remove conflicting devices on PCI bus")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/Y/yG+sm2mhdJeTZW@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/chipsfb.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/video/fbdev/chipsfb.c b/drivers/video/fbdev/chipsfb.c
index f1c1c95c1fdf0..2ecb97c619b7c 100644
--- a/drivers/video/fbdev/chipsfb.c
+++ b/drivers/video/fbdev/chipsfb.c
@@ -358,16 +358,21 @@ static int chipsfb_pci_init(struct pci_dev *dp, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	if (pci_enable_device(dp) < 0) {
+	rc = pci_enable_device(dp);
+	if (rc < 0) {
 		dev_err(&dp->dev, "Cannot enable PCI device\n");
 		goto err_out;
 	}
 
-	if ((dp->resource[0].flags & IORESOURCE_MEM) == 0)
+	if ((dp->resource[0].flags & IORESOURCE_MEM) == 0) {
+		rc = -ENODEV;
 		goto err_disable;
+	}
 	addr = pci_resource_start(dp, 0);
-	if (addr == 0)
+	if (addr == 0) {
+		rc = -ENODEV;
 		goto err_disable;
+	}
 
 	p = framebuffer_alloc(0, &dp->dev);
 	if (p == NULL) {
@@ -417,7 +422,8 @@ static int chipsfb_pci_init(struct pci_dev *dp, const struct pci_device_id *ent)
 
 	init_chips(p, addr);
 
-	if (register_framebuffer(p) < 0) {
+	rc = register_framebuffer(p);
+	if (rc < 0) {
 		dev_err(&dp->dev,"C&T 65550 framebuffer failed to register\n");
 		goto err_unmap;
 	}
-- 
2.39.2



