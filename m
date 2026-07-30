Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A0B436BF8;
	Thu, 30 Jul 2026 15:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426937; cv=none; b=N8YnUZUTeFqPPBmzFm9wrhVCBL5okXjzPvybQTavv9b3/myudOMOtxH++fmTiBcAQTlH/4X4uePUbgE6CnFs9BOq+cvHq+IKHc6RjFPmoEwZtg1IxkdZ/hsS4RAdHAQybtpVVEBQ8eSGWnldK/7xqPSChEv0bPTljQo8Me36DGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426937; c=relaxed/simple;
	bh=M6Tu3MVnlqDJA4+qepiqnxqfoti3yUIsoMmct72Xlhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYFI5BrePhzouvACVoCE22Ea/s9sIJo9g3D0eHPHKAtqu459vOh+9prODEpIpviJ47fr3pP5l0lLSaDglbqvzZ9guLAwAvyPiy0t5avfLefql69I/OypSyqE+jucqwkacyNlO3kTX0e8WIXzhQJvoe99hwoihFDAW6qKkaUPYT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pBig8eRP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pBig8eRP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92461F000E9;
	Thu, 30 Jul 2026 15:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426936;
	bh=YD0Z9ReLVI9jXmDVt9foIj04m9zpCu5F6YO3d8pkSWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pBig8eRPReS70DtVgCsYzQXo8vPw8uImeJU4sE6utGojxzncixch1Ub9o95GdcNW/
	 q6hyAPX7Bbg25UY1J2bYYayMwlqOcCnHbbiauDetAEr3QKs78oGs8NWCD083X0pMoF
	 TU5LsbcRxeXh1XAcSALF1dt2S6qcwK3/6Qlmw3XQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5c042fbab0b292c98fc6@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.12 593/602] afs: Set vllist to NULL if addr parsing fails
Date: Thu, 30 Jul 2026 16:16:25 +0200
Message-ID: <20260730141448.515543736@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

commit 8b3c655fa2406b9853138142746a39b7615c54a2 upstream.

syzbot reported a bug in in afs_put_vlserverlist.

  kAFS: bad VL server IP address
  BUG: unable to handle page fault for address: fffffffffffffffa
  ...
  Oops: Oops: 0002 [#1] SMP KASAN PTI
  ...
  RIP: 0010:refcount_dec_and_test include/linux/refcount.h:450 [inline]
  RIP: 0010:afs_put_vlserverlist+0x3a/0x220 fs/afs/vl_list.c:67
  ...
  Call Trace:
   <TASK>
   afs_alloc_cell fs/afs/cell.c:218 [inline]
   afs_lookup_cell+0x12a5/0x1680 fs/afs/cell.c:264
   afs_cell_init+0x17a/0x380 fs/afs/cell.c:386
   afs_proc_rootcell_write+0x21f/0x290 fs/afs/proc.c:247
   proc_simple_write+0x114/0x1b0 fs/proc/generic.c:825
   pde_write fs/proc/inode.c:330 [inline]
   proc_reg_write+0x23d/0x330 fs/proc/inode.c:342
   vfs_write+0x25c/0x1180 fs/read_write.c:682
   ksys_write+0x12a/0x240 fs/read_write.c:736
   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
   do_syscall_64+0xcd/0x260 arch/x86/entry/syscall_64.c:94
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

Because afs_parse_text_addrs() parses incorrectly, its return value -EINVAL
is assigned to vllist, which results in -EINVAL being used as the vllist
address when afs_put_vlserverlist() is executed.

Set the vllist value to NULL when a parsing error occurs to avoid this
issue.

Fixes: e2c2cb8ef07a ("afs: Simplify cell record handling")
Reported-by: syzbot+5c042fbab0b292c98fc6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5c042fbab0b292c98fc6
Tested-by: syzbot+5c042fbab0b292c98fc6@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/4119365.1753108011@warthog.procyon.org.uk
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/cell.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -177,6 +177,7 @@ static struct afs_cell *afs_alloc_cell(s
 					      VL_SERVICE, AFS_VL_PORT);
 		if (IS_ERR(vllist)) {
 			ret = PTR_ERR(vllist);
+			vllist = NULL;
 			goto parse_failed;
 		}
 


