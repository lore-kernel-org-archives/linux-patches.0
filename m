Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA532222B2;
	Thu,  3 Jul 2025 15:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556010; cv=none; b=O3fZYbcWkccmsGP/xaAFP9TSOe9950nv+HqPh3MzKLxzemoYsDCns5ZwTmU5volcWoJp7PBj8X4eusM/MSdLW0Kv05MpamcBVJecpBgSuN66itTEXk00PVHQspk0mWwU9Bv31VHLeP+yzcYLfKibRg9J3DKkycQAG4aoXm8L/8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556010; c=relaxed/simple;
	bh=OdDYLCxHRoCYb/2ZojYiTiHP5BmZnROViVhaQghPqaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tod7rqHoZtwcLTVX6LXcXCCOTe4PFyWbXluHCnoHPs8cY/2e4sVFQQiJ9tMB7biGIku/51SXZ8+sf4aASw1gmzZpqf7zNBdH6Rv1gpGorNv6ojbYXQJdZeWVpVxWPDpQsuBLGgMZt8DN7fKZykHvSBx+gw1I5SUf7Uy7PDhv9kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u9IalgkV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u9IalgkV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C536C4CEE3;
	Thu,  3 Jul 2025 15:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556009;
	bh=OdDYLCxHRoCYb/2ZojYiTiHP5BmZnROViVhaQghPqaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9IalgkVCftTJhUuURGQj60iPqc0KwngwAgBk9InFboya4JhHYTmk6DbzQ/ceGpp1
	 OYzi9wRVyD9XSEtn8yyN94e5VAmt5lVb9zj7fPH0IF9jXJTbc5K9zfiuFT3nAfU5K1
	 YB3TcoHvPRKc34yD5zO/HXkl+8k8GRDEzVEBZTSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 046/132] media: imx-jpeg: Cleanup after an allocation error
Date: Thu,  3 Jul 2025 16:42:15 +0200
Message-ID: <20250703143941.231824744@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Qian <ming.qian@oss.nxp.com>

[ Upstream commit 7500bb9cf164edbb2c8117d57620227b1a4a8369 ]

When allocation failures are not cleaned up by the driver, further
allocation errors will be false-positives, which will cause buffers to
remain uninitialized and cause NULL pointer dereferences.
Ensure proper cleanup of failed allocations to prevent these issues.

Fixes: 2db16c6ed72c ("media: imx-jpeg: Add V4L2 driver for i.MX8 JPEG Encoder/Decoder")
Cc: stable@vger.kernel.org
Signed-off-by: Ming Qian <ming.qian@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
index 3602324b254a6..6e8d95a2406fd 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -553,6 +553,7 @@ static bool mxc_jpeg_alloc_slot_data(struct mxc_jpeg_dev *jpeg)
 	return true;
 err:
 	dev_err(jpeg->dev, "Could not allocate descriptors for slot %d", jpeg->slot_data.slot);
+	mxc_jpeg_free_slot_data(jpeg);
 
 	return false;
 }
-- 
2.39.5



