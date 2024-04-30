Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999F012D74E;
	Tue, 30 Apr 2024 10:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474440; cv=none; b=UI6TUJ+Fxo3FQZ6obOTpO615sp4aNhGuTmnREikL+dxGLTXCdKedPrSuUNlR7nM+QiR8F88dEOIVR1Sn+qfoiTox101AJo2GVHQqLQLNTVjcXEJkJRITMz5SKRQdBxaqTsVwZ4LqZ5mQ7iKBPANO7SyH8ZL1Pi2ZSyoS7hb5Xok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474440; c=relaxed/simple;
	bh=o3Cj6Ykt//eiuFceFaCbl1c2F5rRt9ZbH9wJ81DXOC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W64wE7K2r1mUNjjS8R8K6k0n23z/krC6DCWfpFAOtrvbsayzGWecA90ZhkDR0cKT5thmaIGrzT1UWMwbPGmt6gxb2NSxFbGU+bNe4EXFMjER/VARueGjIRR4hRK+gLAHeibGyTYao0CC8e7VbK/MMIwRX3rq2BnuVU73bRxQa38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lG3EhPtG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lG3EhPtG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A3BC2BBFC;
	Tue, 30 Apr 2024 10:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474440;
	bh=o3Cj6Ykt//eiuFceFaCbl1c2F5rRt9ZbH9wJ81DXOC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lG3EhPtGxnsK8DqfDSezzWj5yc/LX0+vjqJLwSjSexhjwkbwQy4W3Lau97YlmqOWQ
	 7GJOcnCFpW6NE9v64csUapj/QXWDz2ij/o5yPbeJPoOWe9COMg/0L7I1ksq+ZtL6xx
	 ThEhRwix0WJW4h8GUiOIYSU7loBR/EMfdleLGSfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Neal Gompa <neal@gompa.dev>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.8 158/228] btrfs: fallback if compressed IO fails for ENOSPC
Date: Tue, 30 Apr 2024 12:38:56 +0200
Message-ID: <20240430103108.365110573@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

commit 131a821a243f89be312ced9e62ccc37b2cf3846c upstream.

In commit b4ccace878f4 ("btrfs: refactor submit_compressed_extents()"), if
an async extent compressed but failed to find enough space, we changed
from falling back to an uncompressed write to just failing the write
altogether. The principle was that if there's not enough space to write
the compressed version of the data, there can't possibly be enough space
to write the larger, uncompressed version of the data.

However, this isn't necessarily true: due to fragmentation, there could
be enough discontiguous free blocks to write the uncompressed version,
but not enough contiguous free blocks to write the smaller but
unsplittable compressed version.

This has occurred to an internal workload which relied on write()'s
return value indicating there was space. While rare, it has happened a
few times.

Thus, in order to prevent early ENOSPC, re-add a fallback to
uncompressed writing.

Fixes: b4ccace878f4 ("btrfs: refactor submit_compressed_extents()")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Co-developed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1144,13 +1144,13 @@ static void submit_one_async_extent(stru
 				   0, *alloc_hint, &ins, 1, 1);
 	if (ret) {
 		/*
-		 * Here we used to try again by going back to non-compressed
-		 * path for ENOSPC.  But we can't reserve space even for
-		 * compressed size, how could it work for uncompressed size
-		 * which requires larger size?  So here we directly go error
-		 * path.
+		 * We can't reserve contiguous space for the compressed size.
+		 * Unlikely, but it's possible that we could have enough
+		 * non-contiguous space for the uncompressed size instead.  So
+		 * fall back to uncompressed.
 		 */
-		goto out_free;
+		submit_uncompressed_range(inode, async_extent, locked_page);
+		goto done;
 	}
 
 	/* Here we're doing allocation and writeback of the compressed pages */
@@ -1202,7 +1202,6 @@ done:
 out_free_reserve:
 	btrfs_dec_block_group_reservations(fs_info, ins.objectid);
 	btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset, 1);
-out_free:
 	mapping_set_error(inode->vfs_inode.i_mapping, -EIO);
 	extent_clear_unlock_delalloc(inode, start, end,
 				     NULL, EXTENT_LOCKED | EXTENT_DELALLOC |


