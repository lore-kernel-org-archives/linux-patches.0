Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C04267B99;
	Tue,  8 Apr 2025 11:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110103; cv=none; b=JXS6IDhMTlSffwt+Ec7u/VhaNOGSpAxjNQg/FV5NDhu3P7J0I9P6qzGdga+VYtBsqwv5AoUMjPVH4z9hQKbhJOhdCZWPpbxpZfIHHIbVQWyPBfcZGkbrYraeE0cCrP/HxkHro8+8DR7evv5KAKUWu1hyIC0I9PWE0kSwA9EQFII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110103; c=relaxed/simple;
	bh=hJCC4hw9Lf8ZBWdENVsdhAlT7Y14a4ZEGMSVI6XbDEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Av/ADwoI3/Ko2w8Gfp1698NhsgdBiYxblfTR52WrAC0trsK6CZzVBkJBM9SfMlQhrkhKUX6APEV4OvAAsylBvw1vkhSUNGokZAu/xRQK8DIHGUSLvltRR6gmGx0fNKcT6WnEoZM3sJwpA9VxijxE5SfyX06ozIg/X0uZYJqrrXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TpzH/kMI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TpzH/kMI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A027C4CEE5;
	Tue,  8 Apr 2025 11:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110103;
	bh=hJCC4hw9Lf8ZBWdENVsdhAlT7Y14a4ZEGMSVI6XbDEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TpzH/kMIJVjUJhtUsWw+NEoUgUUbbZjMtZxM9rEcRFqF3NqHEI3AtzLNtZunURo3u
	 pngyRD27f9qzMo9daf1qjj/XBX2iig24Xfxyqvl+b05J+ABO63q11BgzcdOdP3JX1e
	 uwL+PU6jC/T3NWsRhlu7eam9W6YyO7WNogmN0Z3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 129/227] drm: xlnx: zynqmp: Fix max dma segment size
Date: Tue,  8 Apr 2025 12:48:27 +0200
Message-ID: <20250408104824.194318836@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5f6eea81f3cc8..ad081838c4492 100644
--- a/drivers/gpu/drm/xlnx/zynqmp_dpsub.c
+++ b/drivers/gpu/drm/xlnx/zynqmp_dpsub.c
@@ -218,6 +218,8 @@ static int zynqmp_dpsub_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	dma_set_max_seg_size(&pdev->dev, DMA_BIT_MASK(32));
+
 	/* Try the reserved memory. Proceed if there's none. */
 	of_reserved_mem_device_init(&pdev->dev);
 
-- 
2.39.5



