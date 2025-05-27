Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A63627E7EA;
	Tue, 27 May 2025 17:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365205; cv=none; b=SyDnzO8sxnYjBlGDfLjMxwPXPX4loiQr+8DCn7M6zbLldIgyhKdpwAsofYyd5KYPeikolX5iTulJ/TXzaUU1X2dIaF3GFYNTFr3GfkaGWjvfbzfb9Ov4u6jPu1ZMk/+PNEZ9piadJ5zMTqmDlCZfJDdgQ4lAIAbjI7LaYWMktUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365205; c=relaxed/simple;
	bh=/kAR8eaAgoG7fcK9IcClDHthiCUrqzv42GlIzQTt0dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGh5e4wG3vdY2bIcV0ceMzD8vn9kJalxXMdNuiokziN021kjY0987G9ugOSeRaIxIox7gGNGJqGitdrIRE6z0rawXXUxT/qs2C3V0piyPiK4yinIEj+s8XA6KvDCdwsTSZrYoRgtmpLxOpP2vrmP5RQM//NLJy+Ovl0YuWOxfXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=te2kLm9L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="te2kLm9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCBEC4CEE9;
	Tue, 27 May 2025 17:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365205;
	bh=/kAR8eaAgoG7fcK9IcClDHthiCUrqzv42GlIzQTt0dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=te2kLm9LMIUBWSHGaFKk1L1oB+7ldMQCJv77L50CMX+iTeSnYgZcaDsFanj7GrRFw
	 KtTJx0MXoLoFCPDSG3Q+PFkrMK+awkTKTFModFHK8RG6ell5jrYEmgy2Ry+FJX+9Ts
	 9CV+pHDD/raBLZFW+/q7vVGD/dw/pC0lGlgjc9vQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 300/626] loop: check in LO_FLAGS_DIRECT_IO in loop_default_blocksize
Date: Tue, 27 May 2025 18:23:13 +0200
Message-ID: <20250527162457.217532747@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit f6f9e32fe1e454ae8ac0190b2c2bd6074914beec ]

We can't go below the minimum direct I/O size no matter if direct I/O is
enabled by passing in an O_DIRECT file descriptor or due to the explicit
flag.  Now that LO_FLAGS_DIRECT_IO is set earlier after assigning a
backing file, loop_default_blocksize can check it instead of the
O_DIRECT flag to handle both conditions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20250131120120.1315125-4-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 6bd44ec2c9b1a..fa9c77b8f4d23 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -916,7 +916,7 @@ static unsigned int loop_default_blocksize(struct loop_device *lo,
 		struct block_device *backing_bdev)
 {
 	/* In case of direct I/O, match underlying block size */
-	if ((lo->lo_backing_file->f_flags & O_DIRECT) && backing_bdev)
+	if ((lo->lo_flags & LO_FLAGS_DIRECT_IO) && backing_bdev)
 		return bdev_logical_block_size(backing_bdev);
 	return SECTOR_SIZE;
 }
-- 
2.39.5



