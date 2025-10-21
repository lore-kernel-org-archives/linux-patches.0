Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8B7134AC;
	Tue, 21 Oct 2025 20:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077018; cv=none; b=UZ5ZJqG4lKV92uMwAQKM4Gc37YlWgTF2tfa6I3pfaXVcPpOeycGIqBXb2kxEJHTQqHiGVzZ91qkyaOzwMcEGHzWbs+HEG/6fBSkHholBt5ashdGZvMUbaeWEr9xNRdvE9oz+63++tu9cq3ecH2me9niAZJ+kbQbL+62gmHPhMeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077018; c=relaxed/simple;
	bh=9/oCGc+sboRqQm0TRCtGmaouJcQPWmbRRl8hn8+xUE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sz/nsPBs8vnRurmzybcnRJdmpY+9E1NrdtfhOa2t65tC5Ukp0m+7avtKwlvyARwVFf8cfli7eBgvgBRpiS9pVx2Qmh46DiCrwtpccci5nKycI+rep56CTfY3ifm0b5TpI7J820v1mecKXoo1tpdfiCQ/kF5Q4WqERMOBfv+5KAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=197RJIdE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="197RJIdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11ABC4CEF1;
	Tue, 21 Oct 2025 20:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077018;
	bh=9/oCGc+sboRqQm0TRCtGmaouJcQPWmbRRl8hn8+xUE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=197RJIdEhmuMI3AP6MIz4OclpnPFRXxYmZJZGTwJDDXQGzY3PBmREBgJoIHYQtspO
	 Ho8QtG3IKnN/m7JCp4e0YIA+8QaOSz0JooWxQt/iURMTTo7KOvrzJVUu27ZuWi71Cf
	 06r20zwcK/oEtIV9b5HIS2/HSm3+icZ52il00H7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 111/136] md/raid0: Handle bio_split() errors
Date: Tue, 21 Oct 2025 21:51:39 +0200
Message-ID: <20251021195038.635577649@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit 74538fdac3e85aae55eb4ed786478ed2384cb85d ]

Add proper bio_split() error handling. For any error, set bi_status, end
the bio, and return.

Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/r/20241111112150.3756529-5-john.g.garry@oracle.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 22f166218f73 ("md: fix mssing blktrace bio split events")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid0.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -464,6 +464,12 @@ static void raid0_handle_discard(struct
 		struct bio *split = bio_split(bio,
 			zone->zone_end - bio->bi_iter.bi_sector, GFP_NOIO,
 			&mddev->bio_set);
+
+		if (IS_ERR(split)) {
+			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
+			bio_endio(bio);
+			return;
+		}
 		bio_chain(split, bio);
 		submit_bio_noacct(bio);
 		bio = split;
@@ -606,6 +612,12 @@ static bool raid0_make_request(struct md
 	if (sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, sectors, GFP_NOIO,
 					      &mddev->bio_set);
+
+		if (IS_ERR(split)) {
+			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
+			bio_endio(bio);
+			return true;
+		}
 		bio_chain(split, bio);
 		raid0_map_submit_bio(mddev, bio);
 		bio = split;


