Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9118F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3EEC433C8;
	Sun, 16 Jul 2023 20:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539346;
	bh=cqySQXH39UEEVd+jB/HCVb8rs7KaLg8eqv6QL1OR6sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fWkQFhS7nx/n/NGL3cH+rsg5Vv9JlBrC5z/pIv76CpC1EKK4V2VIgVBJOd3eTjEZZ
	 2CrCVIFmejoAsGUhz2uvvlRyX/nii0wjMq7vGsm5AjRNFYEutCCVa5minnG2vfiwdl
	 rWWOxB8RR9UXJRvZsKYC/RsM/CYp371LHuls+RZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.4 775/800] md/raid1-10: fix casting from randomized structure in raid1_submit_write()
Date: Sun, 16 Jul 2023 21:50:28 +0200
Message-ID: <20230716195007.150552042@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

commit b5a99602b74bbfa655be509c615181dd95b0719e upstream.

Following build error triggered while build with clang version 17.0.0
with W=1(this can't be reporduced with gcc 13.1.0):

drivers/md/raid1-10.c:117:25: error: casting from randomized structure
pointer type 'struct block_device *' to 'struct md_rdev *'
     117 |         struct md_rdev *rdev = (struct md_rdev *)bio->bi_bdev;
         |                                ^

Fix this by casting 'bio->bi_bdev' to 'void *', as it used to be.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202306142042.fmjfmTF8-lkp@intel.com/
Fixes: 8295efbe68c0 ("md/raid1-10: factor out a helper to submit normal write")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230616012136.3047071-1-yukuai1@huaweicloud.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid1-10.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -113,7 +113,7 @@ static void md_bio_reset_resync_pages(st
 
 static inline void raid1_submit_write(struct bio *bio)
 {
-	struct md_rdev *rdev = (struct md_rdev *)bio->bi_bdev;
+	struct md_rdev *rdev = (void *)bio->bi_bdev;
 
 	bio->bi_next = NULL;
 	bio_set_dev(bio, rdev->bdev);


