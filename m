Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113AD1D9A42;
	Tue, 15 Oct 2024 11:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992516; cv=none; b=R/xSrhfyCDLBqKX7grpgwOk7VdbxEKX+yfz6o6H9p/ADC6SsnLOAdTaJ7pQQh3roXY7M9v6Jj5yEuek98rjE6WRc9x4EGKiOCa4tgZ3m6V70uOAnVrxRGH8Bn3LLaz1QFzwhGk5VppiIEzUHjiH3jLuQj2aBgsXf7yjQ/7VDVJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992516; c=relaxed/simple;
	bh=0wS8uI0YNYvsLDJBUeBb2Tb7hvbWZjLhZDxnLHT/T+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p0Vqz71n4j/RPcTO4csrO6b0BCXIpznOT0NaMMy2M1pjOJa3N86QAQXkm4Bnuv06TgCzT/AuzPfUQ7XHYBFpsCf8mAiT68bAIh6X9aVPzE8VqWjCtr38pX5gxCJdaGZcCeyawoZ70NcDHd/aApdFYukUKPVwIfV0uVFM2umHJA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zAIsX5Gt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zAIsX5Gt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F67C4CEC6;
	Tue, 15 Oct 2024 11:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992515;
	bh=0wS8uI0YNYvsLDJBUeBb2Tb7hvbWZjLhZDxnLHT/T+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zAIsX5Gtqgk8rPEGpxLYkB+mFrKwxQSs50SYJu/6wPDeI7Me8mxl0ESBppDIJjdWw
	 uJuHcaJMTqgJMQACitTk6VNZ0uIOYhrkit5mronS2pmod5Ef32Yg4Hkc9Svy7eLaUZ
	 UEx1TuBM0HmPZFX+qdsZYiDlDhUxuuX59KGDebj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Riyan Dhiman <riyandhiman14@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 138/691] block: fix potential invalid pointer dereference in blk_add_partition
Date: Tue, 15 Oct 2024 13:21:26 +0200
Message-ID: <20241015112445.832347289@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Riyan Dhiman <riyandhiman14@gmail.com>

[ Upstream commit 26e197b7f9240a4ac301dd0ad520c0c697c2ea7d ]

The blk_add_partition() function initially used a single if-condition
(IS_ERR(part)) to check for errors when adding a partition. This was
modified to handle the specific case of -ENXIO separately, allowing the
function to proceed without logging the error in this case. However,
this change unintentionally left a path where md_autodetect_dev()
could be called without confirming that part is a valid pointer.

This commit separates the error handling logic by splitting the
initial if-condition, improving code readability and handling specific
error scenarios explicitly. The function now distinguishes the general
error case from -ENXIO without altering the existing behavior of
md_autodetect_dev() calls.

Fixes: b72053072c0b (block: allow partitions on host aware zone devices)
Signed-off-by: Riyan Dhiman <riyandhiman14@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20240911132954.5874-1-riyandhiman14@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/partitions/core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/block/partitions/core.c b/block/partitions/core.c
index 00fb271a60510..0d1fe2b42b855 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -590,9 +590,11 @@ static bool blk_add_partition(struct gendisk *disk,
 
 	part = add_partition(disk, p, from, size, state->parts[p].flags,
 			     &state->parts[p].info);
-	if (IS_ERR(part) && PTR_ERR(part) != -ENXIO) {
-		printk(KERN_ERR " %s: p%d could not be added: %pe\n",
-		       disk->disk_name, p, part);
+	if (IS_ERR(part)) {
+		if (PTR_ERR(part) != -ENXIO) {
+			printk(KERN_ERR " %s: p%d could not be added: %pe\n",
+			       disk->disk_name, p, part);
+		}
 		return true;
 	}
 
-- 
2.43.0



