Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5416277636;
	Tue, 23 Jan 2024 02:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975539; cv=none; b=qKh/CR8UgiV+zSFThmaiFPRJ3E8MowsL8B8yRlmChvFMRtHX0W0jFeUcRuApkyQaipp663Aq6SiGIMX0xOeQPdlQDw3JXYF+/ryKOfGWjHueA5nTWfdKHh75xYNypzT93DRShUN6TmaSKBVTpI8olMlAh1mkkpZ2kiWJSgRJ0do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975539; c=relaxed/simple;
	bh=dBeIJBYuSTO0RAEU7ip6Y2bANWWGZZkRuxl+XcOB60E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMFwO18Wz+AvVT29ZpXqSoQT7EpwMAY6oLq/r+M1vMqIMF5j2pcjHPEP3VhbS2eONzB+Wfr1IQBTMe99MxA1FCCSnL5a9l9X3DN7OO5zxW2DE3x/P2IeFDK8sN8zrj80Kf8R2Z1dbn+7Wo8KKnAmTWbQIE45uYo/nbp0+JmjEXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1+N86or; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1+N86or"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABC7C433B2;
	Tue, 23 Jan 2024 02:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975539;
	bh=dBeIJBYuSTO0RAEU7ip6Y2bANWWGZZkRuxl+XcOB60E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1+N86ordwj2XxP7/MC5nDb5ITUn/QZH1QCIcQjoJU/MC3HHt+qD/sVMfxJsljDvX
	 GxiKxHHqIW223rNgIhN/2C702cGe9K0K4T3dblGmBJ/9JQKQN1SzLOb9i1ola3GMxk
	 UY5IRuON0sRFA1gg5iZNbV2TjRobSDyPsFv/HgkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 467/583] vfio/pds: Fix calculations in pds_vfio_dirty_sync
Date: Mon, 22 Jan 2024 15:58:38 -0800
Message-ID: <20240122235826.289075290@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Brett Creeley <brett.creeley@amd.com>

[ Upstream commit 4004497cec3093d7b0087bc70709b45969fa07b6 ]

The incorrect check is being done for comparing the
iova/length being requested to sync. This can cause
the dirty sync operation to fail. Fix this by making
sure the iova offset added to the requested sync
length doesn't exceed the region_size.

Also, the region_start is assumed to always be at 0.
This can cause dirty tracking to fail because the
device/driver bitmap offset always starts at 0,
however, the region_start/iova may not. Fix this by
determining the iova offset from region_start to
determine the bitmap offset.

Fixes: f232836a9152 ("vfio/pds: Add support for dirty page tracking")
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Link: https://lore.kernel.org/r/20231117001207.2793-2-brett.creeley@amd.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/pds/dirty.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/pds/dirty.c b/drivers/vfio/pci/pds/dirty.c
index c937aa6f3954..27607d7b9030 100644
--- a/drivers/vfio/pci/pds/dirty.c
+++ b/drivers/vfio/pci/pds/dirty.c
@@ -478,8 +478,7 @@ static int pds_vfio_dirty_sync(struct pds_vfio_pci_device *pds_vfio,
 		pds_vfio->vf_id, iova, length, pds_vfio->dirty.region_page_size,
 		pages, bitmap_size);
 
-	if (!length || ((dirty->region_start + iova + length) >
-			(dirty->region_start + dirty->region_size))) {
+	if (!length || ((iova - dirty->region_start + length) > dirty->region_size)) {
 		dev_err(dev, "Invalid iova 0x%lx and/or length 0x%lx to sync\n",
 			iova, length);
 		return -EINVAL;
@@ -496,7 +495,8 @@ static int pds_vfio_dirty_sync(struct pds_vfio_pci_device *pds_vfio,
 		return -EINVAL;
 	}
 
-	bmp_offset = DIV_ROUND_UP(iova / dirty->region_page_size, sizeof(u64));
+	bmp_offset = DIV_ROUND_UP((iova - dirty->region_start) /
+				  dirty->region_page_size, sizeof(u64));
 
 	dev_dbg(dev,
 		"Syncing dirty bitmap, iova 0x%lx length 0x%lx, bmp_offset %llu bmp_bytes %llu\n",
-- 
2.43.0



