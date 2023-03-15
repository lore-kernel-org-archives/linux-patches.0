Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEA04431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4208EC433EF;
	Wed, 15 Mar 2023 12:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883470;
	bh=S+HWvcBHvuViWIPRtZcMvd5xYpaf8PssR3zgXbNJBOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+6nIaU/WSmKRmvgFv941zJoigg9I5UYj6KudYfG0niDygB5OR2bvZdQDU2HGWoGW
	 N0YIiYRsS5WnKFlBOzHz7ZaQzpPPaoY29ZxI/JWdTPVFpraFNrXu1HAqWCKL9/vN9N
	 1R6ka8CEfcJZAYlzUJeVdgWOUsapyIcEcncTCriU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 002/143] btrfs: fix unnecessary increment of read error stat on write error
Date: Wed, 15 Mar 2023 13:11:28 +0100
Message-Id: <20230315115740.515545016@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 98e8d36a26c2ed22f78316df7d4bf33e554b9f9f upstream.

Current btrfs_log_dev_io_error() increases the read error count even if the
erroneous IO is a WRITE request. This is because it forget to use "else
if", and all the error WRITE requests counts as READ error as there is (of
course) no REQ_RAHEAD bit set.

Fixes: c3a62baf21ad ("btrfs: use chained bios when cloning")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6739,7 +6739,7 @@ static void btrfs_log_dev_io_error(struc
 
 	if (btrfs_op(bio) == BTRFS_MAP_WRITE)
 		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_WRITE_ERRS);
-	if (!(bio->bi_opf & REQ_RAHEAD))
+	else if (!(bio->bi_opf & REQ_RAHEAD))
 		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_READ_ERRS);
 	if (bio->bi_opf & REQ_PREFLUSH)
 		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_FLUSH_ERRS);


