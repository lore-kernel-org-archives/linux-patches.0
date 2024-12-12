Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171DD2165F0;
	Thu, 12 Dec 2024 15:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016440; cv=none; b=bf336ta35MnjawMcLQEVD11kaPFpkh45iCzb7rNWefsv12pMyNCvq6ViPM5LKn5DzOeTpe6iSwqCRm/njf+Ilsa8NfNoXZk3tFkMYBY7k+Uv5TGP8lm5pxUiY5PwvAD8TTA2pw31rOvkkr7PiDTneSsTQgWKxjERkIrNRuNtvL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016440; c=relaxed/simple;
	bh=4ewJqeMlQu+QDm74iejbvQaoDN8G2oKejt8VTKhjSB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plRMqJTL3iZ3g5NIFU89ioEkYRgtDSFsIN1EWZPRz6Vc/ZLzJ2rZ1h805Alj1E7JdlBvSJ1GX624IUs00AjvX0hKrAKYHJ+n/Xnv8zsJULlxsQbyVaqOzIaGknwmZAVcPE8NJlox6YOhaZ7jHr5xQbFEsFxOubxMEIldlEUCR2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LA8mOzJe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LA8mOzJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424F4C4CEE1;
	Thu, 12 Dec 2024 15:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016439;
	bh=4ewJqeMlQu+QDm74iejbvQaoDN8G2oKejt8VTKhjSB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LA8mOzJeiO/aROzLhr7UMMwL/vQzjYXWllv8hTE1zCUA+DuQxxGXwt7S4FHM9Ojtc
	 nROUYPFskHAG43tiduWLWHvGIWyb6LvKRnVoD+Z+hfYCi6xgPV7D49kRE0rLc2ECHH
	 KhAUPyf5SJ9w/iHEoQpjGPfuY7an3C1ucm01F9gQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	syzbot+3511625422f7aa637f0d@syzkaller.appspotmail.com,
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>,
	Christoph Lameter <cl@linux.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 200/466] mm/mempolicy: fix migrate_to_node() assuming there is at least one VMA in a MM
Date: Thu, 12 Dec 2024 15:56:09 +0100
Message-ID: <20241212144314.692458423@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

commit 091c1dd2d4df6edd1beebe0e5863d4034ade9572 upstream.

We currently assume that there is at least one VMA in a MM, which isn't
true.

So we might end up having find_vma() return NULL, to then de-reference
NULL.  So properly handle find_vma() returning NULL.

This fixes the report:

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 UID: 0 PID: 6021 Comm: syz-executor284 Not tainted 6.12.0-rc7-syzkaller-00187-gf868cd251776 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
RIP: 0010:migrate_to_node mm/mempolicy.c:1090 [inline]
RIP: 0010:do_migrate_pages+0x403/0x6f0 mm/mempolicy.c:1194
Code: ...
RSP: 0018:ffffc9000375fd08 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffc9000375fd78 RCX: 0000000000000000
RDX: ffff88807e171300 RSI: dffffc0000000000 RDI: ffff88803390c044
RBP: ffff88807e171428 R08: 0000000000000014 R09: fffffbfff2039ef1
R10: ffffffff901cf78f R11: 0000000000000000 R12: 0000000000000003
R13: ffffc9000375fe90 R14: ffffc9000375fe98 R15: ffffc9000375fdf8
FS:  00005555919e1380(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005555919e1ca8 CR3: 000000007f12a000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 kernel_migrate_pages+0x5b2/0x750 mm/mempolicy.c:1709
 __do_sys_migrate_pages mm/mempolicy.c:1727 [inline]
 __se_sys_migrate_pages mm/mempolicy.c:1723 [inline]
 __x64_sys_migrate_pages+0x96/0x100 mm/mempolicy.c:1723
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

[akpm@linux-foundation.org: add unlikely()]
Link: https://lkml.kernel.org/r/20241120201151.9518-1-david@redhat.com
Fixes: 39743889aaf7 ("[PATCH] Swap Migration V5: sys_migrate_pages interface")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: syzbot+3511625422f7aa637f0d@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/lkml/673d2696.050a0220.3c9d61.012f.GAE@google.com/T/
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mempolicy.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1080,6 +1080,10 @@ static long migrate_to_node(struct mm_st
 
 	mmap_read_lock(mm);
 	vma = find_vma(mm, 0);
+	if (unlikely(!vma)) {
+		mmap_read_unlock(mm);
+		return 0;
+	}
 
 	/*
 	 * This does not migrate the range, but isolates all pages that


