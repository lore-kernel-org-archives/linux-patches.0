Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB73C221734;
	Mon, 23 Jun 2025 21:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714223; cv=none; b=VnlpFcvAqMAdyk3i5ykb71WiBfVJ/REBJ2kVAhKVlP3Q+Ox24FBKbbA3b0Agnd5RhHemL3h7zX/xeOZzbFAoxryZBAHA6baUl3L4TnFMtmqktKHC7VFER7gMw4Bjg1ycjc3JrUQozlkeZIFumfuqlIm6RZyWnnpGNt9vkCa9oQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714223; c=relaxed/simple;
	bh=jg54u4iaCKVZKGoAt6niYgi6VamCmAld7fmy5UEOtDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBHTPcZ5caSLRJ6iCNoiY7XVoR0o1E+MLutWTs6Mj6Fm0VN0miIWaKjn8zlmuHOva+imOVfM5PGs22TAfEXzqcE5GU2m2kd4zOH4jHTBUkOPKOxojyLBPz8BEBJ6jKpv/F8OzXHrPn6H8ctz/dvfKBP40WwlE8VZPdjwQO3Zahk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DmGGPjR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DmGGPjR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA50C4CEEA;
	Mon, 23 Jun 2025 21:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714223;
	bh=jg54u4iaCKVZKGoAt6niYgi6VamCmAld7fmy5UEOtDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DmGGPjR9OqKbxgeTr8OKS6m4BcZxJseasfQFAcaT/EU4JYX7T0bVxuclp7t7KiUJ5
	 Syn6aLllbvb+3X5ANDxSwQLQ6AefyC13ryWpCUN8zkX4yiV6kXeAuzJp3TECrf5NVw
	 vDU+EALdpXhuAqfWm6tsBPXlUAnwDJuCGLQJ0Jv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 377/592] tracing: Only return an adjusted address if it matches the kernel address
Date: Mon, 23 Jun 2025 15:05:35 +0200
Message-ID: <20250623130709.405037412@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 00d872dd541cdf22230510201a1baf58f0147db9 ]

The trace_adjust_address() will take a given address and examine the
persistent ring buffer to see if the address matches a module that is
listed there. If it does not, it will just adjust the value to the core
kernel delta. But if the address was for something that was not part of
the core kernel text or data it should not be adjusted.

Check the result of the adjustment and only return the adjustment if it
lands in the current kernel text or data. If not, return the original
address.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20250506102300.0ba2f9e0@gandalf.local.home
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 766cb3cd254e0..14e1e1ed55058 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6032,6 +6032,7 @@ unsigned long trace_adjust_address(struct trace_array *tr, unsigned long addr)
 	struct trace_module_delta *module_delta;
 	struct trace_scratch *tscratch;
 	struct trace_mod_entry *entry;
+	unsigned long raddr;
 	int idx = 0, nr_entries;
 
 	/* If we don't have last boot delta, return the address */
@@ -6045,7 +6046,9 @@ unsigned long trace_adjust_address(struct trace_array *tr, unsigned long addr)
 	module_delta = READ_ONCE(tr->module_delta);
 	if (!module_delta || !tscratch->nr_entries ||
 	    tscratch->entries[0].mod_addr > addr) {
-		return addr + tr->text_delta;
+		raddr = addr + tr->text_delta;
+		return __is_kernel(raddr) || is_kernel_core_data(raddr) ||
+			is_kernel_rodata(raddr) ? raddr : addr;
 	}
 
 	/* Note that entries must be sorted. */
-- 
2.39.5



