Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CB53AE5C
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30EFBC433EF;
	Wed,  7 Jun 2023 20:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169781;
	bh=ccY9kNcRCwAvdcz5NUVxfEw3Gr/8eP2fXagni27mMW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VMJv/ZFX9Zklf/r/k50LM6dvZ3DNNPMXhw0qfNMIccq7DZPtliqttJEhe8BAF7qhM
	 6g2zX4xYhcUE18zhzgKd0wJlHM9SFnWNV60kZUNmn4sBH3mziwc2rR9gbf4TPshov4
	 9h5gzLtyraj6OVWOs2h4/8ExqDDVGTf+ooJZWi90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.3 212/286] md/raid5: fix miscalculation of end_sector in raid5_read_one_chunk()
Date: Wed,  7 Jun 2023 22:15:11 +0200
Message-ID: <20230607200930.177576450@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
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

commit 8557dc27126949c702bd3aafe8a7e0b7e4fcb44c upstream.

'end_sector' is compared to 'rdev->recovery_offset', which is offset to
rdev, however, commit e82ed3a4fbb5 ("md/raid6: refactor
raid5_read_one_chunk") changes the calculation of 'end_sector' to offset
to the array. Fix this miscalculation.

Fixes: e82ed3a4fbb5 ("md/raid6: refactor raid5_read_one_chunk")
Cc: stable@vger.kernel.org # v5.12+
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230524014118.3172781-1-yukuai1@huaweicloud.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5516,7 +5516,7 @@ static int raid5_read_one_chunk(struct m
 
 	sector = raid5_compute_sector(conf, raid_bio->bi_iter.bi_sector, 0,
 				      &dd_idx, NULL);
-	end_sector = bio_end_sector(raid_bio);
+	end_sector = sector + bio_sectors(raid_bio);
 
 	rcu_read_lock();
 	if (r5c_big_stripe_cached(conf, sector))


