Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEB7399351;
	Sat, 12 Sep 2026 20:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243303; cv=none; b=CqK/HxK94fQZFExI/5stYveHI2hij7hTl5Sbv8rsLcvOeps60aNsE3PJ3LqNfYsWEtWVXX8ZKL00U0CH8CF3v9bVe1aOyLUFZuQOevdRhLyTTBGTD1Im8PaYy88TQV0fBv4qKaNNzRiNG2mBAY3fgxgWhlVoJ94ddAp0nU7601Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243303; c=relaxed/simple;
	bh=jo80ECIVngO9211TkatlP+69WDwkWoDACcHU+YmnnoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/klSEhrG7oDrp0f895cBVS6NYiHHq5XajofLppYoakkgnVmIaVYpFPll3eOu6z8lPwqelr5I/3lJGYBk4bWOHZq/IyP1VQbh8FE7ZThJpMcTWxC/EqENb9hR3O/yH8ydDQYrcnMrC78sqpfK+D4mwnYVEvdK/2EtttMqKXvFWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vwgTgrp7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vwgTgrp7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27671F00893;
	Sat, 12 Sep 2026 20:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243302;
	bh=Q51toIvWcGcG7zikBFcc1BIPhnenH6YECA4uPFQ1uN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vwgTgrp7QHH6Vff3d1rM3T9wo2Gp3CHSw4vbn8LnBLqwSMTliSb8gW6vhcnVDA627
	 37PUE0hqZHLLIkF4rbWenIm4iPY6Q2oK0NggAcEKiDIKYlIp9gP1Z6GkgMC+YtE50y
	 5VWUf6uw1r7/uYSw2iL7Zj6h2fs7M2AMgJ3TGhWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 709/798] seq_buf: Add seq_buf_terminate() API
Date: Sat, 12 Sep 2026 09:05:37 +0200
Message-ID: <20260912065533.336933537@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

[ Upstream commit f2616c772c768485de18e7fcb2816bcdcd098339 ]

In the case that the seq_buf buffer needs to be printed directly, add a way
to make sure that the buffer is safe to read by forcing a nul terminating
character at the end of the string, or the last byte of the buffer if the
string has overflowed.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Stable-dep-of: ae70b04ab9c7 ("tracing: Have trace_event_update_all() only handle module that is loading")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/seq_buf.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
index 9d6c28cc4d8f2..5b31c51479694 100644
--- a/include/linux/seq_buf.h
+++ b/include/linux/seq_buf.h
@@ -71,6 +71,31 @@ static inline unsigned int seq_buf_used(struct seq_buf *s)
 	return min(s->len, s->size);
 }
 
+/**
+ * seq_buf_terminate - Make sure buffer is nul terminated
+ * @s: the seq_buf descriptor to terminate.
+ *
+ * This makes sure that the buffer in @s is nul terminated and
+ * safe to read as a string.
+ *
+ * Note, if this is called when the buffer has overflowed, then
+ * the last byte of the buffer is zeroed, and the len will still
+ * point passed it.
+ *
+ * After this function is called, s->buffer is safe to use
+ * in string operations.
+ */
+static inline void seq_buf_terminate(struct seq_buf *s)
+{
+	if (WARN_ON(s->size == 0))
+		return;
+
+	if (seq_buf_buffer_left(s))
+		s->buffer[s->len] = 0;
+	else
+		s->buffer[s->size - 1] = 0;
+}
+
 /**
  * seq_buf_get_buf - get buffer to write arbitrary data to
  * @s: the seq_buf handle
-- 
2.53.0



