Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB252D8790;
	Tue, 15 Jul 2025 13:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587490; cv=none; b=mtfK1tskKik3Th4iBoY1EO/6oolxd7YDL8vk5B0fJvkI9dedG8U43TXTfGGJQHrjiI1bTx3xnVv92VAQ2Fc1pcKW5skyIhLCm5B9HsH+NNnkHhkD3h+Qn4kzOZDKmB6C/ztQzBc+f46EYWPiUb9eUwneac26zIOppTD1RS/HYy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587490; c=relaxed/simple;
	bh=iLeiJxZ1q1pvZypch2W2JzeQLzC/2scRPGTsbKpMugw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uv5/bAqS7ZpW6h83lnbIPqkc4uaUvR2OvefD0fNP8g8ruKsxfqi0Ewa+Y/cECJTZt8l0K/KzFPmZBaPJja+pmrkMGlLkR0CAHoxgqwRmmawnGfqmYObAIRS26SaDhmSyCID7kuAVPzzGQB6X9HUeYUG5w1nw29hxaJc3XwCbTX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OD0zofyW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OD0zofyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3994C4CEE3;
	Tue, 15 Jul 2025 13:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587490;
	bh=iLeiJxZ1q1pvZypch2W2JzeQLzC/2scRPGTsbKpMugw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OD0zofyWLdkWjSyloWQtW3eK/3a2Z7156VIMYPjcvW3MtX9X8m2jY00MNhe7g5J5v
	 bO2tNPPbA6qbca2UFvpoxhMX4FeUpwOynFdeU2RMLvk9p93CTiy7N+d1UIAsTFu2H9
	 2jjf1jrgWAl5EqMl1v5opIKarenro3XSLByJ4+/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 008/208] md/md-bitmap: fix dm-raid max_write_behind setting
Date: Tue, 15 Jul 2025 15:11:57 +0200
Message-ID: <20250715130811.170706504@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 91bc764a854c6..f2ba541ed89d4 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -546,7 +546,7 @@ static int md_bitmap_new_disk_sb(struct bitmap *bitmap)
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



