Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0C017BED0;
	Sat, 17 Oct 2026 17:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257948; cv=none; b=tgNbVHx8XPUKS8OX/+ccG8IbWhKXGjH2BSJTSJT8Mquk9+Fpr2KMIuOShMPtVySRf7MczejcCQL36zBSnIhnArHa4HKXe0nSZaK2/BiOx7dzYk83/PXEY9hDjAnwIQLEfCb/EIxk2kF0TcAjbyz7fJmhqXoxwkSKgpvN2V6w6s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257948; c=relaxed/simple;
	bh=kzwMYzv97+NhIxayVOP1YMrhHKAGYBc9vHTj/yKKJ4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OaZUFtYFFGzZGYXdjTo2LSOpcCPKTr5Urn97h/sZVVw15rJxTq+HG8Ncz7GEx7Y3HJtgV6CnXGtdVO3tSoFCOH5D1zAHoHCckYXoUIx/xyZO/av61nn6V73DW2gFQtvtqAYpZDVmdaaXgWoP/0mr1fR3sZLH7BdLRHo2oK5cRV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qkphsw21; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qkphsw21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664B71F000C4;
	Sat, 17 Oct 2026 17:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257947;
	bh=HYfSEUUCyNtM1B1dxBLinoB0gMyqsVU7yMOq+2/BhIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qkphsw21tx67l/yPE6uj/EMT0xv9SS+8Rv4mEzI4jYAZiOoN/fKRfDZcQhcZGiP4A
	 XrjWxDI2nLUgXDIA8PuCdJoR6O1pj67aBnSiN2d8gPYWCSFc/OUiySblUYSjiw9oB3
	 T/L9CYug385J3zSFhXIj1Id87cqTWqCIlbj9AJxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5d0bdc98770e6c55a0fd@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0722/1674] fs/ntfs3: Keep write operations atomic
Date: Sat, 17 Oct 2026 17:49:54 +0200
Message-ID: <20261017160449.641013107@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Lizhi Xu <lizhi.xu@windriver.com>

[ Upstream commit 285cec318bf5a7a6c8ba999b2b6ec96f9a20590f ]

syzbot reported a NULL pointer dereference in __generic_file_write_iter. [1]

Before the write operation is completed, the user executes ioctl[2] to clear
the compress flag of the file, which causes the is_compressed() judgment to
return 0, further causing the program to enter the wrong process and call the
wrong ops ntfs_aops_cmpr, which triggers the null pointer dereference of
write_begin.

Use inode lock to synchronize ioctl and write to avoid this case.

[1]
Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
Mem abort info:
  ESR = 0x0000000086000006
  EC = 0x21: IABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x06: level 2 translation fault
user pgtable: 4k pages, 48-bit VAs, pgdp=000000011896d000
[0000000000000000] pgd=0800000118b44403, p4d=0800000118b44403, pud=0800000117517403, pmd=0000000000000000
Internal error: Oops: 0000000086000006 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 UID: 0 PID: 6427 Comm: syz-executor347 Not tainted 6.13.0-rc3-syzkaller-g573067a5a685 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : 0x0
lr : generic_perform_write+0x29c/0x868 mm/filemap.c:4055
sp : ffff80009d4978a0
x29: ffff80009d4979c0 x28: dfff800000000000 x27: ffff80009d497bc8
x26: 0000000000000000 x25: ffff80009d497960 x24: ffff80008ba71c68
x23: 0000000000000000 x22: ffff0000c655dac0 x21: 0000000000001000
x20: 000000000000000c x19: 1ffff00013a92f2c x18: ffff0000e183aa1c
x17: 0004060000000014 x16: ffff800083275834 x15: 0000000000000001
x14: 0000000000000000 x13: 0000000000000001 x12: ffff0000c655dac0
x11: 0000000000ff0100 x10: 0000000000ff0100 x9 : 0000000000000000
x8 : 0000000000000000 x7 : 0000000000000000 x6 : 0000000000000000
x5 : ffff80009d497980 x4 : ffff80009d497960 x3 : 0000000000001000
x2 : 0000000000000000 x1 : ffff0000e183a928 x0 : ffff0000d60b0fc0
Call trace:
 0x0 (P)
 __generic_file_write_iter+0xfc/0x204 mm/filemap.c:4156
 ntfs_file_write_iter+0x54c/0x630 fs/ntfs3/file.c:1267
 new_sync_write fs/read_write.c:586 [inline]
 vfs_write+0x920/0xcf4 fs/read_write.c:679
 ksys_write+0x15c/0x26c fs/read_write.c:731
 __do_sys_write fs/read_write.c:742 [inline]
 __se_sys_write fs/read_write.c:739 [inline]
 __arm64_sys_write+0x7c/0x90 fs/read_write.c:739
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762

[2]
ioctl$FS_IOC_SETFLAGS(r0, 0x40086602, &(0x7f00000000c0)=0x20)

Reported-by: syzbot+5d0bdc98770e6c55a0fd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5d0bdc98770e6c55a0fd
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 490225b30e600..7ef52eec6f8aa 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -1103,21 +1103,22 @@ static ssize_t ntfs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	ssize_t ret;
 	int err;
 
-	err = check_write_restriction(inode);
-	if (err)
-		return err;
-
-	if (is_compressed(ni) && (iocb->ki_flags & IOCB_DIRECT)) {
-		ntfs_inode_warn(inode, "direct i/o + compressed not supported");
-		return -EOPNOTSUPP;
-	}
-
 	if (!inode_trylock(inode)) {
 		if (iocb->ki_flags & IOCB_NOWAIT)
 			return -EAGAIN;
 		inode_lock(inode);
 	}
 
+	ret = check_write_restriction(inode);
+	if (ret)
+		goto out;
+
+	if (is_compressed(ni) && (iocb->ki_flags & IOCB_DIRECT)) {
+		ntfs_inode_warn(inode, "direct i/o + compressed not supported");
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
 	ret = generic_write_checks(iocb, from);
 	if (ret <= 0)
 		goto out;
-- 
2.53.0



