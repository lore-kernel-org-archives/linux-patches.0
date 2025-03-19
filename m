Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D641C5F26;
	Wed, 19 Mar 2025 14:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395067; cv=none; b=ApeM6MaOk19fbeKnSubmXt/3V6HN1dB+aPt50zKYKH9s/vGSctw2wueFPgXnAT1x5EcmRWr3PNZxFu30ry+rocRWWeeNtkx3z9rkRE0eVCxhDsFdb7+VirlUGyJBp59XeAYSklmY7ac2BTbfJqnEI6xKh5vTAnugzqzKLdxp3vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395067; c=relaxed/simple;
	bh=6oFD7YDyJ/bMc52zIjUP4sArlpxPzw6Hxb/x/77uyac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZWdSVOjwgs5QQ0lWf9SPVj9O/ksUQEOBxVnaU8BRwbEotcVjBs9OtZwj+AuwLRSx+vNYD8i1kt1/RluSyWUXsVY4f8Hj64hh4bhxXDM6arKrVf++Hb4h/tMVzbtyf2qkjXseoAmNr5gZW+/jjUoOzkYK9dwb5ktvCcmUxYw9CjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mdb1W5/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mdb1W5/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E9BC4CEE4;
	Wed, 19 Mar 2025 14:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395066;
	bh=6oFD7YDyJ/bMc52zIjUP4sArlpxPzw6Hxb/x/77uyac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mdb1W5/BzOeGa3VaoiAW7RMG3YUBIcnmm3eiE2fsjb7DmL2hpiyyfXL306pxivIRH
	 SOOpkBP4CaHHFzP0XrZcdX3vHs/Ut6Avk1RW/bjwEgzaKH60sFu5rDQwQah7SY1yeK
	 Xj96s1BIo4OFTGMWEJzCL5zzVJaOf/STx5XeZ28M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 085/231] btrfs: fix two misuses of folio_shift()
Date: Wed, 19 Mar 2025 07:29:38 -0700
Message-ID: <20250319143028.940757134@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 01af106a076352182b2916b143fc50272600bd81 ]

It is meaningless to shift a byte count by folio_shift().  The folio index
is in units of PAGE_SIZE, not folio_size().  We can use folio_contains()
to make this work for arbitrary-order folios, so remove the assertion
that the folios are of order 0.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 660a5b9c08e9e..6551fb003eed2 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -526,8 +526,6 @@ static void end_bbio_data_read(struct btrfs_bio *bbio)
 		u64 end;
 		u32 len;
 
-		/* For now only order 0 folios are supported for data. */
-		ASSERT(folio_order(folio) == 0);
 		btrfs_debug(fs_info,
 			"%s: bi_sector=%llu, err=%d, mirror=%u",
 			__func__, bio->bi_iter.bi_sector, bio->bi_status,
@@ -555,7 +553,6 @@ static void end_bbio_data_read(struct btrfs_bio *bbio)
 
 		if (likely(uptodate)) {
 			loff_t i_size = i_size_read(inode);
-			pgoff_t end_index = i_size >> folio_shift(folio);
 
 			/*
 			 * Zero out the remaining part if this range straddles
@@ -564,9 +561,11 @@ static void end_bbio_data_read(struct btrfs_bio *bbio)
 			 * Here we should only zero the range inside the folio,
 			 * not touch anything else.
 			 *
-			 * NOTE: i_size is exclusive while end is inclusive.
+			 * NOTE: i_size is exclusive while end is inclusive and
+			 * folio_contains() takes PAGE_SIZE units.
 			 */
-			if (folio_index(folio) == end_index && i_size <= end) {
+			if (folio_contains(folio, i_size >> PAGE_SHIFT) &&
+			    i_size <= end) {
 				u32 zero_start = max(offset_in_folio(folio, i_size),
 						     offset_in_folio(folio, start));
 				u32 zero_len = offset_in_folio(folio, end) + 1 -
@@ -960,7 +959,7 @@ static int btrfs_do_readpage(struct folio *folio, struct extent_map **em_cached,
 		return ret;
 	}
 
-	if (folio->index == last_byte >> folio_shift(folio)) {
+	if (folio_contains(folio, last_byte >> PAGE_SHIFT)) {
 		size_t zero_offset = offset_in_folio(folio, last_byte);
 
 		if (zero_offset) {
-- 
2.39.5



