Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624743;
	b=240XmjIZHu533g1a1IUicvgATCCjkPJzCnfpArJ8huYRQj8+mXAHkBDm5MtDDnfn/g7Z
	 Uac821ABH1sQmDvCcYq68+4BvLjFr+lKvMXF3hd5wWupu7btvm/3sle68GGGFTaIAiHJe
	 kOjJUN1K2oMt3+yxObrlOTtmoK9PONO2O1mR4O4AKnWDEH6c/mzvkEqcsAKtJljiTab3J
	 7dKpyiKdlPLXw43IjByvSgYvc4NPN6X454TxNMxNgKTrOriJCZ0kNjUr6AoRjE+oTE6T2
	 YA3dcHKxHV1M3q8UsxW0aq1CvMBZRRedMUTGv4zbo/Qj18kxFA4Fxeb/uRMcxhX2uNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624743;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=946lSkNpwP8ZcGs8DAsOOOpMyoWr2+7IoBX6nfKzNCI=;
	b=tF+QOrcrgliCiasD+IjsoStZ57txXbAiIVvYBzls/95gdGPS0adSU8stVdb34vs08ogI
	 wMB2fhT/8pEv3DrpIkdfNo7tZdlECMBpnkp+KwdgEuSe1u5RruffU7ItVOtKd+8NEz3uW
	 BqKnXSc/423fzUgTazYrCZ3oywK7wWs0Y3kxDE1i4qrwzJIeR0p6YDvs5YmeF2PwaikJS
	 9AMoLudnvH1BnH16JGe7O1EtjI2X+X52jv7gRXg9XfsDgH3XU0PlXAzR/HO3XfpkrJRfc
	 qjLWJNEELF070uw0WoODZptavpjoCLMbg3VvwIczUU3ieTivB4DeWeQEtOg6YxPFluA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e3MgNhtn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC986606A33B;
	Wed, 25 Nov 2026 16:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e3MgNhtn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7F21F000C0;
	Wed, 25 Nov 2026 16:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624743;
	bh=946lSkNpwP8ZcGs8DAsOOOpMyoWr2+7IoBX6nfKzNCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e3MgNhtnB97ZIp0PvkOtUY9zrW4zLaENYY5J+zImwaz/iBLsnrnroVkjSPhk0uYc7
	 YLHgDY5LyD+sSj1AF5jggBq56KI/RcqRbRa3rZpZKTf/a0tdK8glCfl/QEmKW94fby
	 o1L8AusK+Fs17TV/AKEe1JloZj8WKpOcOUIZvZxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 293/816] btrfs: zoned: dont wait for ordered extents in do_zone_finish()
Date: Wed, 25 Nov 2026 15:30:41 +0100
Message-ID: <20261125143855.988073012@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit bcad7df05237382237ad1517411721d839174009 ]

do_zone_finish() calls btrfs_wait_ordered_roots(), which holds
fs_info->ordered_operations_mutex while waiting for writeback. It can be
reached from writeback itself:

  cow_file_range()
  `-> btrfs_reserve_extent()
    `-> find_free_extent()
      `-> btrfs_zone_finish_one_bg()
        `-> do_zone_finish()

If another task holds the mutex and waits for that writeback, this
deadlocks.

In general, we want to ensure all writes in the block group to
complete before finishing the zone, as relocation does. However, the
current callers do not need the wait (or cannot wait) in do_zone_finish():

- Relocation already waits for reservations and ordered extents itself
  before calling btrfs_zone_finish().
- btrfs_delete_unused_bgs() checks that ->reserved is zero and sets the
  block group read-only while holding groups_sem, so there can be no
  in-flight data write.
- btrfs_zone_finish_one_bg() is called from the allocation path and
  cannot wait.

Dropping the wait is still safe. Once the block group is read-only,
->reserved can only drop, and for data it only drops after the ordered
extent's I/O has completed. So if ->reserved is zero, no data write is
left in flight. If it is non-zero, do_zone_finish() returns -EAGAIN,
which all callers handle.

This makes btrfs_zone_finish_one_bg() fail with -EAGAIN when it races
with an allocation in the selected block group.

Fixes: 393f646e34c1 ("btrfs: zoned: finish least available block group on data bg allocation")
Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index e0917a37e4cc6..ead999f072816 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2535,9 +2535,10 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 
 		/* Ensure all writes in this block group finish */
 		btrfs_wait_block_group_reservations(block_group);
-		/* No need to wait for NOCOW writers. Zoned mode does not allow that */
-		btrfs_wait_ordered_roots(fs_info, U64_MAX, block_group);
-		/* Wait for extent buffers to be written. */
+		/*
+		 * No need to wait for NOCOW writers, as zoned mode does not
+		 * allow that, only wait for extent buffers to be written.
+		 */
 		if (is_metadata)
 			wait_eb_writebacks(block_group);
 
-- 
2.53.0



