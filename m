Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621895;
	b=cbs6AjJ8DIoxodkR10T9nZhTpZMhxHTPK+v/O0J3YriSbGQaiY10GHCcEf5ZZj3eTHaM
	 YJyVRb8Hj3e+7p+esUh1K0ixGSVJYpksh8RXxCNya7ui3urPx3XR23bD1efOP9Tn9vXVi
	 GicWEjMN4EjgJ65Esbo1Nateoyrk5BxE3PjPDAmPmUXOXjKHHkUrpqoLx6+tYhpnTYdHJ
	 VWLQa00inmIf5/R9Fy1Uz23Up3EF8czQbAsCfWZZ6ypmNsO1mxLdAegqZ5SeBn5jrZumm
	 ivS6cRHUMMOUAQ4cjHEMnw3vf0pPsKr1PFDSfHchobswX8X5T/k5/r9Fs7ihh1jADgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621895;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c+TtICV5MasfcYQye/1LSvJcLl7ZdOKtQWOYxRzt7aA=;
	b=yS35/5WQEKOSaNxtz8vMNhB80quviiSwhVvbmrQylBUH+6WYo+htS3JDU88u3Ho2T0Pe
	 jQ6jCKHR2R2Jysim6528e26mTEI8anjOx0hbmhpO5VUXzdbluYSDGwAi4/OvhCdEDMJd8
	 OJqGz7uOrGCtxhctV6EpjEjxhYufjrcZ/AtiXDk85j96lgqoRrbDJbeZONwCsF5Cy/E/o
	 H9f7M+qdd+M97pytV/3BJ5B2Gn/M7Aensy5nj2alo4n+ARFmcuNSBIHknFx5QcFy5/F5B
	 NrVANLwFHfj6gAj3u1RFOfCaoID2IrT6giH2cHOZdZ6ZNMalDkMD3Tvnf21X6+AOCAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rJLyovZ0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672E2606A321;
	Wed, 25 Nov 2026 15:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rJLyovZ0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4911F000C4;
	Wed, 25 Nov 2026 15:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621894;
	bh=c+TtICV5MasfcYQye/1LSvJcLl7ZdOKtQWOYxRzt7aA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rJLyovZ0mb0+1VWzh+sMzNA4s79b/QO5QaPh/l/Z/U7rPw9BMM5eH6ku1iK6nN9U4
	 TgoOMtnDVYYeTwWmcbWbADT+EbyVkBs3d7eBuizwgWpCepGOQ2yLuHZNmrGj6yAmj2
	 K/W5b3iMpBBjF6SzFrSm57uWhKAvxAxtM33zKltg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 368/990] btrfs: zoned: dont wait for ordered extents in do_zone_finish()
Date: Wed, 25 Nov 2026 15:28:55 +0100
Message-ID: <20261125143830.710635952@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f25cd3ddbd630..65c238d38e5d5 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2575,9 +2575,10 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 
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



