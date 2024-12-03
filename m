Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDD91F473A;
	Tue,  3 Dec 2024 15:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239672; cv=none; b=hWeEY2B21F6kHJcqgi54w1VzsCORPRPsMuLKl3wofrsL+W1I4YJJeC1R1le+OXG4BGHH2bPfpYm2gIwpGmU26Qma43TgHPsGtuqLhrQHV13aeNNqnbXpcVg2O9HmvFOhSjv6nEPDB1qN7sZzhJuAopaDnoZUroa1+3lL/EDmgkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239672; c=relaxed/simple;
	bh=I6Lkp9TdwxBdByviiV+HT4f04mJpkbp9yG/Jt4oqgL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YEHwBnCCqoFOoerhaBlWdwk0H2zAlpeFWGGvzOuHAy08fkmGpFVBt0GO0cbW4ZD0NKK6LTJ3v3q6+U7IlS+p8F8+M4LVcXPmOx+cf5fFpAXTXCgtLZqVVQ9kGic+lHOJPQfxiDbKSBcY1KudyAALhxxAObtCquvJjXwLVOHa5ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Td3ZBHkr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Td3ZBHkr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19769C4CECF;
	Tue,  3 Dec 2024 15:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239672;
	bh=I6Lkp9TdwxBdByviiV+HT4f04mJpkbp9yG/Jt4oqgL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Td3ZBHkrXQTq8if4idtrDriMHTHUv0eB8kCpYtr83koVD7twdIOv/PWklSGHXq6Uk
	 tUXCGhZfTmmvxDj5FCjVgA9y76XqJXPGjjPX35av/wJSEszXahnWRQMz6QbkxktWB1
	 pHsy1yQUXBG+VFrj5wj0DbpJDAV3SG71Q9oEd2kI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.11 695/817] blk-settings: round down io_opt to physical_block_size
Date: Tue,  3 Dec 2024 15:44:27 +0100
Message-ID: <20241203144023.104081930@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


