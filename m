Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72525227EBD;
	Tue,  8 Apr 2025 11:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112656; cv=none; b=A9B2WHABo6YFeuF8LFPd5fPcsewGZugPe1yVZEfS+AWIGKd5WaJJVCJ9PMLeoBnBlwKGsPSra7qkxSJ2fK4zy1paCi6pAAOvj6zT+lXUbBcJ6vRw5zFm0Hu8yRY9a/rdghfB3yPuo3vk9AS9v/kS/yivPyFmcdbwwfkSjRbpg/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112656; c=relaxed/simple;
	bh=R50GI6e/sfs1gW+dkCxdRDAsAUTkNAaJ8rXMu9wIl6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nRIfNgQaYJ/slbqlKMz7jY026P5/GFDzlWlGvCa6Fp80YnVkLFr/mj5yeJHdjpPHFSMnqgheEmtQzpxvMib34+vtXu6hkyNNWzKHN0XKV4yY/orNGhwPM3QmmCBx0dCrW+CcvLqrGaKaUz07vO/l2M28yhT2q33z7/erJH9yOw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KdZkODal; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KdZkODal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7C6C4CEE7;
	Tue,  8 Apr 2025 11:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112656;
	bh=R50GI6e/sfs1gW+dkCxdRDAsAUTkNAaJ8rXMu9wIl6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KdZkODalD4SqO+9/YLL8Q+DyuPYxSCtZm725ApftBNd5InbKNpnPcGIvrT3OO6ppu
	 BbxJSZfwhAUjsat5RTxwsys4Xy7iC216Jk1diPcESVp6WWOnxVuook6II0XXd/w8qr
	 m0x52QG+5Tw/EMjXuJzivTeV20KiVxm9y1QjcXm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 149/279] drm: xlnx: zynqmp: Fix max dma segment size
Date: Tue,  8 Apr 2025 12:48:52 +0200
Message-ID: <20250408104830.358190128@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 28b529a98525123acd37372a04d21e87ec2edcf7 ]

Fix "mapping sg segment longer than device claims to support" warning by
setting the max segment size.

Fixes: d76271d22694 ("drm: xlnx: DRM/KMS driver for Xilinx ZynqMP DisplayPort Subsystem")
Reviewed-by: Sean Anderson <sean.anderson@linux.dev>
Tested-by: Sean Anderson <sean.anderson@linux.dev>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250115-xilinx-formats-v2-10-160327ca652a@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xlnx/zynqmp_dpsub.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/xlnx/zynqmp_dpsub.c b/drivers/gpu/drm/xlnx/zynqmp_dpsub.c
index 5bb42d0a2de98..78b7dd210d89c 100644
--- a/drivers/gpu/drm/xlnx/zynqmp_dpsub.c
+++ b/drivers/gpu/drm/xlnx/zynqmp_dpsub.c
@@ -204,6 +204,8 @@ static int zynqmp_dpsub_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	dma_set_max_seg_size(&pdev->dev, DMA_BIT_MASK(32));
+
 	/* Try the reserved memory. Proceed if there's none. */
 	of_reserved_mem_device_init(&pdev->dev);
 
-- 
2.39.5



