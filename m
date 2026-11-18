Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044381;
	b=4qjEcGQe0uRPZngR+ze04oIBey7B0ouPq7WEnAiYHUmufbh/YCoKBrr9ZfOkBv7EmHnM
	 HJ+ChuaWB6ukwA+pY70WIy/leaXkxLRQbx7zKm/IhTunRw3CD23cmE+Sv3PhgLA41CGh/
	 l0KtdzT4szguHNzcaQLsrVXqswvT17BBGRX3Xcc6zhgjIO51XrTU1utVdpYBlhTQjPZ6t
	 iNU0I9hqPqJzpY5hQ90Am7egtc5aukSaUGWbBmyLaPkq7+x4CGyx7Top74IZ6G0eeXZCQ
	 gc3GfeGVZHbTaLYdjHS69C+Yex1pB/3c/2vh12ttYTY1OvtirQAcGfcPEa6dt3QaISQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044381;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U6fJUzz1nE7q73pDNa2HHFhQmrjaujrUOjY7JGVJHn8=;
	b=tJqlVUt9I6/9mTvbpW2zAxWwqOZcGSUZl41bKVtFogdGkIeRjfiPEeNxZtJDLkkTAGo6
	 zeEyOCnb1XV/tel5og2xOjfRb6E4X0nfcYlhVoOKXUkBnvkGmwI0XRFaBGGcjHdwy4gHw
	 fDbe49OCIo4cjmwrzEPwEBnHoikaEsmLhmrNsh50gTZXS4o6OCmtoVkoxT7aKm/NdmycT
	 Mdi+hB+fmeWX/2HWljqzPW5HrQo+fYEPNHOlfFTsQEdbED4ECHYeyluvK6FySvinn32lv
	 K8yutQQdlFdJb0aOaxnT1QvviX3Xy4DY6NBYhEl4ttlehOgTuE6L/x5HsIr72kgRImA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jkNcBl1R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A88606A32A;
	Wed, 18 Nov 2026 23:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jkNcBl1R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9938E1F000C4;
	Wed, 18 Nov 2026 23:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044381;
	bh=U6fJUzz1nE7q73pDNa2HHFhQmrjaujrUOjY7JGVJHn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jkNcBl1RFdEZpa4SuDZg6W8h4aSHtplMVT8v4843K7ZMG64yjzKK4UxATM+NCTeep
	 qFRAFLAsqelClPfQgT5J6q0JP8n7AjBXwyfGskXkBVSCJux1sS0/wBPUGb9mu470Ki
	 0l3k6ouJsu718KBxhlxYNg7VWezeV7Vp08aRShr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Bereknyei <tomberek@gmail.com>,
	Elliot Berman <elliotjb@elliotjb.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0520/2857] ext4: fix NULL folio dereference in mballoc
Date: Wed, 18 Nov 2026 15:25:54 +0100
Message-ID: <20261118150220.193749213@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Elliot Berman <elliotjb@elliotjb.com>

In 6.1, __filemap_get_folio() returns NULL on failure. The backported
folio conversion of mballoc keeps the original IS_ERR() checks, so they
are always false here. The fast-path lookup in ext4_mb_load_buddy_gfp()
has no FGP_CREAT and returns NULL whenever the bitmap or buddy page of
an initialised group has been evicted from the page cache, e.g. by
drop_caches or memory pressure. The next block allocation from that
group then oopses under ext4_mb_regular_allocator().

