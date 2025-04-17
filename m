Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF721A3178;
	Thu, 17 Apr 2025 18:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913725; cv=none; b=Nx57vP5Rz+RDde4v51+PGo5cgyeSnLdzIVveHKovVof93PmA+8LsNW7RJUc/x0D6Vk4SgG/1mynP39ZLTxMYxPlSo6MXFkzM6nLNq/g4nicJrLLK3LCi9mqmWaU7rl8w+dbQtOhVm2iaZDZtI0PYoNOUaf43iJSKwFI7Dee9teU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913725; c=relaxed/simple;
	bh=z5nQHlbeRzKn+KgyXLVv5EQ24IpsOzGSAMFXokaELgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iR0IV10BXUz9wK9YECGFONz8f24Vhkrjx/9Vn5S8T8MbrPO8hmI0+SK4jk4TbtsocnfoY+4yYUf2NaxE3sFxoPymqZ/LW6j/HUldpE+OujTpRO8NBi2mbSmQXGfBZ4Y4skDlTFtR8LQDJHHMAQzASviRbQUvHvTZynLU+WbldAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FsnSZAYw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FsnSZAYw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB23C4CEE4;
	Thu, 17 Apr 2025 18:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913724;
	bh=z5nQHlbeRzKn+KgyXLVv5EQ24IpsOzGSAMFXokaELgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FsnSZAYwx7EPubtyI5cZ9lcnwqGn1dRCtUwzkWaqWgY7cDf6rjpaTB1CVmvMrxzv+
	 T7MITewTGjfbEUNCgi31QzMgS1Mra7FGsP3HrvgySvjOTCOFHvcnk/+onmwKFfmFcE
	 NHgX4uG+rbm4ieSdoONNpL1gM5IZI24DDQbzUxoA=
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
Subject: [PATCH 6.14 433/449] ring-buffer: Use flush_kernel_vmap_range() over flush_dcache_folio()
Date: Thu, 17 Apr 2025 19:52:01 +0200
Message-ID: <20250417175135.727650139@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5963,7 +5963,7 @@ static void rb_update_meta_page(struct r
 	meta->read = cpu_buffer->read;
 
 	/* Some archs do not have data cache coherency between kernel and user-space */
-	flush_dcache_folio(virt_to_folio(cpu_buffer->meta_page));
+	flush_kernel_vmap_range(cpu_buffer->meta_page, PAGE_SIZE);
 }
 
 static void
@@ -7278,7 +7278,8 @@ consume:
 
 out:
 	/* Some archs do not have data cache coherency between kernel and user-space */
-	flush_dcache_folio(virt_to_folio(cpu_buffer->reader_page->page));
+	flush_kernel_vmap_range(cpu_buffer->reader_page->page,
+				buffer->subbuf_size + BUF_PAGE_HDR_SIZE);
 
 	rb_update_meta_page(cpu_buffer);
 


