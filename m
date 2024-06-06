Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324F4198E71;
	Thu,  6 Jun 2024 14:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683453; cv=none; b=Q0mlidrfw8hvLrouxsfPFCK5GMiWT0Xo7pfYciPQ/CuFEyCwXC5eSUW7kRLcazQ7PMtw348piQq2C2N1olWd1qbh4pLMLZ7SqMN88M47PxSoU8Rb4u55lcUQclUWjBzRYBOZ+AqT98PlczE6Gmj2no6D1jkQb3jCJKw2K9HyP9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683453; c=relaxed/simple;
	bh=fnYyfDtEUr8pi1EQEKuTciHRCTtR/bpHqPJ6xgH5yyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MLi8STyOg0iBh+8KMkEWfK3qwReXkF68pzRvHRPSMn7V42yG4rcwC4Rnz6gvmcJw1xOrAD9K+Ydawuc31auCrji6xW+1IXkhPN1oSkWraQNWv9exZEi/Z2/zDW5XBNy0NL8Gnb8HuKY7Fhiwx2QW2JfnC/4okMe+VDRL3CNWcpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1+ScKOpx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1+ScKOpx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF7EC2BD10;
	Thu,  6 Jun 2024 14:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683451;
	bh=fnYyfDtEUr8pi1EQEKuTciHRCTtR/bpHqPJ6xgH5yyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1+ScKOpxJLqAx9H9YLTQqRz1ir50UPx/ccA8mplofWiR1VFfX6AJlbjYuZqzF/Ue2
	 dxCoV1Dqq8n2H24FqZ6jdX8/B4y1m0gF4Mwm2E7UNqzLQ7kJOABqjp0wrMqsjwu9fD
	 RgN14F0m/fWzaqQtg98URo1XpHHhNObOpcjOu4lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Zhang <yi.zhang@redhat.com>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 395/744] f2fs: multidev: fix to recognize valid zero block address
Date: Thu,  6 Jun 2024 16:01:07 +0200
Message-ID: <20240606131745.129066516@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 33e62cd7b4c281cd737c62e5d8c4f0e602a8c5c5 ]

As reported by Yi Zhang in mailing list [1], kernel warning was catched
during zbd/010 test as below:

./check zbd/010
zbd/010 (test gap zone support with F2FS)                    [failed]
    runtime    ...  3.752s
    something found in dmesg:
    [ 4378.146781] run blktests zbd/010 at 2024-02-18 11:31:13
    [ 4378.192349] null_blk: module loaded
    [ 4378.209860] null_blk: disk nullb0 created
    [ 4378.413285] scsi_debug:sdebug_driver_probe: scsi_debug: trim
poll_queues to 0. poll_q/nr_hw = (0/1)
    [ 4378.422334] scsi host15: scsi_debug: version 0191 [20210520]
                     dev_size_mb=1024, opts=0x0, submit_queues=1, statistics=0
    [ 4378.434922] scsi 15:0:0:0: Direct-Access-ZBC Linux
scsi_debug       0191 PQ: 0 ANSI: 7
    [ 4378.443343] scsi 15:0:0:0: Power-on or device reset occurred
    [ 4378.449371] sd 15:0:0:0: Attached scsi generic sg5 type 20
    [ 4378.449418] sd 15:0:0:0: [sdf] Host-managed zoned block device
    ...
    (See '/mnt/tests/gitlab.com/api/v4/projects/19168116/repository/archive.zip/storage/blktests/blk/blktests/results/nodev/zbd/010.dmesg'

WARNING: CPU: 22 PID: 44011 at fs/iomap/iter.c:51
CPU: 22 PID: 44011 Comm: fio Not tainted 6.8.0-rc3+ #1
RIP: 0010:iomap_iter+0x32b/0x350
Call Trace:
 <TASK>
 __iomap_dio_rw+0x1df/0x830
 f2fs_file_read_iter+0x156/0x3d0 [f2fs]
 aio_read+0x138/0x210
 io_submit_one+0x188/0x8c0
 __x64_sys_io_submit+0x8c/0x1a0
 do_syscall_64+0x86/0x170
 entry_SYSCALL_64_after_hwframe+0x6e/0x76

Shinichiro Kawasaki helps to analyse this issue and proposes a potential
fixing patch in [2].

Quoted from reply of Shinichiro Kawasaki:

"I confirmed that the trigger commit is dbf8e63f48af as Yi reported. I took a
look in the commit, but it looks fine to me. So I thought the cause is not
in the commit diff.

I found the WARN is printed when the f2fs is set up with multiple devices,
and read requests are mapped to the very first block of the second device in the
direct read path. In this case, f2fs_map_blocks() and f2fs_map_blocks_cached()
modify map->m_pblk as the physical block address from each block device. It
becomes zero when it is mapped to the first block of the device. However,
f2fs_iomap_begin() assumes that map->m_pblk is the physical block address of the
whole f2fs, across the all block devices. It compares map->m_pblk against
NULL_ADDR == 0, then go into the unexpected branch and sets the invalid
iomap->length. The WARN catches the invalid iomap->length.

This WARN is printed even for non-zoned block devices, by following steps.

 - Create two (non-zoned) null_blk devices memory backed with 128MB size each:
   nullb0 and nullb1.
 # mkfs.f2fs /dev/nullb0 -c /dev/nullb1
 # mount -t f2fs /dev/nullb0 "${mount_dir}"
 # dd if=/dev/zero of="${mount_dir}/test.dat" bs=1M count=192
 # dd if="${mount_dir}/test.dat" of=/dev/null bs=1M count=192 iflag=direct

..."

So, the root cause of this issue is: when multi-devices feature is on,
f2fs_map_blocks() may return zero blkaddr in non-primary device, which is
a verified valid block address, however, f2fs_iomap_begin() treats it as
an invalid block address, and then it triggers the warning in iomap
framework code.

Finally, as discussed, we decide to use a more simple and direct way that
checking (map.m_flags & F2FS_MAP_MAPPED) condition instead of
(map.m_pblk != NULL_ADDR) to fix this issue.

Thanks a lot for the effort of Yi Zhang and Shinichiro Kawasaki on this
issue.

[1] https://lore.kernel.org/linux-f2fs-devel/CAHj4cs-kfojYC9i0G73PRkYzcxCTex=-vugRFeP40g_URGvnfQ@mail.gmail.com/
[2] https://lore.kernel.org/linux-f2fs-devel/gngdj77k4picagsfdtiaa7gpgnup6fsgwzsltx6milmhegmjff@iax2n4wvrqye/

Reported-by: Yi Zhang <yi.zhang@redhat.com>
Closes: https://lore.kernel.org/linux-f2fs-devel/CAHj4cs-kfojYC9i0G73PRkYzcxCTex=-vugRFeP40g_URGvnfQ@mail.gmail.com/
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Tested-by: Yi Zhang <yi.zhang@redhat.com>
Fixes: 1517c1a7a445 ("f2fs: implement iomap operations")
Fixes: 8d3c1fa3fa5e ("f2fs: don't rely on F2FS_MAP_* in f2fs_iomap_begin")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 5805b77d925e3..5d6ba12e84482 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -4243,7 +4243,7 @@ static int f2fs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	if (WARN_ON_ONCE(map.m_pblk == COMPRESS_ADDR))
 		return -EINVAL;
 
-	if (map.m_pblk != NULL_ADDR) {
+	if (map.m_flags & F2FS_MAP_MAPPED) {
 		iomap->length = blks_to_bytes(inode, map.m_len);
 		iomap->type = IOMAP_MAPPED;
 		iomap->flags |= IOMAP_F_MERGED;
-- 
2.43.0



