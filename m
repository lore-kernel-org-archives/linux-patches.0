Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A4411710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4CFC433C8;
	Mon, 11 Sep 2023 15:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445353;
	bh=m8R4VTar8VwjaIQ2QFTsjKtarTio9evRQx+0ZmTKu+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQF96lvrd6AkVz7MMhwxaWpZXlbxMXvxF850ZCv7yI2Jr5vNk/sZ1N+nN5JGHgNYd
	 pD59y6e9jQovLOoAZ906e86QFcrTA/FcTdxBAH7hbHHfpPNDKtyiIB+pN2T1u++41w
	 kFuuXVCxzd0fDJ+yWM9RjRNPbWhKWdFggMAc8qZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Xueshi Hu <xueshi.hu@smartx.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 317/600] md/raid1: hold the barrier until handle_read_error() finishes
Date: Mon, 11 Sep 2023 15:45:50 +0200
Message-ID: <20230911134643.038861632@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

From: Xueshi Hu <xueshi.hu@smartx.com>

[ Upstream commit c069da449a13669ffa754fd971747e7e17e7d691 ]

handle_read_error() will call allow_barrier() to match the former barrier
raising. However, it should put the allow_barrier() at the end to avoid a
concurrent raid reshape.

Fixes: 689389a06ce7 ("md/raid1: simplify handle_read_error().")
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
Link: https://lore.kernel.org/r/20230814135356.1113639-4-xueshi.hu@smartx.com
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 433db7007f88b..2d9372e6b5961 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2495,6 +2495,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	struct mddev *mddev = conf->mddev;
 	struct bio *bio;
 	struct md_rdev *rdev;
+	sector_t sector;
 
 	clear_bit(R1BIO_ReadError, &r1_bio->state);
 	/* we got a read error. Maybe the drive is bad.  Maybe just
@@ -2524,12 +2525,13 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	}
 
 	rdev_dec_pending(rdev, conf->mddev);
-	allow_barrier(conf, r1_bio->sector);
+	sector = r1_bio->sector;
 	bio = r1_bio->master_bio;
 
 	/* Reuse the old r1_bio so that the IO_BLOCKED settings are preserved */
 	r1_bio->state = 0;
 	raid1_read_request(mddev, bio, r1_bio->sectors, r1_bio);
+	allow_barrier(conf, sector);
 }
 
 static void raid1d(struct md_thread *thread)
-- 
2.40.1



