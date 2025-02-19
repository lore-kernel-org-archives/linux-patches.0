Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64BF1E0B7C;
	Wed, 19 Feb 2025 09:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955637; cv=none; b=XSVF4U7Gxiu3YiEle5l9Uap1ySznneYRnndU+/1e/XChln/Jhrxa/eVH42/zv6LoG3kTGf2/H6wN22cYcRZzB3LHtQYl7WFbiWI5ipjEVl7oLXo0sUkuoyUOVzYQmDwYdq0mFkaB/fJsLmt4VS3of9i7Me9xU6+JsRB+GeCXR/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955637; c=relaxed/simple;
	bh=nthfx4gaUVhqQxvm0EkhC2xdxwne0tJvEzA9ZbCbLR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P9/ne1mFIk2/03qlKQzp3Edd4mtuVzZTjLekKlYC31oXUtDcXQKPLfT0deKy16XzLNPoH21Mq+2D9OjBvyPaqElwNHUuFTDgeIx7vRuPVWMWyT3lyqAEAQAYOdLuZYsyhCuFjwQalopTpQsYtfCBiHNnWuhurKskFAnBDNUoD5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X1N+UJU4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X1N+UJU4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A37BC4CED1;
	Wed, 19 Feb 2025 09:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955637;
	bh=nthfx4gaUVhqQxvm0EkhC2xdxwne0tJvEzA9ZbCbLR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X1N+UJU4PDQFG49F9G04Qfzz0duVL6Iaxib13W9XaFWbsDHu7oyyxHPxoS3YhHx2B
	 t+77UZYJoAJSxFkNmdD414nAaRF2njrn+wKpMZz0kst8L+Cq8C1FcqmkH3ohsdOqwg
	 Qrq0P5vTzIoxYaXKatCMKZJAuAMdpl+sbPcJTjks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Firas Jahjah <firasj@amazon.com>,
	Yonatan Nachum <ynachum@amazon.com>,
	Michael Margolin <mrgolin@amazon.com>,
	Gal Pressman <gal.pressman@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/152] RDMA/efa: Reset device on probe failure
Date: Wed, 19 Feb 2025 09:27:19 +0100
Message-ID: <20250219082551.072514537@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Margolin <mrgolin@amazon.com>

[ Upstream commit 123c13f10ed3627ba112172d8bd122a72cae226d ]

Make sure the device is being reset on driver exit whatever the reason
is, to keep the device aligned and allow it to close shared resources
(e.g. admin queue).

Reviewed-by: Firas Jahjah <firasj@amazon.com>
Reviewed-by: Yonatan Nachum <ynachum@amazon.com>
Signed-off-by: Michael Margolin <mrgolin@amazon.com>
Link: https://patch.msgid.link/20241225131548.15155-1-mrgolin@amazon.com
Reviewed-by: Gal Pressman <gal.pressman@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/efa/efa_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_main.c b/drivers/infiniband/hw/efa/efa_main.c
index 15ee920811187..924940ca9de0a 100644
--- a/drivers/infiniband/hw/efa/efa_main.c
+++ b/drivers/infiniband/hw/efa/efa_main.c
@@ -452,7 +452,6 @@ static void efa_ib_device_remove(struct efa_dev *dev)
 	ibdev_info(&dev->ibdev, "Unregister ib device\n");
 	ib_unregister_device(&dev->ibdev);
 	efa_destroy_eqs(dev);
-	efa_com_dev_reset(&dev->edev, EFA_REGS_RESET_NORMAL);
 	efa_release_doorbell_bar(dev);
 }
 
@@ -623,12 +622,14 @@ static struct efa_dev *efa_probe_device(struct pci_dev *pdev)
 	return ERR_PTR(err);
 }
 
-static void efa_remove_device(struct pci_dev *pdev)
+static void efa_remove_device(struct pci_dev *pdev,
+			      enum efa_regs_reset_reason_types reset_reason)
 {
 	struct efa_dev *dev = pci_get_drvdata(pdev);
 	struct efa_com_dev *edev;
 
 	edev = &dev->edev;
+	efa_com_dev_reset(edev, reset_reason);
 	efa_com_admin_destroy(edev);
 	efa_free_irq(dev, &dev->admin_irq);
 	efa_disable_msix(dev);
@@ -656,7 +657,7 @@ static int efa_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 
 err_remove_device:
-	efa_remove_device(pdev);
+	efa_remove_device(pdev, EFA_REGS_RESET_INIT_ERR);
 	return err;
 }
 
@@ -665,7 +666,7 @@ static void efa_remove(struct pci_dev *pdev)
 	struct efa_dev *dev = pci_get_drvdata(pdev);
 
 	efa_ib_device_remove(dev);
-	efa_remove_device(pdev);
+	efa_remove_device(pdev, EFA_REGS_RESET_NORMAL);
 }
 
 static struct pci_driver efa_pci_driver = {
-- 
2.39.5



