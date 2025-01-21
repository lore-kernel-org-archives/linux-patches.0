Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694FBE571;
	Tue, 21 Jan 2025 18:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482455; cv=none; b=lt79YCD4wtKbTGYrZF1VjOULrNHd4Vz5j5aVqS5RPulk9hbQVXm9PPdSTKm50LZryLkaPL5IHdgqPz5qoRKIQqik53eABb+wbkSkMaoNhL/2OItDSMBDLD0TlggkUeJoVAI4TVAiOJG0AIdykFt0VNuiUjxPVOiwR7bvMKaRQ9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482455; c=relaxed/simple;
	bh=w+xs83tv6xklk7WgfWuDjxymha0G3iCTBG0tKccIlHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3shaRpQFR+9sg7e3BQorAjxlBPP5XNvfiMnE1bhVtcJ69u7KtKcEJI/rbx/stFdmIfJzjtLbpox5JYDbFoWM14ZiPVygtV3rL/i6knxF9SH4dQQ8sPmTajK3j30PIt4UTyxnZiIXdAMP6uLDQUwav2QHcDThLr31RaK/yHRAi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q120UFmP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q120UFmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F993C4CEDF;
	Tue, 21 Jan 2025 18:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482454;
	bh=w+xs83tv6xklk7WgfWuDjxymha0G3iCTBG0tKccIlHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q120UFmPB1lx47RvkJsCv6dTBfV4bYhlYsI5EKJjkT99VwO3qknTlX0cer/pk2zwA
	 QwPHCFdMnb3umzLYkl9F8FANrPLbBmrKhjF/HR7DoINfPEJg6XIEMjf//5nMl7mMVW
	 D0jF1ii2MYM7atVZtM45oIItGIPu0KrLzXlqDGSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+76f33569875eb708e575@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 065/122] afs: Fix merge preference rule failure condition
Date: Tue, 21 Jan 2025 18:51:53 +0100
Message-ID: <20250121174535.501629770@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Xu <lizhi.xu@windriver.com>

[ Upstream commit 17a4fde81d3a7478d97d15304a6d61094a10c2e3 ]

syzbot reported a lock held when returning to userspace[1].  This is
because if argc is less than 0 and the function returns directly, the held
inode lock is not released.

Fix this by store the error in ret and jump to done to clean up instead of
returning directly.

[dh: Modified Lizhi Xu's original patch to make it honour the error code
from afs_split_string()]

[1]
WARNING: lock held when returning to user space!
6.13.0-rc3-syzkaller-00209-g499551201b5f #0 Not tainted
------------------------------------------------
syz-executor133/5823 is leaving the kernel with locks still held!
1 lock held by syz-executor133/5823:
 #0: ffff888071cffc00 (&sb->s_type->i_mutex_key#9){++++}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #0: ffff888071cffc00 (&sb->s_type->i_mutex_key#9){++++}-{4:4}, at: afs_proc_addr_prefs_write+0x2bb/0x14e0 fs/afs/addr_prefs.c:388

Reported-by: syzbot+76f33569875eb708e575@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=76f33569875eb708e575
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/20241226012616.2348907-1-lizhi.xu@windriver.com/
Link: https://lore.kernel.org/r/529850.1736261552@warthog.procyon.org.uk
Tested-by: syzbot+76f33569875eb708e575@syzkaller.appspotmail.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/addr_prefs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/afs/addr_prefs.c b/fs/afs/addr_prefs.c
index a189ff8a5034e..c0384201b8feb 100644
--- a/fs/afs/addr_prefs.c
+++ b/fs/afs/addr_prefs.c
@@ -413,8 +413,10 @@ int afs_proc_addr_prefs_write(struct file *file, char *buf, size_t size)
 
 	do {
 		argc = afs_split_string(&buf, argv, ARRAY_SIZE(argv));
-		if (argc < 0)
-			return argc;
+		if (argc < 0) {
+			ret = argc;
+			goto done;
+		}
 		if (argc < 2)
 			goto inval;
 
-- 
2.39.5



