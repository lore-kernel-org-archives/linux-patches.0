Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1DD17AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:41:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508EFC433C8;
	Wed,  9 Aug 2023 11:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691581271;
	bh=EUk601PggebqOuW2vRU61JwiZbHquPBH5MGhVYsjvC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJUGLLKKzfjZBfBDxi4ubHXN+LU7KtAFrlX6BUne/0uATX53gY7neDlnW9P/f743G
	 6rPMYtS0+f17B12IfVbdTiZj2w6h+9W3s43V78ClEOfVvv9N8yl96KaIowulAzxEO0
	 EhE+zvWtGHYkR99GHp91E+NhRPy5vZivcPuT2Sys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	gaoming <gaoming20@hihonor.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 5.10 166/201] exfat: use kvmalloc_array/kvfree instead of kmalloc_array/kfree
Date: Wed,  9 Aug 2023 12:42:48 +0200
Message-ID: <20230809103649.288538826@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: gaoming <gaoming20@hihonor.com>

commit daf60d6cca26e50d65dac374db92e58de745ad26 upstream.

The call stack shown below is a scenario in the Linux 4.19 kernel.
Allocating memory failed where exfat fs use kmalloc_array due to
system memory fragmentation, while the u-disk was inserted without
recognition.
Devices such as u-disk using the exfat file system are pluggable and
may be insert into the system at any time.
However, long-term running systems cannot guarantee the continuity of
physical memory. Therefore, it's necessary to address this issue.

Binder:2632_6: page allocation failure: order:4,
 mode:0x6040c0(GFP_KERNEL|__GFP_COMP), nodemask=(null)
Call trace:
[242178.097582]  dump_backtrace+0x0/0x4
[242178.097589]  dump_stack+0xf4/0x134
[242178.097598]  warn_alloc+0xd8/0x144
[242178.097603]  __alloc_pages_nodemask+0x1364/0x1384
[242178.097608]  kmalloc_order+0x2c/0x510
[242178.097612]  kmalloc_order_trace+0x40/0x16c
[242178.097618]  __kmalloc+0x360/0x408
[242178.097624]  load_alloc_bitmap+0x160/0x284
[242178.097628]  exfat_fill_super+0xa3c/0xe7c
[242178.097635]  mount_bdev+0x2e8/0x3a0
[242178.097638]  exfat_fs_mount+0x40/0x50
[242178.097643]  mount_fs+0x138/0x2e8
[242178.097649]  vfs_kern_mount+0x90/0x270
[242178.097655]  do_mount+0x798/0x173c
[242178.097659]  ksys_mount+0x114/0x1ac
[242178.097665]  __arm64_sys_mount+0x24/0x34
[242178.097671]  el0_svc_common+0xb8/0x1b8
[242178.097676]  el0_svc_handler+0x74/0x90
[242178.097681]  el0_svc+0x8/0x340

By analyzing the exfat code,we found that continuous physical memory
is not required here,so kvmalloc_array is used can solve this problem.

Cc: stable@vger.kernel.org
Signed-off-by: gaoming <gaoming20@hihonor.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/balloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/exfat/balloc.c
+++ b/fs/exfat/balloc.c
@@ -69,7 +69,7 @@ static int exfat_allocate_bitmap(struct
 	}
 	sbi->map_sectors = ((need_map_size - 1) >>
 			(sb->s_blocksize_bits)) + 1;
-	sbi->vol_amap = kmalloc_array(sbi->map_sectors,
+	sbi->vol_amap = kvmalloc_array(sbi->map_sectors,
 				sizeof(struct buffer_head *), GFP_KERNEL);
 	if (!sbi->vol_amap)
 		return -ENOMEM;
@@ -84,7 +84,7 @@ static int exfat_allocate_bitmap(struct
 			while (j < i)
 				brelse(sbi->vol_amap[j++]);
 
-			kfree(sbi->vol_amap);
+			kvfree(sbi->vol_amap);
 			sbi->vol_amap = NULL;
 			return -EIO;
 		}
@@ -138,7 +138,7 @@ void exfat_free_bitmap(struct exfat_sb_i
 	for (i = 0; i < sbi->map_sectors; i++)
 		__brelse(sbi->vol_amap[i]);
 
-	kfree(sbi->vol_amap);
+	kvfree(sbi->vol_amap);
 }
 
 int exfat_set_bitmap(struct inode *inode, unsigned int clu)


