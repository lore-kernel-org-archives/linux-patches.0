Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4428F40C03;
	Tue, 29 Apr 2025 18:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950075; cv=none; b=W3MbiPs9eyUc4QNTgcNyLQoJRu6Ams+GN3is3lV9Tufj6hAEDHytB1hliAJt/vi9b13EmTFXDqd2kWVoJ8t3cbPZOuJLzUKEiK5d/mhnQm04s+VV0bDMvthr07+fJ8ujOvIvYL+eTJHMru48mPdN8WcV51eqnBvNe9/c8YA6MIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950075; c=relaxed/simple;
	bh=rldtOZutT8pQiDv8AhZYn17npcd26yMIMFO4hUuUgvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pM1oBg9S1ogSU4+W/x93qDb2WgPERgQXFBhxoxoG18WlhPEEGYaUP2NiDVm/fXoZeTIs5qspbJAJG3QqGethKSbe42gDg1lkIRzSlhI/CU2cyNjUtA/s+GPAf7URYx+E0Vqwuss3QNwcqVlW4QtW8mV/xCokfqW7n1CK6TdgkYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZkI9vvDM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZkI9vvDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27447C4CEE3;
	Tue, 29 Apr 2025 18:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950074;
	bh=rldtOZutT8pQiDv8AhZYn17npcd26yMIMFO4hUuUgvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZkI9vvDMl4iJ/NXNRwmwADjQwac0QbiErBAboCnckkFm/FwJVISdBKRhZv1syx69D
	 SOm7/To28oklADZI3BZjwpD6W5iId+PyQ5BVG9/mtT9PdQOYmiNllUNFCdU0UZPy8q
	 uNXFPDv/Uj8HIXEOy/chhljUotrDYfUjQ8GB0Ckk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meir Elisha <meir.elisha@volumez.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 148/167] md/raid1: Add check for missing source disk in process_checks()
Date: Tue, 29 Apr 2025 18:44:16 +0200
Message-ID: <20250429161057.713782818@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Meir Elisha <meir.elisha@volumez.com>

[ Upstream commit b7c178d9e57c8fd4238ff77263b877f6f16182ba ]

During recovery/check operations, the process_checks function loops
through available disks to find a 'primary' source with successfully
read data.

If no suitable source disk is found after checking all possibilities,
the 'primary' index will reach conf->raid_disks * 2. Add an explicit
check for this condition after the loop. If no source disk was found,
print an error message and return early to prevent further processing
without a valid primary source.

Link: https://lore.kernel.org/linux-raid/20250408143808.1026534-1-meir.elisha@volumez.com
Signed-off-by: Meir Elisha <meir.elisha@volumez.com>
Suggested-and-reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 76f7ca53d8123..38e77a4b6b338 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2068,14 +2068,9 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 				if (!rdev_set_badblocks(rdev, sect, s, 0))
 					abort = 1;
 			}
-			if (abort) {
-				conf->recovery_disabled =
-					mddev->recovery_disabled;
-				set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-				md_done_sync(mddev, r1_bio->sectors, 0);
-				put_buf(r1_bio);
+			if (abort)
 				return 0;
-			}
+
 			/* Try next page */
 			sectors -= s;
 			sect += s;
@@ -2214,10 +2209,21 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
 	int disks = conf->raid_disks * 2;
 	struct bio *wbio;
 
-	if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
-		/* ouch - failed to read all of that. */
-		if (!fix_sync_read_error(r1_bio))
+	if (!test_bit(R1BIO_Uptodate, &r1_bio->state)) {
+		/*
+		 * ouch - failed to read all of that.
+		 * No need to fix read error for check/repair
+		 * because all member disks are read.
+		 */
+		if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) ||
+		    !fix_sync_read_error(r1_bio)) {
+			conf->recovery_disabled = mddev->recovery_disabled;
+			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
+			md_done_sync(mddev, r1_bio->sectors, 0);
+			put_buf(r1_bio);
 			return;
+		}
+	}
 
 	if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
 		process_checks(r1_bio);
-- 
2.39.5



