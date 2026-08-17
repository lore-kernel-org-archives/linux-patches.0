Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6871641F5EA;
	Mon, 17 Aug 2026 14:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978209; cv=none; b=Y0kZ6X55sWIcB5D3WQAQvr/ODkxl5mbByQpOQ6vvqDfJmMC3dcLYTJ74QxOjynGcWj/wR6drC02TXsDkbK6sbZEPFJlnK5F67OeJkYLVsdRxkofaE8ZTcyNKWnMgMHTldd4MwbUU66rC7y7EqkxueIbAq15jj/MA1n14ASdbHs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978209; c=relaxed/simple;
	bh=tAmc7LGApxqI8+sx2rWHjcaxiS0ckF+UvUL5eG+VqaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MMAoPePPTVqZRvv+omhePfRZHx0zqeOuwVdDK5ZpmwshAu7jJpjvwjqRnE/MbyZGfWfGHaB5mHGK/BZVgOK5ZYCT0nNzSTWHm8Jb0CKqDTQHSuO7bhqjGgfJlfYPIbj61HvvwTY5dOXNRmSONKILjgx6U2qzpXl4yhCe/Awt4pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BIyy3gyL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BIyy3gyL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36871F000E9;
	Mon, 17 Aug 2026 14:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978208;
	bh=nz6b/TFjmHigvcqFP+k/yUcsv35Kj3/D1QB2Hpy67Ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BIyy3gyL7ovUxoKvn3OAZ4OGqD9RoTsHa0zkMojxTGKZkOazr/7shIqgP75OmJu2l
	 CoX+a74ushCAJdpZMod51tgv+I8p3B6cp1YCR5mU0CMvFs+6ioTPH/u43/JbztwRDv
	 SRS0G7IF5P+4dzofc6f9qzfCzzQ3wZLMrUlkiqe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e0cc44465d6bae735679@syzkaller.appspotmail.com,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 139/181] ring-buffer: Prevent subbuf order change when resizing is disabled
Date: Mon, 17 Aug 2026 15:33:53 +0200
Message-ID: <20260817132541.114416491@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6756,7 +6756,7 @@ int ring_buffer_subbuf_order_set(struct
 
 		cpu_buffer = buffer->buffers[cpu];
 
-		if (cpu_buffer->mapped) {
+		if (atomic_read(&cpu_buffer->resize_disabled)) {
 			err = -EBUSY;
 			goto error;
 		}


