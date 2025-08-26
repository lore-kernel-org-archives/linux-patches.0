Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052DA20C001;
	Tue, 26 Aug 2025 11:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208249; cv=none; b=Js6rrUSK7F+RORbGOO4adjjB+1ZyuheSiGaVTd1BZe3hH1dPQfiuz6Z7nVo1xIjtGKwrls71TPgyiuQTIjhNMaHJHCwTYXYCtjo4vX65+ITZV6yvIicKNMArDbx01ayjmzIWzAFiHJ41ql8fCZUmap4yg5N34YFjvysN8RftxOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208249; c=relaxed/simple;
	bh=5NpZsi8kGd16utynqtWJwbO5H+PEoF+f8p49GAv95RE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCsK4ZMW2Y4JofCqLnIQlsMnSRbBpP92/SdSTZjALfA9kJDVGxRZyJt38K4uADaFFh1xCFY/ZNNJ7Lg9nC5my95poidkel0GIQIeDThyqZ/0A+KD5eNnD9g7aCVKELfHd/dIi9+85KvZqx5BEvBbxGom4mEqVld9zfoSxyaadLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jkqwJ7gE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jkqwJ7gE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0F5C4CEF1;
	Tue, 26 Aug 2025 11:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208248;
	bh=5NpZsi8kGd16utynqtWJwbO5H+PEoF+f8p49GAv95RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jkqwJ7gEC+BwkQWDNsKSc0W6qP0EQGKUi/RfQJVgrkcVY69L+K4dgvtIpo4z/fgR+
	 DOKgrXQE5jlHBX8XYrIxXk2qZPfwtUMJCiiPxg3EaVV/T35uwZVf0aMI0NRnkksTAK
	 FMFGzSG/jrVcXJ7GTM2SljXhu2kJe6f7IEKjZBlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 007/322] dm: Check for forbidden splitting of zone write operations
Date: Tue, 26 Aug 2025 13:07:02 +0200
Message-ID: <20250826110915.382151250@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: Damien Le Moal <dlemoal@kernel.org>

commit 409f9287dab3b53bffe8d28d883a529028aa6a42 upstream.

DM targets must not split zone append and write operations using
dm_accept_partial_bio() as doing so is forbidden for zone append BIOs,
breaks zone append emulation using regular write BIOs and potentially
creates deadlock situations with queue freeze operations.

Modify dm_accept_partial_bio() to add missing BUG_ON() checks for all
these cases, that is, check that the BIO is a write or write zeroes
operation. This change packs all the zone related checks together under
a static_branch_unlikely(&zoned_enabled) and done only if the target is
a zoned device.

Fixes: f211268ed1f9 ("dm: Use the block layer zone append emulation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Link: https://lore.kernel.org/r/20250625093327.548866-6-dlemoal@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1307,8 +1307,9 @@ out:
 /*
  * A target may call dm_accept_partial_bio only from the map routine.  It is
  * allowed for all bio types except REQ_PREFLUSH, REQ_OP_ZONE_* zone management
- * operations, REQ_OP_ZONE_APPEND (zone append writes) and any bio serviced by
- * __send_duplicate_bios().
+ * operations, zone append writes (native with REQ_OP_ZONE_APPEND or emulated
+ * with write BIOs flagged with BIO_EMULATES_ZONE_APPEND) and any bio serviced
+ * by __send_duplicate_bios().
  *
  * dm_accept_partial_bio informs the dm that the target only wants to process
  * additional n_sectors sectors of the bio and the rest of the data should be
@@ -1341,11 +1342,19 @@ void dm_accept_partial_bio(struct bio *b
 	unsigned int bio_sectors = bio_sectors(bio);
 
 	BUG_ON(dm_tio_flagged(tio, DM_TIO_IS_DUPLICATE_BIO));
-	BUG_ON(op_is_zone_mgmt(bio_op(bio)));
-	BUG_ON(bio_op(bio) == REQ_OP_ZONE_APPEND);
 	BUG_ON(bio_sectors > *tio->len_ptr);
 	BUG_ON(n_sectors > bio_sectors);
 
+	if (static_branch_unlikely(&zoned_enabled) &&
+	    unlikely(bdev_is_zoned(bio->bi_bdev))) {
+		enum req_op op = bio_op(bio);
+
+		BUG_ON(op_is_zone_mgmt(op));
+		BUG_ON(op == REQ_OP_WRITE);
+		BUG_ON(op == REQ_OP_WRITE_ZEROES);
+		BUG_ON(op == REQ_OP_ZONE_APPEND);
+	}
+
 	*tio->len_ptr -= bio_sectors - n_sectors;
 	bio->bi_iter.bi_size = n_sectors << SECTOR_SHIFT;
 


