Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EA03AFCF0;
	Sat, 17 Oct 2026 17:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256977; cv=none; b=KJmypRf77GFhlfZ699YCcjvEZblisVghwMlXJsHvefygfdtYaeInAa/KTSp0ri8ILzpjhZg4oP6UX0Pp3bwEQxpZs94Hr2e6oHk9YiHaHIpOi6JhyG/SQfNnsRUqtoUn+nF4IXUpIsOOIiEF9oWW0iqVf7u6OjJCXsgzPyI4ECU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256977; c=relaxed/simple;
	bh=LyiloZSAp1gtkmV9Nt8oHDVJrf9OcKx7fFlycBfLwzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bp0HmhzvYDQ4+INs33p/zQXp6odfcXVRmkHXh8QPjtZtoVMNqPe/YrWjNVtP/MLjmTz7pv+JubFFNp0LKzkuunQbdngKGmG+9zl1dJeR4ytlfveA5K1i3ZS8nyexfJAlqRYeQkqmh6mBWktqC37HwZezM5aNvRna8DwYJUdHKus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mQyUwj66; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mQyUwj66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6721D1F000C4;
	Sat, 17 Oct 2026 17:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256976;
	bh=SpbCqgQdgonzNFz/ZHcz2OGLpLtaAUutTUYZizW5AL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mQyUwj66pYjStSl6Cz1NZ629E84J8BFho8u4AeIqZ7HfJRVxMnVxfXA0nh4FrtVYr
	 lUc1cGtw9v1CF2tcVbYcasYjC+krSUANYhTkgHhKy/JyF5Ls0y4bC3s0mm4VXxRbxK
	 JE1kdf7DbPOYhzMI+Qju6xq881IYYYZ7zjET8DSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jan Kara <jack@suse.cz>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0412/1674] block2mtd: prevent direct access of bd_inode
Date: Sat, 17 Oct 2026 17:44:44 +0200
Message-ID: <20261017160441.701208279@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit c9600c63a694249100e2bdcbb604c30d8fee2dc7 ]

All we need is size, and that can be obtained via bdev_nr_bytes()

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Link: https://lore.kernel.org/r/20240411145346.2516848-11-viro@zeniv.linux.org.uk
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: b5965c422116 ("mtd: block2mtd: Fix divide error when erase_size is zero")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/devices/block2mtd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
index aa44a23ec0451..502c30124aa61 100644
--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -269,6 +269,7 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size,
 	struct bdev_handle *bdev_handle;
 	struct block_device *bdev;
 	struct block2mtd_dev *dev;
+	loff_t size;
 	char *name;
 
 	if (!devname)
@@ -295,7 +296,8 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size,
 		goto err_free_block2mtd;
 	}
 
-	if ((long)bdev->bd_inode->i_size % erase_size) {
+	size = bdev_nr_bytes(bdev);
+	if ((long)size % erase_size) {
 		pr_err("erasesize must be a divisor of device size\n");
 		goto err_free_block2mtd;
 	}
@@ -313,7 +315,7 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size,
 
 	dev->mtd.name = name;
 
-	dev->mtd.size = bdev->bd_inode->i_size & PAGE_MASK;
+	dev->mtd.size = size & PAGE_MASK;
 	dev->mtd.erasesize = erase_size;
 	dev->mtd.writesize = 1;
 	dev->mtd.writebufsize = PAGE_SIZE;
-- 
2.53.0



