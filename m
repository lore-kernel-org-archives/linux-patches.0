Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6C3209695;
	Thu, 12 Dec 2024 17:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025810; cv=none; b=ZtkyacHrx83Y7+p3EfBMidFvaivvGIhBBqxgldhuLuHNCSakAf+fqO/oCOOFzvAr6pAY/5z2AGLJQRtGgCwOmyH2IXDV/jBDYgjn5i1moawXWx64sLAjckzpdGrNp9CvxsGzBz5MJKkkkrjMDByqFhDpdnW6jPyWreoVM9E+EtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025810; c=relaxed/simple;
	bh=b2m9tOcsQls/1Ng5wacPoqDcl0dpNh60tEr24/RUGV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcLq7hlqczVUfO36keXbuSpXLY1WVaokneJqN0uBZGgxU4E/5f+1Ax8Fde8nyJaoD+YQZDhmYtoBun/PpymrdtdP/O0t0/yetrsxxiPjC4RgLqCneLQaEZgLqf8FXgvwR8/IIJAfVcF3VYdcoHEphMKn1HSJqjxY3hQUH3pGyWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w0HXMWGM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w0HXMWGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B98C4CECE;
	Thu, 12 Dec 2024 17:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025810;
	bh=b2m9tOcsQls/1Ng5wacPoqDcl0dpNh60tEr24/RUGV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w0HXMWGMBUNVYHnuH9T4k6+HnbA0Dy6Z4CpW6HVr7mfJGoy7xibAHtPAj5sfACsE3
	 et9gnpL6MpgZY8WXlThHXJckIPn/x7HNVfOJuTrxHT0u+W8OHjQycNJAl4ZjK+w7ji
	 OwyshoznTdfBZTCg1womM0WvLKEvZItzp+35OzD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Uros Bizjak <ubizjak@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 294/321] tracing: Use atomic64_inc_return() in trace_clock_counter()
Date: Thu, 12 Dec 2024 16:03:32 +0100
Message-ID: <20241212144241.594111822@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



