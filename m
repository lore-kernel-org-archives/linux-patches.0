Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E42305668;
	Fri, 15 May 2026 15:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860629; cv=none; b=T5CDZMw2QFAq0lMPXf4rUdZtauQWh9vH+8ty5ddB0m7Fo1q/sFTLSUyHkmh3eBJahK5ZllZYfHZlYSyG70KzHMWOQ+99xYyW5MNA9qmL2X9450khzkeGzTeSCtl9rs1j7t7Ck1GKNKbZut1GSNk9wWjZsHFvbrP+3/bgaioK+Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860629; c=relaxed/simple;
	bh=EO4qzNLkyCyUVyLQbWWGcRXvj6Ge6Slwusq4wQzipn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J6+3pCek98bV8xC8mBkV8nvZMCXKT7FXMA/ZQiPteqq561Zhhfx6VCCO9zakUqLzA5LL1dqvdXCGfbML5C3ITB45m5HjAYrzlUViCM/RtsukBq1dokdlQGw+hfWQENVi39sJqtBswnMID0vurN8M3KprfFskXyjrLEOuVvLNdp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1YZFdb4h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1YZFdb4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB320C2BCB0;
	Fri, 15 May 2026 15:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860629;
	bh=EO4qzNLkyCyUVyLQbWWGcRXvj6Ge6Slwusq4wQzipn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1YZFdb4h34RxlSAPHXboQkCQUe+MJ36UlON0wIABoas0OFqS1TYBEO7DaEjnnXcGI
	 lqZBUKNVHSiZetQl3lt4Erx096d6knDQBlTu1hHxAPK3s2NSB8X3XeS2bAXEsZM7iT
	 ucMNjcbpN54XDS7VzUakyAxnpYbYIKe5kZeNJDt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Jan Kara <jack@suse.cz>,
	Kees Cook <keescook@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Wen Yang <wen.yang@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/474] regset: use kvzalloc() for regset_get_alloc()
Date: Fri, 15 May 2026 17:42:08 +0200
Message-ID: <20260515154715.468366786@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Douglas Anderson <dianders@chromium.org>

commit 6b839b3b76cf17296ebd4a893841f32cae08229c upstream.

While browsing through ChromeOS crash reports, I found one with an
allocation failure that looked like this:

  chrome: page allocation failure: order:7,
          mode:0x40dc0(GFP_KERNEL|__GFP_COMP|__GFP_ZERO),
	  nodemask=(null),cpuset=urgent,mems_allowed=0
  CPU: 7 PID: 3295 Comm: chrome Not tainted
          5.15.133-20574-g8044615ac35c #1 (HASH:1162 1)
  Hardware name: Google Lazor (rev3 - 8) with KB Backlight (DT)
  Call trace:
  ...
  warn_alloc+0x104/0x174
  __alloc_pages+0x5f0/0x6e4
  kmalloc_order+0x44/0x98
  kmalloc_order_trace+0x34/0x124
  __kmalloc+0x228/0x36c
  __regset_get+0x68/0xcc
  regset_get_alloc+0x1c/0x28
  elf_core_dump+0x3d8/0xd8c
  do_coredump+0xeb8/0x1378
  get_signal+0x14c/0x804
  ...

An order 7 allocation is (1 << 7) contiguous pages, or 512K. It's not
a surprise that this allocation failed on a system that's been running
for a while.

More digging showed that it was fairly easy to see the order 7
allocation by just sending a SIGQUIT to chrome (or other processes) to
generate a core dump. The actual amount being allocated was 279,584
bytes and it was for "core_note_type" NT_ARM_SVE.

There was quite a bit of discussion [1] on the mailing lists in
response to my v1 patch attempting to switch to vmalloc. The overall
conclusion was that we could likely reduce the 279,584 byte allocation
by quite a bit and Mark Brown has sent a patch to that effect [2].
However even with the 279,584 byte allocation gone there are still
65,552 byte allocations. These are just barely more than the 65,536
bytes and thus would require an order 5 allocation.

An order 5 allocation is still something to avoid unless necessary and
nothing needs the memory here to be contiguous. Change the allocation
to kvzalloc() which should still be efficient for small allocations
but doesn't force the memory subsystem to work hard (and maybe fail)
at getting a large contiguous chunk.

[1] https://lore.kernel.org/r/20240201171159.1.Id9ad163b60d21c9e56c2d686b0cc9083a8ba7924@changeid
[2] https://lore.kernel.org/r/20240203-arm64-sve-ptrace-regset-size-v1-1-2c3ba1386b9e@kernel.org

Link: https://lkml.kernel.org/r/20240205092626.v2.1.Id9ad163b60d21c9e56c2d686b0cc9083a8ba7924@changeid
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Wen Yang <wen.yang@linux.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/binfmt_elf.c | 2 +-
 kernel/regset.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 3ff7d2e47c7e9..e4348dd76658e 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -2035,7 +2035,7 @@ static void free_note_info(struct elf_note_info *info)
 		threads = t->next;
 		WARN_ON(t->notes[0].data && t->notes[0].data != &t->prstatus);
 		for (i = 1; i < info->thread_notes; ++i)
-			kfree(t->notes[i].data);
+			kvfree(t->notes[i].data);
 		kfree(t);
 	}
 	kfree(info->psinfo.data);
diff --git a/kernel/regset.c b/kernel/regset.c
index 586823786f397..b2871fa68b2a7 100644
--- a/kernel/regset.c
+++ b/kernel/regset.c
@@ -16,14 +16,14 @@ static int __regset_get(struct task_struct *target,
 	if (size > regset->n * regset->size)
 		size = regset->n * regset->size;
 	if (!p) {
-		to_free = p = kzalloc(size, GFP_KERNEL);
+		to_free = p = kvzalloc(size, GFP_KERNEL);
 		if (!p)
 			return -ENOMEM;
 	}
 	res = regset->regset_get(target, regset,
 			   (struct membuf){.p = p, .left = size});
 	if (res < 0) {
-		kfree(to_free);
+		kvfree(to_free);
 		return res;
 	}
 	*data = p;
@@ -71,6 +71,6 @@ int copy_regset_to_user(struct task_struct *target,
 	ret = regset_get_alloc(target, regset, size, &buf);
 	if (ret > 0)
 		ret = copy_to_user(data, buf, ret) ? -EFAULT : 0;
-	kfree(buf);
+	kvfree(buf);
 	return ret;
 }
-- 
2.53.0



