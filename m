Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684FE22154C;
	Mon, 10 Mar 2025 17:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627278; cv=none; b=nzjewxVj3OE680WtSuGArqE8e65BLz/3oxtiWNzcbmy9Ddwakuu7Qt9Mm6/MTsVt/jdUhf5Xlp4vbt6FGW2tG2kVNXH7MS9U8eMp+Rwz/fFZUxJfgN53PZBxdM1RkqGlKWV/+KhV9KLmt492Sz1p/lqoRWMFAj/E2O+dSggOtJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627278; c=relaxed/simple;
	bh=v9XZEWK1OER6YEX/XE66z5eDSclm/c6hgjPxFJFPEKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BlqAX+sbdMdbzEJZRSVndWjHvhaz2Lakn1ciyEkUBjAtd1v03gOOTiJxPoHsf5R7/3zJ+duhkpUetCY66Ch8abvXElYLIHYUWKZ44shDrWE6J7yIJetWzS1otL+D3nDCiLGAvkRj3x4XgbUM81/5JfAceetA8FIwpcVjC5eP1KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H7m0jMeM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H7m0jMeM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D614C4CEE5;
	Mon, 10 Mar 2025 17:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627277;
	bh=v9XZEWK1OER6YEX/XE66z5eDSclm/c6hgjPxFJFPEKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H7m0jMeM0bm87XXHmDZEqlaoTXhL/vpNolfGV77iPXjYBPySregpIGwRhikZFFw4t
	 pYjB2pUcq4dhbpkdQIv5YX9o9m3ukwlpje3sQDHDtm6MGlaHvO7aCfnTL8nY8Pofg/
	 XtOMnXjHk+KQBRNLmjxMp2V3VpTGU5W4129k9+os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 073/269] tracing: tprobe-events: Fix a memory leak when tprobe with $retval
Date: Mon, 10 Mar 2025 18:03:46 +0100
Message-ID: <20250310170500.639356855@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit ac965d7d88fc36fb42e3d50225c0a44dd8326da4 upstream.

Fix a memory leak when a tprobe is defined with $retval. This
combination is not allowed, but the parse_symbol_and_return() does
not free the *symbol which should not be used if it returns the error.
Thus, it leaks the *symbol memory in that error path.

Link: https://lore.kernel.org/all/174055072650.4079315.3063014346697447838.stgit@mhiramat.tok.corp.google.com/

Fixes: ce51e6153f77 ("tracing: fprobe-event: Fix to check tracepoint event and return")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_fprobe.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/trace_fprobe.c
+++ b/kernel/trace/trace_fprobe.c
@@ -1025,6 +1025,8 @@ static int parse_symbol_and_return(int a
 			if (is_tracepoint) {
 				trace_probe_log_set_index(i);
 				trace_probe_log_err(tmp - argv[i], RETVAL_ON_PROBE);
+				kfree(*symbol);
+				*symbol = NULL;
 				return -EINVAL;
 			}
 			*is_return = true;


