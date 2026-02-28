Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883A3373157;
	Sat, 28 Feb 2026 17:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301514; cv=none; b=MdRw634tegvjyIN601eB1Eqbc5BzwJslKpacdn/WGma5S9EimfrxG9kuzs8Mg3l13Tm3medN/2/rRkX9Uv2pBxRwbmLs+RIpSMo5tDPQ5Ug2HM/+3XDic4ePGdMCBjbB2Hq1V9y6083F5eMzVpZeIPt175WcQFTd6/IJ+L1ZnJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301514; c=relaxed/simple;
	bh=1cpbWyMS6NRpK4dRYdTs2oHVgJqfBLrbU34ckanq6WM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHmZ3fODqSo7OE+pIvuObcptLbviGuKvtlOPAVlf8YnBcXYcQ6rKnNchbW/17bhx0ciiuIvx4NeCcl4HuKnbHgatWs7t2OCqYZqjCjKHbYe8sd3ViuVHuxACnVXyaF/ft8y9cHKAETydG4a+KhfsDDVLianJMQNabywqfsmols4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C+57QhBW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C+57QhBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2EEEC19424;
	Sat, 28 Feb 2026 17:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301514;
	bh=1cpbWyMS6NRpK4dRYdTs2oHVgJqfBLrbU34ckanq6WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C+57QhBWJAwgdNFT580zOGDVt0BiDnt5VdWhAxDUX9yM7jE3rlj0J2MchJ4WkIWxb
	 VGMychR7z68ikdgjIlvlDNEGSbYD4CQOWb0QpdkGX49ggm2iDb1pBWVJworcLcyInC
	 ut4q1txl9OOC6j3wNG0MVH8x02cKzlCpc97vhx6TpqUt0KnWDytlkPfX2p49Ls2WDV
	 oWHXxr9TS8zrQgMykerHwhNkKufBSi0vvKFW0yTaUXcbo04mApjpn9ZzfPXUk4CQaf
	 qPJEIaMianclhlqNS54nhXrY+kDlWeM2DuRSNw/E4TJSRCGDVuXcae2RvDokGTO3pq
	 0i+777O4k8KWA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sam Edwards <cfsworks@gmail.com>,
	stable@vger.kernel.org,
	Sam Edwards <CFSworks@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 700/752] ceph: fix write storm on fscrypted files
Date: Sat, 28 Feb 2026 12:46:51 -0500
Message-ID: <20260228174750.1542406-700-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sam Edwards <cfsworks@gmail.com>

[ Upstream commit cac190c7674fea71620d754ffcdaaeed7c551dbc ]

CephFS stores file data across multiple RADOS objects. An object is the
atomic unit of storage, so the writeback code must clean only folios
that belong to the same object with each OSD request.

CephFS also supports RAID0-style striping of file contents: if enabled,
each object stores multiple unbroken "stripe units" covering different
portions of the file; if disabled, a "stripe unit" is simply the whole
object. The stripe unit is (usually) reported as the inode's block size.

Though the writeback logic could, in principle, lock all dirty folios
belonging to the same object, its current design is to lock only a
single stripe unit at a time. Ever since this code was first written,
it has determined this size by checking the inode's block size.
However, the relatively-new fscrypt support needed to reduce the block
size for encrypted inodes to the crypto block size (see 'fixes' commit),
which causes an unnecessarily high number of write operations (~1024x as
many, with 4MiB objects) and correspondingly degraded performance.

Fix this (and clarify intent) by using i_layout.stripe_unit directly in
ceph_define_write_size() so that encrypted inodes are written back with
the same number of operations as if they were unencrypted.

This patch depends on the preceding commit ("ceph: do not propagate page
array emplacement errors as batch errors") for correctness. While it
applies cleanly on its own, applying it alone will introduce a
regression. This dependency is only relevant for kernels where
ce80b76dd327 ("ceph: introduce ceph_process_folio_batch() method") has
been applied; stable kernels without that commit are unaffected.

Cc: stable@vger.kernel.org
Fixes: 94af0470924c ("ceph: add some fscrypt guardrails")
Signed-off-by: Sam Edwards <CFSworks@gmail.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 32447023615a0..261f8996abc0f 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1000,7 +1000,8 @@ unsigned int ceph_define_write_size(struct address_space *mapping)
 {
 	struct inode *inode = mapping->host;
 	struct ceph_fs_client *fsc = ceph_inode_to_fs_client(inode);
-	unsigned int wsize = i_blocksize(inode);
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	unsigned int wsize = ci->i_layout.stripe_unit;
 
 	if (fsc->mount_options->wsize < wsize)
 		wsize = fsc->mount_options->wsize;
-- 
2.51.0

