Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88C622127B;
	Wed, 25 Feb 2026 01:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983968; cv=none; b=OXOXononEV9ig8bkAclaHZ/LU7HdFDvTGljTB5+IXln80HZwf7A72ekU4ddop48WIm3d0y8qR0MJpkvNoPrBSLY7JlK7AmDOAMrXGdZxhvBQWoniSMXBbSmigDxgDTEZDv2O35UcnRrBjx4eONUKGNgW/NW2YBoawZyj2GcmUh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983968; c=relaxed/simple;
	bh=3kO9t42GTTZgiN3nvfdA4TqZzK3ujnzN1nBPlGqugtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gsMBEWjeXW8DZCu7rXKewCRyjd/FqJFmnBtW/5+yLNWrufKrxqGOLpIW04o6q2o5+mr6VJ/hN251Z5ZQ/25e86GsNJowkjDnYwzZBH1p1bok3KtS9rLAdfPDVU6zLMvfXVcBwCoulOBoByOOp36qs3sLEOPpY6FTaiesh0gAH1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q3QeVdh2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q3QeVdh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA28C116D0;
	Wed, 25 Feb 2026 01:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983967;
	bh=3kO9t42GTTZgiN3nvfdA4TqZzK3ujnzN1nBPlGqugtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q3QeVdh2CK8nwnk3dYpZzZ+dcKhSVpAivh1/hQBCt3e+CflCQKapSsg03LAORYAhL
	 BjNPrYhmnLG0NK3cYXUgJtRGxurxNQ3hAkWb2Z6TxSrraRNjqc/OsAx/LoQprpjPTg
	 hpVdVniQkNu1XbrWeYv+MLQi17qd0c05kSJfCBYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 223/641] accel/amdxdna: Hold mm structure across iommu_sva_unbind_device()
Date: Tue, 24 Feb 2026 17:19:09 -0800
Message-ID: <20260225012354.320387172@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit a9162439ad792afcddc04718408ec1380b7a5f63 ]

Some tests trigger a crash in iommu_sva_unbind_device() due to
accessing iommu_mm after the associated mm structure has been
freed.

Fix this by taking an explicit reference to the mm structure
after successfully binding the device, and releasing it only
after the device is unbound. This ensures the mm remains valid
for the entire SVA bind/unbind lifetime.

Fixes: be462c97b7df ("accel/amdxdna: Add hardware context")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260128002356.1858122-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_pci_drv.c | 3 +++
 drivers/accel/amdxdna/amdxdna_pci_drv.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/accel/amdxdna/amdxdna_pci_drv.c b/drivers/accel/amdxdna/amdxdna_pci_drv.c
index ccf2d1de558c0..88643e28af84b 100644
--- a/drivers/accel/amdxdna/amdxdna_pci_drv.c
+++ b/drivers/accel/amdxdna/amdxdna_pci_drv.c
@@ -88,6 +88,8 @@ static int amdxdna_drm_open(struct drm_device *ddev, struct drm_file *filp)
 		ret = -ENODEV;
 		goto unbind_sva;
 	}
+	client->mm = current->mm;
+	mmgrab(client->mm);
 	init_srcu_struct(&client->hwctx_srcu);
 	xa_init_flags(&client->hwctx_xa, XA_FLAGS_ALLOC);
 	mutex_init(&client->mm_lock);
@@ -127,6 +129,7 @@ static void amdxdna_drm_close(struct drm_device *ddev, struct drm_file *filp)
 		drm_gem_object_put(to_gobj(client->dev_heap));
 
 	iommu_sva_unbind_device(client->sva);
+	mmdrop(client->mm);
 
 	XDNA_DBG(xdna, "pid %d closed", client->pid);
 	kfree(client);
diff --git a/drivers/accel/amdxdna/amdxdna_pci_drv.h b/drivers/accel/amdxdna/amdxdna_pci_drv.h
index 72d6696d49da8..64009ca249827 100644
--- a/drivers/accel/amdxdna/amdxdna_pci_drv.h
+++ b/drivers/accel/amdxdna/amdxdna_pci_drv.h
@@ -128,6 +128,7 @@ struct amdxdna_client {
 
 	struct iommu_sva		*sva;
 	int				pasid;
+	struct mm_struct		*mm;
 };
 
 #define amdxdna_for_each_hwctx(client, hwctx_id, entry)		\
-- 
2.51.0



