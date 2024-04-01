Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434A11C0DE7;
	Mon,  1 Apr 2024 17:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990924; cv=none; b=r1d4+7qYv5tLMChAleS64amZANoRcNW6f+d5CzGCA+OmF5iGmdQ9hJLqdspJSq5LCYhuVEcs1RHrn3Oy4avGI2ljOeEurJ4rhj0HOfHTcroMTeufaT3UZDr82kkGe5KjaUjq+SzIqJlQKPxSICFHg4b1pRl9yQL6RP0mHZg+uFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990924; c=relaxed/simple;
	bh=ONXXWMPIhn8AQhOQQtvyBHf7+k8kW0lEUgKkLeJ7t4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qYiveYhQrbMO1nJCFf4qX/IO9M7ijrlprU/l6deLgzcfHWSZGlsO3AHfc6uRgHJbfohFDrGDNstaoHbCxSJH6VWzvtaJuEjOPteamGosZ8skeoE8Om1UhVVC7uxlTeKCj0fNCkSMcs2PDYzxcTCELNyi7ZmLos9ubM5FtIS58vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvsLVNci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvsLVNci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA917C433F1;
	Mon,  1 Apr 2024 17:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990924;
	bh=ONXXWMPIhn8AQhOQQtvyBHf7+k8kW0lEUgKkLeJ7t4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jvsLVNciGiK/AaXjzvpUmTXDR7aFl2YEVA5HnSrfXJDBElxYsJmrKZpvwYBhpy8D6
	 J4X1Hr+2Oxx7EK0TqAzGut34xdTxh5XnJdY7OWJP2f96klnSlQADu48kHTsm9w1VmN
	 vI7Jco5hJjAYpoCx6rjboybJOMescD6EkQqluO5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/272] ring-buffer: Do not set shortest_full when full target is hit
Date: Mon,  1 Apr 2024 17:44:58 +0200
Message-ID: <20240401152534.027922353@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit 761d9473e27f0c8782895013a3e7b52a37c8bcfc ]

The rb_watermark_hit() checks if the amount of data in the ring buffer is
above the percentage level passed in by the "full" variable. If it is, it
returns true.

But it also sets the "shortest_full" field of the cpu_buffer that informs
writers that it needs to call the irq_work if the amount of data on the
ring buffer is above the requested amount.

The rb_watermark_hit() always sets the shortest_full even if the amount in
the ring buffer is what it wants. As it is not going to wait, because it
has what it wants, there's no reason to set shortest_full.

Link: https://lore.kernel.org/linux-trace-kernel/20240312115641.6aa8ba08@gandalf.local.home

Cc: stable@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Fixes: 42fb0a1e84ff5 ("tracing/ring-buffer: Have polling block on watermark")
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 3c4d62f499505..c934839f625df 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -974,9 +974,10 @@ static bool rb_watermark_hit(struct trace_buffer *buffer, int cpu, int full)
 		pagebusy = cpu_buffer->reader_page == cpu_buffer->commit_page;
 		ret = !pagebusy && full_hit(buffer, cpu, full);
 
-		if (!cpu_buffer->shortest_full ||
-		    cpu_buffer->shortest_full > full)
-			cpu_buffer->shortest_full = full;
+		if (!ret && (!cpu_buffer->shortest_full ||
+			     cpu_buffer->shortest_full > full)) {
+		    cpu_buffer->shortest_full = full;
+		}
 		raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 	}
 	return ret;
-- 
2.43.0



