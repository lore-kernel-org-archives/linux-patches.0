Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE192D8DD4;
	Mon, 18 Aug 2025 14:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526221; cv=none; b=amLDXmMcB8f0crgRTLT1bsQMTp9hm3Uk92KhpgWV/9dKvQ4F4zQRPiQzOlocDCQGDIx0UqPD9Qxtxd7LgumLIRfIzwX0VC9mmkXSZe5miCKSGLeagxnOb1SeTtH59/B0F66122frCKtyU1YcRGzLT4a4cy+mTPiy6TF5F/xzicM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526221; c=relaxed/simple;
	bh=1D3/vmt28oBMUrvb07LWSxpWCbtamR89mtzbsQygHgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFfjIh2A4xLfJ3BlGlUgxsJYibk34HKPHmdLMy+EzrWc45jev7VcdFGfZxjNNNXn7yUWvpBuU5Qpmh90odV1EyFiBjENdfB2poP4yvOQDGw4UbmvQvGh1BvSMaJeER41ngtdloBwVSaWa/kTdM66wLTLGsc9MmQy1JgSlYqnxqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XFuZYnVu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XFuZYnVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6EECC4CEEB;
	Mon, 18 Aug 2025 14:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526220;
	bh=1D3/vmt28oBMUrvb07LWSxpWCbtamR89mtzbsQygHgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XFuZYnVuaWJMSTLhCLB3V/igIHyaVHFqH9gpvSoYersgpn+b6TUOK7jGuPtZdyCxP
	 PLwJ2dJmcEaStxXiir4fOZELH86ducxSnn4RXbkTqwEuRHinPCv19xWGHs41oG+1Vn
	 U0aDbAPJRKFPTzD3tWJNflAaA1r4khLPW+kfZcIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.16 493/570] dm: Always split write BIOs to zoned device limits
Date: Mon, 18 Aug 2025 14:48:00 +0200
Message-ID: <20250818124524.864360744@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 2df7168717b7d2d32bcf017c68be16e4aae9dd13 upstream.

Any zoned DM target that requires zone append emulation will use the
block layer zone write plugging. In such case, DM target drivers must
not split BIOs using dm_accept_partial_bio() as doing so can potentially
lead to deadlocks with queue freeze operations. Regular write operations
used to emulate zone append operations also cannot be split by the
target driver as that would result in an invalid writen sector value
return using the BIO sector.

In order for zoned DM target drivers to avoid such incorrect BIO
splitting, we must ensure that large BIOs are split before being passed
to the map() function of the target, thus guaranteeing that the
limits for the mapped device are not exceeded.

dm-crypt and dm-flakey are the only target drivers supporting zoned
devices and using dm_accept_partial_bio().

In the case of dm-crypt, this function is used to split BIOs to the
internal max_write_size limit (which will be suppressed in a different
patch). However, since crypt_alloc_buffer() uses a bioset allowing only
up to BIO_MAX_VECS (256) vectors in a BIO. The dm-crypt device
max_segments limit, which is not set and so default to BLK_MAX_SEGMENTS
(128), must thus be respected and write BIOs split accordingly.

In the case of dm-flakey, since zone append emulation is not required,
the block layer zone write plugging is not used and no splitting of BIOs
required.

Modify the function dm_zone_bio_needs_split() to use the block layer
helper function bio_needs_zone_write_plugging() to force a call to
bio_split_to_limits() in dm_split_and_process_bio(). This allows DM
target drivers to avoid using dm_accept_partial_bio() for write
operations on zoned DM devices.

Fixes: f211268ed1f9 ("dm: Use the block layer zone append emulation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20250625093327.548866-4-dlemoal@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |   29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1780,12 +1780,29 @@ static inline bool dm_zone_bio_needs_spl
 					   struct bio *bio)
 {
 	/*
-	 * For mapped device that need zone append emulation, we must
-	 * split any large BIO that straddles zone boundaries.
+	 * Special case the zone operations that cannot or should not be split.
 	 */
-	return dm_emulate_zone_append(md) && bio_straddles_zones(bio) &&
-		!bio_flagged(bio, BIO_ZONE_WRITE_PLUGGING);
+	switch (bio_op(bio)) {
+	case REQ_OP_ZONE_APPEND:
+	case REQ_OP_ZONE_FINISH:
+	case REQ_OP_ZONE_RESET:
+	case REQ_OP_ZONE_RESET_ALL:
+		return false;
+	default:
+		break;
+	}
+
+	/*
+	 * Mapped devices that require zone append emulation will use the block
+	 * layer zone write plugging. In such case, we must split any large BIO
+	 * to the mapped device limits to avoid potential deadlocks with queue
+	 * freeze operations.
+	 */
+	if (!dm_emulate_zone_append(md))
+		return false;
+	return bio_needs_zone_write_plugging(bio) || bio_straddles_zones(bio);
 }
+
 static inline bool dm_zone_plug_bio(struct mapped_device *md, struct bio *bio)
 {
 	if (!bio_needs_zone_write_plugging(bio))
@@ -1934,9 +1951,7 @@ static void dm_split_and_process_bio(str
 
 	is_abnormal = is_abnormal_io(bio);
 	if (static_branch_unlikely(&zoned_enabled)) {
-		/* Special case REQ_OP_ZONE_RESET_ALL as it cannot be split. */
-		need_split = (bio_op(bio) != REQ_OP_ZONE_RESET_ALL) &&
-			(is_abnormal || dm_zone_bio_needs_split(md, bio));
+		need_split = is_abnormal || dm_zone_bio_needs_split(md, bio);
 	} else {
 		need_split = is_abnormal;
 	}


