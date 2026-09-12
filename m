Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4BF41A4E7;
	Sat, 12 Sep 2026 09:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204416; cv=none; b=juMmwTkBvwei+DWdFyzhBUqFLRg9lty/oaoUAdkp9EHbV7PKYtV8mqrvFToR2MnruYm31q/NIb2AOKe+36I6x/d4lO6iOTKzIvNyx5vBB4xtDwH0Rt6IbdkIjU7Lh6A2yh2wYW4qnNIgCGVVHOhrOEbI6Qa9jvp20b4poUDMWbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204416; c=relaxed/simple;
	bh=YZ2ojFTozKpyFTK7WoYjbRSj5xMYT7anQVRnOuEbqnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRA89qtZFAbPMC9qPaUWJdfgbosOMbvx53AQdHNYdi83XuIsCqLiwGZVs5RNh+RJi/kk0EOgMdf1+nGIzPEsYqA1B/ydTg508YmCaDDTG3b4rzRWyVxIad87knCC9GkHt7Shsts6S8yPlG24d7cMBFKwZO1yj/J4r9Ok/hY2S0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VYQjpEn0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VYQjpEn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79751F000FF;
	Sat, 12 Sep 2026 09:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204414;
	bh=2tiS2faUrBsGWm3LCiqSHrcQsWP9QW5H9RxsbOBhlcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VYQjpEn073UPm7liGvzX9Otci6BApuhNTMaR1XzPgXRDLbaG6lr+gEGxfaF7xNZS2
	 p6w7CXLoWtOF+WPkNKT6YjeSP/32Q7ueM994PEuLB+f6wFbiq5160OWPCEnZ/neIMF
	 35wRrr9R2In/oNoER6t5KGll0+zrhEvhORc8okBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandro Calo <alexandro.calo@nozominetworks.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1609/1815] ntfs: Fix index_root heap OOB write in ntfs_ir_to_ib()
Date: Sat, 12 Sep 2026 08:55:59 +0200
Message-ID: <20260912065726.764529015@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandro Calo <alexandro.calo@nozominetworks.com>

[ Upstream commit dc09bf79b76f9a7157e225f449655f3f62f96c9c ]

ntfs_ir_to_ib copies all entries from index_root into a freshly allocated
index_block_size-byte buffer without verifying that the entries fit in the
available space. The entries in index_root may be larger than the usable
entry space in the index block.

This can cause OOB writes past the end of the allocation.

The validator ntfs_index_root_inconsistent() checks that entries are
self-consistent within the IR value, but never cross-checks them against
index_block_size. There is no bounds check in ntfs_ir_to_ib() before the
memcpy.

Fixing this at the sink in ntfs_ir_to_ib() since
ntfs_index_root_inconsistent() validates the logical consistency of
index_root as a structure and a root with large entries is a structurally
valid root. The bug is a size conflict of ntfs_ir_to_ib().
Also, the validator is called once per inode load in
ntfs_read_locked_inode() while ntfs_ir_to_ib() is only called during a
reparent, a check there adds no overhead to the common path.
Moreover, even a future call path that bypasses the validator would still
be protected.

With NULL as first parameter of ntfs_error(), the volume error flag is
never set by this call, so the device name will be absent from the error
message. In any case, that the caller, ntfs_ir_reparent(), prints an error
message that includes the device name on NULL returns.
I think this is the best solution available without adding
'struct super_block *sb' as a parameter to ntfs_ir_to_ib().

This heap out-of-bounds write is triggered by a crafted filesystem image,
which is not in the kernel threat model, anyway, fixing memory errors would
be nice to keep  things secure.

Fixes: 0a8ac0c1fa0b ("ntfs: update directory operations")
Signed-off-by: Alexandro Calo <alexandro.calo@nozominetworks.com>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/index.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/ntfs/index.c b/fs/ntfs/index.c
index faa7ee920a3ad..409759eab55d3 100644
--- a/fs/ntfs/index.c
+++ b/fs/ntfs/index.c
@@ -1112,6 +1112,7 @@ static struct index_block *ntfs_ir_to_ib(struct index_root *ir, s64 ib_vcn)
 	struct index_entry *ie_last;
 	char *ies_start, *ies_end;
 	int i;
+	u32 ib_cap;
 
 	ntfs_debug("Entering\n");
 
@@ -1127,6 +1128,16 @@ static struct index_block *ntfs_ir_to_ib(struct index_root *ir, s64 ib_vcn)
 	 * as well, which can never have any data.
 	 */
 	i = (char *)ie_last - ies_start + le16_to_cpu(ie_last->length);
+
+	/* Entries must fit in the allocated index block */
+	ib_cap = le32_to_cpu(ib->index.allocated_size) -
+			le32_to_cpu(ib->index.entries_offset);
+	if ((u32)i > ib_cap) {
+		ntfs_error(NULL, "Entries (%d B) exceed IB capacity", i);
+		kvfree(ib);
+		return NULL;
+	}
+
 	memcpy(ntfs_ie_get_first(&ib->index), ies_start, i);
 
 	ib->index.flags = ir->index.flags;
-- 
2.53.0



