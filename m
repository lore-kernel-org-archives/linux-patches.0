Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EA96FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468F8C433D2;
	Tue, 10 Jan 2023 18:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375119;
	bh=cJOTbZrZvuG4JkBxT+Pqu2oTtiZKpW0DW80RISTmDYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jBx9B/mRf85eygh94jYlMxzUlwWqulsrpp/p8/uCB5dX/vwUhuRo37wWDKq5KSD7M
	 n5ALsXlc78WWS/rYn5t4mbgaLS6YWyfQQHO9VxJootdVdJfAppicRYhBnKUqXj76hZ
	 KThFB7Qtb/YmJ+kRvxIL4girZUHtsaxZPcw+YHg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Meng <luomeng12@huawei.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.15 084/290] dm thin: resume even if in FAIL mode
Date: Tue, 10 Jan 2023 19:02:56 +0100
Message-Id: <20230110180034.508278030@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luo Meng <luomeng12@huawei.com>

commit 19eb1650afeb1aa86151f61900e9e5f1de5d8d02 upstream.

If a thinpool set fail_io while suspending, resume will fail with:
 device-mapper: resume ioctl on vg-thinpool  failed: Invalid argument

The thin-pool also can't be removed if an in-flight bio is in the
deferred list.

This can be easily reproduced using:

  echo "offline" > /sys/block/sda/device/state
  dd if=/dev/zero of=/dev/mapper/thin bs=4K count=1
  dmsetup suspend /dev/mapper/pool
  mkfs.ext4 /dev/mapper/thin
  dmsetup resume /dev/mapper/pool

The root cause is maybe_resize_data_dev() will check fail_io and return
error before called dm_resume.

Fix this by adding FAIL mode check at the end of pool_preresume().

Cc: stable@vger.kernel.org
Fixes: da105ed5fd7e ("dm thin metadata: introduce dm_pool_abort_metadata")
Signed-off-by: Luo Meng <luomeng12@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3566,20 +3566,28 @@ static int pool_preresume(struct dm_targ
 	 */
 	r = bind_control_target(pool, ti);
 	if (r)
-		return r;
+		goto out;
 
 	r = maybe_resize_data_dev(ti, &need_commit1);
 	if (r)
-		return r;
+		goto out;
 
 	r = maybe_resize_metadata_dev(ti, &need_commit2);
 	if (r)
-		return r;
+		goto out;
 
 	if (need_commit1 || need_commit2)
 		(void) commit(pool);
+out:
+	/*
+	 * When a thin-pool is PM_FAIL, it cannot be rebuilt if
+	 * bio is in deferred list. Therefore need to return 0
+	 * to allow pool_resume() to flush IO.
+	 */
+	if (r && get_pool_mode(pool) == PM_FAIL)
+		r = 0;
 
-	return 0;
+	return r;
 }
 
 static void pool_suspend_active_thins(struct pool *pool)


