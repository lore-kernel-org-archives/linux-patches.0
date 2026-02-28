Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C557342146;
	Sat, 28 Feb 2026 17:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301499; cv=none; b=mvnkXC4t/P/VDbJibQeWZi4sZIh3ZoAYRLlq3zipIjiDijaQF91YSUcl/tq0PeAf3bVIeYdSWus90J+bBhy5tqRhjGFCe9MUVp/DdxoTdyEhoMu66Cz4Wmfx/E3PpZO9VRAvYvVCPvU5aOmudnQAGy5OJo7ssysdOwv4cEInESU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301499; c=relaxed/simple;
	bh=NHWBKgLnuZz203UKff6k05JnAybLBmhPGgpcQK1TCyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imXUQQKFmeJ/EMnLKnvtw9VXuZoqK18l/sYQyxQQ2+jcaXYqRtJ62uqzvKmid+kVnl5VFWjei7MN0z/QenGykJQALWQoZEWlamR4/I4kmkz6J+ZDvMU0urog5/OjbIaXLWBQIED/WMsxMPJwIMMYagxu28ovd7Tl0iC/cljW+0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EVMx05Tw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EVMx05Tw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D9AC19423;
	Sat, 28 Feb 2026 17:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301499;
	bh=NHWBKgLnuZz203UKff6k05JnAybLBmhPGgpcQK1TCyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EVMx05Tw9AYBgdGqvH7UVLtMudX0724sDEiNKfWwMCbcTANAnFtNrrH41x17X12YR
	 JwrOnKG4qNu7lNjcEZ0IF3aY+lJuS4WySFjL7vrO673l3TwRtEMJKxpG2YFQ1Al+EA
	 LrGgwsgXlUWGGKezNWy7rdEoMlEP7PIg4bkHbwkR7Ib1uugAQC0YKf1AV8dJN7I9PC
	 qVO9+eOgGhD5Rlvy1eybq4ndiAxFs1i2qoMI1Wg8mhkaIOuhpzOSIRVLmKTLsOFuU5
	 q8OHii4ny57J3ANoMGhzfR3LFtO7fNOWGLknNSb1zstruRFznzwgwCDYbLTf6Mc/vj
	 choIPq86z3C4Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: ethanwu <ethanwu@synology.com>,
	stable@vger.kernel.org,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 683/752] ceph: supply snapshot context in ceph_zero_partial_object()
Date: Sat, 28 Feb 2026 12:46:34 -0500
Message-ID: <20260228174750.1542406-683-sashal@kernel.org>
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

[ Upstream commit f16bd3fa74a2084ee7e16a8a2be7e7399b970907 ]

The ceph_zero_partial_object function was missing proper snapshot
context for its OSD write operations, which could lead to data
inconsistencies in snapshots.

Reproducer:
../src/vstart.sh --new -x --localhost --bluestore
./bin/ceph auth caps client.fs_a mds 'allow rwps fsname=a' mon 'allow r fsname=a' osd 'allow rw tag cephfs data=a'
mount -t ceph fs_a@.a=/ /mnt/mycephfs/ -o conf=./ceph.conf
dd if=/dev/urandom of=/mnt/mycephfs/foo bs=64K count=1
mkdir /mnt/mycephfs/.snap/snap1
md5sum /mnt/mycephfs/.snap/snap1/foo
fallocate -p -o 0 -l 4096 /mnt/mycephfs/foo
echo 3 > /proc/sys/vm/drop/caches
md5sum /mnt/mycephfs/.snap/snap1/foo # get different md5sum!!

Cc: stable@vger.kernel.org
Fixes: ad7a60de882ac ("ceph: punch hole support")
Signed-off-by: ethanwu <ethanwu@synology.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Tested-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/file.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 99b30f784ee24..f43a42909e7cf 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2568,6 +2568,7 @@ static int ceph_zero_partial_object(struct inode *inode,
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_fs_client(inode);
 	struct ceph_osd_request *req;
+	struct ceph_snap_context *snapc;
 	int ret = 0;
 	loff_t zero = 0;
 	int op;
@@ -2582,12 +2583,25 @@ static int ceph_zero_partial_object(struct inode *inode,
 		op = CEPH_OSD_OP_ZERO;
 	}
 
+	spin_lock(&ci->i_ceph_lock);
+	if (__ceph_have_pending_cap_snap(ci)) {
+		struct ceph_cap_snap *capsnap =
+				list_last_entry(&ci->i_cap_snaps,
+						struct ceph_cap_snap,
+						ci_item);
+		snapc = ceph_get_snap_context(capsnap->context);
+	} else {
+		BUG_ON(!ci->i_head_snapc);
+		snapc = ceph_get_snap_context(ci->i_head_snapc);
+	}
+	spin_unlock(&ci->i_ceph_lock);
+
 	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout,
 					ceph_vino(inode),
 					offset, length,
 					0, 1, op,
 					CEPH_OSD_FLAG_WRITE,
-					NULL, 0, 0, false);
+					snapc, 0, 0, false);
 	if (IS_ERR(req)) {
 		ret = PTR_ERR(req);
 		goto out;
@@ -2601,6 +2615,7 @@ static int ceph_zero_partial_object(struct inode *inode,
 	ceph_osdc_put_request(req);
 
 out:
+	ceph_put_snap_context(snapc);
 	return ret;
 }
 
-- 
2.51.0

