Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDDC2C1B4;
	Sun,  1 Sep 2024 16:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207636; cv=none; b=QgDWuap6cQeH0Vs5G6SRnAFitfRAF3ouAYx6fJ8P8vVk2iIUfo6KFVKd1U4Keq2MIedFxTtn3aj01hJgvq4TdNARf9pIe221GwsTMAJvm1aG9CFCc4FM33z+syQB0aUXFUp5fL3wxaxxFea0rE+ZjbQ1G1J0v/VbbcViF71HIa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207636; c=relaxed/simple;
	bh=37jUno90uhltMdwfJXE65JQ/4aLRpX2ig3oX9TBH5f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bw1iy1+cm3THpG7Vja3xHaV2pcbkOwLSQD5A82rZ5rjZuuPsm8FO5y4MQCNyR41k39tavVnHKOtT/dEkyjVuIjIOVYnWudpwMgfAtKa7ZVOs/7JQXwVa93fQsJVM9FLuzR2DeTKnKSg+s/pXLKk89UmcH86VDdzrsUlcq1VLR2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SzKA56Nm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SzKA56Nm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4C9C4CEC3;
	Sun,  1 Sep 2024 16:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207635;
	bh=37jUno90uhltMdwfJXE65JQ/4aLRpX2ig3oX9TBH5f8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SzKA56NmKsT7hWHIR/haDxeAB4IxGMk2W9+DabmlH+/Wm9HeiENlNPvKV9U48gTmq
	 2rdAeBDILjgiAq8/ai7w0yr2PUYN1cIIGFBwFjQEJqzTA7Fz/nGUbFSY1XiVaLzPKI
	 V6P6n3wBsGdkzyBdgVHZuGgYX6JBftKRhLblxER4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 32/98] md: clean up invalid BUG_ON in md_ioctl
Date: Sun,  1 Sep 2024 18:16:02 +0200
Message-ID: <20240901160804.909907771@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 68eb3220be1c9..6f463eec60b48 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7245,11 +7245,6 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 
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



