Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA0F34405B;
	Fri, 20 Feb 2026 12:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771591098; cv=none; b=ok3pz67S2fp6QOpL8S/R/wqNMhOBb8ZgXjn6K/lMS02rGAQ0JeVehm0bMKgf0lRD9fZcVh3OjsGvyK1UN+eKjMldwvsi1BBdwV868o3a8aAhlNbCQSjnmCw9AuIN2/t+WqmTky5jayZ1oftpW2iysCWF3rHHOh0vOLRoxkWxoao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771591098; c=relaxed/simple;
	bh=pRO9IN213oQrBu+VLwnbbinX8CLsfnTtiFHne3ap5TI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I8he8z3GjJU3BYIdzkxecX7B3Z59w4l+MgIffKxJWkzNf6g0qfpNThBrBUZvT4ZfugOcGGNfwckWrHCHoOtHOeDT5WMYcETsMaJbFglGn0PbOZaRhl3TxTB6S3/9O3Geo+6M+agBscDztbdVpTmcT6HZOlQzKx/+J1RvkZxjmYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pjAhWy00; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pjAhWy00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8387FC116C6;
	Fri, 20 Feb 2026 12:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771591097;
	bh=pRO9IN213oQrBu+VLwnbbinX8CLsfnTtiFHne3ap5TI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pjAhWy006rSSRGnBMng8YkaA6wu/3gYxwbQ64V9xXsIHkYSYh/o6sfPJQdDGGGKGl
	 lJCdUUf0z9QySmD3dkMPwaXoVbl2gP9c5zR63Nvub36Y7pgSaIVJ+gif3+38QTjOJQ
	 u7vziAw5qvg2eARLvyD8924HNM5fo1vCfYbnmJCLurNNVFRnVWH4XpFCC9H5ZReknB
	 Jr60B6VzttGvv1DrzOkwiz4uN8sC6hNkfBi7uCm0GZK0/3PhE0eiJnT+u+FriT/LsG
	 TlRbBUO1ojqnF+eNI3uMwXQDQNDzSVGwU8LDFH6E9zS8uNgmP1GH6NTZ7L+mZr34Ea
	 k2RX884dRkH0Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: ethanwu <ethanwu@synology.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	amarkuze@redhat.com,
	slava@dubeyko.com,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.1] ceph: supply snapshot context in ceph_uninline_data()
Date: Fri, 20 Feb 2026 07:37:56 -0500
Message-ID: <20260220123805.3371698-7-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260220123805.3371698-1-sashal@kernel.org>
References: <20260220123805.3371698-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.3
Content-Type: text/plain; charset=UTF-8
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

LLM Generated explanations, may be completely bogus:

Now I have a comprehensive understanding. Let me also check the
`__ceph_mark_dirty_caps` function which is where `i_head_snapc` normally
gets populated:

The pattern at `caps.c:1813-1817` shows the standard way `i_head_snapc`
gets populated:
```c
if (!ci->i_head_snapc) {
    WARN_ON_ONCE(!rwsem_is_locked(&mdsc->snap_rwsem));
    ci->i_head_snapc = ceph_get_snap_context(
        ci->i_snap_realm->cached_context);
}
```

The fix in `ceph_uninline_data()` uses the same pattern, which confirms
it's correct.

Now let me assess the overall analysis:

## Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit message clearly explains:
- **What**: `ceph_uninline_data()` passes NULL instead of proper
  snapshot context to OSD write operations
- **Why**: This causes unnecessary RADOS object clones when inline data
  is uninlined in the presence of snapshots
- **Reproducer**: A detailed step-by-step reproducer is provided
- **Impact**: Unnecessary object clones (storage waste, incorrect
  snapshot state)

The commit is reviewed and tested by Viacheslav Dubeyko (IBM) and signed
off by Ilya Dryomov (CephFS maintainer).

### 2. CODE CHANGE ANALYSIS

The fix:
1. Adds snapshot context acquisition before OSD write operations
   (following the established pattern from `__ceph_mark_dirty_caps` and
   `ceph_write_begin`)
2. Passes `snapc` instead of NULL to both `CEPH_OSD_OP_CREATE` and
   `CEPH_OSD_OP_WRITE` requests
3. Properly releases the snapshot context reference with
   `ceph_put_snap_context(snapc)` in the cleanup path

The pattern of snapshot context acquisition is identical to what's used
in other CephFS write paths (caps.c:1813-1817, caps.c:2779-2783).

### 3. CLASSIFICATION

This is a **bug fix** - it fixes incorrect behavior where OSD objects
are created with snap_seq=0 instead of the proper snapshot sequence
number, causing unnecessary clones.

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed**: ~20 lines added (very small)
- **Files touched**: 1 (fs/ceph/addr.c)
- **Pattern**: Well-established, used identically in multiple other
  write paths
