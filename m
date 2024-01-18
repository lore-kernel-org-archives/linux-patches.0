Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16661774B;
	Thu, 18 Jan 2024 10:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575305; cv=none; b=DB9p4YvMqgwyq96RlHRDJk9Zg1NfbhZjjnCOIrbSVhMD57OZiOnRZ6KnWThmAvMVaI+XL7yRgvRZn8Cr0igiDrXeycM1TbtqUXAJ42WTOiIluqBBKMfDIb7WOeeWkAHRlRlWgiwGt3yEzoZ7nF/n+LRW55mz+49OBcl/Ymw7+Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575305; c=relaxed/simple;
	bh=sQy3sHiCI3SeWNqRE/Dl6j1vBNJ50JW21KoA1BvWmZU=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=clVLDq/CWadJFMjXfJHLc+orwAEuYzuVQBsVCY/0ZcSJWEnnE8gWT7Np5IutAn+8/d1kirqIppwgVdajs5cpPMX26ckQ5nU/tlPRtmVLthvAmTAfl7rPzZ09loiSbrfI6SIG6i5fj16clIAIt4KbCShZ2hGP3MTC43vOUhqUBeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aq0dZ049; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aq0dZ049"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668CAC433C7;
	Thu, 18 Jan 2024 10:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575304;
	bh=sQy3sHiCI3SeWNqRE/Dl6j1vBNJ50JW21KoA1BvWmZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aq0dZ049Sn7xSmPKikBFHG2Z9fqWYFq0w5xmgOikfx+2oIilZqOQZftk35HqCzxHR
	 oemyl+rjjva46iJJU/W1VkzTcfCiTnV9MHO779Ytr1xnH+RcymLKilL8DsMMKUBUPZ
	 kcAqENrpLAurjK0QnL3XFnKBtDSKSEErWA4Kx2g8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/150] ring-buffer: Do not record in NMI if the arch does not support cmpxchg in NMI
Date: Thu, 18 Jan 2024 11:48:26 +0100
Message-ID: <20240118104323.856578567@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

[ Upstream commit 712292308af2265cd9b126aedfa987f10f452a33 ]

As the ring buffer recording requires cmpxchg() to work, if the
architecture does not support cmpxchg in NMI, then do not do any recording
within an NMI.

Link: https://lore.kernel.org/linux-trace-kernel/20231213175403.6fc18540@gandalf.local.home

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 901a140e30fa..f232cf56fa05 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3649,6 +3649,12 @@ rb_reserve_next_event(struct trace_buffer *buffer,
 	int nr_loops = 0;
 	int add_ts_default;
 
+	/* ring buffer does cmpxchg, make sure it is safe in NMI context */
+	if (!IS_ENABLED(CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG) &&
+	    (unlikely(in_nmi()))) {
+		return NULL;
+	}
+
 	rb_start_commit(cpu_buffer);
 	/* The commit page can not change after this */
 
-- 
2.43.0



