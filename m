Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28853368B2;
	Mon, 20 Apr 2026 15:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700004; cv=none; b=JkfQKSP2bd37B7lV8+pKqVqiK80+CUz2jID6CV1EcnXQtII6zj76RoVk5GL9Rzz95VAjZlEANaevuaVTa1QyCxP3tVsxzlxBMyCaDDt6rGM3Wl951SM05kt0urDF/U9C/sdXp8PC/A3htMGxjs8CixQYixdVjMGiGoO5NV2iJh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700004; c=relaxed/simple;
	bh=SQshGYj147SFs0/dlGEWdHVuzOxhiZhAjpzGyMqMuDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+gd7/VfMM75IlnqzH0AwXgetGxqA+bCrpmrxTgjW86RxtdvWAnOJNYEANPkM7J5grj14iyCQiRoxxqsoWwUb8ArtTBRLQBqEjvgkjtKMIv4SLwFOccD08Sv2NmhWfqEAMrZ9qkB48CpZhvtdI8bVIs2pRbHoF2/BxOFPgYYoFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dmYaU46P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dmYaU46P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89807C19425;
	Mon, 20 Apr 2026 15:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700003;
	bh=SQshGYj147SFs0/dlGEWdHVuzOxhiZhAjpzGyMqMuDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dmYaU46P+dkI9ELfn0kvL3t9Py5p1sxUxYZmIqKKZpAhAzAu53SdMjzNuNvrJxXVL
	 TXxYO5oFp3OTMXKXt/kytv1znBbRAjCoRjx41cVPyNp5PJ1GwAJSmd7uT10ppWCrWv
	 wYpCHjBZsTw8gCAFLBysse1eL+Yj60Zvhsg/nUYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4b4093b1f24ad789bf37@syzkaller.appspotmail.com,
	Deepanshu Kartikey <Kartikey406@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 7.0 73/76] nilfs2: fix NULL i_assoc_inode dereference in nilfs_mdt_save_to_shadow_map
Date: Mon, 20 Apr 2026 17:42:24 +0200
Message-ID: <20260420153913.474623905@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
References: <20260420153910.810034134@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -524,6 +524,9 @@ int nilfs_dat_read(struct super_block *s
 	if (err)
 		goto failed;
 
+	err = nilfs_attach_btree_node_cache(dat);
+	if (err)
+		goto failed;
 	err = nilfs_read_inode_common(dat, raw_inode);
 	if (err)
 		goto failed;


