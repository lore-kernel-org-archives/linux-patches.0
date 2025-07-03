Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9A12EE96D;
	Thu,  3 Jul 2025 14:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554642; cv=none; b=mS1iWMjaGckjajSKxtx5T9dtw8uIfh2N7kkGAohgq8anwwuQbAks+px1QMNSIPtKyffD5tVug18p7w4uiuS1O9lyJoFyOHbKqaA8W8e1OBe8FT7yfU6kIeG4BHbt94uF3iS57jQQl5ONgzrb5nFMbKpfc6OnsIiuTBipOIW4x/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554642; c=relaxed/simple;
	bh=DI4JjvV3nkFi1sAwyQElZBv+GfomhD08oBhOHL0YGuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QzbZoJEB5cGCM0vjGwqb+rcIt+QS96Sa2ZXb8A9ApBTqb2qn1MdnPrE518U7abZT/W2D26Ktrmjd2y7OS34/+5IAzYjOcavPL9udg9DXm9hLHywC2CYGYBRhmSG2r0As69Y5xoqu2tp6Z50A5Zm0sINOtjNprrLhOdr6UP4+RIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=do7lCqJr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="do7lCqJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF233C4CEE3;
	Thu,  3 Jul 2025 14:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554642;
	bh=DI4JjvV3nkFi1sAwyQElZBv+GfomhD08oBhOHL0YGuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=do7lCqJrN0eyHx0gyMo8xZ6QGRxvssML1R6MOOLMm7XQOCkw6dKtDtW1D/l3r3+R0
	 lxi24hd6sVDd+KzYiDGL6KZpM9tW+LIegmym+YsA8hu4uGxZCjuD7jQXx8N+5AE9lT
	 aAf1PN7895l6Wh2x83ZwBby6YigOorUTp8MYkAa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 035/263] md/md-bitmap: fix dm-raid max_write_behind setting
Date: Thu,  3 Jul 2025 16:39:15 +0200
Message-ID: <20250703144005.704353181@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 2afe17794cfed5f80295b1b9facd66e6f65e5002 ]

It's supposed to be COUNTER_MAX / 2, not COUNTER_MAX.

Link: https://lore.kernel.org/linux-raid/20250524061320.370630-14-yukuai1@huaweicloud.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 37b08f26c62f5..45dd3d9f01a8e 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -789,7 +789,7 @@ static int md_bitmap_new_disk_sb(struct bitmap *bitmap)
 	 * is a good choice?  We choose COUNTER_MAX / 2 arbitrarily.
 	 */
 	write_behind = bitmap->mddev->bitmap_info.max_write_behind;
-	if (write_behind > COUNTER_MAX)
+	if (write_behind > COUNTER_MAX / 2)
 		write_behind = COUNTER_MAX / 2;
 	sb->write_behind = cpu_to_le32(write_behind);
 	bitmap->mddev->bitmap_info.max_write_behind = write_behind;
-- 
2.39.5



