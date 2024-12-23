Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453FA19E971;
	Mon, 23 Dec 2024 16:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970086; cv=none; b=ktsl9NAYCNGaJcp3URMjKfvGWVB2CQ4+ttXkwsmtyGpUkxSGPBe7WODCQB9n3nptoCD4vycI95vhEesM8GRdWSrzGfvbQ1GGhdXhPEqTj5yvtLCUQ5Vt4Tuk26sANTaOXcWKXiZXjeiwKtZW3XmAH3d8KHzs/gJvGjct2SA7Hxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970086; c=relaxed/simple;
	bh=IIW5NBremAyTO8O+KFXm8Nzp5a6D5QObueJ2+Qp+6/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cbu3JBAkP9XN1mIeyts+Lxt1xsch2XcLAXwrbsdxDZbsuyvsJlahj1H7Eur8v6BNMTYlZ3UwLWYd6bzyqWyqfm28dx9qoCpRwDimtwyz+G5fzAg1zNFCzS0x3ZlUEgZBvFXiVDkCDhAs/ZztEHqL9nJc/RN6A6IHWeTofb0KykA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Io4RW+YQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Io4RW+YQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF892C4CED3;
	Mon, 23 Dec 2024 16:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970086;
	bh=IIW5NBremAyTO8O+KFXm8Nzp5a6D5QObueJ2+Qp+6/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Io4RW+YQNkcm6wIOqwPvXlYTOADUNR6qlgBipFQ5ORgWB68vrgBYRGQQMUv81lHTw
	 rbf4BqOwBZ04xYXFPGlKwzsWaT0OjbyrMmhkHlK3xkjtBhIDIEJy/LO71dNQPB20JQ
	 +PWeWATfRn5/Z8cesENibORW4RwBcRhCHI0lfquU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+345e4443a21200874b18@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 113/160] ring-buffer: Fix overflow in __rb_map_vma
Date: Mon, 23 Dec 2024 16:58:44 +0100
Message-ID: <20241223155413.040678705@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

From: Edward Adam Davis <eadavis@qq.com>

commit c58a812c8e49ad688f94f4b050ad5c5b388fc5d2 upstream.

An overflow occurred when performing the following calculation:

   nr_pages = ((nr_subbufs + 1) << subbuf_order) - pgoff;

Add a check before the calculation to avoid this problem.

syzbot reported this as a slab-out-of-bounds in __rb_map_vma:

BUG: KASAN: slab-out-of-bounds in __rb_map_vma+0x9ab/0xae0 kernel/trace/ring_buffer.c:7058
Read of size 8 at addr ffff8880767dd2b8 by task syz-executor187/5836

CPU: 0 UID: 0 PID: 5836 Comm: syz-executor187 Not tainted 6.13.0-rc2-syzkaller-00159-gf932fb9b4074 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/25/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xc3/0x620 mm/kasan/report.c:489
 kasan_report+0xd9/0x110 mm/kasan/report.c:602
 __rb_map_vma+0x9ab/0xae0 kernel/trace/ring_buffer.c:7058
 ring_buffer_map+0x56e/0x9b0 kernel/trace/ring_buffer.c:7138
 tracing_buffers_mmap+0xa6/0x120 kernel/trace/trace.c:8482
 call_mmap include/linux/fs.h:2183 [inline]
 mmap_file mm/internal.h:124 [inline]
 __mmap_new_file_vma mm/vma.c:2291 [inline]
 __mmap_new_vma mm/vma.c:2355 [inline]
 __mmap_region+0x1786/0x2670 mm/vma.c:2456
 mmap_region+0x127/0x320 mm/mmap.c:1348
 do_mmap+0xc00/0xfc0 mm/mmap.c:496
 vm_mmap_pgoff+0x1ba/0x360 mm/util.c:580
 ksys_mmap_pgoff+0x32c/0x5c0 mm/mmap.c:542
 __do_sys_mmap arch/x86/kernel/sys_x86_64.c:89 [inline]
 __se_sys_mmap arch/x86/kernel/sys_x86_64.c:82 [inline]
 __x64_sys_mmap+0x125/0x190 arch/x86/kernel/sys_x86_64.c:82
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The reproducer for this bug is:

------------------------8<-------------------------
 #include <fcntl.h>
 #include <stdlib.h>
 #include <unistd.h>
 #include <asm/types.h>
 #include <sys/mman.h>

 int main(int argc, char **argv)
 {
	int page_size = getpagesize();
	int fd;
	void *meta;

	system("echo 1 > /sys/kernel/tracing/buffer_size_kb");
	fd = open("/sys/kernel/tracing/per_cpu/cpu0/trace_pipe_raw", O_RDONLY);

	meta = mmap(NULL, page_size, PROT_READ, MAP_SHARED, fd, page_size * 5);
 }
------------------------>8-------------------------

Cc: stable@vger.kernel.org
Fixes: 117c39200d9d7 ("ring-buffer: Introducing ring-buffer mapping functions")
Link: https://lore.kernel.org/tencent_06924B6674ED771167C23CC336C097223609@qq.com
Reported-by: syzbot+345e4443a21200874b18@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=345e4443a21200874b18
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 7e257e855dd1..60210fb5b211 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -7019,7 +7019,11 @@ static int __rb_map_vma(struct ring_buffer_per_cpu *cpu_buffer,
 	lockdep_assert_held(&cpu_buffer->mapping_lock);
 
 	nr_subbufs = cpu_buffer->nr_pages + 1; /* + reader-subbuf */
-	nr_pages = ((nr_subbufs + 1) << subbuf_order) - pgoff; /* + meta-page */
+	nr_pages = ((nr_subbufs + 1) << subbuf_order); /* + meta-page */
+	if (nr_pages <= pgoff)
+		return -EINVAL;
+
+	nr_pages -= pgoff;
 
 	nr_vma_pages = vma_pages(vma);
 	if (!nr_vma_pages || nr_vma_pages > nr_pages)
-- 
2.47.1



