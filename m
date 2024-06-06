Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E771A2C2A;
	Thu,  6 Jun 2024 14:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683205; cv=none; b=g1UDFTnL5zBLA6l8gFc1YIWFlIK9h2F4wJaque9Lox1mR1Aldp5uslbJa/SY6wGXQgYr2fzd28xrkt8uuCxcs4NWWxWocZ39H5qG3aqZIqI0pomRlLQweUlBRh6dFUFiLF8ba6n7pVeiO55bew3ZaHzyRZn90+z1Fw9TtWSsE1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683205; c=relaxed/simple;
	bh=zgS90Wy9ocHGKFj7ympq+GWWPjQ1bbbxmqngNAWDzSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/hfmbVpHJf7DpzNeIodw2M0BusXik2SQgq1aynJ2jorITjAEHtWVw2xO2sM6X+YBQxyauhOOt7yXQwXyuduCTXfLd8SS8eEdQKkUi2K5qAKIH6XwEpt9LdC81hrhwmvARXO2fFvJtO9FpeCqilrspOZiXkNwz+A3ETt3h+qAyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eqzkS36B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eqzkS36B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3192C2BD10;
	Thu,  6 Jun 2024 14:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683205;
	bh=zgS90Wy9ocHGKFj7ympq+GWWPjQ1bbbxmqngNAWDzSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqzkS36B21bjQNkNGd4Eu40Cl9jG5vkCoUYMyGNxbyviZj+ghNV2VjxmS4aJ6oxia
	 SNjxd57EFRyIPWCvFpe4mMkvE1ZjvYbVpLQtEE5iXTTMQA0a2/C7HM+ZL/iQ3b3IQb
	 VEbCUB/WbhG7EXGoFeCK2fbbvuY4SoGZWVZ8dcMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Denisyev <dev@elkcl.ru>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 083/473] jffs2: prevent xattr node from overflowing the eraseblock
Date: Thu,  6 Jun 2024 16:00:12 +0200
Message-ID: <20240606131702.652151809@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Denisyev <dev@elkcl.ru>

[ Upstream commit c6854e5a267c28300ff045480b5a7ee7f6f1d913 ]

Add a check to make sure that the requested xattr node size is no larger
than the eraseblock minus the cleanmarker.

Unlike the usual inode nodes, the xattr nodes aren't split into parts
and spread across multiple eraseblocks, which means that a xattr node
must not occupy more than one eraseblock. If the requested xattr value is
too large, the xattr node can spill onto the next eraseblock, overwriting
the nodes and causing errors such as:

jffs2: argh. node added in wrong place at 0x0000b050(2)
jffs2: nextblock 0x0000a000, expected at 0000b00c
jffs2: error: (823) do_verify_xattr_datum: node CRC failed at 0x01e050,
read=0xfc892c93, calc=0x000000
jffs2: notice: (823) jffs2_get_inode_nodes: Node header CRC failed
at 0x01e00c. {848f,2fc4,0fef511f,59a3d171}
jffs2: Node at 0x0000000c with length 0x00001044 would run over the
end of the erase block
jffs2: Perhaps the file system was created with the wrong erase size?
jffs2: jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found
at 0x00000010: 0x1044 instead

This breaks the filesystem and can lead to KASAN crashes such as:

BUG: KASAN: slab-out-of-bounds in jffs2_sum_add_kvec+0x125e/0x15d0
Read of size 4 at addr ffff88802c31e914 by task repro/830
CPU: 0 PID: 830 Comm: repro Not tainted 6.9.0-rc3+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS Arch Linux 1.16.3-1-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xc6/0x120
 print_report+0xc4/0x620
 ? __virt_addr_valid+0x308/0x5b0
 kasan_report+0xc1/0xf0
 ? jffs2_sum_add_kvec+0x125e/0x15d0
 ? jffs2_sum_add_kvec+0x125e/0x15d0
 jffs2_sum_add_kvec+0x125e/0x15d0
 jffs2_flash_direct_writev+0xa8/0xd0
 jffs2_flash_writev+0x9c9/0xef0
 ? __x64_sys_setxattr+0xc4/0x160
 ? do_syscall_64+0x69/0x140
 ? entry_SYSCALL_64_after_hwframe+0x76/0x7e
 [...]

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: aa98d7cf59b5 ("[JFFS2][XATTR] XATTR support on JFFS2 (version. 5)")
Signed-off-by: Ilya Denisyev <dev@elkcl.ru>
Link: https://lore.kernel.org/r/20240412155357.237803-1-dev@elkcl.ru
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jffs2/xattr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/jffs2/xattr.c b/fs/jffs2/xattr.c
index acb4492f5970c..5a31220f96f5f 100644
--- a/fs/jffs2/xattr.c
+++ b/fs/jffs2/xattr.c
@@ -1111,6 +1111,9 @@ int do_jffs2_setxattr(struct inode *inode, int xprefix, const char *xname,
 		return rc;
 
 	request = PAD(sizeof(struct jffs2_raw_xattr) + strlen(xname) + 1 + size);
+	if (request > c->sector_size - c->cleanmarker_size)
+		return -ERANGE;
+
 	rc = jffs2_reserve_space(c, request, &length,
 				 ALLOC_NORMAL, JFFS2_SUMMARY_XATTR_SIZE);
 	if (rc) {
-- 
2.43.0



