Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE2F50E5A3;
	Thu, 17 Sep 2026 17:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666522; cv=none; b=EjNtZyqB8w92K2wss5j9QW95pR72vUDxwxIJoKaIKi+8qoqk86a/yB+Tgfy/+0wEViYtJhVBA5wnYkaxLefHBpaQZqoS8Z3d190fkO3HEwqAndaxeObvw+d2yDZg8wN8zgkQB+RLZkZ2ACAmQcucCjyozJRMjMVtXjGIGmjPpSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666522; c=relaxed/simple;
	bh=J2pY80pMRg9v8lJ2LXBPU0hvLG59/x89e2edAcH0H6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZTxIilaq2VEQeAauvonUONaso5+Y1gvbc18bSOPK2ZNTsRsOvUJZGOfZ6eQMTCJ5q3WBlseywkT+aqHPIkpfcDus8F2Ft+6qPmppo6IHYZMhDGYI1k9qVhZSj8J47dHzYI4bUVRkrX4qt8NSuywmqYRAF9Ua7Vq7RwgqE9Kd/yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iux8EtEz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iux8EtEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27BC1F00893;
	Thu, 17 Sep 2026 17:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666521;
	bh=Rv46S0/GGRfrtS/nw9gWauSRPIbTeYWIAP/7vQZfWiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iux8EtEzo3kwYs8vPGCMT/FZr5IQWcElNJJo3SgtYnKUU4hH4/Ed6miXPFyNCtDHC
	 ELpexGt6jcRQdNzkVFEgKELZLucI0pKlcc6WKnfGHQ+jp4Vo9jhtdI3LewRrvAJu4A
	 qa13sU12gR724KVVK5ShsuuWU67S/cSKEMcnIbPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiong Weimin <xiongweimin@kylinos.cn>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.18 1026/1250] vdpa: solidrun: Free IRQs after request failure
Date: Thu, 17 Sep 2026 16:13:41 +0100
Message-ID: <20260917151619.869139603@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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


