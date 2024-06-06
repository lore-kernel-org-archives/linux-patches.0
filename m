Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344491BF8E3;
	Thu,  6 Jun 2024 14:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683550; cv=none; b=cpktj8uxnrbGhkX2fV1+mLgF+NDRvNcK462V/O1krQ3itlf1LTwgMjcu+IWulqH0VYt0pbhNriX7NisHRRMLZALey2HzHd/PyuH402Wb27yunpVCx1/ZBlb+JmZvLdeTmk6eiKn5mdNS/G/xwtzyijoCl0c3kvSYG/1OsfrtkFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683550; c=relaxed/simple;
	bh=Dnxocy+DvWZeXRssaU3Egn7hwaMGhBPbV50F4fAl624=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqXrnVxeGY4FlvW69l0pxkDmG1Vzx2zm4WO06Wc4I9Myu9IPkK3WjPTG2EAaJAsVbzAailalBJ+6vDmBapc/nVhJtV2NZidEixGYraNiIBFgGJk2auEfjCxFwK/xOlKsZdfH/5D4C7+SvU52vr9wbitKU0E/AuMiQ9PMP/voP84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TbsGhfhz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TbsGhfhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1673EC2BD10;
	Thu,  6 Jun 2024 14:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683550;
	bh=Dnxocy+DvWZeXRssaU3Egn7hwaMGhBPbV50F4fAl624=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TbsGhfhzCXxWF1Wm1qzW6bQ9Y2EQz5Dnptomw/QFXtcfA+voBxlSQ6vt3SNlvSnvw
	 sfJLtqI736VNh3ntgHiDzge5gr5FtawS8MOiLruirsG0Dz3XeCn1hk9LcCY15J22a/
	 1mTQkNw/2bhd6wKJp0G6YYyk0amVFb7NNZxYMzFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 459/744] vfio/pci: fix potential memory leak in vfio_intx_enable()
Date: Thu,  6 Jun 2024 16:02:11 +0200
Message-ID: <20240606131747.192629347@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 99bbd647e5d81..620134041b488 100644
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



