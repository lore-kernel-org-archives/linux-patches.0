Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FE9321431;
	Mon, 18 Aug 2025 13:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524576; cv=none; b=KTGDLV2cgj+H+PqqzrJKBPyXyHOZVJIpowHj70h4Ha6EwqoHp7psXc1RU7Vt70C6CNUeuMePinkuQKOhm3dPM4yJOrG738ZXXMbmE8bJ5Ir+yA5nNTKBD/Hb7u/vRQXJ73G5rsGBMJSoF7chk9YvzIUtco2+JrTdaXUeqxcyHy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524576; c=relaxed/simple;
	bh=PVBBPbPfsviA2S9VxMYCSPDe1Z5/s9MHWQyrTyfLx7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKdZuN/b4s0GXhATAKRyjAKHWgoK3LeNl6gbq4Ix3VHaMh3AcVX2iQOlpUn5XgLoD9s7ZpQhF6HE2JTSzWfedrJqdi9ak5XQh2Uh/qIPc0DjDx4QvfrNquLyYRrTZxIs4VAY0+2XwwA90BbfOJOOh5T9A3HDJgm0/EhQocM2DKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nhs/+5HW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nhs/+5HW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DC0C113D0;
	Mon, 18 Aug 2025 13:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524576;
	bh=PVBBPbPfsviA2S9VxMYCSPDe1Z5/s9MHWQyrTyfLx7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nhs/+5HWYe4sJmP7sypYsIDanxeae4SSJoh1V18VkJApvfxm+jsqmebpobejKuRMz
	 h4zpEnGIVRD/Jilx91y1wkWMgAGy7ACQ5Yzj88AhYVVdH6aq2AJmW2Kh4gBAHe2Sj/
	 SY/l/XLN1wpAUFAy+O9CZT7cF8hL7FzHcCMzgR5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.15 515/515] dm: split write BIOs on zone boundaries when zone append is not emulated
Date: Mon, 18 Aug 2025 14:48:21 +0200
Message-ID: <20250818124518.263031939@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1790,8 +1790,7 @@ static void init_clone_info(struct clone
 }
 
 #ifdef CONFIG_BLK_DEV_ZONED
-static inline bool dm_zone_bio_needs_split(struct mapped_device *md,
-					   struct bio *bio)
+static inline bool dm_zone_bio_needs_split(struct bio *bio)
 {
 	/*
 	 * Special case the zone operations that cannot or should not be split.
@@ -1807,13 +1806,11 @@ static inline bool dm_zone_bio_needs_spl
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
 
@@ -1937,8 +1934,7 @@ static blk_status_t __send_zone_reset_al
 }
 
 #else
-static inline bool dm_zone_bio_needs_split(struct mapped_device *md,
-					   struct bio *bio)
+static inline bool dm_zone_bio_needs_split(struct bio *bio)
 {
 	return false;
 }
@@ -1965,7 +1961,7 @@ static void dm_split_and_process_bio(str
 
 	is_abnormal = is_abnormal_io(bio);
 	if (static_branch_unlikely(&zoned_enabled)) {
-		need_split = is_abnormal || dm_zone_bio_needs_split(md, bio);
+		need_split = is_abnormal || dm_zone_bio_needs_split(bio);
 	} else {
 		need_split = is_abnormal;
 	}


