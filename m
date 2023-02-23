Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E2C257C
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:07:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898A2C4339C;
	Thu, 23 Feb 2023 13:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677157667;
	bh=+vzHs0CQPVIfw082TyBxGEZC1LLGnSLAg759kIH/oAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2YHnuoOuRQgLPoCqVmY2eMsurSU/QAxcK6ObU33MDeuPAoM67D5f//OwKEwDWfOGh
	 RpYkTh24ySUYl0lf7JTCdc0u5uytj1665w24QeBZbMCX+rkp5cCdI2FRen7Z6QsBjO
	 BIsPY+DZ50vN7DazCVkR2HQ573epV5I3JzI/O92g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Wen Yang <wenyang.linux@foxmail.com>
Subject: [PATCH 5.10 19/25] nbd: fix max value for first_minor
Date: Thu, 23 Feb 2023 14:06:36 +0100
Message-Id: <20230223130427.650259573@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130426.817998725@linuxfoundation.org>
References: <20230223130426.817998725@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

commit e4c4871a73944353ea23e319de27ef73ce546623 upstream.

commit b1a811633f73 ("block: nbd: add sanity check for first_minor")
checks that 'first_minor' should not be greater than 0xff, which is
wrong. Whitout the commit, the details that when user pass 0x100000,
it ends up create sysfs dir "/sys/block/43:0" are as follows:

nbd_dev_add
 disk->first_minor = index << part_shift
  -> default part_shift is 5, first_minor is 0x2000000
  device_add_disk
   ddev->devt = MKDEV(disk->major, disk->first_minor)
    -> (0x2b << 20) | (0x2000000) = 0x2b00000
   device_add
    device_create_sys_dev_entry
	 format_dev_t
	  sprintf(buffer, "%u:%u", MAJOR(dev), MINOR(dev));
	   -> got 43:0
	  sysfs_create_link -> /sys/block/43:0

By the way, with the wrong fix, when part_shift is the default value,
only 8 ndb devices can be created since 8 << 5 is greater than 0xff.

Since the max bits for 'first_minor' should be the same as what
MKDEV() does, which is 20. Change the upper bound of 'first_minor'
from 0xff to 0xfffff.

Fixes: b1a811633f73 ("block: nbd: add sanity check for first_minor")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Link: https://lore.kernel.org/r/20211102015237.2309763-2-yebin10@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Wen Yang <wenyang.linux@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/nbd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1773,11 +1773,11 @@ static int nbd_dev_add(int index)
 	disk->major = NBD_MAJOR;
 
 	/* Too big first_minor can cause duplicate creation of
-	 * sysfs files/links, since first_minor will be truncated to
-	 * byte in __device_add_disk().
+	 * sysfs files/links, since MKDEV() expect that the max bits of
+	 * first_minor is 20.
 	 */
 	disk->first_minor = index << part_shift;
-	if (disk->first_minor > 0xff) {
+	if (disk->first_minor > MINORMASK) {
 		err = -EINVAL;
 		goto out_free_idr;
 	}


