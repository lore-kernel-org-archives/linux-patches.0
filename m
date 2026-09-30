Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71134F4047;
	Wed, 30 Sep 2026 15:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783447; cv=none; b=LVsLpZpJhYMP5ZgbuyCcQawYrVF8Av7I2TWNZQFmRQc2+n6vKXBzeAFGC9uo1xzoK7LvjAzzVwSqMfrzj9rT38R3crsCYkG4fjosu1GxzAqrGUzo5Bm1x17b+3vBjq158CLJpCCqSiqBASm6DgLLt4084Qc1yiTnlLA4lvkYq/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783447; c=relaxed/simple;
	bh=UoZJj7OA2H9uzhhcS3hbWq0TCQXjiLh0KSFvqz6A5TI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HOGINpri6ce/mIDZHVL2DM7dgfdNtgez2gUBM+Nxzesi5rnYG+woVhJyYuLTxaWQ8TWlWLg+IuWKOrXrnl4H4+ivXblzlcoI1asDkRnrbHOxUtR6i2NQEuuTEEWOVJkTBAkr/cRdw1uCFtvxsbPkYuhyaHavyGfo0veuWWTsFa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mdm5GVB2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mdm5GVB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01EF1F00898;
	Wed, 30 Sep 2026 15:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783441;
	bh=NQgRkNveAt4Y6Dg8F7DW0yEu0Ic7SilP2Ync5GuJU9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mdm5GVB2D1bQC7wJabeH8bKTJvuJ5Pnyrx2DMA8gPVq2TE4Mls75YkZS4hss0wH9q
	 yWsv+37YsqsLFdLPQqxy7s3yLe/pgy5tY8/1/eAhyjaIy0qZgf6d5qBTgxZrwhxb8R
	 zlNzWqsXdel3G8RwK8zUZbPay1ypANSiH1eY3xvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 398/595] btrfs: tree-checker: print dev extent offset in error message
Date: Wed, 30 Sep 2026 17:24:51 +0200
Message-ID: <20260930152356.233953337@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit a1167d9420474ab9ed9efca99d86aeb6217c0265 ]

If a dev extent's offset is not sector size aligned, the error message is
printing the dev extent's objectid instead of the offset. This is a copy
paste error, as before this check we check the objectid field.

Fixes: 008e2512dc56 ("btrfs: tree-checker: add dev extent item checks")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-checker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index dd27fdb9521a8..48f8172bb15f8 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1608,7 +1608,7 @@ static int check_dev_extent_item(const struct extent_buffer *leaf,
 				 sectorsize))) {
 		generic_err(leaf, slot,
 			    "invalid dev extent chunk offset, has %llu not aligned to %u",
-			    btrfs_dev_extent_chunk_objectid(leaf, de),
+			    btrfs_dev_extent_chunk_offset(leaf, de),
 			    sectorsize);
 		return -EUCLEAN;
 	}
-- 
2.53.0



