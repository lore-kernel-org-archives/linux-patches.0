Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E94C60252;
	Tue, 23 Jan 2024 00:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970857; cv=none; b=ctx2qHnyCRPvp7cFkkL//dJFAAET+3rnWs8HX6FyZh/Vp6kUl+GNWi8KgYD+L3BfxVS/NCqdXCg1GVbhmsVt0nUgkJFZnWqvcKsZZBjBD1ZT9N9Zis7IWvDoixZrqKCVJ2cycek4uEFP/5HRPDcOuhhe0e2H+5O35SBnkO18s9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970857; c=relaxed/simple;
	bh=qDweAP6AwiHEp0NvNS/lpgWyPy2JUYQb+kMsMvEmo8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0Mp3xrG4pTIKzhTzWNmrJS22/qZV/1fnLUzlKPR4JsltPkjzZMOXgJB/+5MH5xwXAhYS92zeK26eXR/PADq6x7F0xm4hlRG8w6Wve+ExDbKL4b1bQd6gnC5asYMZG7hgpvKGMBwQvxE+ab+knQS9dmFVOtu1s7/vcFPJ53fIHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJ/NrIjA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJ/NrIjA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ACBDC43390;
	Tue, 23 Jan 2024 00:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970857;
	bh=qDweAP6AwiHEp0NvNS/lpgWyPy2JUYQb+kMsMvEmo8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OJ/NrIjAD2BAxKQga9VLoK2rV7aP1Nz53LT1+ZVb34lBYSphcTw7DH6SJwCc5z37e
	 Aoh+IVGU2RfZs0Mf1B7fqSS9aCTZ/m+dhVE0W2g/bhO959O3JDw6tthy4r2VbdodBb
	 wtisSLAvr/+yiynsYEmno4gKxHWxJtLTqvUSNixk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 126/417] block: add check of minors and first_minor in device_add_disk()
Date: Mon, 22 Jan 2024 15:54:54 -0800
Message-ID: <20240122235756.167113946@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5b23f2c3d692..8e9d162cbdbd 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -444,7 +444,9 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
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



