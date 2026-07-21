Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F148B46C4B1;
	Tue, 21 Jul 2026 15:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649355; cv=none; b=mtG9ThgMRVyE5cFE66y9blS60vDku1aBwdZFfmhDe+ECPXF0FlObEmBdlHo7CagrbTOTtUs8oZRZ9T1KY0Kbrr3l2a+DEArTRDW/fHyB4ppn60IZ7Ls+zbNwfgpRQB04FbCAYl/4UN1zQdJzhKignNKzmALsOIAFyH190FnvvgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649355; c=relaxed/simple;
	bh=najQ70ls0Di1ZGIIQbZX/8y6j//l/ICcVXK/nlVGwM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cdwCWzhPECW+zCqMdKobZF5+UqiAGH4ijlEoIJxvQhxFZtm7JY38uh4Z4rl5IoVN91fjhwfk8o+zG6doBfhQyDh1WGl4FJ5IEH7r08bPFgEg9uEHZ1l+rKU6y5Ym/Ap/L8KyzoCgeFZcEQh3Wl/GRgXczKiS027bfG3CT+CwxaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TdOd4jQ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TdOd4jQ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B5D1F00A3A;
	Tue, 21 Jul 2026 15:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649352;
	bh=BFSxPvTBUgQfqbYCg80IItLbw/pdSeI38y8KF+vA2rY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TdOd4jQ9Fl1BwR8mmXzGUTFgbrBEgn1UuiE2Asv8OQnOt3IXMXpMFoAlcQcFyJFmj
	 bqKCm/4R+LW2uqYaBAx/0laOUDfMc6EzHIaWikM+Y58kx1uNiRaOFSK+lB5ecXupTl
	 tmHyJR5Quel3dG3/TsZzDiszyQgUpmG2O7CbVhVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Harmstone <mark@harmstone.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0544/2077] btrfs: dont force DIO writes to be serialized
Date: Tue, 21 Jul 2026 17:03:37 +0200
Message-ID: <20260721152605.640966624@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Harmstone <mark@harmstone.com>

[ Upstream commit 14f9161e872072075284b8afa4c3f929e199a0f6 ]

Before btrfs switched to the new mount API in 2023, we were setting
SB_NOSEC in btrfs_mount_root(). This flag tells the VFS that the
filesystem may have files which don't have security xattrs, enabling it
to do some optimizations.

Unfortunately this was missed in the transition, meaning that IS_NOSEC
will always return false for a btrfs inode. This means that
btrfs_direct_write() calls will always get the inode lock exclusively,
meaning that DIO writes to the same file will be serialized.

On my machine, this one-line change results in a ~59% improvement in DIO
throughput:

Before patch:

  test: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=io_uring, iodepth=64
  ...
  fio-3.39
  Starting 32 processes
  test: Laying out IO file (1 file / 1024MiB)
  Jobs: 32 (f=32): [w(32)][100.0%][w=764MiB/s][w=195k IOPS][eta 00m:00s]
  test: (groupid=0, jobs=32): err= 0: pid=586: Wed Apr 22 13:03:04 2026
    write: IOPS=202k, BW=787MiB/s (826MB/s)(46.1GiB/60012msec); 0 zone resets
     bw (  KiB/s): min=498714, max=1199892, per=100.00%, avg=806659.03, stdev=4229.94, samples=3808
     iops        : min=124677, max=299971, avg=201661.82, stdev=1057.49, samples=3808
    cpu          : usr=0.32%, sys=1.27%, ctx=8329204, majf=0, minf=1163
    IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=100.0%
       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
       complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
       issued rwts: total=0,12094328,0,0 short=0,0,0,0 dropped=0,0,0,0
       latency   : target=0, window=0, percentile=100.00%, depth=64

  Run status group 0 (all jobs):
    WRITE: bw=787MiB/s (826MB/s), 787MiB/s-787MiB/s (826MB/s-826MB/s), io=46.1GiB (49.5GB), run=60012-60012msec

After patch:

  test: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=io_uring, iodepth=64
  ...
  fio-3.39
  Starting 32 processes
  test: Laying out IO file (1 file / 1024MiB)
  Jobs: 32 (f=32): [w(32)][100.0%][w=1255MiB/s][w=321k IOPS][eta 00m:00s]
  test: (groupid=0, jobs=32): err= 0: pid=572: Wed Apr 22 13:13:46 2026
    write: IOPS=320k, BW=1250MiB/s (1311MB/s)(73.3GiB/60003msec); 0 zone resets
     bw (  MiB/s): min=  619, max= 2289, per=100.00%, avg=1251.28, stdev= 9.64, samples=3808
     iops        : min=158538, max=586025, avg=320320.80, stdev=2468.97, samples=3808
    cpu          : usr=0.35%, sys=11.50%, ctx=1584847, majf=0, minf=1160
    IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=100.0%
       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
       complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, >=64=0.0%
       issued rwts: total=0,19203309,0,0 short=0,0,0,0 dropped=0,0,0,0
       latency   : target=0, window=0, percentile=100.00%, depth=64

  Run status group 0 (all jobs):
    WRITE: bw=1250MiB/s (1311MB/s), 1250MiB/s-1250MiB/s (1311MB/s-1311MB/s), io=73.3GiB (78.7GB), run=60003-60003msec

The script to reproduce that:

  #!/bin/bash
  mkfs.btrfs -f /dev/nvme0n1
  mount /dev/nvme0n1 /mnt/test
  mkdir /mnt/test/nocow
  chattr +C /mnt/test/nocow
  fio /root/test.fio

  # cat /root/test.fio
  [global]
  rw=randwrite
  ioengine=io_uring
  iodepth=64
  size=1g
  direct=1
  startdelay=20
  force_async=4
  ramp_time=5
  runtime=60
  group_reporting=1
  numjobs=32
  time_based
  disk_util=0
  clat_percentiles=0
  disable_lat=1
  disable_clat=1
  disable_slat=1
  filename=/mnt/test/nocow/fiofile
  [test]
  name=test
  bs=4k
  stonewall

This was on a VM with 8 cores and 8GB of RAM, with a real NVMe exposed
through PCI passthrough. The figures for XFS and ext4 in comparison are
both about ~3GB/s.

Fixes: ad21f15b0f79 ("btrfs: switch to the new mount API")
Signed-off-by: Mark Harmstone <mark@harmstone.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b26aa9169e8388..64514d600eec71 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1873,6 +1873,7 @@ static int btrfs_get_tree_super(struct fs_context *fc)
 	fs_info->fs_devices = fs_devices;
 	mutex_unlock(&uuid_mutex);
 
+	fc->sb_flags |= SB_NOSEC;
 
 	sb = sget_fc(fc, btrfs_fc_test_super, set_anon_super_fc);
 	if (IS_ERR(sb)) {
-- 
2.53.0



