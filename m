Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10A72FA624;
	Tue, 17 Jun 2025 16:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179578; cv=none; b=pOBP/qHl+1misxCo8JysI63O06mlFFQG6u/uDc0ln4tDweInw2g8hX2ef6mwcxGXykdizSfOElfrdm9qN97a4iQaXdCif71/p6zHRlw9pWfIBh9vG1c26L4zEwTl88DQLbRy9UO64JwZ8lZi5vy18+Q5o1/rNE6gjNudO9tZUAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179578; c=relaxed/simple;
	bh=ZJ7WnB75ZXawUh0yNUj+GOLV8xZbkLRdIxLm87ZJNIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQDNB5/wXzoTbRGldep16dn6f5EvIo5FxqM+dLTSfcUzsckUK6xWTO78g359qR5/W7sgt92Z48vXFY6PLNtoi2BUuQQWF5k2gXiDzem9pHPw2A6xeZJKrVnPVBkYKVUvI2lj1AcpvLtTQ7VYsh7hZBZnKM0b9YWzNs8Mj5+Z0Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iCyfQIGK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iCyfQIGK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403D1C4CEE3;
	Tue, 17 Jun 2025 16:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179578;
	bh=ZJ7WnB75ZXawUh0yNUj+GOLV8xZbkLRdIxLm87ZJNIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iCyfQIGKxy9mGJ96SUFfnaerLYnlDCTCMcxD4oXyAKjT58DthYkdbKHIprZZQQtPq
	 jj0uxnXgWuK+4Hsl7Tht5U95yNQGM7g8WZ5jQIPqRbRqYdR0XxYcVD5GxXFv7W3XkP
	 a+ygUOWxq1DxxMSuGL5u7IUYkxbvqkWxdgXoDOdE=
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
Subject: [PATCH 6.15 767/780] ring-buffer: Fix buffer locking in ring_buffer_subbuf_order_set()
Date: Tue, 17 Jun 2025 17:27:55 +0200
Message-ID: <20250617152522.748685578@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6764,7 +6764,7 @@ int ring_buffer_subbuf_order_set(struct
 	old_size = buffer->subbuf_size;
 
 	/* prevent another thread from changing buffer sizes */
-	mutex_lock(&buffer->mutex);
+	guard(mutex)(&buffer->mutex);
 	atomic_inc(&buffer->record_disabled);
 
 	/* Make sure all commits have finished */
@@ -6869,7 +6869,6 @@ int ring_buffer_subbuf_order_set(struct
 	}
 
 	atomic_dec(&buffer->record_disabled);
-	mutex_unlock(&buffer->mutex);
 
 	return 0;
 
@@ -6878,7 +6877,6 @@ error:
 	buffer->subbuf_size = old_size;
 
 	atomic_dec(&buffer->record_disabled);
-	mutex_unlock(&buffer->mutex);
 
 	for_each_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];


