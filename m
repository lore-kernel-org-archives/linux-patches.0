Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A42644C93;
	Sun,  1 Sep 2024 16:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209512; cv=none; b=jXBirAOKDUre7K3CB4Vjsn5JQ7QiEAa0PXgSH9rSLPtcyLLHUZOY8ohPToUVMGJbIqRmfQA0CBwl9LxzPs+rotPuyOGudnL32LgkEoTfl6EdcSLL2M5WZ0FEQFLimU9+eLpPdUtoL4hZHBfnimjNYrWSGkmu4EdU9njVveUp5XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209512; c=relaxed/simple;
	bh=qlbFpnysDdZou9jnb7N/iXGexbT81UL3Vo76HZOHB0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfUHwrTKFTMFmP17Bjj/KvE7LR34wtPixM/yjTUNMbpDXvZTsMdn3bzuLNl1R8HFg367NmUwcvDh7wdRU3MPTqvcXIuqQTWkjCFxafCZdljE/hd8+kSI04R8nVnmf5dAn9eDVEBzzFvY4sTCq/IjYUa9ZTsTuVHoYzuzGIxrj0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqzPmcXD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqzPmcXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD208C4CEC3;
	Sun,  1 Sep 2024 16:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209512;
	bh=qlbFpnysDdZou9jnb7N/iXGexbT81UL3Vo76HZOHB0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BqzPmcXD4ohOrkf6u2hsPjK3asFfS4rIBbzWLNRi/X+aNzMiQh+5bDRQiZP934j71
	 IXFEaDHuPsqvRqcukObpTPtwbwfj2JyzmWY9hiz8ut3w623mr37bNmCWR95uq1q4qh
	 VWOTekOF/l6h0CRrGI9V5C11MObLbujaCQwCjrwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/151] md: clean up invalid BUG_ON in md_ioctl
Date: Sun,  1 Sep 2024 18:16:58 +0200
Message-ID: <20240901160816.300378818@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f1f029243e0cb..accf9ac9bb8c0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7601,11 +7601,6 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 
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



