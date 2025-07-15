Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E8D1531E8;
	Tue, 15 Jul 2025 13:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587573; cv=none; b=J7z8qlSgP0vr+5LUcwTCKn5shhzlOZXCUCP7LT31NF0rAVAlb/VtFsCka9fRqYlqMsG9mvVJVRixQsJ0MNP9lzSUKa7wurFx1dA4DthlCD6+7F9Kkk8z3wrh7hwhloaQEBCgtTbo5DLwmAVP/dVM8r2ThEDVnDLN8cxvPFwNCng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587573; c=relaxed/simple;
	bh=lNJwXzZToNzhH5SnEObZxD/LyqIjEu6i/c2wRmPYce4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PIH0mKLeiv2yjE0FkJBUpq3MIl70W+XtLOwxr9VVeJCwX9QS/Uq4DTP+asBqG4J+Hb2koWqjvlBefA4SNouraIVbcYcc3xsAx5wwo/jdfVzUhuvmoMUEZWXMpCyRybjWUiCOX+dcSfUBPPDqRpnaRSy6syCEozncYMvSCmDeG8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BXmg23KK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BXmg23KK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409BFC4CEE3;
	Tue, 15 Jul 2025 13:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587572;
	bh=lNJwXzZToNzhH5SnEObZxD/LyqIjEu6i/c2wRmPYce4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BXmg23KKc+uXoaJcqpTmncUg2GCtrx23YcgS7ZjAIZl8bIMe0/4mgNACO5XmWRq6f
	 Vfn6lSCnBcFyIGVoIRzNhbiWig+EfZZqcI/0qU59pjUqkHbl0oP9mLEjFfXtmlgioZ
	 TR0x2r1lAlububK+/Ay45Tx3ZrR3/78ZYKRoWBnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fe8264911355151c487f@syzkaller.appspotmail.com,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/208] jfs: validate AG parameters in dbMount() to prevent crashes
Date: Tue, 15 Jul 2025 15:12:20 +0200
Message-ID: <20250715130812.078811519@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasiliy Kovalev <kovalev@altlinux.org>

[ Upstream commit 37bfb464ddca87f203071b5bd562cd91ddc0b40a ]

Validate db_agheight, db_agwidth, and db_agstart in dbMount to catch
corrupted metadata early and avoid undefined behavior in dbAllocAG.
Limits are derived from L2LPERCTL, LPERCTL/MAXAG, and CTLTREESIZE:

- agheight: 0 to L2LPERCTL/2 (0 to 5) ensures shift
  (L2LPERCTL - 2*agheight) >= 0.
- agwidth: 1 to min(LPERCTL/MAXAG, 2^(L2LPERCTL - 2*agheight))
  ensures agperlev >= 1.
  - Ranges: 1-8 (agheight 0-3), 1-4 (agheight 4), 1 (agheight 5).
  - LPERCTL/MAXAG = 1024/128 = 8 limits leaves per AG;
    2^(10 - 2*agheight) prevents division to 0.
- agstart: 0 to CTLTREESIZE-1 - agwidth*(MAXAG-1) keeps ti within
  stree (size 1365).
  - Ranges: 0-1237 (agwidth 1), 0-348 (agwidth 8).

UBSAN: shift-out-of-bounds in fs/jfs/jfs_dmap.c:1400:9
shift exponent -335544310 is negative
CPU: 0 UID: 0 PID: 5822 Comm: syz-executor130 Not tainted 6.14.0-rc5-syzkaller #0
Hardware name: Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_shift_out_of_bounds+0x3c8/0x420 lib/ubsan.c:468
 dbAllocAG+0x1087/0x10b0 fs/jfs/jfs_dmap.c:1400
 dbDiscardAG+0x352/0xa20 fs/jfs/jfs_dmap.c:1613
 jfs_ioc_trim+0x45a/0x6b0 fs/jfs/jfs_discard.c:105
 jfs_ioctl+0x2cd/0x3e0 fs/jfs/ioctl.c:131
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:906 [inline]
 __se_sys_ioctl+0xf5/0x170 fs/ioctl.c:892
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Cc: stable@vger.kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+fe8264911355151c487f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fe8264911355151c487f
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index ba60e24b30a45..37888187b9773 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -194,7 +194,11 @@ int dbMount(struct inode *ipbmap)
 	    !bmp->db_numag || (bmp->db_numag > MAXAG) ||
 	    (bmp->db_maxag >= MAXAG) || (bmp->db_maxag < 0) ||
 	    (bmp->db_agpref >= MAXAG) || (bmp->db_agpref < 0) ||
-	    !bmp->db_agwidth ||
+	    (bmp->db_agheight < 0) || (bmp->db_agheight > (L2LPERCTL >> 1)) ||
+	    (bmp->db_agwidth < 1) || (bmp->db_agwidth > (LPERCTL / MAXAG)) ||
+	    (bmp->db_agwidth > (1 << (L2LPERCTL - (bmp->db_agheight << 1)))) ||
+	    (bmp->db_agstart < 0) ||
+	    (bmp->db_agstart > (CTLTREESIZE - 1 - bmp->db_agwidth * (MAXAG - 1))) ||
 	    (bmp->db_agl2size > L2MAXL2SIZE - L2MAXAG) ||
 	    (bmp->db_agl2size < 0) ||
 	    ((bmp->db_mapsize - 1) >> bmp->db_agl2size) > MAXAG) {
-- 
2.39.5



