Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CEF2727E2;
	Mon, 18 Aug 2025 13:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522859; cv=none; b=A1Ag7lzVgmIbYYEvb1Sm/O33kmifuk7sEIQRr4MiFaiuygWenpVdoecg8nlXEAy/MT1h9BE6NP3Wx0jymqYnOIvM2PXHo+wwWudsBGs4o+qY+q2sU+vI5QES7mrxpMhsQT0WfMfr1flEaxEOB3gY+KfNp3LaG9Byn5lIr3IyFXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522859; c=relaxed/simple;
	bh=rNLECt/MDVR4LQhwjOtyx3dSNcruxxeLyZgo5S3FxoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OTVkuguHcNPXeZzuQx6StPLOPrVUY33zPTxyl4za2FSz82xgtZGA7JMP/gJC2Z79XljAO/SgKcysL/vOF3+Q9shsk8VxVdZnFUhyf7xtGU0gnlN4HLLM0LmsavXjjTQoOGG0GlahIWJ3fhxT8IxdWzQs+P2wNYHiD1nU4HqvLaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rxKp0In0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rxKp0In0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17BF8C4CEEB;
	Mon, 18 Aug 2025 13:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522859;
	bh=rNLECt/MDVR4LQhwjOtyx3dSNcruxxeLyZgo5S3FxoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rxKp0In0vNiFjPWLEA9tXDX9DN6h6jlyhsn/5GEHZfmxuOn81DefE/Tbn+iPIxjaB
	 iRPc2vuoQbSfcWV/wHNeFRsEv8nXe08NbrC67bgmZ5pkhGItO2fdPXExjqQOvqAqhj
	 buBigelDIaHG5Xq80SLKSSOT93W6x4HaAEWxKZLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 443/444] dm: split write BIOs on zone boundaries when zone append is not emulated
Date: Mon, 18 Aug 2025 14:47:49 +0200
Message-ID: <20250818124505.567768551@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

commit 675f940576351bb049f5677615140b9d0a7712d0 upstream.

Commit 2df7168717b7 ("dm: Always split write BIOs to zoned device
limits") updates the device-mapper driver to perform splits for the
write BIOs. However, it did not address the cases where DM targets do
not emulate zone append, such as in the cases of dm-linear or dm-flakey.
For these targets, when the write BIOs span across zone boundaries, they
trigger WARN_ON_ONCE(bio_straddles_zones(bio)) in
blk_zone_wplug_handle_write(). This results in I/O errors. The errors
are reproduced by running blktests test case zbd/004 using zoned
dm-linear or dm-flakey devices.

To avoid the I/O errors, handle the write BIOs regardless whether DM
targets emulate zone append or not, so that all write BIOs are split at
zone boundaries. For that purpose, drop the check for zone append
emulation in dm_zone_bio_needs_split(). Its argument 'md' is no longer
used then drop it also.

Fixes: 2df7168717b7 ("dm: Always split write BIOs to zoned device limits")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Link: https://lore.kernel.org/r/20250717103539.37279-1-shinichiro.kawasaki@wdc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1788,8 +1788,7 @@ static void init_clone_info(struct clone
 }
 
 #ifdef CONFIG_BLK_DEV_ZONED
-static inline bool dm_zone_bio_needs_split(struct mapped_device *md,
-					   struct bio *bio)
+static inline bool dm_zone_bio_needs_split(struct bio *bio)
 {
 	/*
 	 * Special case the zone operations that cannot or should not be split.
@@ -1805,13 +1804,11 @@ static inline bool dm_zone_bio_needs_spl
 	}
 
 	/*
-	 * Mapped devices that require zone append emulation will use the block
-	 * layer zone write plugging. In such case, we must split any large BIO
-	 * to the mapped device limits to avoid potential deadlocks with queue
-	 * freeze operations.
+	 * When mapped devices use the block layer zone write plugging, we must
+	 * split any large BIO to the mapped device limits to not submit BIOs
+	 * that span zone boundaries and to avoid potential deadlocks with
+	 * queue freeze operations.
 	 */
-	if (!dm_emulate_zone_append(md))
-		return false;
 	return bio_needs_zone_write_plugging(bio) || bio_straddles_zones(bio);
 }
 
@@ -1935,8 +1932,7 @@ static blk_status_t __send_zone_reset_al
 }
 
 #else
-static inline bool dm_zone_bio_needs_split(struct mapped_device *md,
-					   struct bio *bio)
+static inline bool dm_zone_bio_needs_split(struct bio *bio)
 {
 	return false;
 }
@@ -1963,7 +1959,7 @@ static void dm_split_and_process_bio(str
 
 	is_abnormal = is_abnormal_io(bio);
 	if (static_branch_unlikely(&zoned_enabled)) {
-		need_split = is_abnormal || dm_zone_bio_needs_split(md, bio);
+		need_split = is_abnormal || dm_zone_bio_needs_split(bio);
 	} else {
 		need_split = is_abnormal;
 	}


