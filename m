Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6F31B96D;
	Thu, 18 Jan 2024 10:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575140; cv=none; b=JIaSedpnKHFhOpTgygSMvdYmT7ur0REidgp6uot5mVHCRaqmLG4KoXwIDimGyVOJRLcTFE0Tnzt4YIl2vyR0TIzuLrLhj7z+GMxmenztXa5l7uKxfA8NBQPwJDzGFkyiz2bVlL78NpyUqz+zbVQBoPu2wFjjrLucBwnv1uhONN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575140; c=relaxed/simple;
	bh=RX60X6kng1L60qLjMXkby0VXvBVH2GJgJJNubvMKAvg=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=ak7R5gF0NWglFTUPz3G07+zpyokm+ygKBQ6EqVB2ARVO7v/nnF3S6VDbFJ2+cvrrwBUY0qzvxXqjNGKDy8LgFI6duCmZyzM1qvljgytsP6Jnr9eAleX8A4fUmTMJW2aOyEzYbf2NxB+vktAO6tNNfuxih4+y4lcT/NPyjPIwlQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Br2smidq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Br2smidq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFD9C433C7;
	Thu, 18 Jan 2024 10:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575140;
	bh=RX60X6kng1L60qLjMXkby0VXvBVH2GJgJJNubvMKAvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Br2smidqmFzCUYsxoVdP3AVwnlHQz3kuzn//eES2z8xDRj73zFGdvEiLtsr/rz8Vt
	 wxBCRzkBOYNkK3w3YXdW7+cRu13zV5od9UtAdLXqxyStyWitRu0D7kVEA+kvnb1P5r
	 A2hPY3096f3vmFJiYbDPlE2LpK43pCwQ3q5RMCWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/150] nvme-core: check for too small lba shift
Date: Thu, 18 Jan 2024 11:47:27 +0100
Message-ID: <20240118104321.234870494@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 212991308bbe..ae234f34ac9b 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1893,9 +1893,10 @@ static void nvme_update_disk_info(struct gendisk *disk,
 
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