$ echo 3 > /proc/sys/vm/drop_caches, in 0.51 seconds)
$ dd if=/dev/zero of=/mnt/b0 bs=1M count=4 conv=fsync
BUG: kernel NULL pointer dereference, address: 0000000000000000
PGD 5f19067 P4D 0
Oops: 0000 [#1] PREEMPT SMP NOPTI
CPU: 0 PID: 908 Comm: dd Not tainted 6.1.191 #1-NixOS
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
RIP: 0010:ext4_mb_load_buddy_gfp (fs/ext4/mballoc.c:1536 (discriminator 1)) ext4
Call Trace:
 <TASK>
ext4_mb_regular_allocator (fs/ext4/mballoc.c:1641 fs/ext4/mballoc.c:2798) ext4
ext4_mb_new_blocks (fs/ext4/mballoc.c:5793) ext4
 ? ext4_find_extent (fs/ext4/extents.c:925) ext4
ext4_ext_map_blocks (fs/ext4/extents.c:4369) ext4
   ...

Check for NULL instead and return -ENOMEM, as failures did before the
conversion.

Fixes: d34e4fd4e73f ("ext4: convert bd_bitmap_page to bd_bitmap_folio")
Fixes: 862483175d3d ("ext4: convert bd_buddy_page to bd_buddy_folio")
Reported-by: Tom Bereknyei <tomberek@gmail.com>
Signed-off-by: Elliot Berman <elliotjb@elliotjb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e77d56c533c0b..d0b276ce9401c 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1375,8 +1375,8 @@ static int ext4_mb_get_buddy_page_lock(struct super_block *sb,
 	poff = block % blocks_per_page;
 	folio = __filemap_get_folio(inode->i_mapping, pnum,
 			FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
-	if (IS_ERR(folio))
-		return PTR_ERR(folio);
+	if (!folio)
+		return -ENOMEM;
 	BUG_ON(folio->mapping != inode->i_mapping);
 	e4b->bd_bitmap_folio = folio;
 	e4b->bd_bitmap = folio_address(folio) + (poff * sb->s_blocksize);
@@ -1389,8 +1389,8 @@ static int ext4_mb_get_buddy_page_lock(struct super_block *sb,
 	/* blocks_per_page == 1, hence we need another page for the buddy */
 	folio = __filemap_get_folio(inode->i_mapping, block + 1,
 			FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
-	if (IS_ERR(folio))
-		return PTR_ERR(folio);
+	if (!folio)
+		return -ENOMEM;
 	BUG_ON(folio->mapping != inode->i_mapping);
 	e4b->bd_buddy_folio = folio;
 	return 0;
@@ -1533,7 +1533,7 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 
 	/* Avoid locking the folio in the fast path ... */
 	folio = __filemap_get_folio(inode->i_mapping, pnum, FGP_ACCESSED, 0);
-	if (IS_ERR(folio) || !folio_test_uptodate(folio) || folio_test_locked(folio)) {
+	if (!folio || !folio_test_uptodate(folio) || folio_test_locked(folio)) {
 		/*
 		 * folio_test_locked is employed to detect ongoing folio
 		 * migrations, since concurrent migrations can lead to
@@ -1543,11 +1543,11 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 		 * try to get the folio with lock in both cases to avoid
 		 * concurrency.
 		 */
-		if (!IS_ERR(folio))
+		if (folio)
 			folio_put(folio);
 		folio = __filemap_get_folio(inode->i_mapping, pnum,
 				FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
-		if (!IS_ERR(folio)) {
+		if (folio) {
 			if (WARN_RATELIMIT(folio->mapping != inode->i_mapping,
 	"ext4: bitmap's mapping != inode->i_mapping\n")) {
 				/* should never happen */
@@ -1567,8 +1567,8 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 			folio_unlock(folio);
 		}
 	}
-	if (IS_ERR(folio)) {
-		ret = PTR_ERR(folio);
+	if (!folio) {
+		ret = -ENOMEM;
 		goto err;
 	}
 	if (!folio_test_uptodate(folio)) {
@@ -1585,12 +1585,12 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 	poff = block % blocks_per_page;
 
 	folio = __filemap_get_folio(inode->i_mapping, pnum, FGP_ACCESSED, 0);
-	if (IS_ERR(folio) || !folio_test_uptodate(folio) || folio_test_locked(folio)) {
-		if (!IS_ERR(folio))
+	if (!folio || !folio_test_uptodate(folio) || folio_test_locked(folio)) {
+		if (folio)
 			folio_put(folio);
 		folio = __filemap_get_folio(inode->i_mapping, pnum,
 				FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
-		if (!IS_ERR(folio)) {
+		if (folio) {
 			if (WARN_RATELIMIT(folio->mapping != inode->i_mapping,
 	"ext4: buddy bitmap's mapping != inode->i_mapping\n")) {
 				/* should never happen */
@@ -1609,8 +1609,8 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 			folio_unlock(folio);
 		}
 	}
-	if (IS_ERR(folio)) {
-		ret = PTR_ERR(folio);
+	if (!folio) {
+		ret = -ENOMEM;
 		goto err;
 	}
 	if (!folio_test_uptodate(folio)) {
-- 
2.53.0



