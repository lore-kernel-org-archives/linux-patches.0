Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA6FFBFD
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:06:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271BCC4339C;
	Mon, 15 May 2023 17:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170374;
	bh=4WoCIRYarhKRg3t4I+aMszyQ+wLDNX7DJUp8huWSEhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PuVtfNqxQi74e4K1guqMiw8abHv+E3gvXeAkat9eISBsGuaUBJsZalLEqXddr3cNU
	 tfRRiN6cT0+WXMQRenr1bjDvFQHsizJbYgBMsUYnQCPgaQorII7z5fdXGM2T5Sx+ze
	 wQTOHxHDH7+77kmGX5ASq0IM8T5BvQG6HcyZEbA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 111/239] btrfs: properly reject clear_cache and v1 cache for block-group-tree
Date: Mon, 15 May 2023 18:26:14 +0200
Message-Id: <20230515161725.028354035@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qu Wenruo <wqu@suse.com>

commit 64b5d5b2852661284ccbb038c697562cc56231bf upstream.

[BUG]
With block-group-tree feature enabled, mounting it with clear_cache
would cause the following transaction abort at mount or remount:

  BTRFS info (device dm-4): force clearing of disk cache
  BTRFS info (device dm-4): using free space tree
  BTRFS info (device dm-4): auto enabling async discard
  BTRFS info (device dm-4): clearing free space tree
  BTRFS info (device dm-4): clearing compat-ro feature flag for FREE_SPACE_TREE (0x1)
  BTRFS info (device dm-4): clearing compat-ro feature flag for FREE_SPACE_TREE_VALID (0x2)
  BTRFS error (device dm-4): block-group-tree feature requires fres-space-tree and no-holes
  BTRFS error (device dm-4): super block corruption detected before writing it to disk
  BTRFS: error (device dm-4) in write_all_supers:4288: errno=-117 Filesystem corrupted (unexpected superblock corruption detected)
  BTRFS warning (device dm-4: state E): Skipping commit of aborted transaction.

[CAUSE]
For block-group-tree feature, we have an artificial dependency on
free-space-tree.

This means if we detect block-group-tree without v2 cache, we consider
it a corruption and cause the problem.

For clear_cache mount option, it would temporary disable v2 cache, then
re-enable it.

But unfortunately for that temporary v2 cache disabled status, we refuse
to write a superblock with bg tree only flag, thus leads to the above
transaction abortion.

[FIX]
For now, just reject clear_cache and v1 cache mount option for block
group tree.  So now we got a graceful rejection other than a transaction
abort:

  BTRFS info (device dm-4): force clearing of disk cache
  BTRFS error (device dm-4): cannot disable free space tree with block-group-tree feature
  BTRFS error (device dm-4): open_ctree failed

CC: stable@vger.kernel.org # 6.1+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/super.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1136,7 +1136,12 @@ out:
 	    !btrfs_test_opt(info, CLEAR_CACHE)) {
 		btrfs_err(info, "cannot disable free space tree");
 		ret = -EINVAL;
-
+	}
+	if (btrfs_fs_compat_ro(info, BLOCK_GROUP_TREE) &&
+	    (btrfs_test_opt(info, CLEAR_CACHE) ||
+	     !btrfs_test_opt(info, FREE_SPACE_TREE))) {
+		btrfs_err(info, "cannot disable free space tree with block-group-tree feature");
+		ret = -EINVAL;
 	}
 	if (!ret)
 		ret = btrfs_check_mountopts_zoned(info);


