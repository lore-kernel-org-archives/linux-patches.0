Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF23512EBCE;
	Tue, 14 May 2024 11:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685759; cv=none; b=BZ5cTRbmz4pjim+nz193gOPOljzZTKEu6UzxeGFBp655aMoUrhkKJmGml2w5u5COnxLQZ+e2mdPDeux5v3mvAn6POqix4PO0EotFe58YjL4dwZJEbaWewFTROFAB+teAi5SspUPeMLHOlWy3UW7KqZBPqssG7LICmHD6D2gFfus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685759; c=relaxed/simple;
	bh=/yeEAeqlbyVB1eUHSxGPL98HsnstS70DUxioVAarWFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLD4D8BMoon2ElQ+N05ptXerycFRg8XgvmxJnO9ixmVNz312VrxNUn/ntkNgD55A7e1jWPEDUF5+wzAdSVLkgWuEYw7Z5gXZanqyLVE5Md8aweHQLKgkbVNh43yfx5wKQ4GwW7ylLqXZjAH0X/BvClCNCv+K0fh00KVIJAgNt9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mpQ1tpCN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mpQ1tpCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF25C2BD10;
	Tue, 14 May 2024 11:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685758;
	bh=/yeEAeqlbyVB1eUHSxGPL98HsnstS70DUxioVAarWFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mpQ1tpCNpATY0FFhIKoLwWTedjwamrl0cI5skT1o/Xa9E21iUMitdeGdoTmz7uThh
	 kQEKdRrYkhEytlBOuUpgAqJy0kSZFtkAGXDsGXLEaGO2YpBgjcaLHYcT8ceIQO2HtE
	 zzJ55H4u8LlhsMZe4oOjbEMA2CenvajVS/LuMaGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 242/301] btrfs: set correct ram_bytes when splitting ordered extent
Date: Tue, 14 May 2024 12:18:33 +0200
Message-ID: <20240514101041.391256783@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

commit 63a6ce5a1a6261e4c70bad2b55c4e0de8da4762e upstream.

[BUG]
When running generic/287, the following file extent items can be
generated:

        item 16 key (258 EXTENT_DATA 2682880) itemoff 15305 itemsize 53
                generation 9 type 1 (regular)
                extent data disk byte 1378414592 nr 462848
                extent data offset 0 nr 462848 ram 2097152
                extent compression 0 (none)

Note that file extent item is not a compressed one, but its ram_bytes is
way larger than its disk_num_bytes.

According to btrfs on-disk scheme, ram_bytes should match disk_num_bytes
if it's not a compressed one.

[CAUSE]
Since commit b73a6fd1b1ef ("btrfs: split partial dio bios before
submit"), for partial dio writes, we would split the ordered extent.

However the function btrfs_split_ordered_extent() doesn't update the
ram_bytes even it has already shrunk the disk_num_bytes.

Originally the function btrfs_split_ordered_extent() is only introduced
for zoned devices in commit d22002fd37bd ("btrfs: zoned: split ordered
extent when bio is sent"), but later commit b73a6fd1b1ef ("btrfs: split
partial dio bios before submit") makes non-zoned btrfs affected.

Thankfully for un-compressed file extent, we do not really utilize the
ram_bytes member, thus it won't cause any real problem.

[FIX]
Also update btrfs_ordered_extent::ram_bytes inside
btrfs_split_ordered_extent().

Fixes: d22002fd37bd ("btrfs: zoned: split ordered extent when bio is sent")
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ordered-data.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -1202,6 +1202,7 @@ struct btrfs_ordered_extent *btrfs_split
 	ordered->disk_bytenr += len;
 	ordered->num_bytes -= len;
 	ordered->disk_num_bytes -= len;
+	ordered->ram_bytes -= len;
 
 	if (test_bit(BTRFS_ORDERED_IO_DONE, &ordered->flags)) {
 		ASSERT(ordered->bytes_left == 0);


