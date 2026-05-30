Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A366D3438AE;
	Sat, 30 May 2026 17:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162869; cv=none; b=X/4S4O/72Bm6xS6efR2Qhna8JFQp+vXPjs4JlRrPekxthAkSbyy02Ph877HoTc8Ra60GnGiYQXDnYXJja2p/SmxjEn09KJeJ4ItZ7eaGg4spLZyLMEN5nHVmOVhca+V3hAKx0W/O1Kp0duet3DAX/paiH87Dd4CaIlctj5/J6IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162869; c=relaxed/simple;
	bh=FqtqA9iB3hSa3rCzgmecGBs57m12Lu+N+8cm7qFKS8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LzZgCLoFlz6Z5J1FcT12FVhnRan2BqhCLhb2Mb5z4cXyttuirtzlxMXldmmwXf9IICOcdlLp5eRzVOYHgoyl9DCP8/ArQYIZbkg/YQ7H80S/HR4fLJ2AzGzoLckZTktR8q1o6fMrxSTwBQ3JlY4ks67cli8a+/fX9kibvduvdqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=objEY1zM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="objEY1zM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F951F00893;
	Sat, 30 May 2026 17:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162868;
	bh=kiffSts+Jna60GDhULfP+2AWKyLIxr33ktQA4sgnT/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=objEY1zMan7EtaRIVfKnn2ZHbOEVEc/glLywdvcJWg+YQEhAIpjD0x2UwxHFYy5dL
	 lGQ/Vj9FQHe4Gm077sAfcxWxj/RLhQ2K9U9KpconN9kQXsCrpR1VABNk/FTv4WRV2f
	 IfNJ6anfjCOb5sSG5vKHVbs1v/BMEakWW5kczL94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4b4093b1f24ad789bf37@syzkaller.appspotmail.com,
	Deepanshu Kartikey <Kartikey406@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 5.15 087/776] nilfs2: fix NULL i_assoc_inode dereference in nilfs_mdt_save_to_shadow_map
Date: Sat, 30 May 2026 17:56:41 +0200
Message-ID: <20260530160242.584599228@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit 4a4e0328edd9e9755843787d28f16dd4165f8b48 upstream.

The DAT inode's btree node cache (i_assoc_inode) is initialized lazily
during btree operations. However, nilfs_mdt_save_to_shadow_map()
assumes i_assoc_inode is already initialized when copying dirty pages
to the shadow map during GC.

If NILFS_IOCTL_CLEAN_SEGMENTS is called immediately after mount before
any btree operation has occurred on the DAT inode, i_assoc_inode is
NULL leading to a general protection fault.

Fix this by calling nilfs_attach_btree_node_cache() on the DAT inode
in nilfs_dat_read() at mount time, ensuring i_assoc_inode is always
initialized before any GC operation can use it.

Reported-by: syzbot+4b4093b1f24ad789bf37@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4b4093b1f24ad789bf37
Tested-by: syzbot+4b4093b1f24ad789bf37@syzkaller.appspotmail.com
Fixes: e897be17a441 ("nilfs2: fix lockdep warnings in page operations for btree nodes")
Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/dat.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -515,6 +515,9 @@ int nilfs_dat_read(struct super_block *s
 	if (err)
 		goto failed;
 
+	err = nilfs_attach_btree_node_cache(dat);
+	if (err)
+		goto failed;
 	err = nilfs_read_inode_common(dat, raw_inode);
 	if (err)
 		goto failed;


