Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E10A13AA43;
	Tue, 27 Feb 2024 14:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042912; cv=none; b=AhI9zHapv4geHx5wyrSE2iGNK2Yq8Le7zAw+6EKs0aiL3pptELCK/xqlmAKUMtcDSaK2qt92s1rwFBTgPlpLvxNZu0QwpYXkOOjGFHZuIfBttvs2MnRnPZbHlpUe7RwPL3ispUlvaIox/d5aFIbq0ORLelYciIQQG2cFJtvYja4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042912; c=relaxed/simple;
	bh=IgKGvP6sEwsFraTkiUTVLM0B4muXHshIprtDsD8+vfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dKGjWSUeEiEcu4BKrzBLed7x7Gfa+MlrF2Fg/I8LwW+YwTyr6uQZ6jfzdjj3WKRH78bAkNASYXKfnlPWIXR+yF2hg2JHGT95W6rhzBcr7YGM5LfeAyT5ptDLETYMeGN3tOBa4kOFUI5/4B1DIy6aEJpkK7Nr6B3FMOG1TcWC1BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xg1gBqnX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xg1gBqnX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4557C433F1;
	Tue, 27 Feb 2024 14:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042912;
	bh=IgKGvP6sEwsFraTkiUTVLM0B4muXHshIprtDsD8+vfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xg1gBqnXqH55DG09Ah7pNbiUVKOw0sCtjB/sTfHmEgMAScGx8K0tIYqUruqI5y4Pb
	 psSSZLWc+CnT66AqfTvOFKmLFvwY8pLmSlvfqMJemMfzgzSYkQb5dqIzaAQfgKAeVC
	 4U0TiCOdmABsFEfn7OKqbDvc6Hqyb6IRmfLyRDZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhong Jinghua <zhongjinghua@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 166/245] nbd: Add the maximum limit of allocated index in nbd_dev_add
Date: Tue, 27 Feb 2024 14:25:54 +0100
Message-ID: <20240227131620.603340303@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

From: Zhong Jinghua <zhongjinghua@huawei.com>

[ Upstream commit f12bc113ce904777fd6ca003b473b427782b3dde ]

If the index allocated by idr_alloc greater than MINORMASK >> part_shift,
the device number will overflow, resulting in failure to create a block
device.

Fix it by imiting the size of the max allocation.

Signed-off-by: Zhong Jinghua <zhongjinghua@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20230605122159.2134384-1-zhongjinghua@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index e563aa407e888..d379a047d4273 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1715,7 +1715,8 @@ static struct nbd_device *nbd_dev_add(int index, unsigned int refs)
 		if (err == -ENOSPC)
 			err = -EEXIST;
 	} else {
-		err = idr_alloc(&nbd_index_idr, nbd, 0, 0, GFP_KERNEL);
+		err = idr_alloc(&nbd_index_idr, nbd, 0,
+				(MINORMASK >> part_shift) + 1, GFP_KERNEL);
 		if (err >= 0)
 			index = err;
 	}
-- 
2.43.0



