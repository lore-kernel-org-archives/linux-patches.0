Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B868118C034;
	Thu, 17 Apr 2025 18:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914978; cv=none; b=algeIW77P4s0mZYC0ymsqyrqlSpYmgui+JM4dSCke58Ewr9Jd/gzoQygkS+ut8apstlMnQimRALVkGbHolDs1zcX/N1kLY4vBKA01lIhdLGDyoyVqphmsqRzkA1AfZ1iDcT6pc6IyubmIE8250ZVM9vMtZ8ASLdnJT0Mik7WU6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914978; c=relaxed/simple;
	bh=SoaDQ/QHc1SSgt2tdr1C411B+Z3vJP4UPE6EpLfm92Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8PkPmEguO9eqkSFZx7vlDVSVIpkTtC81XuaDrGonZWxzYWu9wWzAyW4Z6LxcEEYRsMOyEDX927xInCbIclkkVDMXPKIyKTTraCje3EXRsBZ5JDNuGGKYGBdinbC3Vr5ci9Pjx5Z6BUYPYaPxouq5dBU3zD0EP7wjuq7uwPnkgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PICiw/bX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PICiw/bX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F20C4CEE4;
	Thu, 17 Apr 2025 18:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914978;
	bh=SoaDQ/QHc1SSgt2tdr1C411B+Z3vJP4UPE6EpLfm92Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PICiw/bXIPAQPBuLlgsNrTn9Z8hqyICoWmm9K0JGkWvnJEkB5mEmfPVQGZmDfeFo/
	 zyvSD8XOJ3ZliPpv3zcQNsuNtiliudEFMpFUsHvHDmapH0JJsQExJSHFjeIoZGa0vV
	 Pnq4st8Be2+2eb/jKcRm9WxBCikRy2tcYQGa0v+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Jann Horn <jannh@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.13 393/414] ring-buffer: Use flush_kernel_vmap_range() over flush_dcache_folio()
Date: Thu, 17 Apr 2025 19:52:31 +0200
Message-ID: <20250417175127.296212845@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit e4d4b8670c44cdd22212cab3c576e2d317efa67c upstream.

Some architectures do not have data cache coherency between user and
kernel space. For these architectures, the cache needs to be flushed on
both the kernel and user addresses so that user space can see the updates
the kernel has made.

Instead of using flush_dcache_folio() and playing with virt_to_folio()
within the call to that function, use flush_kernel_vmap_range() which
takes the virtual address and does the work for those architectures that
need it.

This also fixes a bug where the flush of the reader page only flushed one
page. If the sub-buffer order is 1 or more, where the sub-buffer size
would be greater than a page, it would miss the rest of the sub-buffer
content, as the "reader page" is not just a page, but the size of a
sub-buffer.

Link: https://lore.kernel.org/all/CAG48ez3w0my4Rwttbc5tEbNsme6tc0mrSN95thjXUFaJ3aQ6SA@mail.gmail.com/

Cc: stable@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Vincent Donnefort <vdonnefort@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Link: https://lore.kernel.org/20250402144953.920792197@goodmis.org
Fixes: 117c39200d9d7 ("ring-buffer: Introducing ring-buffer mapping functions");
Suggested-by: Jann Horn <jannh@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -5994,7 +5994,7 @@ static void rb_update_meta_page(struct r
 	meta->read = cpu_buffer->read;
 
 	/* Some archs do not have data cache coherency between kernel and user-space */
-	flush_dcache_folio(virt_to_folio(cpu_buffer->meta_page));
+	flush_kernel_vmap_range(cpu_buffer->meta_page, PAGE_SIZE);
 }
 
 static void
@@ -7309,7 +7309,8 @@ consume:
 
 out:
 	/* Some archs do not have data cache coherency between kernel and user-space */
-	flush_dcache_folio(virt_to_folio(cpu_buffer->reader_page->page));
+	flush_kernel_vmap_range(cpu_buffer->reader_page->page,
+				buffer->subbuf_size + BUF_PAGE_HDR_SIZE);
 
 	rb_update_meta_page(cpu_buffer);
 


