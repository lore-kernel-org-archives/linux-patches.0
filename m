Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A22019B3FF;
	Tue, 15 Oct 2024 11:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993076; cv=none; b=qpYX8o0AqckyyJ83IJRQ5JhMUIF8SvO6mRXPLEY6OhUlCV9/JUwkZWU1XwglEx5RYW80xneDt07hT8z8aFXyBl2gertmim7WMTTwGUVUbJPkg+MDIVbp3GFpj/Z7zUK6F8Ul1QysyLdWJUWqONUU2rsLbkS2u5s9V8HzgOtL7jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993076; c=relaxed/simple;
	bh=ZnQjG7YSkXi56dk/4eZ1pebXwjxChY+ZTlQPVMEgPRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXz2IMonNquy7SKHpz6QEWyknbXq5LoPJpewJVwCqqOasOewtIeEQaEP80JjoQ7uku7pWP1jhc/qAJbKtOo091W5eIYAH3nd40zI7RaYbAK4N5iaTLpyNb2j5gyZ6NPbpDI3aeCWpagubVIctsT2R7aTM7Z5F2Nk+k1N8Frfo2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KccSqGmT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KccSqGmT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE287C4CEC6;
	Tue, 15 Oct 2024 11:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993076;
	bh=ZnQjG7YSkXi56dk/4eZ1pebXwjxChY+ZTlQPVMEgPRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KccSqGmTq714FYH32zrx/mTIQ8nFAtz01ToqgJpDhf5ima/gNMNajFh7KPn9FPvvU
	 nsaeTR8xpEGNKg/vFmm7dvOVxxgIQM0otkKEPTTNOiLdaFyjNJ+/jMu+o5N6gM0IfX
	 yQxm27IALLK6xXrBR6whHU0+h8g+t3kA8lIborsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Oleksandr Tymoshenko <ovt@google.com>
Subject: [PATCH 5.15 303/691] vfio/pci: fix potential memory leak in vfio_intx_enable()
Date: Tue, 15 Oct 2024 13:24:11 +0200
Message-ID: <20241015112452.368312916@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ye Bin <yebin10@huawei.com>

commit 82b951e6fbd31d85ae7f4feb5f00ddd4c5d256e2 upstream.

If vfio_irq_ctx_alloc() failed will lead to 'name' memory leak.

Fixes: 18c198c96a81 ("vfio/pci: Create persistent INTx handler")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Acked-by: Reinette Chatre <reinette.chatre@intel.com>
Link: https://lore.kernel.org/r/20240415015029.3699844-1-yebin10@huawei.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Oleksandr Tymoshenko <ovt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/pci/vfio_pci_intrs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -181,8 +181,10 @@ static int vfio_intx_enable(struct vfio_
 		return -ENOMEM;
 
 	vdev->ctx = kzalloc(sizeof(struct vfio_pci_irq_ctx), GFP_KERNEL);
-	if (!vdev->ctx)
+	if (!vdev->ctx) {
+		kfree(name);
 		return -ENOMEM;
+	}
 
 	vdev->num_ctx = 1;
 


