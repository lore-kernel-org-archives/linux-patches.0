Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA14148FE8;
	Tue, 23 Jan 2024 01:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972084; cv=none; b=tlPQKN9vbPrfw8EyK+bO5pNb/pwchwYFuWhDvtBZ/Ttw+/JH7QsT/YcunQ0TznatnX7hPTk4Sg+/jx/fTU/u/TxqeLH3uMznzHcdlFUFAOCJ48fHQOIBkcyOqL6O1E1ogl2wgGTnGrbaIv9dmXbf0gs8gDrt3ZeL5sQNAY1jO6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972084; c=relaxed/simple;
	bh=1aecxd9/pDUq6lX6EUeJV5PCf5lfn3jlxu/s9Va2Gec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EABclmU5DaS6p9eyMkaVFUON+Oh6fudWt0weID6MuDCOUOSIm1Kxqf4NVpMUDg/MdNr82Yvr9wCHnVG58whnMSFbGtbvuuapgqvznpLLqGLLYDrU8NSnpvHNrXtAyw8ARU4tGmBrHgfIxvYLrgFTSmk4U5HKumq3WJ4lAkC/5mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l28ziOwA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l28ziOwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B081DC43390;
	Tue, 23 Jan 2024 01:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972083;
	bh=1aecxd9/pDUq6lX6EUeJV5PCf5lfn3jlxu/s9Va2Gec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l28ziOwAIM0hdgPU1Xm6Q/WlNEkwLQ2xdpDHlmhKz8VsOkrmh6uDvkIgjQGvJZu4M
	 P+piWoyyPgAi3CjN5+UgeEDykdlrv1BJlxhOuNOWF/od0oobNeRM9zBWKoqmF8u4U2
	 fEqu9Sst9tJgJFzYU+Mz+I6i7SBFQPnO6cWMONk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 008/374] nvme-core: check for too small lba shift
Date: Mon, 22 Jan 2024 15:54:24 -0800
Message-ID: <20240122235744.917018880@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 74fbc88e161424b3b96a22b23a8e3e1edab9d05c ]

The block layer doesn't support logical block sizes smaller than 512
bytes. The nvme spec doesn't support that small either, but the driver
isn't checking to make sure the device responded with usable data.
Failing to catch this will result in a kernel bug, either from a
division by zero when stacking, or a zero length bio.

Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 98a7649a0f06..8f06e5c1706b 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1846,9 +1846,10 @@ static void nvme_update_disk_info(struct gendisk *disk,
 
 	/*
 	 * The block layer can't support LBA sizes larger than the page size
-	 * yet, so catch this early and don't allow block I/O.
+	 * or smaller than a sector size yet, so catch this early and don't
+	 * allow block I/O.
 	 */
-	if (ns->lba_shift > PAGE_SHIFT) {
+	if (ns->lba_shift > PAGE_SHIFT || ns->lba_shift < SECTOR_SHIFT) {
 		capacity = 0;
 		bs = (1 << 9);
 	}
-- 
2.43.0



