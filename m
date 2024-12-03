Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C3D1E3DF9;
	Tue,  3 Dec 2024 16:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242401; cv=none; b=OVxkWYQQeqAg25MD/zEtuSh4lclCJM3UI+1tFDSWPWHJMzUFKYwI9FKk8AJWT7ARwBQ+tbF15ZMGJJFaTBZWrvwFG1fA5t/fDBFl75QM2hiF+CpRDLZadxkxOp16hTl2sHJS7Md0JnTILP/J0EPrUOEduWaC1LjdxTzgUXqpL24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242401; c=relaxed/simple;
	bh=GfCc/UYTq4h9YYh7tfgMx7Tsd+ylQbw2c/LDSmjPVp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCiid2OHXKFHuZSSJo86vVEb4AzbwhrgvY5QjsCB4I5vyLAH4L3BAIlrLqJ3WmerlZCrkJMDsXHnaMfDmsp7Jl1LYww5HU2pHXxu3eGGSbndIbpP707mpNGpinHhGfEFD/Y8Xfi+4l6KzD2/WW1enNA4E6ndwyIx5Jde1DnVROo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tr9OjZjJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tr9OjZjJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCE1C4CECF;
	Tue,  3 Dec 2024 16:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242400;
	bh=GfCc/UYTq4h9YYh7tfgMx7Tsd+ylQbw2c/LDSmjPVp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tr9OjZjJeEsRrA366Ge/pisLX53CLXlPcq/+pbQ6nLl1icMI7RY4uXRyuGX+A8ae7
	 K4HPE4CSwIHctZkJXF7OJsjNfamKaVFOqX+qakigdYTmO98jXmG3i08gPRwzEzf8wG
	 1KrTmXNC6vlyVFqXRYdFVIAG8NHB+XAJQ9iMxZZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 693/826] blk-settings: round down io_opt to physical_block_size
Date: Tue,  3 Dec 2024 15:47:00 +0100
Message-ID: <20241203144810.789578643@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 9c0ba14828d64744ccd195c610594ba254a1a9ab upstream.

There was a bug report [1] where the user got a warning alignment
inconsistency. The user has optimal I/O 16776704 (0xFFFE00) and physical
block size 4096. Note that the optimal I/O size may be set by the DMA
engines or SCSI controllers and they have no knowledge about the disks
attached to them, so the situation with optimal I/O not aligned to
physical block size may happen.

This commit makes blk_validate_limits round down optimal I/O size to the
physical block size of the block device.

Closes: https://lore.kernel.org/dm-devel/1426ad71-79b4-4062-b2bf-84278be66a5d@redhat.com/T/ [1]
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: a23634644afc ("block: take io_opt and io_min into account for max_sectors")
Cc: stable@vger.kernel.org	# v6.11+
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/3dc0014b-9690-dc38-81c9-4a316a2d4fb2@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-settings.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -250,6 +250,13 @@ static int blk_validate_limits(struct qu
 		lim->io_min = lim->physical_block_size;
 
 	/*
+	 * The optimal I/O size may not be aligned to physical block size
+	 * (because it may be limited by dma engines which have no clue about
+	 * block size of the disks attached to them), so we round it down here.
+	 */
+	lim->io_opt = round_down(lim->io_opt, lim->physical_block_size);
+
+	/*
 	 * max_hw_sectors has a somewhat weird default for historical reason,
 	 * but driver really should set their own instead of relying on this
 	 * value.


