Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97401155335;
	Mon, 16 Sep 2024 12:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488590; cv=none; b=h0Ei9RucYrVmhOmpPU6y+lVwOaQZAoVM5tyG2upRfFKc0VOP6x0xA+ROTypYtFpQle4/+12jm1/nfg71vSwBTF1Dz9Frq/6ekGHAGm1NVsM9EFgTHvj7i/yl+rgVRP0t3CMUkTG9FdES9qHrJUGUC/o/Cg9nojEtmJuHIGOfTmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488590; c=relaxed/simple;
	bh=pnu3Vpmj0uhMDx0UmZg6GpEtxWf1dUGFCqULjyKwlxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JNtmMM2yfU2k+QM8wkf7gx0xvIK5cr7gqp6HsGLUG7zPz6a8xe35TYt88P+pzesOsUCbjsq8YIubt8iff5GAstR4pdGY0lji7TNEpQsMX01BYa+TyMmYpksNa2rekP9kVpJSr6hBTwAHuHaKV288iX/LUqpOn3kF0IDAe9ear1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hpBwB5u9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hpBwB5u9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6F7C4CEC4;
	Mon, 16 Sep 2024 12:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488590;
	bh=pnu3Vpmj0uhMDx0UmZg6GpEtxWf1dUGFCqULjyKwlxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hpBwB5u9+MxE69OsFl0JxraaZXo59vxteCU/as6lQN2Z8sx7e2WiZ7zexQ522k3ov
	 n3Jyx8MJmot/wXBMCa7/DI43pMHi/z+byW57rrnLpTTnsxQhEA3/hzNPQw65ROFBEL
	 oKsuM1C68eijUl3rxoO1K2RWAGLCmjaI8FIKCVxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 44/91] dm-integrity: fix a race condition when accessing recalc_sector
Date: Mon, 16 Sep 2024 13:44:20 +0200
Message-ID: <20240916114225.957184600@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit f8e1ca92e35e9041cc0a1bc226ef07a853a22de4 upstream.

There's a race condition when accessing the variable
ic->sb->recalc_sector. The function integrity_recalc writes to this
variable when it makes some progress and the function
dm_integrity_map_continue may read this variable concurrently.

One problem is that on 32-bit architectures the 64-bit variable is not
read and written atomically - it may be possible to read garbage if read
races with write.

Another problem is that memory accesses to this variable are not guarded
with memory barriers.

This commit fixes the race - it moves reading ic->sb->recalc_sector to an
earlier place where we hold &ic->endio_wait.lock.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2183,6 +2183,7 @@ static void dm_integrity_map_continue(st
 	struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
 	unsigned int journal_section, journal_entry;
 	unsigned int journal_read_pos;
+	sector_t recalc_sector;
 	struct completion read_comp;
 	bool discard_retried = false;
 	bool need_sync_io = ic->internal_hash && dio->op == REQ_OP_READ;
@@ -2323,6 +2324,7 @@ offload_to_thread:
 			goto lock_retry;
 		}
 	}
+	recalc_sector = le64_to_cpu(ic->sb->recalc_sector);
 	spin_unlock_irq(&ic->endio_wait.lock);
 
 	if (unlikely(journal_read_pos != NOT_FOUND)) {
@@ -2377,7 +2379,7 @@ offload_to_thread:
 	if (need_sync_io) {
 		wait_for_completion_io(&read_comp);
 		if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING) &&
-		    dio->range.logical_sector + dio->range.n_sectors > le64_to_cpu(ic->sb->recalc_sector))
+		    dio->range.logical_sector + dio->range.n_sectors > recalc_sector)
 			goto skip_check;
 		if (ic->mode == 'B') {
 			if (!block_bitmap_op(ic, ic->recalc_bitmap, dio->range.logical_sector,


