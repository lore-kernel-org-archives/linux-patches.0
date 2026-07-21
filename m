Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622DB46C4D3;
	Tue, 21 Jul 2026 17:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654853; cv=none; b=Kc0Iu9g3Edy7NO869M9t1JAc8P1AbZqHVvWzFMcANb5b+18r87qzUYS5ByftU/aNAdpZAOJoSfZEpqW4OdLdmvODGF7mpv6fMG6Nl9Zmu5Hmm+1GWqaSPvocak3ffHykPyMT9Gspyvpbp4jFXCAuDR3sG4MkU0jbbtMUv9mx1pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654853; c=relaxed/simple;
	bh=Y82ob7GmUQxRTxSLeO3kKXusWldaZ2ObnR5RB8Ksc60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZxY6WYrXKEALeUQoLthRWVKOKuaiL3rC54NKaj6tLMIxh4gpXorJXZY/EmJdKpHIEgqrSgPXD/S+diiCeiimkAeJI3Op7G0drVvzR4xY8zPESFNXwRjIG2Kgn3bLp2odOMiTqFMeEYU93xJShgJP//ji4mmSy+9mz9gVlZVU5fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qI+YXp9I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qI+YXp9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 919ED1F00A3A;
	Tue, 21 Jul 2026 17:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654852;
	bh=hyJMD6GVX5q32wSwf6LZI4Wo82d4d6cD4ghyQ/KhFho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qI+YXp9I7wquyqM4QdhnYmM9E6lScJ/aQiq55D8OPOlu2zv4M6Bfi+ytPO/xlv+ES
	 mPlPgpnP+UTpIZ0cIE/QetYr17jRTFaJbdhAy1a0abWXK04j7RLeH7ZeT3kYg5JBnV
	 QxXY2cezcty+UuPMVUK3/XUdg8Gyq1bAgcjFVeio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.1 1845/2077] dm era: fix out-of-bounds memory access for non-zero start sector
Date: Tue, 21 Jul 2026 17:25:18 +0200
Message-ID: <20260721152636.255449658@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1231,6 +1231,7 @@ static dm_block_t get_block(struct era *
 static void remap_to_origin(struct era *era, struct bio *bio)
 {
 	bio_set_dev(bio, era->origin_dev->bdev);
+	bio->bi_iter.bi_sector = dm_target_offset(era->ti, bio->bi_iter.bi_sector);
 }
 
 /*
@@ -1562,7 +1563,7 @@ static void era_dtr(struct dm_target *ti
 static int era_map(struct dm_target *ti, struct bio *bio)
 {
 	struct era *era = ti->private;
-	dm_block_t block = get_block(era, bio);
+	dm_block_t block;
 
 	/*
 	 * All bios get remapped to the origin device.  We do this now, but
@@ -1570,6 +1571,7 @@ static int era_map(struct dm_target *ti,
 	 * block is marked in this era.
 	 */
 	remap_to_origin(era, bio);
+	block = get_block(era, bio);
 
 	/*
 	 * REQ_PREFLUSH bios carry no data, so we're not interested in them.


