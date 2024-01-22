Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559A660DCE;
	Tue, 23 Jan 2024 00:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970727; cv=none; b=SLiUfrwt6oVzJxMmAoz1OA13+GBOrpaezAcboP/IByeV08m5J4fKF18CxaFVRZJYH/Wt/3saELEUyF4L54IYFFQGzFOgsOqlc+sQ8fMg65YbBum0aqUPBCzZhvyi/bFHVySFHZqcZNgKMkkn1cV3w/DJLfknxjVmDd4xcIDFFwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970727; c=relaxed/simple;
	bh=ZvavzwcXjeQCAFgjhcb5kfAtHGOxBTJ1yg1dTcVCs9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfW13Ua4rsVVRHfXrJC3lLFjBhsIF3zyyH2gNlMnoIja/FlnVQ+wLGF4iDywHTrnW16D8TByxMBykxqhVkeH8dm6n6l83sX5MPE/IUBBd45k7myO3iKu/psUYVG2gTiEKLcls9XttoEJWo9OLB0vHfrlb4VgiBdjUuTaXQCoX3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+hsc11C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+hsc11C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18751C433C7;
	Tue, 23 Jan 2024 00:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970727;
	bh=ZvavzwcXjeQCAFgjhcb5kfAtHGOxBTJ1yg1dTcVCs9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+hsc11CcxMV+IYvAGh9xOuWxn45HxtSR88s5C3Ed6ZJNjCACPbO2rpI0hCiQRUhr
	 DDjJSePh2U6MWGdxhyiY2UoQUwqkKA+VGiC9PR1IdEWrjwJTycG45TqZQd4R8oL/z4
	 +pktB7AghsWKDQodaqwX6ORNdInNOFWsx9jqZtgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 007/286] nvme-core: check for too small lba shift
Date: Mon, 22 Jan 2024 15:55:13 -0800
Message-ID: <20240122235732.289351134@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 07c41a149328..30a642c8f537 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2071,9 +2071,10 @@ static void nvme_update_disk_info(struct gendisk *disk,
 
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



