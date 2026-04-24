Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066F23B38AE;
	Fri, 24 Apr 2026 13:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038012; cv=none; b=NoM29fMu8OvMWKLxjXw69liR92NOBy4fank9Fq17KI77A5EdGQlKDDpKY5g9JGA/HW3vRee3xF6oGzuOfTJAtiQ6f54pVraanj2e31lGGYUGPeAinabun4kBxmx3MKwPj9hl7AceYRpvc1zWfKb/0EaLk2lg8HOz4yrau0u1+js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038012; c=relaxed/simple;
	bh=7OKwp2MMROGyYar8ZevlC18nFoLABbeCc2yAZ26UqcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRcfyYytdgMJg4bL2kByjTwMo6L8VdWExIXuky1LhdpoCYxrq/PnxNS2BMIF55V+bUtSB6kizvN3Jy/g8RqxglZlQNf22Nodu6jMVTcvvdEs8Z8psZH1RYBl4LSU5MlfE9MT/HqFGU4D74XIOAGIBt1Z1/1ZlkZ6uFjYuedg330=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NqBfCsU3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NqBfCsU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91076C19425;
	Fri, 24 Apr 2026 13:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038011;
	bh=7OKwp2MMROGyYar8ZevlC18nFoLABbeCc2yAZ26UqcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NqBfCsU3cdtFmh8qtolOUcHBjj3BCsCdyNtogS5VkAWdx7nvWrLi+nhrqpuIGe1WP
	 xwh/xDUAl96ZVNdwL0hcZhHUH4vdQsvEY3nZpCPqx1SLm+IiL6xrhkLGbREEOye/JS
	 Cz+7KrqshJyarIcDpcIp/ToqwpjB6Y1BzyUmmqSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4b4093b1f24ad789bf37@syzkaller.appspotmail.com,
	Deepanshu Kartikey <Kartikey406@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH 6.6 123/166] nilfs2: fix NULL i_assoc_inode dereference in nilfs_mdt_save_to_shadow_map
Date: Fri, 24 Apr 2026 15:30:37 +0200
Message-ID: <20260424132558.589515472@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -526,6 +526,9 @@ int nilfs_dat_read(struct super_block *s
 	if (err)
 		goto failed;
 
+	err = nilfs_attach_btree_node_cache(dat);
+	if (err)
+		goto failed;
 	err = nilfs_read_inode_common(dat, raw_inode);
 	if (err)
 		goto failed;


