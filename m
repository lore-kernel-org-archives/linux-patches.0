Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1F249738A;
	Thu, 17 Sep 2026 15:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660332; cv=none; b=EKs0qpPiWi1NSefBPwZIXAYlDbhnBNUZyYG59C2GE5AkgEUMRnKYrX/alcdWT6ufLHC9EKrtrF6dQNWp9VlN0/NDrdhHwooa33mtda9fzCj1aQyShvtrYHc0GhF+kmwoaNi2VNGgiIuCzG8zN62VoG/zg2SukdxQCQYMpihXu9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660332; c=relaxed/simple;
	bh=KGN9BeYG+A9m5d6W9/tZRXoEiFS6yGU279GVv2B8IKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ND5StGN+tuHu0MD92l0kTgmy2shFdpSlYYvKhSekgmqAziAyT3XvLVh5kuT2xuINWeD8DlTNqR2KvO71ffq3NXj1Iu8CaAR4ClJQhTCna8ng6iALuWLWdu0vwEMMJtMl0zuS203LzIsBKy8hgrEQr80QSvQoK+jKYYXdcgcnVf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GKjGo4h/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GKjGo4h/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF7B1F00893;
	Thu, 17 Sep 2026 15:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660330;
	bh=WpZjnotAQEs+OyevucyKOhzepe2iZTdvfsMx4QJ4Iss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GKjGo4h/ieZBjj7YgJi7OpQzdciKSYe3ts0VYIMxK3zvkXI7W7yoxEHvYctUby2GS
	 v1I/oP3AJfG4d8mgYstD3vGdfXc3rn6BzanCquQ6WOSZ9LF0qgcxEhX6fdE1Ddsq9r
	 q0mof0hJ/vObb9Byo49dEq2XIE9vQuRHT5EVVLFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiong Weimin <xiongweimin@kylinos.cn>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 7.2 556/733] vdpa: solidrun: Free IRQs after request failure
Date: Thu, 17 Sep 2026 16:14:24 +0100
Message-ID: <20260917151406.141153975@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiong Weimin <xiongweimin@kylinos.cn>

commit e847542ab0545c73354849126150206c29d83929 upstream.

Unwind IRQs already requested by snet_request_irqs() before returning a
VQ IRQ request error so a later DRIVER_OK retry starts from a clean
state. The IRQs are requested and freed while the PCI device remains
bound, so the driver cannot wait for devres cleanup at detach time.

Fixes: 51a8f9d7f587 ("virtio: vdpa: new SolidNET DPU driver.")
Cc: stable@vger.kernel.org # v6.3+
Signed-off-by: Xiong Weimin <xiongweimin@kylinos.cn>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <178589471328.1556376.15570536900532373521@kylinos.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/solidrun/snet_main.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/vdpa/solidrun/snet_main.c
+++ b/drivers/vdpa/solidrun/snet_main.c
@@ -418,11 +418,15 @@ static int snet_request_irqs(struct pci_
 				       snet->vqs[i]->irq_name, snet->vqs[i]);
 		if (ret) {
 			SNET_ERR(pdev, "Failed to request IRQ\n");
-			return ret;
+			goto err_free_irqs;
 		}
 		snet->vqs[i]->irq = irq;
 	}
 	return 0;
+
+err_free_irqs:
+	snet_free_irqs(snet);
+	return ret;
 }
 
 static void snet_set_status(struct vdpa_device *vdev, u8 status)


