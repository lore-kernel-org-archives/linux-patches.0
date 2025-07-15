Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F46263F52;
	Tue, 15 Jul 2025 13:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586123; cv=none; b=TLQCJMy1InzuJt0HFuNjnlOFbq4C2ePJtpv7+guzJAVC4FS4zuUBeks9TwzYdhrA7fGsnPa/f6DFw9V+Jwii7OunvlbUr7rd6GUzUPclC8Gh13BOAn/UduRgzASFpvP10Jl9snY8C+i7yIOEueBlNKBbnr9rKgPRGviYjiOY1cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586123; c=relaxed/simple;
	bh=Mzi1aspxwvSJXJ8Pt1E7wpxFmtCM4C9lofwZvvc5kFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHjE4KhjfrxR9Drrbeapsp1gvna94ePGJVgyqILtUSY5uWfNOcrYRIUZLlwwZ7LFY9meEZH5J2PFPaDsXXexJUO9WprucGny+7uinUHNqd0177xcNpIbOACzV2dxdN/1UObbDxW5028amcqiPB+98ljWxObP1RwLgrW+4S2evnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ll0MWr4I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ll0MWr4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB21C4CEE3;
	Tue, 15 Jul 2025 13:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586123;
	bh=Mzi1aspxwvSJXJ8Pt1E7wpxFmtCM4C9lofwZvvc5kFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ll0MWr4IsrmHGuwWAJ+pgY6oopMh36JRr+89cC+e3DitNod9SknZ8RFdFa82cHvtW
	 oq12TUYAl2aJR4sC3V5FaG6ADuWMC5X9Wi+oWq9ibnOGQWrSW4qBYgASfgBX4MFd+f
	 RBGktqUnXjps/hDO5yamz/AO+f+H9td5NAFs12R8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bba84aef3a26fb93deb9@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Aditya Dutt <duttaditya18@gmail.com>
Subject: [PATCH 5.15 24/77] jfs: fix null ptr deref in dtInsertEntry
Date: Tue, 15 Jul 2025 15:13:23 +0200
Message-ID: <20250715130752.673321389@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Edward Adam Davis <eadavis@qq.com>

commit ce6dede912f064a855acf6f04a04cbb2c25b8c8c upstream.

[syzbot reported]
general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 PID: 5061 Comm: syz-executor404 Not tainted 6.8.0-syzkaller-08951-gfe46a7dd189e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
RIP: 0010:dtInsertEntry+0xd0c/0x1780 fs/jfs/jfs_dtree.c:3713
...
[Analyze]
In dtInsertEntry(), when the pointer h has the same value as p, after writing
name in UniStrncpy_to_le(), p->header.flag will be cleared. This will cause the
previously true judgment "p->header.flag & BT-LEAF" to change to no after writing
the name operation, this leads to entering an incorrect branch and accessing the
uninitialized object ih when judging this condition for the second time.

[Fix]
After got the page, check freelist first, if freelist == 0 then exit dtInsert()
and return -EINVAL.

Reported-by: syzbot+bba84aef3a26fb93deb9@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Aditya Dutt <duttaditya18@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jfs/jfs_dtree.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -835,6 +835,8 @@ int dtInsert(tid_t tid, struct inode *ip
 	 * the full page.
 	 */
 	DT_GETSEARCH(ip, btstack->top, bn, mp, p, index);
+	if (p->header.freelist == 0)
+		return -EINVAL;
 
 	/*
 	 *	insert entry for new key


