Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EA515C85
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD20C433D7;
	Mon,  5 Dec 2022 19:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670269196;
	bh=dxU7GQ6y7EbjdtJ2vHoHYTRsyqJyR1aM76v0IhwAXpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vMzpcubagCd03r3MI+yTJV2X+qjT8ApRL+MnfYzRQ9rIZvFSaNHKyLQHDFQGHqxcJ
	 Mn9e+8kohhJNE26ySerd/zBSWDlN7WkoIX6K3cbqmvkV9ZiB/ibYQnIc8tUaMcOUMb
	 zcIkH5Ecav46ALpu+chVso/XtPTrAPtwzXJZ/uAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Haberland <sth@linux.ibm.com>,
	Jan Hoeppner <hoeppner@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 039/153] s390/dasd: fix no record found for raw_track_access
Date: Mon,  5 Dec 2022 20:09:23 +0100
Message-Id: <20221205190809.846182239@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stefan Haberland <sth@linux.ibm.com>

[ Upstream commit 590ce6d96d6a224b470a3862c33a483d5022bfdb ]

For DASD devices in raw_track_access mode only full track images are
read and written.
For this purpose it is not necessary to do search operation in the
locate record extended function. The documentation even states that
this might fail if the searched record is not found on a track.

Currently the driver sets a value of 1 in the search field for the first
record after record zero. This is the default for disks not in
raw_track_access mode but record 1 might be missing on a completely
empty track.

There has not been any problem with this on IBM storage servers but it
might lead to errors with DASD devices on other vendors storage servers.

Fix this by setting the search field to 0. Record zero is always available
even on a completely empty track.

Fixes: e4dbb0f2b5dd ("[S390] dasd: Add support for raw ECKD access.")
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Reviewed-by: Jan Hoeppner <hoeppner@linux.ibm.com>
Link: https://lore.kernel.org/r/20221123160719.3002694-4-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/block/dasd_eckd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 7749deb614d7..53d22975a32f 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -4627,7 +4627,6 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_raw(struct dasd_device *startdev,
 	struct dasd_device *basedev;
 	struct req_iterator iter;
 	struct dasd_ccw_req *cqr;
-	unsigned int first_offs;
 	unsigned int trkcount;
 	unsigned long *idaws;
 	unsigned int size;
@@ -4661,7 +4660,6 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_raw(struct dasd_device *startdev,
 	last_trk = (blk_rq_pos(req) + blk_rq_sectors(req) - 1) /
 		DASD_RAW_SECTORS_PER_TRACK;
 	trkcount = last_trk - first_trk + 1;
-	first_offs = 0;
 
 	if (rq_data_dir(req) == READ)
 		cmd = DASD_ECKD_CCW_READ_TRACK;
@@ -4705,13 +4703,13 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_raw(struct dasd_device *startdev,
 
 	if (use_prefix) {
 		prefix_LRE(ccw++, data, first_trk, last_trk, cmd, basedev,
-			   startdev, 1, first_offs + 1, trkcount, 0, 0);
+			   startdev, 1, 0, trkcount, 0, 0);
 	} else {
 		define_extent(ccw++, data, first_trk, last_trk, cmd, basedev, 0);
 		ccw[-1].flags |= CCW_FLAG_CC;
 
 		data += sizeof(struct DE_eckd_data);
-		locate_record_ext(ccw++, data, first_trk, first_offs + 1,
+		locate_record_ext(ccw++, data, first_trk, 0,
 				  trkcount, cmd, basedev, 0, 0);
 	}
 
-- 
2.35.1



