Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9909A397929;
	Sat, 17 Oct 2026 16:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254422; cv=none; b=aRrut9PsVzXVyLAeucgZzXRVCgJNjUWdfTdULcnqnR8dBmXWk9HLB/J9ArEEWqWOwxG1UMAptWDBDttmJ+dmhDzWY2HYxhZ4LuKz2bmeAedJU3Ex29OQTNlqLTEqK3+muIjgFFQIV3WRMgTk99pHUt6f8lKCp0+vOWc7CVoL74c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254422; c=relaxed/simple;
	bh=xWxFxKkI29kvQnr95i8lWvBh4pRejde7mZNr7GuL3lM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b4QmrkX0Gfnb+sxMGvNJV/DHAF60NHDyXxFTDqbSEXc/Y7IkP7dFKsD0c9W2kvF+nXnbkibKnfbvxxR1qmNf61wZlptnlBkHYCLSHkFmMaC6si4qv3eEgWRoxFpPN1C/s/oy9ag7/WbAIHfsN4BR7iiJkCF9PCCsmo9pRAS5DWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nj/JlFsu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nj/JlFsu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E261F000C4;
	Sat, 17 Oct 2026 16:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254421;
	bh=ku7/F7XJ94ttYsTgtMMX1YNkRswmyfXRkq9v0eOFZbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nj/JlFsuLe9RXl3V4IYGZVFDBKiYrpjy8z3lGq2b+OFLm+AbGHywOCkZyWLAZcupF
	 dl30VZ/+NGilia9GQ7wbghUT2Mcq4ftr10g0fZe+QjFvJ/eh36dF02ufEyjtCkzWDS
	 hxRgmEMvVx7T7EDfB3SKoOb2xwRF2ZiKdvwYURbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Morduan Zang <zhangdandan@uniontech.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 442/869] iomap: guard io_size EOF trim against concurrent truncate underflow
Date: Sat, 17 Oct 2026 17:54:43 +0200
Message-ID: <20261017160048.476455463@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Morduan Zang <zhangdandan@uniontech.com>

[ Upstream commit 55ec50d046c03b3724741957f7b007856e36dbe7 ]

iomap: fix zero padding data issue in concurrent append writes
changed ioend accounting so that io_size tracks only valid data
within EOF.  This trims io_size when a writeback range extends
past end_pos:

    ioend->io_size += map_len;
    if (ioend->io_offset + ioend->io_size > end_pos)
        ioend->io_size = end_pos - ioend->io_offset;

However, if end_pos ends up below ioend->io_offset, the subtraction
becomes negative and is stored in size_t io_size, causing an unsigned
wrap to a huge value.  This can happen when writeback continues past
byte-level EOF up to a block-aligned range, or when a concurrent
truncate shrinks the file after end_pos was sampled in
iomap_writeback_handle_eof().

A wrapped io_size can mislead append detection and corrupt
completion-time size handling, since filesystem end_io paths consume
io_size for decisions such as on-disk EOF updates and unwritten/COW
completion ranges.

Fix this by clamping io_size to zero when EOF has moved to or before
the ioend start offset.  This preserves the original intent of trimming
io_size to valid in-EOF data while avoiding the underflow.

Fixes: 51d20d1dacbe ("iomap: fix zero padding data issue in concurrent append writes")
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Morduan Zang <zhangdandan@uniontech.com>
Link: https://patch.msgid.link/9E38E2659B47DC2A+20260624062622.337469-1-zhangdandan@uniontech.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 4703fa7343e7b..02a5fc5105e7e 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1858,8 +1858,12 @@ static int iomap_add_to_ioend(struct iomap_writepage_ctx *wpc,
 	 * appending writes.
 	 */
 	wpc->ioend->io_size += len;
-	if (wpc->ioend->io_offset + wpc->ioend->io_size > end_pos)
-		wpc->ioend->io_size = end_pos - wpc->ioend->io_offset;
+	if (wpc->ioend->io_offset + wpc->ioend->io_size > end_pos) {
+		if (wpc->ioend->io_offset >= end_pos)
+			wpc->ioend->io_size = 0;
+		else
+			wpc->ioend->io_size = end_pos - wpc->ioend->io_offset;
+	}
 
 	wbc_account_cgroup_owner(wbc, folio, len);
 	return 0;
-- 
2.53.0



