Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DA946C4DC;
	Tue, 21 Jul 2026 15:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649497; cv=none; b=Q8CNKckjaRvPGsF8YmEXZZOignWQFZxKwCOhXQyApy3u+WaWGBw102mPRc01VkM1X3b5hMgcY/PdeKfZChVdR2bYEmZ5PyEHpKsHHw5oJkImahhWKFZmT9k/9yIBxBcSu8oiFWXulTddrO+uk4dJjZzDLN1jGfxLf5rQTpIxJgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649497; c=relaxed/simple;
	bh=NticZMIKztRxJPpeDkHhWjSTUpENgyUFfKxNVnL03Ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPJlNQp1Scs5iw2YLQTVaHzVjIAfgAh7h+f7vmkL6zfr2PkwmGpYDoow2+N61HsDAiH5ZCQI90SfLi3JfZT1h896xz8G/mMzouPGI07z8P0CCvTE6YI+ZVbYJbHx8PGObB957+e/pOiu/2WM42GySNSrBN+/Otci1fiOXnf9XgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XBjFLxBJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XBjFLxBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB65A1F00A3A;
	Tue, 21 Jul 2026 15:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649495;
	bh=BB6llS/o/ut4LzAQpJcYbjCQlGi3/N+lwcnn4Jd8Bdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XBjFLxBJDtMyfgfHVl1AHUrZVTg2eMzxN6E0mnPmjSOF+w2LcwGHoT2juSDp60h2J
	 J0ec50t+Sya8K/mgyToYHsRhR1J8l/Sa2UGLZXiWV/OiZcacDHvPdTgDLFieAOdrSk
	 wM3o6sK7XYccluIEqGS1bpAvx9ZX5v5RxQbvBMhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0546/2077] ntfs: bound the look-ahead attribute-list entry in ntfs_external_attr_find()
Date: Tue, 21 Jul 2026 17:03:39 +0200
Message-ID: <20260721152605.690756808@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 344b18f389f9934d59c7b0cf3d20541ea2e0da58 ]

When resolving an attribute lookup with a non-zero @lowest_vcn,
ntfs_external_attr_find() peeks at the next $ATTRIBUTE_LIST entry to
decide whether to keep searching, but bounds that not-yet-validated
entry only with "(u8 *)next_al_entry + 6 < al_end" (which proves just
bytes 0..6 are in range) and "(u8 *)next_al_entry + length <= al_end"
with an attacker-controlled, non-8-aligned length. It then reads
next_al_entry->lowest_vcn (an __le64 at offset 8) and the name at
next_al_entry->name_offset, both of which can lie past al_end -- the
exact end of the kvmalloc'd attribute-list buffer (allocated at the
on-disk attr_list_size, no rounding). A crafted on-disk $ATTRIBUTE_LIST
whose last entry sits a few bytes before al_end therefore yields a slab
out-of-bounds read when the inode is read.

Validate the look-ahead entry with ntfs_attr_list_entry_is_valid() (added
in patch 1/3) before dereferencing lowest_vcn and the name, so the same
fixed-header, length and name bounds the main attribute-list walk uses now
guard this read too.

Fixes: 1e9ea7e04472 ("Revert "fs: Remove NTFS classic"")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/attrib.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index abc0add6f0c446..e425c8d074c58a 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -1185,9 +1185,8 @@ static int ntfs_external_attr_find(const __le32 type,
 		 * we have reached the right one or the search has failed.
 		 */
 		if (lowest_vcn && (u8 *)next_al_entry >= al_start &&
-				(u8 *)next_al_entry + 6 < al_end &&
-				(u8 *)next_al_entry + le16_to_cpu(
-					next_al_entry->length) <= al_end &&
+				ntfs_attr_list_entry_is_valid(next_al_entry,
+							      al_end) &&
 				le64_to_cpu(next_al_entry->lowest_vcn) <=
 					lowest_vcn &&
 				next_al_entry->type == al_entry->type &&
-- 
2.53.0



