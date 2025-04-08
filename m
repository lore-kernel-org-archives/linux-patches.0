Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280AC26A0C4;
	Tue,  8 Apr 2025 12:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115443; cv=none; b=LT/CZTp+J1tUaavEIhJtA6Fk+69OPgVW0XfveztJztPFtpKKk1TQKR3aUXJuZb5CR1nhlNH3IE9P1fLAiw0fh2InXPBV1dRmjCGvwoz54xnTmqeQUfocPYw3NdlcFKEWVKSNxN4t8qY0yIPlNAACxs5nboNH94HXTqRQckjGWsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115443; c=relaxed/simple;
	bh=sz0qjP5iiwuxFrtwYrxwzUIYrxa+qI6WcRF4/TmE1pU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PqhrGp068beouNupgTvUygpIFJKVs5DMjpRfKBlZsT4CmMeBG1fvzivdJCG7bci/Ily6P3L25kKsEkhjNrF050guOzzmThZt/JOP0REViJArHM5s8UocWhnkcQiiDnvbE9K30JRC4J0JEMMKceirxGjYtjcAOzI7tVcjOf2NlwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+oCkm96; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+oCkm96"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46955C4CEE7;
	Tue,  8 Apr 2025 12:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115442;
	bh=sz0qjP5iiwuxFrtwYrxwzUIYrxa+qI6WcRF4/TmE1pU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o+oCkm96sxalXQO8XeuSY0F4Rm02iE6tXF8qkv0TFU7/z3i03ZfO7JOS8GypZkVgh
	 WxnFhJbo2WWQTAf4V6vra42EiGgGduBZCPueiQX10OIX2jB+TS+FrUFTM0hQMuK3/y
	 +cCtqlwqUNi3vOaFWYFBorgCoQGTe6DkRm7fDtAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Douglas Raillard <douglas.raillard@arm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.13 477/499] tracing: Fix synth event printk format for str fields
Date: Tue,  8 Apr 2025 12:51:29 +0200
Message-ID: <20250408104903.249265663@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 


