Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A9B39478D;
	Sat, 30 May 2026 16:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159841; cv=none; b=KVwF4i31zT7FByiP2UUzfLuij/TQsMcXHOO2XLAJt3gH5ZxldYvCYdqI4odUUzLofBbIrZ51QtJHvCZfTpAm/idgrhms0Lys24sjS0i16CFO2llDy9T5DGq8pFzb+a+pCdZExz1rmxXPSCKfgpSm6s9h5GYErj+vAlpYqPcwxKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159841; c=relaxed/simple;
	bh=2LEvt0zmlNuzw1WXfG71HshMunekWdJJd4N3DV3F6ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fu1rnmWA2bRvHkaA3QGdI0XGHpdXR4V4/loe2S8q4gOj8PLbBGp4WlotPvTuUAXiPYWikRb3sxDz2UsI341/tPK7+pMSeSxk9nxMMeZkPDJj0De0qbwqJv4VnCmH/SLgOPEgMctK/MgM+2zDeVCSZAHYBsHodCyXC05AAaw5wIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gVWqHSdd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gVWqHSdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300F21F00893;
	Sat, 30 May 2026 16:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159840;
	bh=00LS3Au5XXPgs2yOilIJsC2xJuYXMFlTsQHXWSH8BNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gVWqHSddWdl4ff+zuuooQSiKyYb3QEOmBKyisosoGpaFfYxxuNnp3MMYvv+JHjcF1
	 Pd9tuE6YI3LEbdtXYqxx1qd6jjHX7yDRRQloeNgvR8UJ/qQHeqx6k/Rew38Cx9CRzQ
	 lrwbjvZgK5TZwd9KQUEIOjmCkdqzIlfAYX/3aoDQ=
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
Subject: [PATCH 6.1 176/969] regset: use kvzalloc() for regset_get_alloc()
Date: Sat, 30 May 2026 17:55:00 +0200
Message-ID: <20260530160305.355689378@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 762704eed9ce9..2fa739f2f7bb8 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -2014,7 +2014,7 @@ static void free_note_info(struct elf_note_info *info)
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



