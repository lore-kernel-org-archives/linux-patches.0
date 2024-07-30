Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F648BE8;
	Tue, 30 Jul 2024 16:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357024; cv=none; b=SNJabAthH+4+N4Fm/HjEMLdlkJssgbnaRhF9D4OsWUU3J1cDa5rR8HSeo2IkknbUWCwVb0oTJH9wLkmP976mvzEZP0CUT15hzHkJxvx1k8D7YLo1IScocUiCfeBYM5RCcuFrGNtZuJTW56Z16CgFyZlCHprrCoF/b+727Mn+FSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357024; c=relaxed/simple;
	bh=JlU3KGqtlPiKXG4u2HWbUVfroFCOWXFtTF1pM31nNp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rrrx1cZNbDSjhcB8EyrKQqh/R8jVUI8M/myR/E5jF3yRYRrstXU5pvxEu+WoAF4LP3VDGWO9DnLBHU3OJxgURaw2eazWqgJGl/P/YmVmi73uSUvSu9Ii4nT2FunV44ADr7n8dWbU06I8PavUq7QLl4LvaUkm3UfmHQCgyNV9xJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JsKpDihQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JsKpDihQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE79C32782;
	Tue, 30 Jul 2024 16:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357023;
	bh=JlU3KGqtlPiKXG4u2HWbUVfroFCOWXFtTF1pM31nNp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JsKpDihQBQx/DqBQHlXfdqPIFEk3nshwnKhmS8g0YWkQpxvcZLvG9CEaGJ+WR7fmK
	 zLF4M0j+kw3zlOhC5cVN4WAn/FqUzz/3JRKKe7gF8TY6t79Rtg3ZS3ieH04Ggvce0y
	 +uOO+rm7gnOVPygVHU64LZdrdpN05PGtbXAPv69Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 251/440] fs/ntfs3: Fix field-spanning write in INDEX_HDR
Date: Tue, 30 Jul 2024 17:48:04 +0200
Message-ID: <20240730151625.652514156@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 2f3e176fee66ac86ae387787bf06457b101d9f7a ]

Fields flags and res[3] replaced with one 4 byte flags.

Fixes: 4534a70b7056 ("fs/ntfs3: Add headers and misc files")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/index.c | 4 ++--
 fs/ntfs3/ntfs.h  | 9 +++++----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index 730629235ffa1..9c36e0f3468d7 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -979,7 +979,7 @@ static struct indx_node *indx_new(struct ntfs_index *indx,
 		hdr->used =
 			cpu_to_le32(eo + sizeof(struct NTFS_DE) + sizeof(u64));
 		de_set_vbn_le(e, *sub_vbn);
-		hdr->flags = 1;
+		hdr->flags = NTFS_INDEX_HDR_HAS_SUBNODES;
 	} else {
 		e->size = cpu_to_le16(sizeof(struct NTFS_DE));
 		hdr->used = cpu_to_le32(eo + sizeof(struct NTFS_DE));
@@ -1677,7 +1677,7 @@ static int indx_insert_into_root(struct ntfs_index *indx, struct ntfs_inode *ni,
 	e->size = cpu_to_le16(sizeof(struct NTFS_DE) + sizeof(u64));
 	e->flags = NTFS_IE_HAS_SUBNODES | NTFS_IE_LAST;
 
-	hdr->flags = 1;
+	hdr->flags = NTFS_INDEX_HDR_HAS_SUBNODES;
 	hdr->used = hdr->total =
 		cpu_to_le32(new_root_size - offsetof(struct INDEX_ROOT, ihdr));
 
diff --git a/fs/ntfs3/ntfs.h b/fs/ntfs3/ntfs.h
index b992ec42a1d92..625f2b52bd586 100644
--- a/fs/ntfs3/ntfs.h
+++ b/fs/ntfs3/ntfs.h
@@ -686,14 +686,15 @@ static inline bool de_has_vcn_ex(const struct NTFS_DE *e)
 	      offsetof(struct ATTR_FILE_NAME, name) + \
 	      NTFS_NAME_LEN * sizeof(short), 8)
 
+#define NTFS_INDEX_HDR_HAS_SUBNODES cpu_to_le32(1)
+
 struct INDEX_HDR {
 	__le32 de_off;	// 0x00: The offset from the start of this structure
 			// to the first NTFS_DE.
 	__le32 used;	// 0x04: The size of this structure plus all
 			// entries (quad-word aligned).
 	__le32 total;	// 0x08: The allocated size of for this structure plus all entries.
-	u8 flags;	// 0x0C: 0x00 = Small directory, 0x01 = Large directory.
-	u8 res[3];
+	__le32 flags;	// 0x0C: 0x00 = Small directory, 0x01 = Large directory.
 
 	//
 	// de_off + used <= total
@@ -740,7 +741,7 @@ static inline struct NTFS_DE *hdr_next_de(const struct INDEX_HDR *hdr,
 
 static inline bool hdr_has_subnode(const struct INDEX_HDR *hdr)
 {
-	return hdr->flags & 1;
+	return hdr->flags & NTFS_INDEX_HDR_HAS_SUBNODES;
 }
 
 struct INDEX_BUFFER {
@@ -760,7 +761,7 @@ static inline bool ib_is_empty(const struct INDEX_BUFFER *ib)
 
 static inline bool ib_is_leaf(const struct INDEX_BUFFER *ib)
 {
-	return !(ib->ihdr.flags & 1);
+	return !(ib->ihdr.flags & NTFS_INDEX_HDR_HAS_SUBNODES);
 }
 
 /* Index root structure ( 0x90 ). */
-- 
2.43.0



