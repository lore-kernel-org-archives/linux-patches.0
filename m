Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA491FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E724DC433EF;
	Fri,  3 Feb 2023 10:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419530;
	bh=3ANQVPVLn2flnVKIGz3NzeClX/UMYEWd5Zs6KXoyoAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sJDA+oGnseNppvEnpK28r1A8jKYxPKd+pvndseXuJVg8J5Au9+oKFqeAVtnxQqiNF
	 yQguyMR6wegf7VtCUXHykIJwqpO5x850AEDlkp2JRxeEV8WTopSv49SMb/ojNVArYZ
	 UrZkpY5b+zjXq1+XgGJolbu7hd2JVZ+SoFVbCOxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Fedor Pchelkin <pchelkin@ispras.ru>
Subject: [PATCH 4.19 33/80] block: fix and cleanup bio_check_ro
Date: Fri,  3 Feb 2023 11:12:27 +0100
Message-Id: <20230203101016.584169850@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

commit 57e95e4670d1126c103305bcf34a9442f49f6d6a upstream.

Don't use a WARN_ON when printing a potentially user triggered
condition.  Also don't print the partno when the block device name
already includes it, and use the %pg specifier to simplify printing
the block device name.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20220304180105.409765-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-core.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2179,10 +2179,7 @@ static inline bool bio_check_ro(struct b
 
 		if (op_is_flush(bio->bi_opf) && !bio_sectors(bio))
 			return false;
-
-		WARN_ONCE(1,
-		       "generic_make_request: Trying to write "
-			"to read-only block-device %s (partno %d)\n",
+		pr_warn("Trying to write to read-only block-device %s (partno %d)\n",
 			bio_devname(bio, b), part->partno);
 		/* Older lvm-tools actually trigger this */
 		return false;


