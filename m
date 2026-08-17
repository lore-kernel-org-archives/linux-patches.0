Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C81420472;
	Mon, 17 Aug 2026 14:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977433; cv=none; b=pWZfMTz1czao3H9X+HPsMPqkN6Emx59mXnTaPuyiK+maj4RdY/ZzwsUrTiwcMpTYHnR1lHSU8hRepjsZcp6LFRo57OR50iPlb1F12GyanOnD+M+MYUxdoFHWJ5qo7a9mAoHLf2eaNQbNpxAoM/4lEGBUZ2t9VNXjNL549c10cLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977433; c=relaxed/simple;
	bh=4Lf5lebnYXX3/LoJNIMZ5xhZfBK26/2kaIZ/9JAHgA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RI+fFKQRMl8O9UnyYFrJYxk0P/3pY7g6vo9ve9jnmZWqIi+S/g4PAN8zglEVncThAQeKpnr4pvZANsyndmaKRygnyE0w1uVhyGQ26ZJxE43ECYH0MEOpzpqq2LgXeqwtuz/q1ZXHvLxlPNduOC898NV1w9KzqxThHaHyG4s8nlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vJ26dNZJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vJ26dNZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708221F000E9;
	Mon, 17 Aug 2026 14:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977432;
	bh=dNLHGW1wnSLXF23wDb4i3cJ10g2XMW0UCo2fcEq3zeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vJ26dNZJsceFGv31vB8rozaX0Kji/3nQ+jGOUs8ptajszWZaTKQiCkZsIWtLOxgIF
	 cGwE9aPrCRGIsWyjGo6vzgn4tAlvC03huPah7ANZhR7N8s8Mc19QcltJpYoNYdeCIB
	 w7xvi5BtGFyMEtNRP+WnBJjk6smz8Qupr51jE8H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5.15 328/456] tracing/filters: Fix false positive match in regex_match_full()
Date: Mon, 17 Aug 2026 15:31:58 +0200
Message-ID: <20260817132552.477660075@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit c22c7b735f9810ad276014f788f9aa5c879ec238 upstream.

regex_match_full() calls strncmp(str, r->pattern, len) where len is the
target field buffer size. When len is smaller than r->len (the filter
pattern length), strncmp() checks only len bytes of r->pattern against
str. If those len bytes match, strncmp() returns 0, resulting in a
false-positive match where a shorter string in a fixed-size field
matches a longer filter pattern.

For example, a 4-byte static string field containing "abcd" matched the
filter pattern "abcdefgh" because strncmp("abcd", "abcdefgh", 4)
returned 0. In this case, @len does NOT include '\0' because it is
fixed-size array.

Fix this by returning 0 (no match) early when len < r->len.

Fixes: 1889d20922d1 ("tracing/filters: Provide basic regex support")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/178528488779.124250.5571741156199253769.stgit@devnote2
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_filter.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -836,6 +836,9 @@ static int regex_match_full(char *str, s
 	if (!len)
 		return strcmp(str, r->pattern) == 0;
 
+	if (len < r->len)
+		return 0;
+
 	return strncmp(str, r->pattern, len) == 0;
 }
 


