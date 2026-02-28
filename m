Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890F743636C
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301193; cv=none; b=ME/VkixbDcEqTjrjAkrFsxTryBpUgpcG3APoXiC7/WMBuA3z6bFLfCGkf5skRsb27e0fldCLqArntxvAeIDktP3QOYtZfmqYpZMw3bFbmfq+JCFQ3YuO6kEqCs4Fe7QxjeHhhiTpF9YO35628qD6aK2GxKnWfmIJWjhld/DBcdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301193; c=relaxed/simple;
	bh=FLhThxezrkVeSLFk+QT4Gl5v0YHSUUfuXiFPZvmQPsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z9nkV7xbbtagk0Tf6n6QmYnvBtN1XhXcwv/WmwUrMQ6SwMBcXGiS9+Tk2zOMGtOj5NZHencNjxF6yqLD8v16Rq9ZO3m9urWJboeioVRgwrB2KIU0AWrg3mGGKUEK4NzOh+pCM2ovDkDQZh/SfVxleKZ4FxaZaw5Jc4T/QNFqSac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pawUw8RD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pawUw8RD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D760BC116D0;
	Sat, 28 Feb 2026 17:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301193;
	bh=FLhThxezrkVeSLFk+QT4Gl5v0YHSUUfuXiFPZvmQPsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pawUw8RDO23bFOWs1IscnAE+ZNlsCAcqkBK30UyvJyixZL12a4v2vJrZs0L7GRVOq
	 61nM6XsCw4Xx5yNFGu38ikVDpsKespkiVSYmEAwwhWt3Spoe4VGW9xgmz20kYrEI+F
	 irstR8/T7AUxkbuFNuePFPrFJTyjSvARup9la5viPJO36WQUpEJv/pitNYCbcFGlrk
	 5ANMKkB3KhF6JJICXStUSnBmPTdJEI6N2YSAUmb3gnDnC5aYxyCZF0m00nSLxO3XpI
	 IFhnqKOh78gYQY9tQTrCLOckGfIYDGicXiqHqn3cHwG28k6MqJBV4f2QeulL8qVOJs
	 7KaPZ9TkN+gaA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: ethanwu <ethanwu@synology.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 364/752] ceph: supply snapshot context in ceph_uninline_data()
Date: Sat, 28 Feb 2026 12:41:15 -0500
Message-ID: <20260228174750.1542406-364-sashal@kernel.org>
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

From: ethanwu <ethanwu@synology.com>

[ Upstream commit 305ff6b3a03c230d3c07b61457e961406d979693 ]

The ceph_uninline_data function was missing proper snapshot context
handling for its OSD write operations. Both CEPH_OSD_OP_CREATE and
CEPH_OSD_OP_WRITE requests were passing NULL instead of the appropriate
snapshot context, which could lead to unnecessary object clone.

Reproducer:
../src/vstart.sh --new -x --localhost --bluestore
// turn on cephfs inline data
./bin/ceph fs set a inline_data true --yes-i-really-really-mean-it
// allow fs_a client to take snapshot
./bin/ceph auth caps client.fs_a mds 'allow rwps fsname=a' mon 'allow r fsname=a' osd 'allow rw tag cephfs data=a'
// mount cephfs with fuse, since kernel cephfs doesn't support inline write
ceph-fuse --id fs_a -m 127.0.0.1:40318 --conf ceph.conf -d /mnt/mycephfs/
// bump snapshot seq
mkdir /mnt/mycephfs/.snap/snap1
echo "foo" > /mnt/mycephfs/test
// umount and mount it again using kernel cephfs client
umount /mnt/mycephfs
mount -t ceph fs_a@.a=/ /mnt/mycephfs/ -o conf=./ceph.conf
echo "bar" >> /mnt/mycephfs/test
./bin/rados listsnaps -p cephfs.a.data $(printf "%x\n" $(stat -c %i /mnt/mycephfs/test)).00000000

will see this object does unnecessary clone
1000000000a.00000000 (seq:2):
cloneid snaps   size    overlap
2       2       4       []
head    -       8

but it's expected to see
10000000000.00000000 (seq:2):
cloneid snaps   size    overlap
head    -       8

since there's no snapshot between these 2 writes

clone happened because the first osd request CEPH_OSD_OP_CREATE doesn't
pass snap context so object is created with snap seq 0, but later data
writeback is equipped with snapshot context.
snap.seq(1) > object snap seq(0), so osd does object clone.

This fix properly acquiring the snapshot context before performing
write operations.

Signed-off-by: ethanwu <ethanwu@synology.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Tested-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 322ed268f14aa..9faeaf1196c5c 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -2203,6 +2203,7 @@ int ceph_uninline_data(struct file *file)
 	struct ceph_osd_request *req = NULL;
 	struct ceph_cap_flush *prealloc_cf = NULL;
 	struct folio *folio = NULL;
+	struct ceph_snap_context *snapc = NULL;
 	u64 inline_version = CEPH_INLINE_NONE;
 	struct page *pages[1];
 	int err = 0;
@@ -2230,6 +2231,24 @@ int ceph_uninline_data(struct file *file)
 	if (inline_version == 1) /* initial version, no data */
 		goto out_uninline;
 
+	down_read(&fsc->mdsc->snap_rwsem);
+	spin_lock(&ci->i_ceph_lock);
+	if (__ceph_have_pending_cap_snap(ci)) {
+		struct ceph_cap_snap *capsnap =
+				list_last_entry(&ci->i_cap_snaps,
+						struct ceph_cap_snap,
+						ci_item);
+		snapc = ceph_get_snap_context(capsnap->context);
+	} else {
+		if (!ci->i_head_snapc) {
+			ci->i_head_snapc = ceph_get_snap_context(
+				ci->i_snap_realm->cached_context);
+		}
+		snapc = ceph_get_snap_context(ci->i_head_snapc);
+	}
+	spin_unlock(&ci->i_ceph_lock);
+	up_read(&fsc->mdsc->snap_rwsem);
+
 	folio = read_mapping_folio(inode->i_mapping, 0, file);
 	if (IS_ERR(folio)) {
 		err = PTR_ERR(folio);
@@ -2245,7 +2264,7 @@ int ceph_uninline_data(struct file *file)
 	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout,
 				    ceph_vino(inode), 0, &len, 0, 1,
 				    CEPH_OSD_OP_CREATE, CEPH_OSD_FLAG_WRITE,
-				    NULL, 0, 0, false);
+				    snapc, 0, 0, false);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
 		goto out_unlock;
@@ -2261,7 +2280,7 @@ int ceph_uninline_data(struct file *file)
 	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout,
 				    ceph_vino(inode), 0, &len, 1, 3,
 				    CEPH_OSD_OP_WRITE, CEPH_OSD_FLAG_WRITE,
-				    NULL, ci->i_truncate_seq,
+				    snapc, ci->i_truncate_seq,
 				    ci->i_truncate_size, false);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
@@ -2324,6 +2343,7 @@ int ceph_uninline_data(struct file *file)
 		folio_put(folio);
 	}
 out:
+	ceph_put_snap_context(snapc);
 	ceph_free_cap_flush(prealloc_cf);
 	doutc(cl, "%llx.%llx inline_version %llu = %d\n",
 	      ceph_vinop(inode), inline_version, err);
-- 
2.51.0

