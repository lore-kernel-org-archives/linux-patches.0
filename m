Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4BB22331E;
	Thu, 12 Dec 2024 17:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023396; cv=none; b=oK/9ah2oqeE9ZZXjLY+LvqMqzQpaggaNcShMv8b0zpfXuJU5J19t1WGZ/sDrYWdGGn7NiBRX8YcWQ9yTy2OsP80xjtbBMRCy5o3O6DXDMqIjFd1PwiWUIkrs/gNZ3WwjRduIJyCJoXQruaJ0XzrDRyWLFY5rpwaVjs/EDC80yic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023396; c=relaxed/simple;
	bh=lfS4xdA6cuMAL4OJ3227DnOk94dJ86ZT0MZinFDFpK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HS2n5vI72dMpF37OlWGn6NwMkAI16dyL9/0xRUjwnn05V+eKVkoaFy9Nlvk4LFwINYpnjK+X0t0kJ+72Ugujkd/h53IWuKtg1rkT87UKEpArEt/SsVxSArvroD86MPW7+wWQjdP3LNPex474nn3CVtNmmfcbz72NqQdadXc4vkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eGDXBwwY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eGDXBwwY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058CDC4CECE;
	Thu, 12 Dec 2024 17:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023396;
	bh=lfS4xdA6cuMAL4OJ3227DnOk94dJ86ZT0MZinFDFpK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eGDXBwwY2/AuBkSGBEAAnV/bIvk+z0nZPMthygO/sjvtNSoAKjOobxiuKuKjr4He7
	 yLjIR5FTzycaDYSrXpTOaO7ebdLusrfX9rMmgdS4WnBWmRrQamhv6SeEoXIm880bjm
	 8kBpPasJsjKuo6hlh8jc3LRWZTic+vWz5I1t/bZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Uros Bizjak <ubizjak@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 513/565] tracing: Use atomic64_inc_return() in trace_clock_counter()
Date: Thu, 12 Dec 2024 16:01:48 +0100
Message-ID: <20241212144332.058645687@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

From: Uros Bizjak <ubizjak@gmail.com>

[ Upstream commit eb887c4567d1b0e7684c026fe7df44afa96589e6 ]

Use atomic64_inc_return(&ref) instead of atomic64_add_return(1, &ref)
to use optimized implementation and ease register pressure around
the primitive for targets that implement optimized variant.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20241007085651.48544-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 4702efb00ff21..4cb2ebc439be6 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -154,5 +154,5 @@ static atomic64_t trace_counter;
  */
 u64 notrace trace_clock_counter(void)
 {
-	return atomic64_add_return(1, &trace_counter);
+	return atomic64_inc_return(&trace_counter);
 }
-- 
2.43.0



