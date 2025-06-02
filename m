Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464792C327E;
	Mon,  2 Jun 2025 14:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875054; cv=none; b=JujeUDBSxQ4E6swhcxqbeogIvNrCvXblNS0QwSxBs/Jaol1RbFlKuZa6kvR0mb4hDaTAQvZ5TcCx4x2k+ictJnKFMiSlmN5tc5OmkcR/B1c3xtuh9MR7ag/Wy4rGsRoEA98OZ+ehGep1b2PhyMZC4GrXgXXcH+NpoFq9Npwh8s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875054; c=relaxed/simple;
	bh=Nh7ihVqUm7Mpr/imBPiNuJ2WjuzWr0yuO7vvreGalA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ddaTyddU097nZa1naKp5RwC5M9J2d4Tvd5RJG3oJwKzO6L44YY7ASwEsVVXs/2IrlQ5DU9bn6aPK6uHnTkZnXkUSgwMOReR6GS/HKiM9xMmAipcik6XpzA4r5LZ8LTYl19oPQLIA0+FPENJAcG5YClpuByAVq0jgT6pCGBV/4iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P4AAVN2g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P4AAVN2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC2DC4CEEB;
	Mon,  2 Jun 2025 14:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875054;
	bh=Nh7ihVqUm7Mpr/imBPiNuJ2WjuzWr0yuO7vvreGalA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P4AAVN2gxUXzTn+mW+e08THale6XDYXXbD1O+4cDXMNA/wjN4SjRjWy4yuhCfknH9
	 LOdhcfjwhZ05Q2RL6ZBYAxlUYa2djER1nx8l6tDNpiUBtIBVac5qupBYDXySc6rGe5
	 5phuSKx+sjfV8u4xJ+2bSqlbi6KJRSrsm/CUHJB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c8cd2d2c412b868263fb@syzkaller.appspotmail.com,
	Steven Rostedt <rostedt@goodmis.org>,
	Jeongjun Park <aha310510@gmail.com>
Subject: [PATCH 5.10 014/270] tracing: Fix oob write in trace_seq_to_buffer()
Date: Mon,  2 Jun 2025 15:44:59 +0200
Message-ID: <20250602134307.776619126@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

From: Jeongjun Park <aha310510@gmail.com>

commit f5178c41bb43444a6008150fe6094497135d07cb upstream.

syzbot reported this bug:
==================================================================
BUG: KASAN: slab-out-of-bounds in trace_seq_to_buffer kernel/trace/trace.c:1830 [inline]
BUG: KASAN: slab-out-of-bounds in tracing_splice_read_pipe+0x6be/0xdd0 kernel/trace/trace.c:6822
Write of size 4507 at addr ffff888032b6b000 by task syz.2.320/7260

CPU: 1 UID: 0 PID: 7260 Comm: syz.2.320 Not tainted 6.15.0-rc1-syzkaller-00301-g3bde70a2c827 #0 PREEMPT(full)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:408 [inline]
 print_report+0xc3/0x670 mm/kasan/report.c:521
 kasan_report+0xe0/0x110 mm/kasan/report.c:634
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0xef/0x1a0 mm/kasan/generic.c:189
 __asan_memcpy+0x3c/0x60 mm/kasan/shadow.c:106
 trace_seq_to_buffer kernel/trace/trace.c:1830 [inline]
 tracing_splice_read_pipe+0x6be/0xdd0 kernel/trace/trace.c:6822
 ....
==================================================================

It has been reported that trace_seq_to_buffer() tries to copy more data
than PAGE_SIZE to buf. Therefore, to prevent this, we should use the
smaller of trace_seq_used(&iter->seq) and PAGE_SIZE as an argument.

Link: https://lore.kernel.org/20250422113026.13308-1-aha310510@gmail.com
Reported-by: syzbot+c8cd2d2c412b868263fb@syzkaller.appspotmail.com
Fixes: 3c56819b14b0 ("tracing: splice support for tracing_pipe")
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6685,13 +6685,14 @@ static ssize_t tracing_splice_read_pipe(
 		/* Copy the data into the page, so we can start over. */
 		ret = trace_seq_to_buffer(&iter->seq,
 					  page_address(spd.pages[i]),
-					  trace_seq_used(&iter->seq));
+					  min((size_t)trace_seq_used(&iter->seq),
+						  PAGE_SIZE));
 		if (ret < 0) {
 			__free_page(spd.pages[i]);
 			break;
 		}
 		spd.partial[i].offset = 0;
-		spd.partial[i].len = trace_seq_used(&iter->seq);
+		spd.partial[i].len = ret;
 
 		trace_seq_init(&iter->seq);
 	}


