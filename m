Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5083E46D091;
	Thu, 20 Aug 2026 17:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247282; cv=none; b=nbGl2HiGOzrWc6f9LvzFor2QLnmsno2FkmJaLgDKbvWThQ1OrNo2vzVjULZ8U3+cxA5p20NUaIZaIfBf+kLkrvBQnfMqq6an8HmXXHx2HQa3SNx9r7924W+AhhDXn8uZULj9oJon4K3l0iiEyMYkjF2+ObhZpHCkN4Kq8ENugZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247282; c=relaxed/simple;
	bh=8rFdU7W3kjE5aCejvic+byoo3aCycqjySkxsDgONBoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iFqTYLiCk25d4K9qLlTB3ccTwOV8V9H1gEfd6CDbzH2kIGj0toe/4zX7d3N/qsczhqvLDBbr0cR7GFzcfYfwgGiZiPkcMW4d/0YRVgLfBDIJsRBdSPVXH4chSJHT/SvwyNkr6n6KSDlRQYFSSumlmArOX8QMsywinegeZinbbG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wSk05rBU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wSk05rBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEDBD1F000E9;
	Thu, 20 Aug 2026 17:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247281;
	bh=k3uGY+JgjzB8eu+DlOMT3TSiz6ZndmJHzZxWLstypPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wSk05rBUq7G8je4HvNAx8r+I8FZjXdFB/zF6RUODg0CevPEUP51CYU80bIent5ZvP
	 CJUoGZd46RI1NI20CDYkbMLuYpwlI1afXw9HtkMjG9fnB+3nfFKDdmjeWJ1qVCGreA
	 CvA+5alwE7eWPAf1yjI9Llyx+Vpxy0oAzkGawrpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 185/220] ring-buffer: Prevent resizing of persistent ring buffer
Date: Thu, 20 Aug 2026 16:56:15 +0200
Message-ID: <20260820145229.060320158@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

[ Upstream commit 7c727dfce6be04dd009b29091a4a17d952dbfe03 ]

Dynamically resizing a persistent ring buffer is not possible. Disable
the feature.

Cc: stable@vger.kernel.org
Fixes: be68d63a139b ("ring-buffer: Add ring_buffer_alloc_range()")
Link: https://patch.msgid.link/20260806211306.3704194-2-vdonnefort@google.com
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ Dropped the incoming `} else if (buffer->remote) {` branch context, which does not exist in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2239,6 +2239,8 @@ rb_allocate_cpu_buffer(struct trace_buff
 		if (cpu_buffer->ring_meta->head_buffer)
 			rb_meta_buffer_update(cpu_buffer, bpage);
 		bpage->range = 1;
+
+		atomic_inc(&cpu_buffer->resize_disabled);
 	} else {
 		page = alloc_pages_node(cpu_to_node(cpu),
 					GFP_KERNEL | __GFP_COMP | __GFP_ZERO,


