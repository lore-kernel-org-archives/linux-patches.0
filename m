Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF52B1EBA1E;
	Tue, 15 Oct 2024 11:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992513; cv=none; b=mRVIoMy6RViW6Hv/fdrXV0++NHEn3ht6Tjl4Tr70VDdEQGS38gE53Hd72ZxPg8r/kNYnSZoIki7rJRo5Z1GhL/dcnuowbMY58JVVR1IYBQxQhEI3Izkm6q9BEN4wB9bzYL70XTsGNQZkI4UzrZJp5TSF5Ga+aj3uZSZ1hp8BUVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992513; c=relaxed/simple;
	bh=16e+Q3yYJeJ+T/G+8z0kLY2C4DX8XucRasmQbNA341Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLhZHm1bH8yOMM0BExppxfg/qhkEQfnRq41z0SdkT/1JbfDqE+CArKpA/IJgagrbzTzgw7dqae/u6fpb3+swdNKANkCUDCPosiJVK06gF77EY7VcMALeIhq9eX1QIHKBz2jqG7MbDDK6cEkPXwTYO5hX4LkmyIdah2rO7zTOle8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ap2HQUx8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ap2HQUx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C27C4CEC6;
	Tue, 15 Oct 2024 11:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992512;
	bh=16e+Q3yYJeJ+T/G+8z0kLY2C4DX8XucRasmQbNA341Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ap2HQUx8APoc+FICwMhc9BxvzIsQlR82k1zjgjhyee59DYV7B19+8uTxWJRyQUP7z
	 uAlXmg5vPXJ4l7+0+WM+QiLVXuzLL/N2/Ceg3qRPfk3ufYZJcnx6Er6s2xJSSX0ElG
	 XQ1ILeerrBgyVnDStxvU13BjsNkExK1r/233v/uQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Heusel <christian@heusel.eu>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 137/691] block: print symbolic error name instead of error code
Date: Tue, 15 Oct 2024 13:21:25 +0200
Message-ID: <20241015112445.793138154@linuxfoundation.org>
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

From: Christian Heusel <christian@heusel.eu>

[ Upstream commit 25c1772a0493463408489b1fae65cf77fe46cac1 ]

Utilize the %pe print specifier to get the symbolic error name as a
string (i.e "-ENOMEM") in the log message instead of the error code to
increase its readablility.

This change was suggested in
https://lore.kernel.org/all/92972476-0b1f-4d0a-9951-af3fc8bc6e65@suswa.mountain/

Signed-off-by: Christian Heusel <christian@heusel.eu>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20240111231521.1596838-1-christian@heusel.eu
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 26e197b7f924 ("block: fix potential invalid pointer dereference in blk_add_partition")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/partitions/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/partitions/core.c b/block/partitions/core.c
index b6a941889bb48..00fb271a60510 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -591,8 +591,8 @@ static bool blk_add_partition(struct gendisk *disk,
 	part = add_partition(disk, p, from, size, state->parts[p].flags,
 			     &state->parts[p].info);
 	if (IS_ERR(part) && PTR_ERR(part) != -ENXIO) {
-		printk(KERN_ERR " %s: p%d could not be added: %ld\n",
-		       disk->disk_name, p, -PTR_ERR(part));
+		printk(KERN_ERR " %s: p%d could not be added: %pe\n",
+		       disk->disk_name, p, part);
 		return true;
 	}
 
-- 
2.43.0



