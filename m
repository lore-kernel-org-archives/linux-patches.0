Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8011D12A;
	Mon, 18 Dec 2023 14:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xjnow/XQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C72C433C7;
	Mon, 18 Dec 2023 14:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908347;
	bh=gmd7m+gXJbUQ0fd/yFnGzvc/kLqGl7m8Ax0IOHCGvyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xjnow/XQlXnax5fcl6PB5sBgdJ7zAPALTFH8Gn75qDeQXcdxn+8EwPawwyDDLrUzg
	 hQJ71jbq9HGrf7U7mehM+ZG58Jfs1DywN/yGVPH9FAa+0TVWnmTH8ipBxal9nfQPON
	 miV3wEtoNlyjmWCz0wo1a4xJB6Py0pqwtCws/rs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 143/166] btrfs: free qgroup reserve when ORDERED_IOERR is set
Date: Mon, 18 Dec 2023 14:51:49 +0100
Message-ID: <20231218135111.516196020@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

From: Boris Burkov <boris@bur.io>

commit f63e1164b90b385cd832ff0fdfcfa76c3cc15436 upstream.

An ordered extent completing is a critical moment in qgroup reserve
handling, as the ownership of the reservation is handed off from the
ordered extent to the delayed ref. In the happy path we release (unlock)
but do not free (decrement counter) the reservation, and the delayed ref
drives the free. However, on an error, we don't create a delayed ref,
since there is no ref to add. Therefore, free on the error path.

CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ordered-data.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -603,7 +603,9 @@ void btrfs_remove_ordered_extent(struct
 			release = entry->disk_num_bytes;
 		else
 			release = entry->num_bytes;
-		btrfs_delalloc_release_metadata(btrfs_inode, release, false);
+		btrfs_delalloc_release_metadata(btrfs_inode, release,
+						test_bit(BTRFS_ORDERED_IOERR,
+							 &entry->flags));
 	}
 
 	percpu_counter_add_batch(&fs_info->ordered_bytes, -entry->num_bytes,


