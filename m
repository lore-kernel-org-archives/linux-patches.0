Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BF31482E8;
	Fri,  9 Jan 2026 12:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962747; cv=none; b=I3II+B6dTSZGLtzisMcfGFKrcTMohwLjyc0XgQtghw5qM3ZsObWY3JNJ6yD8kOcrCtRYqAsefbfolEjSijv34HZNEssJ54oPceGYQtUfjGnRrjMyltxE6XXVB0mBvhNHMVkog3oDIfQV2JwlqlHmUVU2WOmXMB9FHZHDfd4/sFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962747; c=relaxed/simple;
	bh=w9GSpCPTnzBuNl2rgf2zPhECGc/lRYDeyGVvNYYcBAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9aM6HE5a7cGoFOmaVtzI4HLXSRhljWL7sen5UU+ukeFsYaF2utf4LOPmRWnWCwx38I8pH6cYM0N9AThGzZGqq9d5ClAAtvjWZJnXCFIjAQSdZtQbo4+DwYBnO5zoGO+r7CNzua8+Ak/5iSM4MpfEjP7hEXC4EwU09cgt6cpAf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iNJYEcfu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iNJYEcfu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D24C4CEF1;
	Fri,  9 Jan 2026 12:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962747;
	bh=w9GSpCPTnzBuNl2rgf2zPhECGc/lRYDeyGVvNYYcBAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iNJYEcfuWB6qYb5hCUdQk/1qUdKXLrRWd6lL2yp4cRZIBy+hue3AZpQxBgzVGGMjZ
	 GKy7JvRj3yS/8Z9pjC1PxvL5h9bi3WZo12OJJb8vLBd8wGcA4DsNEIc9Wv9urFhnGJ
	 jyUyK9B2ZKbMdnylphJcHXGI4eHsTZrl4bwFF6p4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 473/634] dm-ebs: Mark full buffer dirty even on partial write
Date: Fri,  9 Jan 2026 12:42:31 +0100
Message-ID: <20260109112135.347583396@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -102,7 +102,7 @@ static int __ebs_rw_bvec(struct ebs_c *e
 			} else {
 				flush_dcache_page(bv->bv_page);
 				memcpy(ba, pa, cur_len);
-				dm_bufio_mark_partial_buffer_dirty(b, buf_off, buf_off + cur_len);
+				dm_bufio_mark_buffer_dirty(b);
 			}
 
 			dm_bufio_release(b);


