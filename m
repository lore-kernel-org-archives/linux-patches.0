Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA3A2B9C7;
	Sun,  1 Sep 2024 16:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208832; cv=none; b=pZHBz+mwqPyWXOD5qdbzN6T47GtmUHBy0YPbPd24Nmo8UGjpNBmDj6F22WA9g+cwwdigVatuLExoueeoF0vzQkDRhGwHS8ImgVg/8y0xDjzOCFqgmqubdGmkZHGjP+ES5aavlUAWa64tlCS1ehzpOpl8t1mETOEJDvhc2wWY7Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208832; c=relaxed/simple;
	bh=Zw1Bu5TGIz++mcb6EaZLeQe14OGaLJSgaMurzBU4lh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOQtwOiX96rl8669ow+VgU0k4GfglLQ6BkCXbq7EGQnndnXdAMmmQZ0M9sqpu8M4lJzhiVDblSKNAPL2S4OGEjaa3ntvJ1L8Jfzz6c5eyiZbOed1Cn3USeOJRH6dbrZgB+EvC7IQb6RGjsnPEUAFJBIZ4ro41huN/BTYVFJ4/EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CUiYHUGV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CUiYHUGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00EEC4CEC3;
	Sun,  1 Sep 2024 16:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208832;
	bh=Zw1Bu5TGIz++mcb6EaZLeQe14OGaLJSgaMurzBU4lh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CUiYHUGVrhXHcO2ZHYTVHIA7hSYT6ItpcFLn8KZovYw3AbjwqyLfwzVM6l2N65tzN
	 UGsq1x75ZdmifpMTzLgmO5R4EaTcnuztVB9UIDGxUR1kmi/nZ0w1gJj3T6uSpAlx0y
	 QMESpu2AhTwVSOmq4qadSPX9zSJxItUsvNwvVH9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 051/134] md: clean up invalid BUG_ON in md_ioctl
Date: Sun,  1 Sep 2024 18:16:37 +0200
Message-ID: <20240901160812.029566090@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 61c3e8df1b55b..e5f3010debb85 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7396,11 +7396,6 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 
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



