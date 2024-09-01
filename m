Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF19017C;
	Sun,  1 Sep 2024 17:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210074; cv=none; b=aFauhNk6CsW+XCA6T3mJrLvnbIl1E47vDCDZIPni+uhIwzAx3oc2ycbx0dXXcmV/FZd9RGQw04jjfS5otiwW/tF4THUzMJiJdOiTbBY0PVFp3IKsC3qXy/XzOSOUkB12SwYpJdtQfNtWs6Gcy0E3D9kRcAtBufXCL/nFffzD1Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210074; c=relaxed/simple;
	bh=CUZgZKfTOxGmvO6bQdRij6s1Xv6KK3Wp+ib9vlxbhL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5HCSd93a/FfHxeOX+cUonw1OkQyCnIS23YM1RpYCHjTP3duhVLvRqXx5ZRDE1Noc2+687mQz5UXl08ihMiOZ/DNERqKFbncXHUCf+YTp3nYKzHii4ndwlH9vrUV2CNsTBAHpesJKO5FF08ywxF6Aor5bvepjaQVSsTzZgLi6vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E3kqm0e1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E3kqm0e1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C513C4CEC3;
	Sun,  1 Sep 2024 17:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210074;
	bh=CUZgZKfTOxGmvO6bQdRij6s1Xv6KK3Wp+ib9vlxbhL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E3kqm0e1d0chXb9qy2GjwBAFfQ6eFNG9Bjkk42+nGwvK8nviaJUygwWe2BoESifxa
	 iDQQD6vvQW/6lmQK/om8Mz6XQ8qP0WLkg069/9KBJlh96b7VIOIkSCZs6qi+C0t6AA
	 kO2KIfMOxuBvZnV4Iu+9w2mbQzMNfzQjA3V357Ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 081/215] md: clean up invalid BUG_ON in md_ioctl
Date: Sun,  1 Sep 2024 18:16:33 +0200
Message-ID: <20240901160826.418153885@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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
index 5b6c366587d54..332458ad96637 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7589,11 +7589,6 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 
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



