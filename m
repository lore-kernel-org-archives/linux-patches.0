Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11A714AD15;
	Tue, 20 Feb 2024 21:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463328; cv=none; b=LmfvwjFNqIltYzsdQU6ab6jOGnAy8ooma/3ykiaR8Te7Uyqq+4zMOWvqY/iVLucmVm6CcriuG33xY1pAcYvsExlAwWXtI0yuRws/Vrsr/pHkywrg/j/yIarnzvhvXStvcUx8gSgohrkkJb98KQV02b36vxo++RaJ6o4EfZiP+nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463328; c=relaxed/simple;
	bh=INLJzwVC1Yb1+KUpcLhLDSfgp3GIcKaY2gzaWJ4AINg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEPLzTM4neR4U2iPRczyRq6Kh0BaBhTofDoaVAahjnofeHfhE3o/ObxQGxt9q2RHAxrTWeqhZvIowN0K1TNjNJVfik0kjKWgMYRCAnRa8MbB4W+NA2qX14T/7Yqem9jrM6/dIuzjItXlXtK+oepSut3jJQll4Faf9CGTPHRpSHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Im3lIoKq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Im3lIoKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80D6C433F1;
	Tue, 20 Feb 2024 21:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463328;
	bh=INLJzwVC1Yb1+KUpcLhLDSfgp3GIcKaY2gzaWJ4AINg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Im3lIoKqLuDdeehk1Mq5ano8yJtgOQqJKhdY11V1XwbPh0dwI8BDe12TvgwMLo1hf
	 vu5AAjrRSjEKUJH6b0T1NheFAltLBTtLRpbLa3Mt+63JrQ8WaPAZR9twIrvRHX6DTM
	 EGkXqqf1BdUuNgAo1f67KVbgcpAsVYTaQOSy6miE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 010/331] btrfs: reject encoded write if inode has nodatasum flag set
Date: Tue, 20 Feb 2024 21:52:06 +0100
Message-ID: <20240220205637.907782006@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

commit 1bd96c92c6a0a4d43815eb685c15aa4b78879dc9 upstream.

Currently we allow an encoded write against inodes that have the NODATASUM
flag set, either because they are NOCOW files or they were created while
the filesystem was mounted with "-o nodatasum". This results in having
compressed extents without corresponding checksums, which is a filesystem
inconsistency reported by 'btrfs check'.

For example, running btrfs/281 with MOUNT_OPTIONS="-o nodatacow" triggers
this and 'btrfs check' errors out with:

   [1/7] checking root items
   [2/7] checking extents
   [3/7] checking free space tree
   [4/7] checking fs roots
   root 256 inode 257 errors 1040, bad file extent, some csum missing
   root 256 inode 258 errors 1040, bad file extent, some csum missing
   ERROR: errors found in fs roots
   (...)

So reject encoded writes if the target inode has NODATASUM set.

CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10223,6 +10223,13 @@ ssize_t btrfs_do_encoded_write(struct ki
 	if (encoded->encryption != BTRFS_ENCODED_IO_ENCRYPTION_NONE)
 		return -EINVAL;
 
+	/*
+	 * Compressed extents should always have checksums, so error out if we
+	 * have a NOCOW file or inode was created while mounted with NODATASUM.
+	 */
+	if (inode->flags & BTRFS_INODE_NODATASUM)
+		return -EINVAL;
+
 	orig_count = iov_iter_count(from);
 
 	/* The extent size must be sane. */


