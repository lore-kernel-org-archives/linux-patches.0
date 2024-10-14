Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08BE1BDC3;
	Mon, 14 Oct 2024 15:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918281; cv=none; b=EzS5emvSoMDjgVEW7SDLGy/E0hq8LnUAjpLo1tUx8cfjeMSRrwBqGiIg/UBK+xhqJTC+prlLqtux+o+0Tvgp5JRhJyAuoWAYsaNFnm+u1SyfgTo8JQiRDlDwS1F7MIGsJNDXUEaRJo6CqAIedIi5HCeJNK6Mn8UfGBiaGhoki58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918281; c=relaxed/simple;
	bh=fuwLa5hCsJ0IkcxTxLTAJf+VXPUbqaluaCIxYhL0GJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=otgdWIOOKcf23rp4Lb/ySh5tHxXBTM1e1ra2DpmFz75KIrnWlssfcKqg3wVvpXaNO0IyYBKpA9FVudM8lYSpY41NA3MUssXhNlYsq1n4wBIUi+t+BDEMxJiyx0Fj+rfV9/fxtV//MEcJLzGwvbA1rVEjyibWB0GrN+cUHFhzL9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxrPWXU1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxrPWXU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DA1C4CEC3;
	Mon, 14 Oct 2024 15:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918280;
	bh=fuwLa5hCsJ0IkcxTxLTAJf+VXPUbqaluaCIxYhL0GJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lxrPWXU1wlsgAlanwRU5N/D+VvlxRI9PvRDNQgTrxjkNiX5y384bXGjN7f7aO0Tk0
	 dnnJLEovMRrKvEQeL8hsg2iTS7sKaDCqpM60xAI44Wn3OeDCNpSV6yshDG94yAuwE0
	 W83jzjVm5LstHEwmXF775mc+S8CwqRsQeq4WWjNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Oleksandr Tymoshenko <ovt@google.com>
Subject: [PATCH 6.1 276/798] vfio/pci: fix potential memory leak in vfio_intx_enable()
Date: Mon, 14 Oct 2024 16:13:50 +0200
Message-ID: <20241014141228.779094357@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -215,8 +215,10 @@ static int vfio_intx_enable(struct vfio_
 		return -ENOMEM;
 
 	vdev->ctx = kzalloc(sizeof(struct vfio_pci_irq_ctx), GFP_KERNEL_ACCOUNT);
-	if (!vdev->ctx)
+	if (!vdev->ctx) {
+		kfree(name);
 		return -ENOMEM;
+	}
 
 	vdev->num_ctx = 1;
 


