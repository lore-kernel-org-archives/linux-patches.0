Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5900214013
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V17VM5u3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA494C433C8;
	Mon,  9 Oct 2023 13:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859350;
	bh=rQY0ybrSKoXT+KqRc8gSuKb/JUv5MLzK6DBTH8BnmVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V17VM5u3xPZgUKRMPCebnV+CkcbzXIGtVJrYcAZPDeM0n8kRKDizfH8tTgq3/6pLJ
	 WSKngGygm1373e3VsMHNr5zwcljzH0UAGlWVmMwRmZNnTDvF6QafpxoPzze6DeKtaM
	 G6to8Ywb22/WBuX82dh0lJUSWOoJwh0Q+Hmc0NOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pan Bian <bianpan2016@163.com>,
	Ferry Meng <mengferry@linux.alibaba.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.14 23/55] nilfs2: fix potential use after free in nilfs_gccache_submit_read_data()
Date: Mon,  9 Oct 2023 15:06:22 +0200
Message-ID: <20231009130108.595362827@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130107.717692466@linuxfoundation.org>
References: <20231009130107.717692466@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pan Bian <bianpan2016@163.com>

commit 7ee29facd8a9c5a26079148e36bcf07141b3a6bc upstream.

In nilfs_gccache_submit_read_data(), brelse(bh) is called to drop the
reference count of bh when the call to nilfs_dat_translate() fails.  If
the reference count hits 0 and its owner page gets unlocked, bh may be
freed.  However, bh->b_page is dereferenced to put the page after that,
which may result in a use-after-free bug.  This patch moves the release
operation after unlocking and putting the page.

NOTE: The function in question is only called in GC, and in combination
with current userland tools, address translation using DAT does not occur
in that function, so the code path that causes this issue will not be
executed.  However, it is possible to run that code path by intentionally
modifying the userland GC library or by calling the GC ioctl directly.

[konishi.ryusuke@gmail.com: NOTE added to the commit log]
Link: https://lkml.kernel.org/r/1543201709-53191-1-git-send-email-bianpan2016@163.com
Link: https://lkml.kernel.org/r/20230921141731.10073-1-konishi.ryusuke@gmail.com
Fixes: a3d93f709e89 ("nilfs2: block cache for garbage collection")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Reported-by: Ferry Meng <mengferry@linux.alibaba.com>
Closes: https://lkml.kernel.org/r/20230818092022.111054-1-mengferry@linux.alibaba.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/gcinode.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -82,10 +82,8 @@ int nilfs_gccache_submit_read_data(struc
 		struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
 
 		err = nilfs_dat_translate(nilfs->ns_dat, vbn, &pbn);
-		if (unlikely(err)) { /* -EIO, -ENOMEM, -ENOENT */
-			brelse(bh);
+		if (unlikely(err)) /* -EIO, -ENOMEM, -ENOENT */
 			goto failed;
-		}
 	}
 
 	lock_buffer(bh);
@@ -111,6 +109,8 @@ int nilfs_gccache_submit_read_data(struc
  failed:
 	unlock_page(bh->b_page);
 	put_page(bh->b_page);
+	if (unlikely(err))
+		brelse(bh);
 	return err;
 }
 


