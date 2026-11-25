Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623487;
	b=XSV8catYu7Na5JNglUrAsaaFVossfN1sPCzV/GJETUeOtaP4zqPSCp7Jjfa7IlmH8hRj
	 VRu2DRXeT/PSDmATlLPVIVdbUXFh4PnjLLzYzl0SXycecim/NjNrIQl9VTPmLkszYyIEg
	 ER8EgLr4wDwVkMEzWwoKVBVdEHYUXP3ujLPDQBSoZuqtz/DWtQ/iDf2cmtoZ3QXjW90SX
	 cj4+NfKXLfLWPK2rF0xnhve186rYMGLqboXKo5NDicl85V8vsJydl65Gwzj3DNE9aqGH6
	 3NbAlsvRdOW6b5awKpuU7qtrFmZGkpiYWN5nLzZS+Lw6NIhxswOLBh5icMII4u64UMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623487;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=20SAxmvllL5tr4arpABGhYizfMzgEo+9TODrR0kXV1Q=;
	b=wiMfCPWierBxQcWOOd6hTJYa5iGubnTzUEmi1NeJTzhjp2DgKefnsuvWDvfiIpvLSi3y
	 4cIUhaEyuLfqzqYwX3uWMSmOugrva3B90fiHeJfG1694u+7y0KKMxoGfbzgq5PgKmu8w5
	 NnIT1rVSQTBE9GqEza+1JBjYqo89dcBvGbmdlYpVmqv1VCYO8fHPEGdVOblLj+V0ev6i9
	 mbCzN4PTlqH0KVbNcDFUNizN9jEjdTPiYp6/Y3aHj6cWeM7BHNJrrRcDLGWOlIlZfarma
	 xCOOurJJJMqI1E4LOTZOWA9VUGTAHo/6SayJPHifsWsoBhLHY5KWKe/799X6dGAhCpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mt9Hl1Lo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74996606A31E;
	Wed, 25 Nov 2026 16:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mt9Hl1Lo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C49A01F000C6;
	Wed, 25 Nov 2026 16:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623487;
	bh=20SAxmvllL5tr4arpABGhYizfMzgEo+9TODrR0kXV1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mt9Hl1LoZOET1Iy3ESwIngcvrzo7lvR83ptTTosRN8oUZogBaULaEBrECQqYUrCnL
	 hhMDj+vedUEW1d2ht0hPldss3ubyxtxSTxYckLV0n4/vgNNrJu/ndlXsI0LwQ3NBAU
	 qMzKhJ1Y77XrO9TnwCHtQpH3/96BrZ+fiWENKNP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sinan Polat <sinan86polat@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 874/990] dm-integrity: dont recalculate with HMAC because of a dirty bitmap
Date: Wed, 25 Nov 2026 15:37:21 +0100
Message-ID: <20261125143842.491169021@linuxfoundation.org>
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
@@ -3886,6 +3886,24 @@ static bool superblock_changed(struct dm
 	       memcmp(ic->sb->salt, ic->sb_copy->salt, SALT_SIZE) != 0;
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
 	struct dm_integrity_c *ic = ti->private;
@@ -3975,8 +3993,10 @@ static void dm_integrity_resume(struct d
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


