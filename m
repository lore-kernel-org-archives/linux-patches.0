Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625103AD53C;
	Mon, 23 Mar 2026 14:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275007; cv=none; b=jhZikhrazN5oKjfCxzODqnmcLYPOY+I7dCIIqnz3IKrhTmkC2dDymu4eqOUI9zlAGS97iKDAXwenaCNJXKKXfQDvX6fqYykkdg5PgyXluL4vBlfIwWt4ZPTFDflHzm+BQIOwKEGEt53H8UmmmQapxJYxC5vMfMpUA471HXnQy8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275007; c=relaxed/simple;
	bh=f/0ThroJHbbm+xINyx4fNXAfurbuBsfcrfoCOMPIDUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=piMnTRb/iwxyxXuMUj3FxIfrV2Ff6QVjGtAo7tbAgN2d5DFIyV8ME4j99+X8ozwARWjh7RyqYXTIdT69OLkMDT47vFotWe5s1A4SFiplNeXxgJSSr8TrN0oyYmzlZc1AWmwVxKxu+8w7BhYLohwyjTCc4AEDiuud/tv9sN5s7Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LBqNNfEF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LBqNNfEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7B2C4CEF7;
	Mon, 23 Mar 2026 14:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275007;
	bh=f/0ThroJHbbm+xINyx4fNXAfurbuBsfcrfoCOMPIDUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LBqNNfEF5im8MOLZpOP6hAqJcdlUxHzR0pfZEHuvRfQ1QEZV00+4n3BujKIoMvX9C
	 IjBrvwbmljMNS4kFbpg0aq7pZA0c4X3GlMIGbKR45DOPc0MJ63tsa4gW6nk9zXkYUT
	 MxU1Un9ytxqStZhzZ4sMA1p2iQRAqQIMgXGtD7k8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ian Rogers <irogers@google.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.18 191/212] ring-buffer: Fix to update per-subbuf entries of persistent ring buffer
Date: Mon, 23 Mar 2026 14:46:52 +0100
Message-ID: <20260323134509.769841371@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit f35dbac6942171dc4ce9398d1d216a59224590a9 upstream.

Since the validation loop in rb_meta_validate_events() updates the same
cpu_buffer->head_page->entries, the other subbuf entries are not updated.
Fix to use head_page to update the entries field, since it is the cursor
in this loop.

Cc: stable@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ian Rogers <irogers@google.com>
Fixes: 5f3b6e839f3c ("ring-buffer: Validate boot range memory events")
Link: https://patch.msgid.link/177391153882.193994.17158784065013676533.stgit@mhiramat.tok.corp.google.com
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2017,7 +2017,7 @@ static void rb_meta_validate_events(stru
 
 		entries += ret;
 		entry_bytes += local_read(&head_page->page->commit);
-		local_set(&cpu_buffer->head_page->entries, ret);
+		local_set(&head_page->entries, ret);
 
 		if (head_page == cpu_buffer->commit_page)
 			break;


