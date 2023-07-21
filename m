Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3968020F88
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:10:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF713C433C7;
	Fri, 21 Jul 2023 19:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966635;
	bh=kbJcNiaKMhoG4keMWgFaWj7Tf7oLEeAdWsHOJdN5rYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E8+qBbX/w1xCsjrL1RDK+YZXJcuASB7anq943HIxxaUmZs+74j00tPLMv8Uxu1lMc
	 hIclWtiS+hT/qLLiw6ksQCP4K3+H1xnp6OqLCWTPRmHJ0Hi4r+RgKQ3AwYh7ux7NPP
	 jDS74OPAs1VKlCh6LTNcLS4XoYg/7yqVG92JM/9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Zigotzky <chzigotzky@xenosoft.de>,
	Michael Schmitz <schmitzmic@gmail.com>,
	Martin Steigerwald <martin@lichtvoll.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 386/532] block/partition: fix signedness issue for Amiga partitions
Date: Fri, 21 Jul 2023 18:04:50 +0200
Message-ID: <20230721160635.414421423@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Schmitz <schmitzmic@gmail.com>

commit 7eb1e47696aa231b1a567846bbe3a1e1befe1854 upstream.

Making 'blk' sector_t (i.e. 64 bit if LBD support is active) fails the
'blk>0' test in the partition block loop if a value of (signed int) -1 is
used to mark the end of the partition block list.

Explicitly cast 'blk' to signed int to allow use of -1 to terminate the
partition block linked list.

Fixes: b6f3f28f604b ("block: add overflow checks for Amiga partition support")
Reported-by: Christian Zigotzky <chzigotzky@xenosoft.de>
Link: https://lore.kernel.org/r/024ce4fa-cc6d-50a2-9aae-3701d0ebf668@xenosoft.de
Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
Reviewed-by: Martin Steigerwald <martin@lichtvoll.de>
Tested-by: Christian Zigotzky <chzigotzky@xenosoft.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/partitions/amiga.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/partitions/amiga.c
+++ b/block/partitions/amiga.c
@@ -90,7 +90,7 @@ int amiga_partition(struct parsed_partit
 	}
 	blk = be32_to_cpu(rdb->rdb_PartitionList);
 	put_dev_sector(sect);
-	for (part = 1; blk>0 && part<=16; part++, put_dev_sector(sect)) {
+	for (part = 1; (s32) blk>0 && part<=16; part++, put_dev_sector(sect)) {
 		/* Read in terms partition table understands */
 		if (check_mul_overflow(blk, (sector_t) blksize, &blk)) {
 			pr_err("Dev %s: overflow calculating partition block %llu! Skipping partitions %u and beyond\n",


