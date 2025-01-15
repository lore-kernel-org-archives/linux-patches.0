Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42281ACE12;
	Wed, 15 Jan 2025 10:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937914; cv=none; b=RjBzLo+hh0Y3wBTbG45klpc4og6sJma82ms0pU+VrUCYKwWeq/xz0Z5NGc9E7bN7GEbJttZZi6n8Aqoad0+N5Jkdg8Bu4oc7GFOiOKhr/w7LUvOO5iOwtVaL1nluXhL7ovPxNsKr/VW8ut6gDXYi8SkhiFiyJgLzgpd6CIKWoFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937914; c=relaxed/simple;
	bh=oy3iwNhtaxHSwcSmCulxM8pPgyGwPWePVvi6CoE15cM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGtfBQsD6eoEHbVL9Go+S/WtVkntTzCZhEzaedKR/srFn9xlMgVAFSLNjNcvR3lo8pUoewNeP7hPQgh5DhyyLdyN3XE9YEYSv9RT8W31qpqtRpmMUt/3v+bR4bafK0gNnyTTEHayYvpgY2F6Am2gtio1YcCAsw3FFMShprVVAzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i3q4CQtN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i3q4CQtN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C44C4CEDF;
	Wed, 15 Jan 2025 10:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937914;
	bh=oy3iwNhtaxHSwcSmCulxM8pPgyGwPWePVvi6CoE15cM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i3q4CQtNeIUEypppYBuw5EK42OS6AZhjFAw9vT/s5kZUicaSbGEOgyBV4C7utexit
	 bk/folercpevGVKZCIEhnNWzKjBdX36zH+dvnCseWfIxmObeddEsAUBJ4YKUgWHS1m
	 vwgVE177Z/SzZuF2Q30K5QdlUKfgv49qjNKfh6UM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	Brian Foster <bfoster@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/189] iomap: pass byte granular end position to iomap_add_to_ioend
Date: Wed, 15 Jan 2025 11:35:00 +0100
Message-ID: <20250115103606.533989308@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

From: Long Li <leo.lilong@huawei.com>

[ Upstream commit b44679c63e4d3ac820998b6bd59fba89a72ad3e7 ]

This is a preparatory patch for fixing zero padding issues in concurrent
append write scenarios. In the following patches, we need to obtain
byte-granular writeback end position for io_size trimming after EOF
handling.

Due to concurrent writeback and truncate operations, inode size may
shrink. Resampling inode size would force writeback code to handle the
newly appeared post-EOF blocks, which is undesirable. As Dave
explained in [1]:

"Really, the issue is that writeback mappings have to be able to
handle the range being mapped suddenly appear to be beyond EOF.
This behaviour is a longstanding writeback constraint, and is what
iomap_writepage_handle_eof() is attempting to handle.

We handle this by only sampling i_size_read() whilst we have the
folio locked and can determine the action we should take with that
folio (i.e. nothing, partial zeroing, or skip altogether). Once
we've made the decision that the folio is within EOF and taken
action on it (i.e. moved the folio to writeback state), we cannot
then resample the inode size because a truncate may have started
and changed the inode size."

To avoid resampling inode size after EOF handling, we convert end_pos
to byte-granular writeback position and return it from EOF handling
function.

Since iomap_set_range_dirty() can handle unaligned lengths, this
conversion has no impact on it. However, iomap_find_dirty_range()
requires aligned start and end range to find dirty blocks within the
given range, so the end position needs to be rounded up when passed
to it.

LINK [1]: https://lore.kernel.org/linux-xfs/Z1Gg0pAa54MoeYME@localhost.localdomain/

Signed-off-by: Long Li <leo.lilong@huawei.com>
Link: https://lore.kernel.org/r/20241209114241.3725722-2-leo.lilong@huawei.com
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 51d20d1dacbe ("iomap: fix zero padding data issue in concurrent append writes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index ce73d2a48c1e..05e5cc3bf976 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1764,7 +1764,8 @@ static bool iomap_can_add_to_ioend(struct iomap_writepage_ctx *wpc, loff_t pos)
  */
 static int iomap_add_to_ioend(struct iomap_writepage_ctx *wpc,
 		struct writeback_control *wbc, struct folio *folio,
-		struct inode *inode, loff_t pos, unsigned len)
+		struct inode *inode, loff_t pos, loff_t end_pos,
+		unsigned len)
 {
 	struct iomap_folio_state *ifs = folio->private;
 	size_t poff = offset_in_folio(folio, pos);
@@ -1790,8 +1791,8 @@ static int iomap_add_to_ioend(struct iomap_writepage_ctx *wpc,
 
 static int iomap_writepage_map_blocks(struct iomap_writepage_ctx *wpc,
 		struct writeback_control *wbc, struct folio *folio,
-		struct inode *inode, u64 pos, unsigned dirty_len,
-		unsigned *count)
+		struct inode *inode, u64 pos, u64 end_pos,
+		unsigned dirty_len, unsigned *count)
 {
 	int error;
 
@@ -1816,7 +1817,7 @@ static int iomap_writepage_map_blocks(struct iomap_writepage_ctx *wpc,
 			break;
 		default:
 			error = iomap_add_to_ioend(wpc, wbc, folio, inode, pos,
-					map_len);
+					end_pos, map_len);
 			if (!error)
 				(*count)++;
 			break;
@@ -1887,11 +1888,11 @@ static bool iomap_writepage_handle_eof(struct folio *folio, struct inode *inode,
 		 *    remaining memory is zeroed when mapped, and writes to that
 		 *    region are not written out to the file.
 		 *
-		 * Also adjust the writeback range to skip all blocks entirely
-		 * beyond i_size.
+		 * Also adjust the end_pos to the end of file and skip writeback
+		 * for all blocks entirely beyond i_size.
 		 */
 		folio_zero_segment(folio, poff, folio_size(folio));
-		*end_pos = round_up(isize, i_blocksize(inode));
+		*end_pos = isize;
 	}
 
 	return true;
@@ -1904,6 +1905,7 @@ static int iomap_writepage_map(struct iomap_writepage_ctx *wpc,
 	struct inode *inode = folio->mapping->host;
 	u64 pos = folio_pos(folio);
 	u64 end_pos = pos + folio_size(folio);
+	u64 end_aligned = 0;
 	unsigned count = 0;
 	int error = 0;
 	u32 rlen;
@@ -1945,9 +1947,10 @@ static int iomap_writepage_map(struct iomap_writepage_ctx *wpc,
 	/*
 	 * Walk through the folio to find dirty areas to write back.
 	 */
-	while ((rlen = iomap_find_dirty_range(folio, &pos, end_pos))) {
+	end_aligned = round_up(end_pos, i_blocksize(inode));
+	while ((rlen = iomap_find_dirty_range(folio, &pos, end_aligned))) {
 		error = iomap_writepage_map_blocks(wpc, wbc, folio, inode,
-				pos, rlen, &count);
+				pos, end_pos, rlen, &count);
 		if (error)
 			break;
 		pos += rlen;
-- 
2.39.5



