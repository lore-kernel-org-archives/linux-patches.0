Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BC6257C
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C428C433D2;
	Thu, 23 Feb 2023 13:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677157670;
	bh=o/MvSD7XTSLEAyXjpthVv1oakAMjdRqXebAZP8Tyla4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aP6noMneSofe1MU0q+f4FM1DrQmX7gLu76dGbJh6WwYaxshKrSz5dseKTBekSKP9j
	 lD0/zbL71LYYxFZvK8EH2CKzc7tWDNO19Ed2wpJy0Iw+/6UqXDxm3Hm5qYhTx3OPau
	 Au+eOb7X8bHwD5yZd0UiVLb+mX2cVQr1hRqrAofk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Wen Yang <wenyang.linux@foxmail.com>
Subject: [PATCH 5.10 20/25] nbd: fix possible overflow for first_minor in nbd_dev_add()
Date: Thu, 23 Feb 2023 14:06:37 +0100
Message-Id: <20230223130427.691761800@linuxfoundation.org>
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

commit 940c264984fd1457918393c49674f6b39ee16506 upstream.

If 'part_shift' is not zero, then 'index << part_shift' might
overflow to a value that is not greater than '0xfffff', then sysfs
might complains about duplicate creation.

Fixes: b0d9111a2d53 ("nbd: use an idr to keep track of nbd devices")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Link: https://lore.kernel.org/r/20211102015237.2309763-3-yebin10@huawei.com
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
-	 * sysfs files/links, since MKDEV() expect that the max bits of
-	 * first_minor is 20.
+	 * sysfs files/links, since index << part_shift might overflow, or
+	 * MKDEV() expect that the max bits of first_minor is 20.
 	 */
 	disk->first_minor = index << part_shift;
-	if (disk->first_minor > MINORMASK) {
+	if (disk->first_minor < index || disk->first_minor > MINORMASK) {
 		err = -EINVAL;
 		goto out_free_idr;
 	}


