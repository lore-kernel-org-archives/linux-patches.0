Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7C92E8DE4;
	Tue, 17 Jun 2025 16:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178445; cv=none; b=Rc4eDAQXwji+wNAtIT30CEXCuZ1DuWRZ3C2MwfemTim/5NR2XTVicqUJ0maWzFeF6VBevBL4xtNwarq1BQoEfPwzXIGOVfonxSr+kW8R93AB4zUUsm2ng+y+cUJTksr2U4qIfAAmrVI4P+NjwWN6jhQ+EQvGq787QfHJAtuT+vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178445; c=relaxed/simple;
	bh=Izl8cuBTgk0Kep/Yyr6GlVn0njFF4/p0HmhTyir4nHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rmvPXvnSD9z8YMJzxwEpiuxW/hZAK+E08NZ6VFOm1T1SrGAxcBTMxe/GNIyvTfAG/bgsojTR6MRVUWf5i86d91pgvTMNS0GjS2dCMh0Kh3+yrAzmBESaiNEFqF1OODQHkxliuJM4cLnRaDgvFDtfbNFcNRlOxIsJsrZPdhduB/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kfigPqUA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kfigPqUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDA6C4CEE3;
	Tue, 17 Jun 2025 16:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178445;
	bh=Izl8cuBTgk0Kep/Yyr6GlVn0njFF4/p0HmhTyir4nHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kfigPqUA5OaR7WbZYt+l+OL/7VYNRhHGYdXQ6w0IwOD0iAm2/NaN23YOpQoq5KjEK
	 ZL2cKKOrFLadJqk8Mg/MzILbdThRcrSGh0OiLwY8PzfyLUN3HlI0+bdN1/cUHtp41o
	 AaD3PcfMHYWDjoTlB3yCb1JNROECYHRcUFdxNud8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
	syzbot+05d673e83ec640f0ced9@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 500/512] ring-buffer: Fix buffer locking in ring_buffer_subbuf_order_set()
Date: Tue, 17 Jun 2025 17:27:46 +0200
Message-ID: <20250617152439.886871922@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

commit 40ee2afafc1d9fe3aa44a6fbe440d78a5c96a72e upstream.

Enlarge the critical section in ring_buffer_subbuf_order_set() to
ensure that error handling takes place with per-buffer mutex held,
thus preventing list corruption and other concurrency-related issues.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Link: https://lore.kernel.org/20250606112242.1510605-1-dmantipov@yandex.ru
Reported-by: syzbot+05d673e83ec640f0ced9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=05d673e83ec640f0ced9
Fixes: f9b94daa542a8 ("ring-buffer: Set new size of the ring buffer sub page")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -6754,7 +6754,7 @@ int ring_buffer_subbuf_order_set(struct
 	old_size = buffer->subbuf_size;
 
 	/* prevent another thread from changing buffer sizes */
-	mutex_lock(&buffer->mutex);
+	guard(mutex)(&buffer->mutex);
 	atomic_inc(&buffer->record_disabled);
 
 	/* Make sure all commits have finished */
@@ -6859,7 +6859,6 @@ int ring_buffer_subbuf_order_set(struct
 	}
 
 	atomic_dec(&buffer->record_disabled);
-	mutex_unlock(&buffer->mutex);
 
 	return 0;
 
@@ -6868,7 +6867,6 @@ error:
 	buffer->subbuf_size = old_size;
 
 	atomic_dec(&buffer->record_disabled);
-	mutex_unlock(&buffer->mutex);
 
 	for_each_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];


