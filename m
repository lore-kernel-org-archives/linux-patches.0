Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B8074BE5;
	Mon,  8 Apr 2024 13:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583192; cv=none; b=bP01DiusdMmTDmePWB9yb1/Oy+MwXM4Xfqhe2WbRpqOkWdINEMAIIA2p/lAV7mfsdyMDegtlJnZMncM4B+XyZTbGtNERqZT3dmYFtd9l7prdXrXb1iVkTiluPNH4yhgqoC+GSLEP3nAGbbKGt6hP3U/3il3O+boIusX5wNuO844=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583192; c=relaxed/simple;
	bh=xZv5gxMhnDdJE8tSoAwkfkTqp8Jti+Lk6ge6InMl0Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRgLFtxiyTrEwFwgURqKLzFHY7/ZKzugx+NxeSeM5tEezvo/ZpC5sAl21ienl/+q1QaiLOV1uM40RQqGWMJ+XF3TK3yVc2mwUk98DNc3a65ptVa6p+KTKZ4/Xv24zSETMp9xJ89LBV2VXh/4yZ9DGu1zkM/6CF4zBqHt8j3gsH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b663T9mL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b663T9mL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F6CC433C7;
	Mon,  8 Apr 2024 13:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583192;
	bh=xZv5gxMhnDdJE8tSoAwkfkTqp8Jti+Lk6ge6InMl0Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b663T9mLatmh2VR2UKD4GJcysdX1ySUpay8s11C9WqsMH/vBuyGFbe0V1Q9iIdHxt
	 nreQo7zS648dD5YKTJYHX+JexlxMpKfNjbuTOLJsKuDKgUKMxYn3dXfd53Cs4P/szX
	 r6gdS/Ry4bf86fRSB16LVXJsoSaML5e7cKtLkEo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 150/273] block: count BLK_OPEN_RESTRICT_WRITES openers
Date: Mon,  8 Apr 2024 14:57:05 +0200
Message-ID: <20240408125313.941904629@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 3ff56e285de5a375fbfab3c3f1af81bbd23db36d ]

The original changes in v6.8 do allow for a block device to be reopened
with BLK_OPEN_RESTRICT_WRITES provided the same holder is used as per
bdev_may_open(). I think this has a bug.

The first opener @f1 of that block device will set bdev->bd_writers to
-1. The second opener @f2 using the same holder will pass the check in
bdev_may_open() that bdev->bd_writers must not be greater than zero.

The first opener @f1 now closes the block device and in bdev_release()
will end up calling bdev_yield_write_access() which calls
bdev_writes_blocked() and sets bdev->bd_writers to 0 again.

Now @f2 holds a file to that block device which was opened with
exclusive write access but bdev->bd_writers has been reset to 0.

So now @f3 comes along and succeeds in opening the block device with
BLK_OPEN_WRITE betraying @f2's request to have exclusive write access.

This isn't a practical issue yet because afaict there's no codepath
inside the kernel that reopenes the same block device with
BLK_OPEN_RESTRICT_WRITES but it will be if there is.

Fix this by counting the number of BLK_OPEN_RESTRICT_WRITES openers. So
we only allow writes again once all BLK_OPEN_RESTRICT_WRITES openers are
done.

Link: https://lore.kernel.org/r/20240323-abtauchen-klauen-c2953810082d@brauner
Fixes: ed5cc702d311 ("block: Add config option to not allow writing to mounted devices")
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bdev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index e9f1b12bd75c7..678807bcd0034 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -738,17 +738,17 @@ void blkdev_put_no_open(struct block_device *bdev)
 
 static bool bdev_writes_blocked(struct block_device *bdev)
 {
-	return bdev->bd_writers == -1;
+	return bdev->bd_writers < 0;
 }
 
 static void bdev_block_writes(struct block_device *bdev)
 {
-	bdev->bd_writers = -1;
+	bdev->bd_writers--;
 }
 
 static void bdev_unblock_writes(struct block_device *bdev)
 {
-	bdev->bd_writers = 0;
+	bdev->bd_writers++;
 }
 
 static bool bdev_may_open(struct block_device *bdev, blk_mode_t mode)
-- 
2.43.0