- **Risk**: Low - the snap context acquisition pattern is battle-tested
  in the CephFS codebase
- **Self-contained**: Yes, no dependencies on other patches

### 5. USER IMPACT

- Affects CephFS users with inline data enabled and snapshots
- The bug causes unnecessary RADOS object clones, leading to:
  - Wasted storage space
  - Incorrect/unexpected snapshot state
  - Could confuse backup/recovery tools that rely on snapshot state

### 6. STABILITY INDICATORS

- Reviewed-by and Tested-by from Viacheslav Dubeyko (IBM)
- Signed-off by CephFS maintainer Ilya Dryomov
- Detailed reproducer provided and verified

### 7. HISTORICAL CONTEXT

The bug was introduced in 2016 by commit `34b759b4a22b0` ("ceph: kill
ceph_empty_snapc") which replaced `ceph_empty_snapc` with NULL, claiming
equivalence. While this was true for message sizing, it meant the
snap_seq sent to OSD became 0 instead of the proper value, causing the
clone issue.

### Concerns

- The bug requires a specific (but documented) configuration: CephFS
  inline data + snapshots
- Inline data is a deprecated feature in CephFS, but still supported and
  used
- The unnecessary clones are a data correctness issue (wrong snapshot
  state) rather than a crash/security issue
- The fix is small, well-tested, and follows established patterns

### Verification

- Verified that commit `305ff6b3a03c2` exists and modifies only
  `fs/ceph/addr.c`
- Verified the snap context acquisition pattern matches
  `caps.c:1813-1817` and `caps.c:2779-2783` (identical pattern)
- Verified that NULL snapc causes `snap_seq=0` to be encoded in OSD
  requests (osd_client.c:2198-2199)
- Verified that `ceph_uninline_data()` is called from `ceph_open()` when
  opening a file with inline data for writing (file.c:242-243)
- Verified the historical context: commit `7b06a826e7c52` (2015) changed
  to `ceph_empty_snapc`, then commit `34b759b4a22b0` (2016) changed to
  NULL, introducing the bug
- Verified the commit is reviewed by Viacheslav Dubeyko and signed off
  by Ilya Dryomov (CephFS maintainer)
- Verified the fix follows the standard lock ordering: `snap_rwsem`
  (read) → `i_ceph_lock` (spin)
- Could NOT verify whether inline_data feature is commonly used in
  production stable kernel environments (unverified)

### Decision

This commit fixes a real bug in CephFS snapshot handling that causes
incorrect RADOS object clones (data correctness issue). The fix is small
(~20 lines), self-contained, follows well-established patterns used
throughout the CephFS codebase, and has been reviewed and tested. The
bug has existed since 2016 and affects all stable kernels. While the
trigger requires inline data + snapshots (a somewhat niche
configuration), the fix is low-risk and addresses incorrect behavior.

**YES**

 fs/ceph/addr.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 63b75d2142102..faecd9025ee9c 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -2199,6 +2199,7 @@ int ceph_uninline_data(struct file *file)
 	struct ceph_osd_request *req = NULL;
 	struct ceph_cap_flush *prealloc_cf = NULL;
 	struct folio *folio = NULL;
+	struct ceph_snap_context *snapc = NULL;
 	u64 inline_version = CEPH_INLINE_NONE;
 	struct page *pages[1];
 	int err = 0;
@@ -2226,6 +2227,24 @@ int ceph_uninline_data(struct file *file)
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
@@ -2241,7 +2260,7 @@ int ceph_uninline_data(struct file *file)
 	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout,
 				    ceph_vino(inode), 0, &len, 0, 1,
 				    CEPH_OSD_OP_CREATE, CEPH_OSD_FLAG_WRITE,
-				    NULL, 0, 0, false);
+				    snapc, 0, 0, false);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
 		goto out_unlock;
@@ -2257,7 +2276,7 @@ int ceph_uninline_data(struct file *file)
 	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout,
 				    ceph_vino(inode), 0, &len, 1, 3,
 				    CEPH_OSD_OP_WRITE, CEPH_OSD_FLAG_WRITE,
-				    NULL, ci->i_truncate_seq,
+				    snapc, ci->i_truncate_seq,
 				    ci->i_truncate_size, false);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
@@ -2320,6 +2339,7 @@ int ceph_uninline_data(struct file *file)
 		folio_put(folio);
 	}
 out:
+	ceph_put_snap_context(snapc);
 	ceph_free_cap_flush(prealloc_cf);
 	doutc(cl, "%llx.%llx inline_version %llu = %d\n",
 	      ceph_vinop(inode), inline_version, err);
-- 
2.51.0

