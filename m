Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACBD3502A2;
	Wed,  3 Dec 2025 16:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778408; cv=none; b=pa2tnR5f18i/Ax54HwNIXqPtTOWM2xWCIqYzcFS87wl1A6yo8poMRW+sNDjgHudTRkm38C8TAUPPNvoEy2aN9FObGjU8j+xzdDn1qOaY2t8CA5CoLNMXjvX7U92WL99vbycF9nUi/6kyjyCNYukRikVx7uu/UArq/QUoSjo/ObY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778408; c=relaxed/simple;
	bh=O/mySWCqsQDsHwTNugyFMSDwFdUrqNTv4W2u5c42WwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tAAjaOHcktR0ThsBE7emD/ZgJhmdc1kNeimI5E5hkrdGFPlk5fIqvDiC1hMFeo4BYOEAZMYMECPiMB5BGgmcuhARQ8f2GhiWWBwv7u2rd3JTwWflrDi+IGRy+LKuGdwdnr333+4PZLHFiyGHTSRtAWw4LG6tuQ+FhjhpFGoZ63Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B3oWF+fJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B3oWF+fJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6552EC4CEF5;
	Wed,  3 Dec 2025 16:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778407;
	bh=O/mySWCqsQDsHwTNugyFMSDwFdUrqNTv4W2u5c42WwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B3oWF+fJC3BhKfA873gHFDXgYu0z+YhcF4NHR7Apn3H3PRy+DBgB15DF2JQyXww1Y
	 X0u1aiOfCr8AhuCMLsTPtN/j7nAFxexgWyKA3ijHheFwVvunzn/OIUkcM5a2m1wleg
	 MBaN45TG08UOwBECWGsiDxGqJv+J3bf+e+bsod0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gulam Mohamed <gulam.mohamed@oracle.com>
Subject: [PATCH 5.15 336/392] Revert "block: dont add or resize partition on the disk with GENHD_FL_NO_PART"
Date: Wed,  3 Dec 2025 16:28:06 +0100
Message-ID: <20251203152426.535356428@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gulam Mohamed <gulam.mohamed@oracle.com>

This reverts commit 1a721de8489fa559ff4471f73c58bb74ac5580d3.

The commit 1a721de8489f ("block: don't add or resize partition on the disk
with GENHD_FL_NO_PART") and the commit 7777f47f2ea6 ("block: Move checking
GENHD_FL_NO_PART to bdev_add_partition()") used the flag GENHD_FL_NO_PART
to prevent the add or resize of partitions in 5.15 stable kernels.But in
these 5.15 kernels, this is giving an issue with the following error
where the loop driver wants to create a partition when the partscan is
disabled on the loop device:

dd if=/dev/zero of=loopDisk.dsk bs=1M count=1 seek=10240;
losetup -f loopDisk.dsk;parted -s /dev/loop0 -- mklabel gpt mkpart primary
           2048s 4096s
1+0 records in
1+0 records out
1048576 bytes (1.0 MB, 1.0 MiB) copied, 0.0016293 s, 644 MB/s
""
Error: Partition(s) 1 on /dev/loop0 have been written, but we have been
unable to inform the kernel of the change, probably because it/they are
in use.  As a result, the old partition(s) will remain in use.  You should
reboot now before making further changes.
""
If the partition scan is not enabled on the loop device, this flag
GENHD_FL_NO_PART is getting set and when partition creation is tried,
it returns an error EINVAL thereby preventing the creation of partitions.
So, there is no such distinction between disabling of partition scan and
partition creation.

Later in 6.xxx kernels, the commit b9684a71fca7 ("block, loop: support
partitions without scanning") a new flag GD_SUPPRESS_PART_SCAN was
introduced that just disables the partition scan and uses GENHD_FL_NO_PART
only to prevent creating partition scan. So, the partition creationg can
proceed with even if partition scan is disabled.

As the commit b9684a71fca7 ("block, loop: support partitions without
scanning") is not available in 5.15 stable kernel, and since there is no
distinction between disabling of "partition scan" and "partition
creation", we need to revert the commits 1a721de8489f and 7777f47f2ea6
from 5.15 stable kernel to allow partition creation when partscan is
disabled.

Cc: stable@vger.kernel.org
Signed-off-by: Gulam Mohamed <gulam.mohamed@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/ioctl.c |    2 --
 1 file changed, 2 deletions(-)

--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -20,8 +20,6 @@ static int blkpg_do_ioctl(struct block_d
 	struct blkpg_partition p;
 	sector_t start, length;
 
-	if (disk->flags & GENHD_FL_NO_PART)
-		return -EINVAL;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 	if (copy_from_user(&p, upart, sizeof(struct blkpg_partition)))


