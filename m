Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A5B1CAA99;
	Thu, 17 Apr 2025 18:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916186; cv=none; b=iqbjobMr2eOTFle0ABRL+axMa6NdVjJ9RsRnDlbrTB8/vIz+ArSroObI7jIuxMz3Rrr41hegGufHw/icPMbN6B/d8zqk/Vd1SpXRSSiJltPnl8rk1TWWjLWkIrUC81b5BB3h2HQnj000yQZoYCEqjJ2+CKfF7UuCWcTRRHYSUkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916186; c=relaxed/simple;
	bh=j9F5EoS8YrMhNcA9yqZVkG7y4zalzcFHHJHRtlbsHnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXYE9f1rcspcKNqhDWbtcLPeutV1kuba8XhiIV0yVgORRNHDq3t02rrRfWNzm7A7L0wUyb46AxYLdX1SijpAiIi8p83B7UnWj/Oe7HZ1LVg8HAOo008KXO8g8NsYtpPxjf7jmRLGwH4CLYP8XYcdTKrBildLGZ32wzzpWGZWZ1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hstKdVWG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hstKdVWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37DD2C4CEE4;
	Thu, 17 Apr 2025 18:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916185;
	bh=j9F5EoS8YrMhNcA9yqZVkG7y4zalzcFHHJHRtlbsHnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hstKdVWG/0ZcZ1Xx7EYnj4WqrZjJepeXoF76VklULYVVAk4gBTOKacBeNNGHJUdR5
	 ZmLKtrEoqp9X47RFczecx4QLNrk/AVc1VS9EqA2cj+tC2tqMrh+bjvhztzPay4Rncu
	 SOLLYWm6r9voIJRwENS2eosKNDwPYFwF4GCSff3E=
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
Subject: [PATCH 6.12 371/393] ring-buffer: Use flush_kernel_vmap_range() over flush_dcache_folio()
Date: Thu, 17 Apr 2025 19:53:00 +0200
Message-ID: <20250417175122.521012448@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


