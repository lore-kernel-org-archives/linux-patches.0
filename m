Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADB11C688E;
	Tue, 27 Aug 2024 14:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770264; cv=none; b=bq+jzWCVe0OVFWeImkbEboheQpmI2gv5IE+PTz6Eox8vR5Y+xZ/bk5d7IwDa4SaXgZHDgYaZAvIJlevBSFovxT/WjbsT8wQ3XVhjSdJbJTsjrUy/+cAV9/i2CEdJfxWEH8wHW56ppU4fjy1hZs1CGzzWr1O0feZmC2tih4+bkQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770264; c=relaxed/simple;
	bh=Yjjqw6/8ps5SGMhQmeHj5MqEb2BvIyCANE+1HWRG/1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bz/k7tMoqRG5s+RClMN00phvhxaAkMnVsrqj97S8l8LCvuJUQIM44L8CvyjtVyG6/ZP4hSojzorEJzvw8L6bC4vvrIEYMiIZC8GItyKszhGrzUI3fy0I3G24tQnPIwUs+5mHHj8224VOtODkwnm2R6RVtku8o7cQ8uMYGT+BoAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YiGtOdc1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YiGtOdc1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5ACCC4DDFF;
	Tue, 27 Aug 2024 14:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770264;
	bh=Yjjqw6/8ps5SGMhQmeHj5MqEb2BvIyCANE+1HWRG/1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YiGtOdc1Whc72T3s+HBrvFKYjzPvChu7zMaPQiyNM9Ooz/j0NNZNIp8iVzgs66hll
	 JyRs16l9q+d+AikFUQX2wpDUhkunxVgGzqVMGP47rwwa9RKW60bkT2V/M0I575R+s3
	 G8F7kedRHTNITrkDjEbD0XOKKc1kIxDNI2KuljKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 176/341] md: clean up invalid BUG_ON in md_ioctl
Date: Tue, 27 Aug 2024 16:36:47 +0200
Message-ID: <20240827143850.112057994@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Li Nan <linan122@huawei.com>

[ Upstream commit 9dd8702e7cd28ebf076ff838933f29cf671165ec ]

'disk->private_data' is set to mddev in md_alloc() and never set to NULL,
and users need to open mddev before submitting ioctl. So mddev must not
have been freed during ioctl, and there is no need to check mddev here.
Clean up it.

Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240226031444.3606764-4-linan666@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 35b003b83ef1b..d1f6770c5cc09 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7652,11 +7652,6 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 
 	mddev = bdev->bd_disk->private_data;
 
-	if (!mddev) {
-		BUG();
-		goto out;
-	}
-
 	/* Some actions do not requires the mutex */
 	switch (cmd) {
 	case GET_ARRAY_INFO:
-- 
2.43.0



