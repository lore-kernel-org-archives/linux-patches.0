Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1971974E3;
	Thu,  6 Jun 2024 14:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682942; cv=none; b=spvCsoEeAVyQPvecTboCMKzZbvsel5ze+aKgpYPWCnxaBWFSEcmY8A+IAVhK0nXt3LCFWciyW9JIq0Sc65XUyBd3DVcJU0jAcsJFREZPnHEEiav1a2WB0CdUA4+MUKw+JCDEwZyv7EX+1PQI4fqTuC6jpOUp9BlkrE9dwa/sD+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682942; c=relaxed/simple;
	bh=nfdoEEE9qkPjzCQ76+GpLT2wXb445MwkV8EgUcm1f30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ShPCJc5L9kARNpIjzRXMwglgHY5rdyRv4/PeOhlAGe7gjGrjfQtSSIOsjdn98tZx7LE+5v4lh8F7VbkKtV2mCk1LE3WkZ6koTg0mLcxJDTgn1eQAoL+bsGn2yMf+HSSm63nZVMKdpNY5X1SrMX3y4MtHOWHeVEJCV3Jh5OoQ9HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nYOTDkD3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nYOTDkD3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20382C32781;
	Thu,  6 Jun 2024 14:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682942;
	bh=nfdoEEE9qkPjzCQ76+GpLT2wXb445MwkV8EgUcm1f30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nYOTDkD3gh5R/mh9BgfUjsvAzUMD95qDSOiCk6PIIi0j1NMdE+iDQaBFIU7HM1h6C
	 krODk6O6AXWVz9LYnOuD1bVhuYGISCgaffCF6PEPcCJg07HV6zqcCidJUE8ekurJXZ
	 ahu8oaCM7EKJtg2bZAe4L5a5B15AFMgF8TKQ+D3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 059/374] vfio/pci: fix potential memory leak in vfio_intx_enable()
Date: Thu,  6 Jun 2024 16:00:38 +0200
Message-ID: <20240606131653.824301380@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit 82b951e6fbd31d85ae7f4feb5f00ddd4c5d256e2 ]

If vfio_irq_ctx_alloc() failed will lead to 'name' memory leak.

Fixes: 18c198c96a81 ("vfio/pci: Create persistent INTx handler")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Acked-by: Reinette Chatre <reinette.chatre@intel.com>
Link: https://lore.kernel.org/r/20240415015029.3699844-1-yebin10@huawei.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index fb5392b749fff..e80c5d75b5419 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -277,8 +277,10 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev,
 		return -ENOMEM;
 
 	ctx = vfio_irq_ctx_alloc(vdev, 0);
-	if (!ctx)
+	if (!ctx) {
+		kfree(name);
 		return -ENOMEM;
+	}
 
 	ctx->name = name;
 	ctx->trigger = trigger;
-- 
2.43.0



