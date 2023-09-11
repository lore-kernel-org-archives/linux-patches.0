Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243C11170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:23:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9AFC433C8;
	Mon, 11 Sep 2023 14:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442235;
	bh=efUZNdNcl5ftBEpsgWVpuLeDT/cIrusn6YqUlRI2cyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XNXOwhxdigjRCS6J+TA0QFnc9xprNlsgCO+TKSwm4v2JgmONk1p1/TgpBdbBy1NUy
	 AMnNUxcRJAe2iu974IRMqwMXoSNDWO6c+IAIP9Prl8FJdVlNuOnQ66yVSiDpA4kviu
	 sxqgJvj3Ar6mCtEDvf8xu834UrakMnUnj2hRIP/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.5 693/739] block: dont add or resize partition on the disk with GENHD_FL_NO_PART
Date: Mon, 11 Sep 2023 15:48:12 +0200
Message-ID: <20230911134710.452943948@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Lingfeng <lilingfeng3@huawei.com>

commit 1a721de8489fa559ff4471f73c58bb74ac5580d3 upstream.

Commit a33df75c6328 ("block: use an xarray for disk->part_tbl") remove
disk_expand_part_tbl() in add_partition(), which means all kinds of
devices will support extended dynamic `dev_t`.
However, some devices with GENHD_FL_NO_PART are not expected to add or
resize partition.
Fix this by adding check of GENHD_FL_NO_PART before add or resize
partition.

Fixes: a33df75c6328 ("block: use an xarray for disk->part_tbl")
Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20230831075900.1725842-1-lilingfeng@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/ioctl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -20,6 +20,8 @@ static int blkpg_do_ioctl(struct block_d
 	struct blkpg_partition p;
 	long long start, length;
 
+	if (disk->flags & GENHD_FL_NO_PART)
+		return -EINVAL;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 	if (copy_from_user(&p, upart, sizeof(struct blkpg_partition)))


