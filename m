Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DA62638B8;
	Tue,  8 Apr 2025 12:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116035; cv=none; b=Q9PS43wHL8YtwFMn2vb4AoBhPP/Oio6kZ3Wyc9spJ1tu4JITtQi9mXKHPyAYXEm+gtNlMaEdeZoCbue6iY581ZF6aBONcDCQRe+6E0EnP668DgQA8bfT//bQ+lSrBx9s4t/rNnIu7AJR1tH6VuMhPW2+g7qHC3+DsbJa3aJraH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116035; c=relaxed/simple;
	bh=DsLNXGqzmRdZLhypfEm+WRXHSwkUm9teff5DHqTLhX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFW5SIVu/yIMLYZ7Pkh0oti2nFuz2KkQDU7Ll6exS6AQZlaB8DwWDBsnJOBe49RO0/V4MeGhsDWb/wsAVLLInq5IlrptWGZM7cek9p/kMCduPvoE6Si7+XNTGcg91v1DvhGv12IisNiUvrm0V3GOSdmUYpL0Dg+Krfa5IBdg+Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pWqpRVHl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pWqpRVHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B631C4CEE7;
	Tue,  8 Apr 2025 12:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116034;
	bh=DsLNXGqzmRdZLhypfEm+WRXHSwkUm9teff5DHqTLhX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pWqpRVHlw7o9WJek9WJFEjtnDw1HQgDRC0pLu7vYlbs9kX15P/yuQu3UgVxPh4bJC
	 lIvJlm62E3Yyaf7T5FO/02lHRPyvgV5QX60Rj+1ax4tsnswa5BQrrw3qs7s3J1rd0r
	 Ng5BrHu8laN8hOIFma6vb7waUwiE9DFFjlbBZSak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Douglas Raillard <douglas.raillard@arm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 195/204] tracing: Fix synth event printk format for str fields
Date: Tue,  8 Apr 2025 12:52:05 +0200
Message-ID: <20250408104826.033584000@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Raillard <douglas.raillard@arm.com>

commit 4d38328eb442dc06aec4350fd9594ffa6488af02 upstream.

The printk format for synth event uses "%.*s" to print string fields,
but then only passes the pointer part as var arg.

Replace %.*s with %s as the C string is guaranteed to be null-terminated.

The output in print fmt should never have been updated as __get_str()
handles the string limit because it can access the length of the string in
the string meta data that is saved in the ring buffer.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Fixes: 8db4d6bfbbf92 ("tracing: Change synthetic event string format to limit printed length")
Link: https://lore.kernel.org/20250325165202.541088-1-douglas.raillard@arm.com
Signed-off-by: Douglas Raillard <douglas.raillard@arm.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_synth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -312,7 +312,7 @@ static const char *synth_field_fmt(char
 	else if (strcmp(type, "gfp_t") == 0)
 		fmt = "%x";
 	else if (synth_field_is_string(type))
-		fmt = "%.*s";
+		fmt = "%s";
 	else if (synth_field_is_stack(type))
 		fmt = "%s";
 


