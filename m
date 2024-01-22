Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255D76AA6;
	Tue, 23 Jan 2024 01:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974075; cv=none; b=GxxpJm81Ou9/CGTN9n8GuupNWyv5tenafy3AuyBfpZ4kTJrS2BWM6fPwEH8DViLXWo5MjeQbKMPH2xXybjgROKrux5SECQ5TkRh63X0gzH0sHaaeXz+7m+53adNRoFx7O/oMNyI8/RHdPAN/2ZaQ51alGTmOoMzTFBdF/+DAWt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974075; c=relaxed/simple;
	bh=+F2stmSx7DYScIUXIEWfVkw0DYLGEJ/gdBTH2lXIgr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2lfcn/5ZOPq0KtbvIEaVTEB4eYddBz5h7NqFZtM3yTzqsUcHspOOifT3hHUza4o+w7pzq/YaLqs42m+ouC2TR8GGnFBGwBxooKo5Vu0ZQhvfFJ2u06yZ7vedx310UT5VhOPr4DXUnFMNolvTq1zoC0p/dp9oTn1b89sZHJjD3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JM4rC95V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JM4rC95V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9E6C43390;
	Tue, 23 Jan 2024 01:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974075;
	bh=+F2stmSx7DYScIUXIEWfVkw0DYLGEJ/gdBTH2lXIgr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JM4rC95VE8aotjnOA7pKe3nC6d77jDcFCPTqFZm6Ra0QU4pEDHWHsLpvOiv/hqoFV
	 64WIbV+a43x/w294BQGymOfdJ09sPj70OGvflQKBzzOUtNET6JmZkMPmcSrEVcbuAz
	 ybE4nxAiXVwDfdoSio1NbSLNG9MyM7yd1SgwUdN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 153/374] block: add check of minors and first_minor in device_add_disk()
Date: Mon, 22 Jan 2024 15:56:49 -0800
Message-ID: <20240122235749.939967864@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

[ Upstream commit 4c434392c4777881d01beada6701eff8c76b43fe ]

'first_minor' represents the starting minor number of disks, and
'minors' represents the number of partitions in the device. Neither
of them can be greater than MINORMASK + 1.

Commit e338924bd05d ("block: check minor range in device_add_disk()")
only added the check of 'first_minor + minors'. However, their sum might
be less than MINORMASK but their values are wrong. Complete the checks now.

Fixes: e338924bd05d ("block: check minor range in device_add_disk()")
Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20231219075942.840255-1-linan666@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/genhd.c b/block/genhd.c
index 6aef540bbacf..84f5ac627e79 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -421,7 +421,9 @@ int device_add_disk(struct device *parent, struct gendisk *disk,
 				DISK_MAX_PARTS);
 			disk->minors = DISK_MAX_PARTS;
 		}
-		if (disk->first_minor + disk->minors > MINORMASK + 1)
+		if (disk->first_minor > MINORMASK ||
+		    disk->minors > MINORMASK + 1 ||
+		    disk->first_minor + disk->minors > MINORMASK + 1)
 			return -EINVAL;
 	} else {
 		if (WARN_ON(disk->minors))
-- 
2.43.0



