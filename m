Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862892F260C;
	Thu, 28 May 2026 20:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998795; cv=none; b=d08wDmRZjx91GAMGCW36ELG52R8cyTREzQANFP+oHKSgAMagayQfH0LTZHQof/vlhDnrVvwT9DA2Bzvv97VUpVFM3sYc0AGTCklD+qzRT0jO16ScJVzrjkHY8B5c7E4xXmdto4tIKwFbRQP2G1oLq7ehwvUvwY57+6dVyrE1vl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998795; c=relaxed/simple;
	bh=OUX1t5JOzywNKfaWykLT4DyBMILsVIRDvMbTwjeoBFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HNidMObzFeifYmdMhj5vJBZ+pOiILil77jRViKaohqLlUVPURzhCEzmKZxDwKVpMcwyN3ygiRDr7H43v3r0jLRQiC8J4+BenA72KEDMbRZF9WdrrRhtvyiFc1PBAXIuu/q5VPh4wbpuxS1WrKB7Oh/A26T8ylz7gOw7S/k0YGjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1uZfzzFo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1uZfzzFo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52391F000E9;
	Thu, 28 May 2026 20:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998794;
	bh=JgZZ8KfI4wZSylR1/3tGfovwfti4qYDzeGwa4Z+DM9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1uZfzzFo/ssvK7s3WFH+sbHRl5wOnnTcaTryQK0GlvPJRU1Wmz+rIcoVrxYX7wrUV
	 E8raDeu0/Uo2aljEqtFEhw6FAPBYGB+KmBhlH/D8Oz1esal3t7qskC/KYthes3PJRP
	 Ks4vzu+fA+yigTZ24P+d4I0L25+VLnnrgw/UowgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 300/461] block: fix handling of dead zone write plugs
Date: Thu, 28 May 2026 21:47:09 +0200
Message-ID: <20260528194655.919114339@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 836efd35c472d89c838d7b17ef339ddb3286ffc5 ]

Shin'ichiro reported hard to reproduce unaligned write errors with zoned
block devices. Under normal operation conditions (e.g. running XFS on an
SMR disk), these errors are nearly impossible to trigger. But using a
"slow" kernel with many debug options enables and some specific use
cases (e.g. fio zbd test case 46), the errors can be reproduced fairly
easily.

The unaligned write errors come from mishandling a valid reference
counting pattern of zone write plugs. Such pattern triggers for instance
if a process A writes a zone (not necessarilly to the full state),
another process B immediately resets the zone and immediately following
the completion of the zone reset, starts issuing writes to the zone.
With such pattern, in some cases, the zone write plugs worker thread of
the device may still be holding a reference to the zone write plug of
the zone taken when process A was writing to the zone. The following
zone reset from process B marks the zone as dead but does not remove the
zone write plug from the device hash table as a reference to the plug
still exist. Once process B starts issuing new writes, the zone write
plug is seen as dead and the writes from process B are immediately
failed, despite this write pattern being perfectly legal.

Fix this by allowing restoring a dead zone write plug to a live state if
a write is issued to the zone when the zone is: marked as dead, empty
and the write sector corresponds to the first sector of the zone (that
is, the write is aligned to the zone write pointer). This is done with
the new helper function disk_check_zone_wplug_dead(), which restores a
dead zone write plug to a live state by clearing the BLK_ZONE_WPLUG_DEAD
flag and restoring the initial reference to the zone write plug taken
when the plug was added to the device hash table.

Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Fixes: b7d4ffb51037 ("block: fix zone write plug removal")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Link: https://patch.msgid.link/20260513111129.108809-1-dlemoal@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-zoned.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 9b697043871f8..af724ce650801 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -634,6 +634,28 @@ static void disk_mark_zone_wplug_dead(struct blk_zone_wplug *zwplug)
 	}
 }
 
+static inline bool disk_check_zone_wplug_dead(struct blk_zone_wplug *zwplug)
+{
+	if (!(zwplug->flags & BLK_ZONE_WPLUG_DEAD))
+		return false;
+
+	/*
+	 * If a new write is received right after a zone reset completes and
+	 * while the disk_zone_wplugs_worker() thread has not yet released the
+	 * reference on the zone write plug after processing the last write to
+	 * the zone, then the new write BIO will see the zone write plug marked
+	 * as dead. This case is however a false positive and a perfectly valid
+	 * pattern. In such case, restore the zone write plug to a live one.
+	 */
+	if (!zwplug->wp_offset && bio_list_empty(&zwplug->bio_list)) {
+		zwplug->flags &= ~BLK_ZONE_WPLUG_DEAD;
+		refcount_inc(&zwplug->ref);
+		return false;
+	}
+
+	return true;
+}
+
 static bool disk_zone_wplug_submit_bio(struct gendisk *disk,
 				       struct blk_zone_wplug *zwplug);
 
@@ -1459,12 +1481,12 @@ static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr_segs)
 	}
 
 	/*
-	 * If we got a zone write plug marked as dead, then the user is issuing
-	 * writes to a full zone, or without synchronizing with zone reset or
-	 * zone finish operations. In such case, fail the BIO to signal this
-	 * invalid usage.
+	 * Check if we got a zone write plug marked as dead. If yes, then the
+	 * user is likely issuing writes to a full zone, or without
+	 * synchronizing with zone reset or zone finish operations. In such
+	 * case, fail the BIO to signal this invalid usage.
 	 */
-	if (zwplug->flags & BLK_ZONE_WPLUG_DEAD) {
+	if (disk_check_zone_wplug_dead(zwplug)) {
 		spin_unlock_irqrestore(&zwplug->lock, flags);
 		disk_put_zone_wplug(zwplug);
 		bio_io_error(bio);
-- 
2.53.0



