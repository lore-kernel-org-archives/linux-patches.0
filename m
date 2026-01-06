Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB473644AD;
	Tue,  6 Jan 2026 17:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721998; cv=none; b=NCSLnMgRmVE2lxn7haFUZqFki7jNCBJSi2HVGkFbmX720bntGO9w1kgEmBlp+tL4hFTve4wSPbFtSOIuzQxVpEMFAnzwPPNC9Ou2hRCT5iEMuxwjZfIjETPQemAmdIu1WHeEoxqHa6g/k/YZFGBKqWRzHaQXFl3vhpv/O75zvHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721998; c=relaxed/simple;
	bh=XVzXjp6MIcmlH0MLNfWRPm7PvYwcQQHL2607KVqqACg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aerPk+EKqzGgap2GDSfTX8QEOxB4pQ5PVXJQ5Nxu1Ude5Uolppc5FdkJ9IykZjEbUwmlscNuqfPD6AT2hXPo3mtsc3hnHHWnxI+5AQ7MnCWUy0q6VnEgX4asIFZJL7ptr4RTINXLfW8PQDdmNoeN2+ibeatobTa0pQtrvhDN5Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ey3BOpSL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ey3BOpSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE82C16AAE;
	Tue,  6 Jan 2026 17:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721998;
	bh=XVzXjp6MIcmlH0MLNfWRPm7PvYwcQQHL2607KVqqACg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ey3BOpSL5NhK95vDFcaJDPI6sC5uTwhYg4p4AK+JvK/TER91Lq9WscGxY4W+0hoFC
	 rx8BP7N8d3CydWqAW2i6EzVcdCUesT/AKtQg4mjzHGpJsaw9zdyJ18ryxrOEzStWjL
	 rBe1q2W4NtdkUF7kVQwnszBPwhRoAo/S9MNJIl3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 135/312] block: Clear BLK_ZONE_WPLUG_PLUGGED when aborting plugged BIOs
Date: Tue,  6 Jan 2026 18:03:29 +0100
Message-ID: <20260106170552.726236025@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 552c1149af7ac0cffab6fccd13feeaf816dd1f53 upstream.

Commit fe0418eb9bd6 ("block: Prevent potential deadlocks in zone write
plug error recovery") added a WARN check in disk_put_zone_wplug() to
verify that when the last reference to a zone write plug is dropped,
this zone write plug does not have the BLK_ZONE_WPLUG_PLUGGED flag set,
that is, that it is not plugged.

However, the function disk_zone_wplug_abort(), which is called for zone
reset and zone finish operations, does not clear this flag after
emptying a zone write plug BIO list. This can result in the
disk_put_zone_wplug() warning to trigger if the user (erroneously as
that is bad pratcice) issues zone reset or zone finish operations while
the target zone still has plugged BIOs.

Modify disk_put_zone_wplug() to clear the BLK_ZONE_WPLUG_PLUGGED flag.
And while at it, also add a lockdep annotation to ensure that this
function is called with the zone write plug spinlock held.

Fixes: fe0418eb9bd6 ("block: Prevent potential deadlocks in zone write plug error recovery")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-zoned.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -616,6 +616,8 @@ static void disk_zone_wplug_abort(struct
 {
 	struct bio *bio;
 
+	lockdep_assert_held(&zwplug->lock);
+
 	if (bio_list_empty(&zwplug->bio_list))
 		return;
 
@@ -623,6 +625,8 @@ static void disk_zone_wplug_abort(struct
 			    zwplug->disk->disk_name, zwplug->zone_no);
 	while ((bio = bio_list_pop(&zwplug->bio_list)))
 		blk_zone_wplug_bio_io_error(zwplug, bio);
+
+	zwplug->flags &= ~BLK_ZONE_WPLUG_PLUGGED;
 }
 
 /*


