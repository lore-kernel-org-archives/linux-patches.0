Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA1463109;
	Tue, 23 Jan 2024 01:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974984; cv=none; b=AjfKGnQZYUt+TS+8gCu4qTEGYvocjpk7hsmFFl7lwJx/FSUxVaONckg96XMxUORY+k51VPmqTMgkESudCpM0zbBAMk7YVC3grt3Z0i6ydC6pT8ugp8VPfPDw39VMIRD8uboRDp65zhK+4XdezJKNx/trrR+xrpseD/CTCtAck+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974984; c=relaxed/simple;
	bh=/1zb43z/KqNGTVzzRRBRux8lvk7xUwFdQwJeYYlsJwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QewmLwaUzwxiZu+l/OSPvfpMb7tG8Y4gnTfWcYxVAKsJfraeRBId9y7lUo3D1CLQU2e/3ZLsYR2Odg+DiCKk3ZZgPgk3MDGyj1UwNdFFqpL5Cbl1Ev8HlHeoeEHD9wvvS1rRaFoEzWkbVPRx/CYs4ObSIgdEfo5d4mpwlokqnm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t7rlR8OQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t7rlR8OQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A4CC433C7;
	Tue, 23 Jan 2024 01:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974983;
	bh=/1zb43z/KqNGTVzzRRBRux8lvk7xUwFdQwJeYYlsJwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t7rlR8OQEPu8raV5suDTVXq6HbEZEPaqdS2jbFHI0DorpAWhOlqswdBbY+DYz9EUi
	 R7NgMjvbMbeeN97/2KVmcqoKvP/jTfZ7g14eLN6NGUVc/+vgIBigGFUjCIilhOJ/VT
	 Hvs06fJ4B3XcBdziidasY8dveYW4QGlYu4L6H5Xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 180/583] block: add check of minors and first_minor in device_add_disk()
Date: Mon, 22 Jan 2024 15:53:51 -0800
Message-ID: <20240122235817.522379655@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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
index 95a4b8ae2aea..f9b81be6c761 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -432,7 +432,9 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
 				DISK_MAX_PARTS);
 			disk->minors = DISK_MAX_PARTS;
 		}
-		if (disk->first_minor + disk->minors > MINORMASK + 1)
+		if (disk->first_minor > MINORMASK ||
+		    disk->minors > MINORMASK + 1 ||
+		    disk->first_minor + disk->minors > MINORMASK + 1)
 			goto out_exit_elevator;
 	} else {
 		if (WARN_ON(disk->minors))
-- 
2.43.0



