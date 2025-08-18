Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C62B33A003;
	Mon, 18 Aug 2025 14:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526348; cv=none; b=XS/YiQv56N3gMbb/RoBdJXTuWEBRltrXue6yf4r0cHi8MjdF3G8NTZXHq8qfa5mqDK1rct0H1FxQtCDCZiKVTiBCQAL/fiRn2r4/JAVSre6rib7p1OsLZWF96RyoQzCBViAkuBTDdQxJ3vT252lvfx2UdxoC+HYuxcZtZ4eh7us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526348; c=relaxed/simple;
	bh=avOG1FdYDo57siB0EhWDdC3qYwooXjcLGZcCQkiwDgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uyjTcMHhca9HDirsIlxugB3kPpbff+DIkdw8dRmXUXl7Dkoutx45epnFuvu0HBw2u99QQITNx9ziQLiFU8hKcBNJjCLkD5Ez0iFg93cQmrEhitJF/L+a8m8wPZmqqGJCEUZ/X+V1h8cwJoKEc4bfPSvErQpUYTLfbJe38KM6vnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1R/ZoD+u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1R/ZoD+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8412C116C6;
	Mon, 18 Aug 2025 14:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526348;
	bh=avOG1FdYDo57siB0EhWDdC3qYwooXjcLGZcCQkiwDgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1R/ZoD+uOd2Ot+kwaCYqCN+5X6vQQUJv2/vC7a7c2yGPxP5ovrWbxnX0hqy0dkRoW
	 h2A5HAnNUHjPCPF0VoBj3cuq2xnq0So9vOA8rRTVGhJdyYg5nMLgZM6APGI90PlhKg
	 IVg2Qgk5EHk1IaVdP3C3Yv98YYRhQlPJQgvYnCo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.16 530/570] btrfs: fix wrong length parameter for btrfs_cleanup_ordered_extents()
Date: Mon, 18 Aug 2025 14:48:37 +0200
Message-ID: <20250818124526.283431219@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

commit deaf895212da74635a7f0a420e1ecf8f5eca1fe5 upstream.

Inside nocow_one_range(), if the checksum cloning for data reloc inode
failed, we call btrfs_cleanup_ordered_extents() to cleanup the just
allocated ordered extents.

But unlike extent_clear_unlock_delalloc(),
btrfs_cleanup_ordered_extents() requires a length, not an inclusive end
bytenr.

This can be problematic, as the @end is normally way larger than @len.

This means btrfs_cleanup_ordered_extents() can be called on folios
out of the correct range, and if the out-of-range folio is under
writeback, we can incorrectly clear the ordered flag of the folio, and
trigger the DEBUG_WARN() inside btrfs_writepage_cow_fixup().

Fix the wrong parameter with correct length instead.

Fixes: 94f6c5c17e52 ("btrfs: move ordered extent cleanup to where they are allocated")
CC: stable@vger.kernel.org # 6.15+
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2010,7 +2010,7 @@ static int nocow_one_range(struct btrfs_
 	 * cleaered by the caller.
 	 */
 	if (ret < 0)
-		btrfs_cleanup_ordered_extents(inode, file_pos, end);
+		btrfs_cleanup_ordered_extents(inode, file_pos, len);
 	return ret;
 }
 


