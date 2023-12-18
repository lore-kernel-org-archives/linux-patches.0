Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE581D141;
	Mon, 18 Dec 2023 14:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ukly9lIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FF6C433C7;
	Mon, 18 Dec 2023 14:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908891;
	bh=aREAXbDz2y9H5KkPigWxCpYkO6/6kJS001CsclO/1bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ukly9lIsSrDRQcqY2+JUxc8CcwFw4X65xz2Bc9TM4rMv7KJFPZ1nBYGvOxEDAsIb7
	 QND9nCN+kbVCwyJjGkSOJbCwBo07/uIRSDE2/CDriypCB4C+qf8sf/YL5QjVIhtKuw
	 vSrjaa+RgauqxdQ2lOMv3GUVkUibGnzM6nX5nHGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 72/83] ring-buffer: Have saved event hold the entire event
Date: Mon, 18 Dec 2023 14:52:33 +0100
Message-ID: <20231218135052.898623247@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135049.738602288@linuxfoundation.org>
References: <20231218135049.738602288@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit b049525855fdd0024881c9b14b8fbec61c3f53d3 upstream.

For the ring buffer iterator (non-consuming read), the event needs to be
copied into the iterator buffer to make sure that a writer does not
overwrite it while the user is reading it. If a write happens during the
copy, the buffer is simply discarded.

But the temp buffer itself was not big enough. The allocation of the
buffer was only BUF_MAX_DATA_SIZE, which is the maximum data size that can
be passed into the ring buffer and saved. But the temp buffer needs to
hold the meta data as well. That would be BUF_PAGE_SIZE and not
BUF_MAX_DATA_SIZE.

Link: https://lore.kernel.org/linux-trace-kernel/20231212072558.61f76493@gandalf.local.home

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Fixes: 785888c544e04 ("ring-buffer: Have rb_iter_head_event() handle concurrent writer")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2367,7 +2367,7 @@ rb_iter_head_event(struct ring_buffer_it
 	 */
 	barrier();
 
-	if ((iter->head + length) > commit || length > BUF_MAX_DATA_SIZE)
+	if ((iter->head + length) > commit || length > BUF_PAGE_SIZE)
 		/* Writer corrupted the read? */
 		goto reset;
 
@@ -5066,7 +5066,8 @@ ring_buffer_read_prepare(struct trace_bu
 	if (!iter)
 		return NULL;
 
-	iter->event = kmalloc(BUF_MAX_DATA_SIZE, flags);
+	/* Holds the entire event: data and meta data */
+	iter->event = kmalloc(BUF_PAGE_SIZE, flags);
 	if (!iter->event) {
 		kfree(iter);
 		return NULL;


