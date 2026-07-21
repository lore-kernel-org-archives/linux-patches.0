Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7568444AB9F;
	Tue, 21 Jul 2026 22:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674348; cv=none; b=uuJddpZ0vg+ZObOpOK4iPzHyJYkRcbQRetPGWzgrTCJ/MR1GR4odEoSeIkz8wDc1bZM52XPldznwFl+5IFqYY3zzf10HmV4xs3GJPfIOKkFg8otL6Ih0M5FZXbvih+RSajSomNEWgwpg8yKBIkeXiJ/V6F2DgZ30weItYTYlUFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674348; c=relaxed/simple;
	bh=e2fSotzT/I+vDGOo5HEDryBzFYAFSF8Cjr8iZkzXeKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hs0mMF7IfqLxhWclcQU+VYAb/p/m48ztSJw8HyCdwOYd8fVEDCEg6wjYGH7QIfY9835sWp+vpjgUZ/sL63PCgCv8ISOMpAC7go20kNk+npMq7E6Ap/fDHMXnW0dV41i6LRzhqMgJejjpkVlvL8zTxJPJITO+6TRWHHCdQJYiblY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EAquNsft; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EAquNsft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDA21F000E9;
	Tue, 21 Jul 2026 22:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674347;
	bh=rMmmYNU/j6S3MqK37gQvApEFED3wk0LBrM1jw0ZfydI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EAquNsftTBBzbDR/iR3xsHdyaOeRuU0LdrPVblhWOM/Hk9vUe5Zk44uNNiRXPdlub
	 97kmZ8cIBXN48r8xDO6IrsZ81HpdOacGMgmaqt7x+LLe91ZOfx0sljeuhBcBNFyPy4
	 48sD6wbFOzMBNXsCKVpJabRnD9bh8TGviwZ7Zp/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 508/699] dm era: fix out-of-bounds memory access for non-zero start sector
Date: Tue, 21 Jul 2026 17:24:27 +0200
Message-ID: <20260721152407.154116783@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Moelius <sam.moelius@trailofbits.com>

commit a868196f03c2b19418ae3d2b69e195d668a271e5 upstream.

dm-era tracks writes in target-relative blocks, but era_map() calculates
the writeset block before applying the target offset.  Tables with a
non-zero start sector can therefore pass an absolute mapped-device block
to metadata_current_marked().

If the absolute block is beyond the current writeset size,
writeset_marked() tests past the end of the in-core bitset.  KASAN reports
this as a vmalloc-out-of-bounds access.

Apply the target offset before calculating the era block so writeset
lookups use the target-relative block number.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
Reviewed-by: Ming-Hung Tsai <mtsai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Fixes: eec40579d848 ("dm: add era target")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-era-target.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1210,6 +1210,7 @@ static dm_block_t get_block(struct era *
 static void remap_to_origin(struct era *era, struct bio *bio)
 {
 	bio_set_dev(bio, era->origin_dev->bdev);
+	bio->bi_iter.bi_sector = dm_target_offset(era->ti, bio->bi_iter.bi_sector);
 }
 
 /*----------------------------------------------------------------
@@ -1534,7 +1535,7 @@ static void era_dtr(struct dm_target *ti
 static int era_map(struct dm_target *ti, struct bio *bio)
 {
 	struct era *era = ti->private;
-	dm_block_t block = get_block(era, bio);
+	dm_block_t block;
 
 	/*
 	 * All bios get remapped to the origin device.  We do this now, but
@@ -1542,6 +1543,7 @@ static int era_map(struct dm_target *ti,
 	 * block is marked in this era.
 	 */
 	remap_to_origin(era, bio);
+	block = get_block(era, bio);
 
 	/*
 	 * REQ_PREFLUSH bios carry no data, so we're not interested in them.


