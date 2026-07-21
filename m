Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E93439325;
	Tue, 21 Jul 2026 21:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670318; cv=none; b=U5CYfpm3aqedEn1IsM189mv8z/QUN7RMNzsRWZg54m6FZ+Hda7aHALWcsk3DtqBB6gk2B8jMfk5v30gaHaTA8/dCsJiuWebJEajNTVFflt8+oWn6SL9QMvBXd2nwC0OYCtYMLDMvyoVd+oYFSBRoxdh0LXkadegONc7bsItaxIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670318; c=relaxed/simple;
	bh=fvohykMggd4IpoqQ1s8z0LVm0PLQA4tJBax1zrPSr6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYlx+0jGfz+ducByM10JgoafjhxqyroDkg0SqZxVekqVz4sh1VoncEr+yyuzNWy44G1vUg+83YSTuxdAXjpRn5cWbDeM+PTrmcnHY6+qH4zZJPIIKCKe5u/XL4q9P0Lgr6+3uTX1SZeuQTuq7gvb8rvqiA0ucpLM8SSvQlghvW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VOlzki1v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VOlzki1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A906C1F000E9;
	Tue, 21 Jul 2026 21:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670317;
	bh=9/xcm27afnpOO7zEBI6ywojnjkE56ALuZ3CmYqJbeZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VOlzki1vEPaNsdwM8yX7A8JOLA3av45ZkBjT2sD1eGMG2x1G5bAkZ0XZgbAdQo/ym
	 VdrNR1ifj17NHsklPuP2gUIcP9ozpAOUqLxS7dmcPvyaLTTiVmjwuvF9NrkEJ6lH5c
	 FFga1m2ymhaUtoEpt0Bf0S56Z9GrCco3nuN91CwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 0844/1067] dm era: fix out-of-bounds memory access for non-zero start sector
Date: Tue, 21 Jul 2026 17:24:05 +0200
Message-ID: <20260721152443.429777218@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1214,6 +1214,7 @@ static dm_block_t get_block(struct era *
 static void remap_to_origin(struct era *era, struct bio *bio)
 {
 	bio_set_dev(bio, era->origin_dev->bdev);
+	bio->bi_iter.bi_sector = dm_target_offset(era->ti, bio->bi_iter.bi_sector);
 }
 
 /*----------------------------------------------------------------
@@ -1538,7 +1539,7 @@ static void era_dtr(struct dm_target *ti
 static int era_map(struct dm_target *ti, struct bio *bio)
 {
 	struct era *era = ti->private;
-	dm_block_t block = get_block(era, bio);
+	dm_block_t block;
 
 	/*
 	 * All bios get remapped to the origin device.  We do this now, but
@@ -1546,6 +1547,7 @@ static int era_map(struct dm_target *ti,
 	 * block is marked in this era.
 	 */
 	remap_to_origin(era, bio);
+	block = get_block(era, bio);
 
 	/*
 	 * REQ_PREFLUSH bios carry no data, so we're not interested in them.


