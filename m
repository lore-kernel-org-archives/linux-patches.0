Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0108C22F0F;
	Thu, 18 Jan 2024 10:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575530; cv=none; b=YUZWvMCC+/I1DC8JNLfQPHWtWjKpFHkhCdut3szwWkNMaJ0bgNOcMRM0iXUQTWDXuNpajxWHWVVrt3BIMUlR1E9Om4JO0XwHjbU52COE/qHwVtjTHfkhpLVCh8JjmYZTZrtlaWmQz8DtrU4MgCNKAz2/lfa/cxLoqA1ukiF1mE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575530; c=relaxed/simple;
	bh=P1yAgonovg0DCJhdfUTlNpH33x9qz+nY2+FCDHHsMck=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=dVenEl0GHYFQx8Z69bgxZ/i0C+Gs8N+FZ28/10H9kR93YidKAXgxxZNJ/j5QjOHJlQN0bpLQetQZSC3YmsfvUZxhLUFAqQfuAmG1m+LynBjZV39HwS4+P7Zuf0D0ucdgU1icSecy4Z5B4/7by4s+WIpYihLqATSp5E3hSvZZQtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+3VACd1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+3VACd1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C27C433F1;
	Thu, 18 Jan 2024 10:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575529;
	bh=P1yAgonovg0DCJhdfUTlNpH33x9qz+nY2+FCDHHsMck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t+3VACd1MLSqxYiKgS+jQdauv1ue5n5NuCjv5ifKZPZJNbspnOGAo7ZulhiYWZODA
	 ge5NkNAQgaLAwM/VNl8qkMYiSRtf4q4oM+E1BSdy64x4sPIAkuY+H7j6XutBUM9gBz
	 ccfEsUxPI/zqdxPNbZuHgX4DDfbLHY3noK3nvnCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 015/100] nvme-core: check for too small lba shift
Date: Thu, 18 Jan 2024 11:48:23 +0100
Message-ID: <20240118104311.560509254@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 67c893934c80..0c088db94470 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1925,9 +1925,10 @@ static void nvme_update_disk_info(struct gendisk *disk,
 
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



