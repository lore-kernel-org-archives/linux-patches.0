Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53606498A1;
	Mon, 18 Dec 2023 14:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ww9MoL7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A79C433C7;
	Mon, 18 Dec 2023 14:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908383;
	bh=23FNE2FSkGTEBClHl3nP1ffN/+0BYdwN/VN75Op/Uqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ww9MoL7y3SRuXWlzTr85MZ0awzrGOd5FpBLgGUtTGNvpiYzppX12udi3phDpZMsch
	 G2NdUZAUFdYch4E5oYh8MElxYrP1DLGVR2/O1Sdy6Rd+twoZSqUcdNLIj5RKwSesg0
	 TQ5fAEnYm/gsrqr3MrGdHWHUzyXRkr6LIsGQq2kY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 157/166] ring-buffer: Fix memory leak of free page
Date: Mon, 18 Dec 2023 14:52:03 +0100
Message-ID: <20231218135112.168079712@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 17d801758157bec93f26faaf5ff1a8b9a552d67a upstream.

Reading the ring buffer does a swap of a sub-buffer within the ring buffer
with a empty sub-buffer. This allows the reader to have full access to the
content of the sub-buffer that was swapped out without having to worry
about contention with the writer.

The readers call ring_buffer_alloc_read_page() to allocate a page that
will be used to swap with the ring buffer. When the code is finished with
the reader page, it calls ring_buffer_free_read_page(). Instead of freeing
the page, it stores it as a spare. Then next call to
ring_buffer_alloc_read_page() will return this spare instead of calling
into the memory management system to allocate a new page.

Unfortunately, on freeing of the ring buffer, this spare page is not
freed, and causes a memory leak.

Link: https://lore.kernel.org/linux-trace-kernel/20231210221250.7b9cc83c@rorschach.local.home

Cc: stable@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Fixes: 73a757e63114d ("ring-buffer: Return reader page back into existing ring buffer")
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1787,6 +1787,8 @@ static void rb_free_cpu_buffer(struct ri
 		free_buffer_page(bpage);
 	}
 
+	free_page((unsigned long)cpu_buffer->free_page);
+
 	kfree(cpu_buffer);
 }
 


