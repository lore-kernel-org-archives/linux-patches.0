Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147BC34CFAC;
	Tue,  6 Jan 2026 18:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722608; cv=none; b=bRD8FbsPwOWDVn4M4l49YmymBTEVIX+lcBfYEYfbtS09afkoiEsjL01RJHGaZ/GjvX86zBV8vmiKmLC9vXw44koIG1832z21sGTj3hm0RBf+QMzZqZnrMm53I8tr/b7sbScJhgOh9/81LLTyPdHXim2yS65naXOdJdhCJdwfXb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722608; c=relaxed/simple;
	bh=f1zNJ1uTeykQWPPq5lHbEZ218ccLuLyeqnYHk5Lxy94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBLyntD9ciQdeAFZJofigR+wJeODFJTIkzYlbQkxc9Pt6vXFYeKU9nQ4bhbJhbsLmfWw27u1hIe/MCZFX1hwT0bDsM0jCucsJ5Q1vGuDV7he0+i+Ji1MH/u8m0EskiqJz9SbOn6CKmTRmeraZMiRm5mmlnfa2BOc1D9s34V8Mt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mDbXzNok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mDbXzNok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C147C116C6;
	Tue,  6 Jan 2026 18:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722607;
	bh=f1zNJ1uTeykQWPPq5lHbEZ218ccLuLyeqnYHk5Lxy94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mDbXzNokTkULeLEwr3z5i7Yej9KiPesHiv7hXVtBg1tAu2DpV9k/5UYg8RZvRQtYb
	 wyHzpgei4FFrCzW56Sc5F0uKSSNqUoZfHYfV5IPuORh0M6ou1mUn15SjoWqnPRKCD+
	 MFhtaTRqZ5IN1z5HZemaFPB5QgcJ49/R3UnVP+rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 306/312] block: fix NULL pointer dereference in blk_zone_reset_all_bio_endio()
Date: Tue,  6 Jan 2026 18:06:20 +0100
Message-ID: <20260106170558.930834219@linuxfoundation.org>
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

commit c2b8d20628ca789640f64074a642f9440eefc623 upstream.

For zoned block devices that do not need zone write plugs (e.g. most
device mapper devices that support zones), the disk hash table of zone
write plugs is NULL. For such devices, blk_zone_reset_all_bio_endio()
should not attempt to scan this has table as that causes a NULL pointer
dereference.

Fix this by checking that the disk does have zone write plugs using the
atomic counter. This is equivalent to checking for a non-NULL hash table
but has the advantage to also speed up the execution of
blk_zone_reset_all_bio_endio() for devices that do use zone write plugs
but do not have any plug in the hash table (e.g. a disk with only full
zones).

Fixes: efae226c2ef1 ("block: handle zone management operations completions")
Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-zoned.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -736,17 +736,20 @@ static void blk_zone_reset_all_bio_endio
 	unsigned long flags;
 	unsigned int i;
 
-	/* Update the condition of all zone write plugs. */
-	rcu_read_lock();
-	for (i = 0; i < disk_zone_wplugs_hash_size(disk); i++) {
-		hlist_for_each_entry_rcu(zwplug, &disk->zone_wplugs_hash[i],
-					 node) {
-			spin_lock_irqsave(&zwplug->lock, flags);
-			disk_zone_wplug_set_wp_offset(disk, zwplug, 0);
-			spin_unlock_irqrestore(&zwplug->lock, flags);
+	if (atomic_read(&disk->nr_zone_wplugs)) {
+		/* Update the condition of all zone write plugs. */
+		rcu_read_lock();
+		for (i = 0; i < disk_zone_wplugs_hash_size(disk); i++) {
+			hlist_for_each_entry_rcu(zwplug,
+						 &disk->zone_wplugs_hash[i],
+						 node) {
+				spin_lock_irqsave(&zwplug->lock, flags);
+				disk_zone_wplug_set_wp_offset(disk, zwplug, 0);
+				spin_unlock_irqrestore(&zwplug->lock, flags);
+			}
 		}
+		rcu_read_unlock();
 	}
-	rcu_read_unlock();
 }
 
 static void blk_zone_finish_bio_endio(struct bio *bio)


