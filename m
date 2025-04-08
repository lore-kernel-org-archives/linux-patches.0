Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD513AC1C;
	Tue,  8 Apr 2025 11:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112983; cv=none; b=FZNLvmX7tYJuj9OmhL5UYWAdqdSN1ITdW1+JMJ0KQBYOHUmm/geQz8NDKpwbsG+FR6jIkMXlGs0b97Gq306hamCuMo+hLX6g6PUGdH/C/DM0cJwgm8lVoYYTPv0Wmtxa30KFyu10MpEI2Fpl0SdnAEaW7ZwYWSX+hqv82YR5Ozo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112983; c=relaxed/simple;
	bh=NmWq95AXmSuXL3FU2Y6yrvM68cFwBJjYv0WGDjRdl8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pj+JrxuzKdPYqvzAGq7aZzELvOisZU2R9ISTFxaktnMIC9Ip/7LcU6eM67Q08weizBpBIRdHnC34bf7NQ3lyvUK7k7iX7Px5VbqZ9KFvYmu/M7KOX5ZFgho8OKjw2jNs5CoWGoeKx7skfUl5AgumBbcluX69M5sgSCG8Wk0mlQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NWppCpLc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NWppCpLc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF29C4CEE5;
	Tue,  8 Apr 2025 11:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112982;
	bh=NmWq95AXmSuXL3FU2Y6yrvM68cFwBJjYv0WGDjRdl8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NWppCpLcrBGuRBpLB3fvZqVNzh1QYdvVtQ70Of9bsxgu3EKOKHqZyBxnzvvgGiH2f
	 zgRw4CyS6/alBtuhmKUJZJ7UtILg41jucXWC++DJLRMr7NN/7oZ5hK/BgrIrWw5oqt
	 N6nXoiBqm3a3xODH7fO372Pa9NTXCsfrlBNg/f30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Douglas Raillard <douglas.raillard@arm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 270/279] tracing: Fix synth event printk format for str fields
Date: Tue,  8 Apr 2025 12:50:53 +0200
Message-ID: <20250408104833.680420377@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -293,7 +293,7 @@ static const char *synth_field_fmt(char
 	else if (strcmp(type, "gfp_t") == 0)
 		fmt = "%x";
 	else if (synth_field_is_string(type))
-		fmt = "%.*s";
+		fmt = "%s";
 	else if (synth_field_is_stack(type))
 		fmt = "%s";
 


