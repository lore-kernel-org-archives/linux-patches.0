Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9680635A280;
	Mon, 18 Aug 2025 14:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526432; cv=none; b=KV2Q8Jif/wFlbxAxhi8TOcveXbaRLgqOYCkEKgEOQmxXSwF01QRVDg+uLYjDxLdeRAfDK7Uv1rDZoBgtVhrWzUFR0VPa7SZ+HGWRqt80OuxXt6WYuWESj/eJGKgk2gIX5HfgJ5jkYhBDw082MjFtaykZbSVPJxlt1YRNazLSeGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526432; c=relaxed/simple;
	bh=Y7OYnH8oZU87ZVDbm2aYYeEnNOWotlyUQSl4KZ2T+Gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bvw4j+WgSPJ408RkWz99dlrzgONWsJsm06DkCikk+67RXqQVGQH5JK5EbgPmlR7K3YXNA2XzSRRSVcgDFx3xmEJaABFau/yLJISA+fzuD3UkcD393kyvd8OutXdncrnGo9VvpjMSHXnJlURldjZYWDGJ3k3rHNspbVyBAG4Ps7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SjubLw5K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SjubLw5K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DDFC4CEEB;
	Mon, 18 Aug 2025 14:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526432;
	bh=Y7OYnH8oZU87ZVDbm2aYYeEnNOWotlyUQSl4KZ2T+Gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SjubLw5KFVMOKxfC3ciLJYiNek7Tcd3kHeCCSoRoO5knP/L9nXRxZt6gDD+XYO45p
	 bgcNZFpul0dOIwz68pxWCG+O9KFz6irTuRkul8uENgBsPaBYkqsyCczQeSAgCn/uyt
	 aFWTRnLbA3B4xSTYWeMRdDGqEDSc75kL88ktuCL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.16 521/570] btrfs: populate otime when logging an inode item
Date: Mon, 18 Aug 2025 14:48:28 +0200
Message-ID: <20250818124525.938470405@linuxfoundation.org>
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

commit 1ef94169db0958d6de39f9ea6e063ce887342e2d upstream.

[TEST FAILURE WITH EXPERIMENTAL FEATURES]
When running test case generic/508, the test case will fail with the new
btrfs shutdown support:

generic/508       - output mismatch (see /home/adam/xfstests/results//generic/508.out.bad)
#    --- tests/generic/508.out	2022-05-11 11:25:30.806666664 +0930
#    +++ /home/adam/xfstests/results//generic/508.out.bad	2025-07-02 14:53:22.401824212 +0930
#    @@ -1,2 +1,6 @@
#     QA output created by 508
#     Silence is golden
#    +Before:
#    +After : stat.btime = Thu Jan  1 09:30:00 1970
#    +Before:
#    +After : stat.btime = Wed Jul  2 14:53:22 2025
#    ...
#    (Run 'diff -u /home/adam/xfstests/tests/generic/508.out /home/adam/xfstests/results//generic/508.out.bad'  to see the entire diff)
Ran: generic/508
Failures: generic/508
Failed 1 of 1 tests

Please note that the test case requires shutdown support, thus the test
case will be skipped using the current upstream kernel, as it doesn't
have shutdown ioctl support.

[CAUSE]
The direct cause the 0 time stamp in the log tree:

leaf 30507008 items 2 free space 16057 generation 9 owner TREE_LOG
leaf 30507008 flags 0x1(WRITTEN) backref revision 1
checksum stored e522548d
checksum calced e522548d
fs uuid 57d45451-481e-43e4-aa93-289ad707a3a0
chunk uuid d52bd3fd-5163-4337-98a7-7986993ad398
	item 0 key (257 INODE_ITEM 0) itemoff 16123 itemsize 160
		generation 9 transid 9 size 0 nbytes 0
		block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0
		sequence 1 flags 0x0(none)
		atime 1751432947.492000000 (2025-07-02 14:39:07)
		ctime 1751432947.492000000 (2025-07-02 14:39:07)
		mtime 1751432947.492000000 (2025-07-02 14:39:07)
		otime 0.0 (1970-01-01 09:30:00) <<<

But the old fs tree has all the correct time stamp:

btrfs-progs v6.12
fs tree key (FS_TREE ROOT_ITEM 0)
leaf 30425088 items 2 free space 16061 generation 5 owner FS_TREE
leaf 30425088 flags 0x1(WRITTEN) backref revision 1
checksum stored 48f6c57e
checksum calced 48f6c57e
fs uuid 57d45451-481e-43e4-aa93-289ad707a3a0
chunk uuid d52bd3fd-5163-4337-98a7-7986993ad398
	item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
		generation 3 transid 0 size 0 nbytes 16384
		block group 0 mode 40755 links 1 uid 0 gid 0 rdev 0
		sequence 0 flags 0x0(none)
		atime 1751432947.0 (2025-07-02 14:39:07)
		ctime 1751432947.0 (2025-07-02 14:39:07)
		mtime 1751432947.0 (2025-07-02 14:39:07)
		otime 1751432947.0 (2025-07-02 14:39:07) <<<

The root cause is that fill_inode_item() in tree-log.c is only
populating a/c/m time, not the otime (or btime in statx output).

Part of the reason is that, the vfs inode only has a/c/m time, no native
btime support yet.

[FIX]
Thankfully btrfs has its otime stored in btrfs_inode::i_otime_sec and
btrfs_inode::i_otime_nsec.

So what we really need is just fill the otime time stamp in
fill_inode_item() of tree-log.c

There is another fill_inode_item() in inode.c, which is doing the proper
otime population.

Fixes: 94edf4ae43a5 ("Btrfs: don't bother committing delayed inode updates when fsyncing")
CC: stable@vger.kernel.org
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4221,6 +4221,9 @@ static void fill_inode_item(struct btrfs
 	btrfs_set_token_timespec_nsec(&token, &item->ctime,
 				      inode_get_ctime_nsec(inode));
 
+	btrfs_set_timespec_sec(leaf, &item->otime, BTRFS_I(inode)->i_otime_sec);
+	btrfs_set_timespec_nsec(leaf, &item->otime, BTRFS_I(inode)->i_otime_nsec);
+
 	/*
 	 * We do not need to set the nbytes field, in fact during a fast fsync
 	 * its value may not even be correct, since a fast fsync does not wait


