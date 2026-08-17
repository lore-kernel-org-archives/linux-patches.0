Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD603ACA74;
	Mon, 17 Aug 2026 13:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974469; cv=none; b=P+pKLU+k6zJXqUYHw7h73HCoc7tahCvRMe0K5E1jHG5xp8DTVjHcKJ9dfclzpWg9DWdC7luCZSBpS8zdo7AdVFMH23fq+Xvqzh6Ulx4ytbkDJ7VljvUS9jj696WkuxhglG+u/oXAbiWqWQ6gsUsd77JVW/eqMPSv4wQhkcd0/+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974469; c=relaxed/simple;
	bh=PPvhjNUT8eGeO0isSovpBn6Bm/cQgqJun0aReUtYoJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFYBZUYuKh9omAcRBwD9jXYWWSg7n4Rr2wjE1Bphbopbcq8eMZesDXzOMuPRRuFTge8KCXl642zduo9OZ1XUFMHK8aIVAce6Jem9Wb7/CIMRb5lJ3ZqzTQ5Pep6P9kDxW5WWrqAhTbgb3yjpXuUcLjZMpUWJsTivOeHyrTxrf4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rX4UVO/K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rX4UVO/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6791F00A3D;
	Mon, 17 Aug 2026 13:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974463;
	bh=nZo/SwCqqVM1a32CYjZ0nv/AsEd2tiSez/aPSYsfESs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rX4UVO/KV/TDE4NbQmgOzZnAK6JY/7xqmwukObIsnWf62eOJQIIzJKngKVm9yFKkn
	 Xl+OBE/t3g3nH1TlDc0JrYVA5pf9Afgaw23dL0YokGdsk4vVLSxIa4Lb7QWNvcsxmo
	 x6Yt83QTw4QNJuDQsQ9ldezY6fZu3CAbYRmc8K1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e0cc44465d6bae735679@syzkaller.appspotmail.com,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.1 207/271] ring-buffer: Prevent subbuf order change when resizing is disabled
Date: Mon, 17 Aug 2026 15:32:12 +0200
Message-ID: <20260817132545.327549620@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Donnefort <vdonnefort@google.com>

commit bf98d7b0d5a99991e47e66cee4eb1d3fa514be97 upstream.

Because ring_buffer_subbuf_order_set() frees buffer pages, we can't
allow it when resizing is disabled. A non-consuming reader is at risk of
use-after-free (rb_advance_iter()).

Return -EBUSY on resize_disabled, matching ring_buffer_resize()
behaviour.

Cc: stable@vger.kernel.org
Fixes: f9b94daa542a ("ring-buffer: Set new size of the ring buffer sub page")
Link: https://patch.msgid.link/20260806211306.3704194-3-vdonnefort@google.com
Reported-by: syzbot+e0cc44465d6bae735679@syzkaller.appspotmail.com
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -7168,7 +7168,7 @@ int ring_buffer_subbuf_order_set(struct
 
 		cpu_buffer = buffer->buffers[cpu];
 
-		if (cpu_buffer->mapped) {
+		if (atomic_read(&cpu_buffer->resize_disabled)) {
 			err = -EBUSY;
 			goto error;
 		}


