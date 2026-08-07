Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B53412C05;
	Fri,  7 Aug 2026 15:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116615; cv=none; b=sNTjyn+LzQoRrxadcw91VReMfCN4A/WDijn72QrItxfkTnsNo4swtW2yvvQdLCNWlZaOWlqcFn4T2mkwlL0gtqXJWOThmIBxbG0qj2bPU4lFdqE/NYW28jvmqZsqWLFlHIoNtTKJwzmejQJ43e34Vu9lNLJuPhu6k1NpFYcC9is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116615; c=relaxed/simple;
	bh=9qd3/0AvGYXMpExhUkcBeoWtVkQhtUxWZgj/cK82vvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JC0/uL9vJkDz1oIZbvL5qcfibnDfJ1aUX486T8qvNQ9l1OOt3uubxWizop6nbw/52g7Rk1S3PJbgitS3e509PbEBZELoM85/sKFQdWtY6u+vepMvqPnpW38J3V63zyjw0E78ltXQfZX6N7IRTlnrC06UYTFXXI2eqMFk8tOy/yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PS1oCkV6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PS1oCkV6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2231F000E9;
	Fri,  7 Aug 2026 15:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116614;
	bh=D58BEQQ4CN3TS/Cy3kFufSu+aBH+prPMsredtlPsMEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PS1oCkV67PpzfYVdOcw28xBfSSLxNqM4fOWvwrCWiPqb7lq13PHjymzJZShRZ+qJ+
	 QDNQX+kdmIOuUEu5NmdyUwBbg2NKW46AueNrKxUSVfyo3jNNmUKBlubgjQ/wAfzedy
	 n9CMIHu4ALvaQQghsXGbJImGAEVX+YOnjcYwu5fU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 031/438] btrfs: zoned: skip fully truncated ordered extents at zone finish
Date: Fri,  7 Aug 2026 16:33:47 +0200
Message-ID: <20260807143428.671988539@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit ab602da96a915d42dcb1b0b322e8daea0f71b51f ]

A fully truncated ordered extent (truncated_len == 0) wrote no data, so its
->csum_list is empty and btrfs_finish_ordered_zoned() trips:

  assertion failed: !list_empty(&ordered->csum_list), in fs/btrfs/zoned.c:2141

Since commit 66ff4d366e7e a short or cancelled direct IO write finishes the
unsubmitted ordered extent as truncated with uptodate = true instead of
setting BTRFS_ORDERED_IOERR, so it now reaches btrfs_finish_ordered_zoned()
rather than being skipped by the IOERR check in btrfs_finish_ordered_io().
generic/208 hits this on a zoned filesystem.

Return early for these, like the BTRFS_ORDERED_PREALLOC case; there is no
zone append result to record and btrfs_finish_one_ordered() skips them too.

Fixes: 66ff4d366e7e ("btrfs: fix false IO failure after falling back to buffered write")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 6963e9068a565..e9d72401d328f 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2136,6 +2136,16 @@ void btrfs_finish_ordered_zoned(struct btrfs_ordered_extent *ordered)
 	if (test_bit(BTRFS_ORDERED_PREALLOC, &ordered->flags))
 		return;
 
+	/*
+	 * A fully truncated ordered extent wrote no data and so has
+	 * no zone append result to record.
+	 */
+	if (test_bit(BTRFS_ORDERED_TRUNCATED, &ordered->flags) &&
+	    ordered->truncated_len == 0) {
+		ASSERT(list_empty(&ordered->csum_list));
+		return;
+	}
+
 	ASSERT(!list_empty(&ordered->csum_list));
 	sum = list_first_entry(&ordered->csum_list, struct btrfs_ordered_sum, list);
 	logical = sum->logical;
-- 
2.53.0



