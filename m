Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732A12CA9;
	Tue, 12 Aug 2025 18:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024523; cv=none; b=DzOJIEUziLCHcQWueuCeAWAftiP/QFjdBEOJxYrPFaTQj7BpGwJzXTA7FLh3VgvIDKxGttZD+ksIqbcy/bKZ7tS1A9wcANWPp4yOjkseohf6iOviSOLkbkhiXF6fm13jvTPMHgy4Ft23hTrVBo6Tm/P1jHsoSE0qVvu71FscTpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024523; c=relaxed/simple;
	bh=eDIE6YPuBB3SPQijJRodESmgYmctprWlXnHG9TugYko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hVUzrAH0giKNSZLDAcvGnC3saf3pZyXCfWhorfifx/9uI/XmLdpNieF6AlRd4gZW/LErfO6alHXsXrx8X+EYG+3IyrLySbTJ8WGV49tMLCgeraGimIfyBUIqVfBgF7jnYTEXyCfmZZZIHGB3g2a4pLg7EtZHwKLX/tV7MKaKVzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JhTUA1KN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JhTUA1KN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFBDC4CEF0;
	Tue, 12 Aug 2025 18:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024523;
	bh=eDIE6YPuBB3SPQijJRodESmgYmctprWlXnHG9TugYko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JhTUA1KNfnL9WdQRqza7jhXtCJrHb3L4lXmHSkr/OKVLtXhrmxSoaMHizS8ZnpRvU
	 WEu7nCxddzZZrW+9/ta4O0EoOvSK4a8FaKvfklXua581HBfoNxh1ZfZkaBjKyBiknh
	 EE9/E/A4Ott/enj4yjBePk8voUBpbuboxYIgUi34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin12138@163.com>,
	Zhi Long <longzhi@sangfor.com.cn>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 399/627] ext4: Make sure BH_New bit is cleared in ->write_end handler
Date: Tue, 12 Aug 2025 19:31:34 +0200
Message-ID: <20250812173434.475068138@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 91b8ca8b26729b729dda8a4eddb9aceaea706f37 ]

Currently we clear BH_New bit in case of error and also in the standard
ext4_write_end() handler (in block_commit_write()). However
ext4_journalled_write_end() misses this clearing and thus we are leaving
stale BH_New bits behind. Generally ext4_block_write_begin() clears
these bits before any harm can be done but in case blocksize < pagesize
and we hit some error when processing a page with these stale bits,
we'll try to zero buffers with these stale BH_New bits and jbd2 will
complain (as buffers were not prepared for writing in this transaction).
Fix the problem by clearing BH_New bits in ext4_journalled_write_end()
and WARN if ext4_block_write_begin() sees stale BH_New bits.

Reported-by: Baolin Liu <liubaolin12138@163.com>
Reported-by: Zhi Long <longzhi@sangfor.com.cn>
Fixes: 3910b513fcdf ("ext4: persist the new uptodate buffers in ext4_journalled_zero_new_buffers")
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20250709084831.23876-2-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inline.c | 2 ++
 fs/ext4/inode.c  | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index a1bbcdf40824..1545846e0e3e 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -612,6 +612,7 @@ static int ext4_convert_inline_data_to_extent(struct address_space *mapping,
 	} else
 		ret = ext4_block_write_begin(handle, folio, from, to,
 					     ext4_get_block);
+	clear_buffer_new(folio_buffers(folio));
 
 	if (!ret && ext4_should_journal_data(inode)) {
 		ret = ext4_walk_page_buffers(handle, inode,
@@ -891,6 +892,7 @@ static int ext4_da_convert_inline_data_to_extent(struct address_space *mapping,
 		return ret;
 	}
 
+	clear_buffer_new(folio_buffers(folio));
 	folio_mark_dirty(folio);
 	folio_mark_uptodate(folio);
 	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8997a5f096b4..2509389badf3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1171,7 +1171,7 @@ int ext4_block_write_begin(handle_t *handle, struct folio *folio,
 			}
 			continue;
 		}
-		if (buffer_new(bh))
+		if (WARN_ON_ONCE(buffer_new(bh)))
 			clear_buffer_new(bh);
 		if (!buffer_mapped(bh)) {
 			WARN_ON(bh->b_size != blocksize);
@@ -1395,6 +1395,7 @@ static int write_end_fn(handle_t *handle, struct inode *inode,
 	ret = ext4_dirty_journalled_data(handle, bh);
 	clear_buffer_meta(bh);
 	clear_buffer_prio(bh);
+	clear_buffer_new(bh);
 	return ret;
 }
 
-- 
2.39.5



