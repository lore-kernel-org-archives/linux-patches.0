Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059DB2F744F;
	Tue,  6 Jan 2026 17:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721567; cv=none; b=Y9llFSNGPsWE4yG7r6Km5P4NOVAPTZKkatwSDnVWtcVrE4YRP5gxwYP96PDFt9E4T8mYtGJgyHlCEvo4FsH8D5G9862WhihnBYZMMMyS6FFlpyqPiFjWAcL9wkhjMgV9NpKuTaGHfMmP4rD1legdZvpfwHM/YTqgZ+WqWZXrTK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721567; c=relaxed/simple;
	bh=NJhgBHOYTMNyvWLOg7G7OMEno/2y1k8Sx1Jxk14tz+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AD9P9BDCOokZV9CXwGMWnEgzLCkd4Xx99iUbEbmzJWpsMyPTa2W5/Je6lvIaH01rRpYieK895Asm9N5ipxlwWCHxuwUdZW7mTgFHRmYEuElwcYF3SckG3/Di7Po0Eh9PjC7t9vGIiJMQ9/Ktvo9sUfCyKFNwgTzQ9ADIvf91ZqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fquyeQlM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fquyeQlM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42DB9C116C6;
	Tue,  6 Jan 2026 17:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721566;
	bh=NJhgBHOYTMNyvWLOg7G7OMEno/2y1k8Sx1Jxk14tz+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fquyeQlMUon+dhTGIfcH6eaQlGObvYgoLcdwdElV0afyfHY3Sqdj9kbwHa70/7tZ/
	 uzXPdAsxeaf1OyiTpLr2LdXFHcWEem5sTwTSH91NPozB6CJxQaGSa4btPSRXiwJpaT
	 qLtWq9AaVNpzy1B/kgcwHvGJryeGMYFavvubKtfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 567/567] block: fix NULL pointer dereference in blk_zone_reset_all_bio_endio()
Date: Tue,  6 Jan 2026 18:05:49 +0100
Message-ID: <20260106170512.411023459@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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
@@ -746,17 +746,20 @@ static void blk_zone_reset_all_bio_endio
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


