Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC90B3D1CD0;
	Thu, 15 Jan 2026 17:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499695; cv=none; b=dIHj5ZbejOsJ9ijoRpWhhL2+a6PnwJddU9Z/YEYjZ2ibuKdxXzCzziQAwCdJJsC4s9l7JfVvbwcs+2StrFYKTn+zd4VnxHlg0+mT2QrtsX7WaENl0Exy0Li9LEksMh5y2YGuEFdz1gFk3f4DXq5ryBFHGrCPWq9FCeaS5YdnIQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499695; c=relaxed/simple;
	bh=uH+7bwFrheRlgZhm4PKS+Mpx5O2YrIh97VgL6xMPBHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClPdDa/Il9zhqelobylkrJTZxdP1rJB8rAJIqYbSXEwjKPxcr5xxPnjRdBGJutGaBKt0jQqsXjppXIgZTzUIjNm6+Lm/7gobNOQpHcSxFM9rcwoEct4k5EQDm2YE54/g8+SrfH5T9cmtFF2t8sx25ct6T4oITgs919eSouebgqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MxzzmEDK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MxzzmEDK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375A3C116D0;
	Thu, 15 Jan 2026 17:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499695;
	bh=uH+7bwFrheRlgZhm4PKS+Mpx5O2YrIh97VgL6xMPBHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MxzzmEDKTeG+HMcpMlUoMhix+Mj9qWTxtBAVDV/Ud3Onjp9L36O5mNxVs4pRORHHo
	 igA4uxXkdlN1cl1x0dKaSpBUE0tobASTs8p1zg2qbv3LwW3+7OWnHzGQQt2EZS0PnQ
	 s8ogI5E/WVrdt3HBC19/Ya2eRhkGAHDty4+ysFgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 318/451] dm-ebs: Mark full buffer dirty even on partial write
Date: Thu, 15 Jan 2026 17:48:39 +0100
Message-ID: <20260115164242.404556745@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uladzislau Rezki (Sony) <urezki@gmail.com>

commit 7fa3e7d114abc9cc71cc35d768e116641074ddb4 upstream.

When performing a read-modify-write(RMW) operation, any modification
to a buffered block must cause the entire buffer to be marked dirty.

Marking only a subrange as dirty is incorrect because the underlying
device block size(ubs) defines the minimum read/write granularity. A
lower device can perform I/O only on regions which are fully aligned
and sized to ubs.

This change ensures that write-back operations always occur in full
ubs-sized chunks, matching the intended emulation semantics of the
EBS target.

As for user space visible impact, submitting sub-ubs and misaligned
I/O for devices which are tuned to ubs sizes only, will reject such
requests, therefore it can lead to losing data. Example:

1) Create a 8K nvme device in qemu by adding

-device nvme,drive=drv0,serial=foo,logical_block_size=8192,physical_block_size=8192

2) Setup dm-ebs to emulate 512B to 8K mapping

urezki@pc638:~/bin$ cat dmsetup.sh

lower=/dev/nvme0n1
len=$(blockdev --getsz "$lower")

echo "0 $len ebs $lower 0 1 16" | dmsetup create nvme-8k
urezki@pc638:~/bin$

offset 0, ebs=1 and ubs=16(in sectors).

3) Create an ext4 filesystem(default 4K block size)

urezki@pc638:~/bin$ sudo mkfs.ext4 -F /dev/dm-0
mke2fs 1.47.0 (5-Feb-2023)
Discarding device blocks: done
Creating filesystem with 2072576 4k blocks and 518144 inodes
Filesystem UUID: bd0b6ca6-0506-4e31-86da-8d22c9d50b63
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: mkfs.ext4: Input/output error while writing out and closing file system
urezki@pc638:~/bin$ dmesg

<snip>
[ 1618.875449] buffer_io_error: 1028 callbacks suppressed
[ 1618.875456] Buffer I/O error on dev dm-0, logical block 0, lost async page write
[ 1618.875527] Buffer I/O error on dev dm-0, logical block 1, lost async page write
[ 1618.875602] Buffer I/O error on dev dm-0, logical block 2, lost async page write
[ 1618.875620] Buffer I/O error on dev dm-0, logical block 3, lost async page write
[ 1618.875639] Buffer I/O error on dev dm-0, logical block 4, lost async page write
[ 1618.894316] Buffer I/O error on dev dm-0, logical block 5, lost async page write
[ 1618.894358] Buffer I/O error on dev dm-0, logical block 6, lost async page write
[ 1618.894380] Buffer I/O error on dev dm-0, logical block 7, lost async page write
[ 1618.894405] Buffer I/O error on dev dm-0, logical block 8, lost async page write
[ 1618.894427] Buffer I/O error on dev dm-0, logical block 9, lost async page write
<snip>

Many I/O errors because the lower 8K device rejects sub-ubs/misaligned
requests.

with a patch:

urezki@pc638:~/bin$ sudo mkfs.ext4 -F /dev/dm-0
mke2fs 1.47.0 (5-Feb-2023)
Discarding device blocks: done
Creating filesystem with 2072576 4k blocks and 518144 inodes
Filesystem UUID: 9b54f44f-ef55-4bd4-9e40-c8b775a616ac
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done

urezki@pc638:~/bin$ sudo mount /dev/dm-0 /mnt/
urezki@pc638:~/bin$ ls -al /mnt/
total 24
drwxr-xr-x  3 root root  4096 Oct 17 15:13 .
drwxr-xr-x 19 root root  4096 Jul 10 19:42 ..
drwx------  2 root root 16384 Oct 17 15:13 lost+found
urezki@pc638:~/bin$

After this change: mkfs completes; mount succeeds.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ebs-target.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-ebs-target.c
+++ b/drivers/md/dm-ebs-target.c
@@ -101,7 +101,7 @@ static int __ebs_rw_bvec(struct ebs_c *e
 			} else {
 				flush_dcache_page(bv->bv_page);
 				memcpy(ba, pa, cur_len);
-				dm_bufio_mark_partial_buffer_dirty(b, buf_off, buf_off + cur_len);
+				dm_bufio_mark_buffer_dirty(b);
 			}
 
 			dm_bufio_release(b);


