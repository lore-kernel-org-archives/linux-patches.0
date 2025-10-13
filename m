Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438A52566;
	Mon, 13 Oct 2025 15:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368601; cv=none; b=r0BSAvDxrYvDbVVWgDbmqdjPEv5NPnW3rJ0Ic/37QEnUoumius+Gf5ttVBDMTQUqS2cWfZhO5A9CqWWP7TJc131B4PTn0+sBi0JfNin0M82WKMBi1DUou0x1o8F2Y7FCcHeoPweB8zoNhmzY8N7W81OZncpL00c7UVJTaeo32WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368601; c=relaxed/simple;
	bh=dN2MRB3lHnC/lv8O4z3R50J0HSBOlkhFAQBADuxH8V4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GwfDHnIcPnvHaqGDaFRwRVYG/NCwfu1fPoYE5t1jNoZgGqjlOUxyMwb9D1eWMu/OBcqwhWBKgHTxcVUBc2iWruKX9HKVN7keHAP/Y8TK8hx14d6LYrHeL5Q5lwNeX5GXUuEsCKpvOwWHL+Ask3t5oTphYzfiaRCFIvxnhfJ3jpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H7vslPsi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H7vslPsi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD017C4CEE7;
	Mon, 13 Oct 2025 15:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368601;
	bh=dN2MRB3lHnC/lv8O4z3R50J0HSBOlkhFAQBADuxH8V4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H7vslPsiDXaM8F+mHW9PCYbfWiwOYRJspUe1PN/lrk+svzfwSj3HSa2Bd+Zsz3DPv
	 gPVwbgZhFrPzYDFvczTiPYyMlT3150vEm+mTgxsYGrZwo9A7I62uF49TxbFLImFx/O
	 fuek4GY9kG0djio0BDkl8+RmZl1D+OeA1zc/cP4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Brett Creeley <brett.creeley@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 175/262] vfio/pds: replace bitmap_free with vfree
Date: Mon, 13 Oct 2025 16:45:17 +0200
Message-ID: <20251013144332.431483740@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit acb59a4bb8ed34e738a4c3463127bf3f6b5e11a9 ]

host_seq_bmp is allocated with vzalloc but is currently freed with
bitmap_free, which uses kfree internally. This mismach prevents the
resource from being released properly and may result in memory leaks
or other issues.

Fix this by freeing host_seq_bmp with vfree to match the vzalloc
allocation.

Fixes: f232836a9152 ("vfio/pds: Add support for dirty page tracking")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Link: https://lore.kernel.org/r/20250913153154.1028835-1-zilin@seu.edu.cn
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/pds/dirty.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/pds/dirty.c b/drivers/vfio/pci/pds/dirty.c
index c51f5e4c3dd6d..481992142f790 100644
--- a/drivers/vfio/pci/pds/dirty.c
+++ b/drivers/vfio/pci/pds/dirty.c
@@ -82,7 +82,7 @@ static int pds_vfio_dirty_alloc_bitmaps(struct pds_vfio_region *region,
 
 	host_ack_bmp = vzalloc(bytes);
 	if (!host_ack_bmp) {
-		bitmap_free(host_seq_bmp);
+		vfree(host_seq_bmp);
 		return -ENOMEM;
 	}
 
-- 
2.51.0



