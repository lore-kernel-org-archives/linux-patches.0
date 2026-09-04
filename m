Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E574195A0;
	Fri,  4 Sep 2026 06:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502330; cv=none; b=hoYK7PkuuBqeR3d8XSGtKX5uN+qYLJjVWTB/RWxidpAYMVnK/alzlEaU9rWb/D0SvOcawHV81bkjqd4OVAphQzGcWqCkqVKOD4tOqToS+ZvDhHR2zTEGYP1eMfZBjtga9twqFeCpT3ekc0Bq6IqbGHKxdPP76FYyoRV+hFo0PYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502330; c=relaxed/simple;
	bh=VmNZ3CTlDmEF8PdZdnnaU3kyihHe3EsFpDNMXYDQXKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngZeQJBKo5ToZaNTbxXBkr4YtJ/EkfG9+YRq7zFTOZ7DTkPVnk+zxqhDDhy5QXFWlbZhN1bkBs1/ucGkn4KVxATKKlhAafz7pvB1jURzuYGrUXFeRV2DCgRndMm+raEivcwOZjE90yzTx+vrN7yHNfG28f+kRwui+7Wt4QincHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IfkqG9+Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IfkqG9+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722F61F00A3D;
	Fri,  4 Sep 2026 06:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502328;
	bh=LgppgLp1TwVAo7ZTg+W/uo80l1la3qRd7PL9wJfNUbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IfkqG9+Q2lgq0rIclKyRxicsGYMvyCEJWQTchKVOq8Syx7DyWM3V3wn0GI7Hjihqp
	 GrkHPvNiTluwV56Gjbkk5vQE1XEyzlYUibW2GnLC5q2Z6YSwbBAGbSOfODZZjZcXgi
	 FnCK1gTD7B4yMZ9WDJCoBIXS9ODTJSXmP+win+uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	liyouhong <liyouhong@kylinos.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 168/403] dm-era: fix shadowed superblock leak on take-snap failure
Date: Fri,  4 Sep 2026 06:59:31 +0200
Message-ID: <20260904045738.681480494@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: liyouhong <liyouhong@kylinos.cn>

commit 39c5aa3bd8ec3912d2cd0b3fe092642b0d2b0713 upstream.

metadata_take_snap() bumps the live superblock refcount and then
dm_tm_shadow_block() allocates a new block for the metadata snapshot.
If the subsequent dm_sm_inc_block() of writeset_tree_root or
era_array_root fails, the function only unlocks the clone and
returns.  The newly allocated shadow block is never returned to the
metadata space map, so each failed take-snap permanently leaks one
metadata block.

Free the clone with dm_sm_dec_block() on those error paths, matching
the final step of metadata_drop_snap().

Fixes: eec40579d848 ("dm: add era target")
Cc: stable@vger.kernel.org
Signed-off-by: liyouhong <liyouhong@kylinos.cn>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-era-target.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1034,6 +1034,7 @@ static int metadata_checkpoint(struct er
 static int metadata_take_snap(struct era_metadata *md)
 {
 	int r, inc;
+	dm_block_t location;
 	struct dm_block *clone;
 
 	if (md->metadata_snap != SUPERBLOCK_LOCATION) {
@@ -1071,7 +1072,9 @@ static int metadata_take_snap(struct era
 	r = dm_sm_inc_block(md->sm, md->writeset_tree_root);
 	if (r) {
 		DMERR("%s: couldn't inc writeset tree root", __func__);
+		location = dm_block_location(clone);
 		dm_tm_unlock(md->tm, clone);
+		dm_sm_dec_block(md->sm, location);
 		return r;
 	}
 
@@ -1079,7 +1082,9 @@ static int metadata_take_snap(struct era
 	if (r) {
 		DMERR("%s: couldn't inc era tree root", __func__);
 		dm_sm_dec_block(md->sm, md->writeset_tree_root);
+		location = dm_block_location(clone);
 		dm_tm_unlock(md->tm, clone);
+		dm_sm_dec_block(md->sm, location);
 		return r;
 	}
 


