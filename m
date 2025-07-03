Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D034086348;
	Thu,  3 Jul 2025 15:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555906; cv=none; b=C5iXGbb36EVlEzorQXpK9Nw+4yt3oRd0WOPG59EG53fjEQyzpCHZ7cFQPuILJMkNDnfx1fggHlwdmNWRSS+8ib1xC0NH8GFz49k8jlzD6uq49/I6ykiF1D3eajGRlbxnYXwwkFHZj2UKbz97yGdwKUxlxVByT9xxaROK5BO1qCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555906; c=relaxed/simple;
	bh=FGE3h5gZwBcw1Yvb3nQsuERROcP88fGc5AlaQB1emck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aj4wIqG/IFcRIe/++LJM5xx+Q3NKQQXEOmqfh7+i49LU2Z7Mj6PkoY8DIH4NtHfP3llb3VIH50c/xWineqV0Lx6zFhbtkpn8v7fkPWBeDLOUGMRPBOdksIXsnKJRmK4oaxixTw5iSYcxK6Roju/PHMnFXd3W6Buggdq43dVDCxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GwrA4CWQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GwrA4CWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57578C4CEE3;
	Thu,  3 Jul 2025 15:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555906;
	bh=FGE3h5gZwBcw1Yvb3nQsuERROcP88fGc5AlaQB1emck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GwrA4CWQ8bT2cVmpy0UBCvfXTKSTdX2S5k+MRZBlFnEQHUEj+6v2MRtGtVA47qQEG
	 v5/Yw/E08oHCnjlcRzMtsREPHP4a+Nm5JRHyuNdCqeC+X6ZBUsjCpsq89LdjIYI/9N
	 GK5TjhpX30ETczEpoullG2LYi1Jwoa8/DW6DeqZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 015/132] md/md-bitmap: fix dm-raid max_write_behind setting
Date: Thu,  3 Jul 2025 16:41:44 +0200
Message-ID: <20250703143939.998345033@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 02629516748e4..dac27206cd3df 100644
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



