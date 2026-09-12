Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0D9416124;
	Sat, 12 Sep 2026 08:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202343; cv=none; b=CAePnq7IlpGejoXgyUWz2i+EsKS4V+YGCleZ/pQpNZtFeXT//0EGE10ztwVSYzKmnNJ+M7/E+qqoTCGxcrOPjWSSEYW38NE4j0LUYAMGoMT8WCxbrzZ4C/35KmAmc09TxFYCzKTFEsfiBAin4lodMyrnAn9OyoWIgZl4gMExxdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202343; c=relaxed/simple;
	bh=oh3nUuImY02Rh5SEWn1lSVW0hEytoTbV/zwMSu7IZcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=joklhLj+yYUOgOOgyrIbNpM3mT4UrLVlfkcAIj5dVZLF1IcrL4/n38pT4W6z7TWX0oDpmD7bRtqQ921SP0YDjQMkfwx94S09H+cCiKcT1ItjC7ZdCtc1w+jMgCHnQrhR6QODgi7WuRO47shvH8XpKm7jnm21Camhi7J7gjDU3VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KMAVxMkZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KMAVxMkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AFDB1F000FF;
	Sat, 12 Sep 2026 08:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202342;
	bh=+PoJ4DeeRWVP8jcXe2zxoqhsQWonOhBBImAai3BvUzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KMAVxMkZn9G78tdGaHFcWaTE6AMn4LOFBRfGbcp1iByeK3fCRCUxfbTVPd9X3yVhm
	 /wiy6kAckOA81RV1R+knxrmqSJB5ZJrpJHyrf5WpuzH8hDALIoyokdmADiU3cYFtuD
	 2uDZoyxPRjN6LFAvB972pz0GAMP+bWo45vsuGBc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1181/1815] ext4: fix transaction overflow during writeback
Date: Sat, 12 Sep 2026 08:48:51 +0200
Message-ID: <20260912065716.741019158@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit 46e8e31771f4f1c5e1cdec37a889a6730e42e9f1 ]

Commit 95ad8ee45cdb ("ext4: correct the reserved credits for extent
conversion") was correct to note that we need to reserve enough credits
for all extents possibly underlying a large folio. However it was too
eager to reduce the number of reserved credits. Extent conversion may
not only need to touch several leaf extent blocks, it may also need to
split extents - for example a single large unwritten extent may need to
be split into many small written ones in case of sparse folio dirtying.
This can thus result not only in extent leaf modifications but also in a
need to allocate new extent tree nodes. As a result the reserved
transaction credits were not sufficient in some corner cases. Use
ext4_meta_trans_blocks() for correct upper bound credit estimate.

Fixes: 95ad8ee45cdb ("ext4: correct the reserved credits for extent conversion")
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260805153605.166545-5-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 334d018766982..a33629b397b06 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2867,10 +2867,10 @@ static int ext4_do_writepages(struct mpage_da_data *mpd)
 	if (ext4_should_dioread_nolock(inode)) {
 		int bpf = ext4_journal_blocks_per_folio(inode);
 		/*
-		 * We may need to convert up to one extent per block in
-		 * the folio and we may dirty the inode.
+		 * We may need to convert up to one extent per block in the
+		 * folio.
 		 */
-		rsv_blocks = 1 + ext4_ext_index_trans_blocks(inode, bpf);
+		rsv_blocks = ext4_meta_trans_blocks(inode, bpf, bpf, 0);
 	}
 
 	if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
-- 
2.53.0



