Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216116;
	b=TQBYi1HOZ+7UfpUw8Xy0thTQ8d/ljU2zHhbxObLT3JJP36qrY44d3qUkNsisWqrIfFWM
	 Exg5VeV3S7SY1HGyckqOlBM4aazjOIpz+ztGhpCjZenBpdr7WoZxqSdY39Q8oWowubzJd
	 iuVYKpSH2HqyNXd6r3L1+tBx9KjrH0rm6HbWBsjMu5+9ZU4clN4XkJOcjLPuV1ftdXYLB
	 hvxUsK3Q9MX0ovMP/2/RgMGNDGLc7fQlntTim2mkCUbHHv4JbcqbC/b96mnqacPkezep0
	 pVbdJU55q47GrZpEHvw6YWztooD/UH8r+EUKM1AI1vM8GIy2ZpGtGTkg3HH6VIbw9ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tmnGKM3Hdpw1dJZIDCzsKMJ5qjoWGAAEQS0ywhJrZa4=;
	b=Lq0unidExyuj0VrKL1ONYCVfabzOaKqE9LPWcE7mBV8B0srFEhGtkWNlTVY4G2N0qabO
	 9oExLg00pLd6ooMpOCT6VvzmsqWyuKIZ3GIjUt5g13AGshD783EBA49RPf2yv++BspMQN
	 IAufoRjgmRhvNjz161FWC/urny0WGKuBYlGl4uFmWRpUyJsuYSR+KI8Cg0gsrfyroz2tz
	 pdqizi8rUdkE9tV8QK2LuVCky5ht6xoeKeol1rbL+T+ETeD5wxWWqq9CJkTSHDrq480/R
	 C19pW8r9Nhqla1faXG+O7bKKlPsgUj8rQnHSYFUM9Y78F7Y8XDvL+SKyOJTqgrc5LMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QS2pmq4L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F8F606A31C;
	Wed, 28 Oct 2026 19:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QS2pmq4L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535981F01825;
	Wed, 28 Oct 2026 19:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216115;
	bh=tmnGKM3Hdpw1dJZIDCzsKMJ5qjoWGAAEQS0ywhJrZa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QS2pmq4LhANc5V5jID/Sg4bQprVGWlkGMTOapp2Wa4C2hRa1zAubUkxu3OTlvgv9n
	 yvyvRFInKkKbYmAAAf8X9Txozgz33cTsH6eNGQEKWNMO10z90HZDV7ycnLYlxWX5mA
	 yrWOIoBWuBFuAAti3hb4zEsn236QgwoJVfH5WLJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1445/1887] btrfs: avoid NULL pointer dereference if no valid csum tree
Date: Wed, 28 Oct 2026 17:59:01 +0100
Message-ID: <20261028170532.339844094@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit f95d186255b319c48a365d47b69bd997fecb674e ]

[BUG]
When trying read-only scrub on a btrfs with rescue=idatacsums mount
option, it will crash with the following call trace:

  BUG: kernel NULL pointer dereference, address: 0000000000000208
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  CPU: 1 UID: 0 PID: 835 Comm: btrfs Tainted: G           O        6.15.0-rc3-custom+ #236 PREEMPT(full)
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2022
  RIP: 0010:btrfs_lookup_csums_bitmap+0x49/0x480 [btrfs]
  Call Trace:
   <TASK>
   scrub_find_fill_first_stripe+0x35b/0x3d0 [btrfs]
   scrub_simple_mirror+0x175/0x290 [btrfs]
   scrub_stripe+0x5f7/0x6f0 [btrfs]
   scrub_chunk+0x9a/0x150 [btrfs]
   scrub_enumerate_chunks+0x333/0x660 [btrfs]
   btrfs_scrub_dev+0x23e/0x600 [btrfs]
   btrfs_ioctl+0x1dcf/0x2f80 [btrfs]
   __x64_sys_ioctl+0x97/0xc0
   do_syscall_64+0x4f/0x120
   entry_SYSCALL_64_after_hwframe+0x76/0x7e

[CAUSE]
Mount option "rescue=idatacsums" will completely skip loading the csum
tree, so that any data read will not find any data csum thus we will
ignore data checksum verification.

Normally call sites utilizing csum tree will check the fs state flag
NO_DATA_CSUMS bit, but unfortunately scrub does not check that bit at all.

This results in scrub to call btrfs_search_slot() on a NULL pointer
and triggered above crash.

[FIX]
Check both extent and csum tree root before doing any tree search.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 98895adb99e33..d06b26e1dbea7 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3631,12 +3631,12 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	scrub_blocked_if_needed(fs_info);
 
 	root = btrfs_extent_root(fs_info, bg->start);
-	if (unlikely(!root)) {
-		btrfs_err(fs_info, "no valid extent root for scrub");
+	csum_root = btrfs_csum_root(fs_info, bg->start);
+	if (unlikely(!root || !csum_root)) {
+		btrfs_err(fs_info, "no valid extent or csum root for scrub");
 		btrfs_free_path(path);
 		return -EUCLEAN;
 	}
-	csum_root = btrfs_csum_root(fs_info, bg->start);
 
 	/*
 	 * collect all data csums for the stripe to avoid seeking during
-- 
2.53.0



