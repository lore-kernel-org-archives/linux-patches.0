Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705605;
	b=Mo6IJZISWBLIi/7TUBvL5vF/o3/Z49uaGnXlS8BFZrzeoMMZA3aymg8e0h6BjC1OSBaU
	 c4j1zzERaEDGpM5tAfMYhdYjEivhaOWcMjUZKC5mLr1z0otq5GBgn/ASt23l6WL5gVFvv
	 qATWbHhKVQz1GCT105B1o71l6PLUxQadIhAKb61U5W4wHxfqGI75lxhMinPrgckvHlWTa
	 n9OkU8wHk3fjQ2eM6/bb6tc5xrgMfHM/P9+plnsn8t5Z0+l51cUGU843RJBvi48Gv3WI+
	 Je9v2tSgIBQPg4zggFePWDgUosR15W9PhBaHllexbZCnUui8vgCnI6CMXkMe5uY64mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705605;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/RrQblm0bzrlK0aWen8bhJx0mOBMLfxywLtvSCyXY1c=;
	b=oNu6jqKZTkj0EXa0nk6lwQad7aDRLr003eN7Bvu4VzZlGELljABte6t+L+3jnIer6Q9Q
	 Lx6wW+zQcXZMVu2LLsNyaZAlSRxAWIdIM1oM+sF5DsDIIouTpmYaXf9DEuCnrQEy5Qge/
	 t8hZ6ZMdxxNhJmDwdyWTvtTeGr77Vq0gwINNmPoz80rq/3IBNm3S4dPphk8p0ALye5tFK
	 sVtTJ0WYfkLhO330QURvwBjg/9SPmok9Rj+HwljSG8CdMqjee4pHq/u3xApywwqtlIQmm
	 tcVp9gyuA4Ez4ZjCj44zQyHlGMBghMkXo0xb7N2rPKIawBwbjKHqrfZmvvCysm7xOxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q7BCR5jx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786B6606A31E;
	Thu, 26 Nov 2026 15:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q7BCR5jx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F82E1F000C0;
	Thu, 26 Nov 2026 15:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705604;
	bh=/RrQblm0bzrlK0aWen8bhJx0mOBMLfxywLtvSCyXY1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q7BCR5jxJUd5bebg1kPl4Dc6mV1sRUNk39vnhc7y4DG+tIHHHSmkpzgJUB1RilYz4
	 ElifYNqVKZktsAkhmEy9CpOvH8j35fNwLrcK0YVV/sfLM5q8a7u//joVWI9lliwlGE
	 B04nghQ8FwYq3jY3hA2/LzTULXioEF0ToFug2wrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sinan Polat <sinan86polat@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 253/319] dm-integrity: dont recalculate with HMAC because of a dirty bitmap
Date: Thu, 26 Nov 2026 15:40:21 +0100
Message-ID: <20261126144012.454958640@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sinan Polat <sinan86polat@gmail.com>

commit 875a7161fe1574205293c36f7bbd0815023e48a1 upstream.

Commit 5c02406428d5 ("dm integrity: conditionally disable "recalculate"
feature") refuses a superblock with SB_FLAG_RECALCULATING if a keyed
hash is used without "legacy_recalculate". Otherwise someone who can
write to the device, but does not know the key, could modify data and
have the kernel compute valid tags for it.

dm_integrity_resume() can still start the same recalculation in J or D
mode: if SB_FLAG_DIRTY_BITMAP is set and the bitmap is not clear, or
log2_blocks_per_bitmap_bit does not match, it sets
SB_FLAG_RECALCULATING and recalc_sector = 0. The superblock is not
authenticated unless fix_hmac and journal_mac are both used, so the
flag can be set offline. Resume also runs on the first activation.

Apply the constructor's policy there. If recalculation is not allowed,
log an error and keep the existing tags, so modified blocks fail
verification. This also avoids queueing recalc_work on a NULL
recalc_wq when internal_hash is not used.

Fixes: 5c02406428d5 ("dm integrity: conditionally disable "recalculate" feature")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Sinan Polat <sinan86polat@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3111,6 +3111,24 @@ static void dm_integrity_postsuspend(str
 	ic->journal_uptodate = true;
 }
 
+/*
+ * The superblock is authenticated only if fix_hmac and journal_mac are used,
+ * so SB_FLAG_DIRTY_BITMAP may have been set by someone who doesn't know the
+ * key. Apply the policy that the constructor applies to SB_FLAG_RECALCULATING.
+ */
+static bool dm_integrity_may_recalc_dirty_bitmap(struct dm_integrity_c *ic)
+{
+	if (!ic->internal_hash) {
+		DMERR("Dirty bitmap found, but internal_hash is not used");
+		return false;
+	}
+	if (dm_integrity_disable_recalculate(ic)) {
+		DMERR("Dirty bitmap found, but HMAC recalculation requires \"legacy_recalculate\"");
+		return false;
+	}
+	return true;
+}
+
 static void dm_integrity_resume(struct dm_target *ti)
 {
 	struct dm_integrity_c *ic = (struct dm_integrity_c *)ti->private;
@@ -3169,8 +3187,10 @@ static void dm_integrity_resume(struct d
 			if (!(ic->sb->log2_blocks_per_bitmap_bit == ic->log2_blocks_per_bitmap_bit &&
 			      block_bitmap_op(ic, ic->journal, 0, ic->provided_data_sectors, BITMAP_OP_TEST_ALL_CLEAR)) ||
 			    ic->reset_recalculate_flag) {
-				ic->sb->flags |= cpu_to_le32(SB_FLAG_RECALCULATING);
-				ic->sb->recalc_sector = cpu_to_le64(0);
+				if (dm_integrity_may_recalc_dirty_bitmap(ic)) {
+					ic->sb->flags |= cpu_to_le32(SB_FLAG_RECALCULATING);
+					ic->sb->recalc_sector = cpu_to_le64(0);
+				}
 			}
 			init_journal(ic, 0, ic->journal_sections, 0);
 			replay_journal(ic);


