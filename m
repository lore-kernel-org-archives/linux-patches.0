Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C242A476CCE;
	Fri,  7 Aug 2026 15:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117547; cv=none; b=GJW+c5/bZPn+bTQEKk2U2Oz8YPYZGGkEtB0Xpt2NvaZzd7p94doVfDgbBUyTSin+GcUuU+0W4+5yO/WGbK4hYNu8twO81Pz55vf/bW3hPb+SXembQhFiml3nTV+1QXqgzXhWBkrcamNwUE/6cXHUbt2UhW638fHuzvKWUSMQi0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117547; c=relaxed/simple;
	bh=s8cUMc6V3mvhZeQkoBLycmtx/2eigKosyDQxK4bTKtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qkRxlykEuplA1lSkCwqhPaxu5VVwu321WoKi5r5Ww98y/iRRaK2r2cY/pCQTTeVkrqMexeRf8tQ2FCA1j+YbQ5Xa6C2GflMnoBTQuTePBjg4Sivkz0wihHFMYwedT4HsfMGxC4k7Q1/HtIbSJfVLgj4fuujITqnBS3j/thk58Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FF5fWLuB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FF5fWLuB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236E81F000E9;
	Fri,  7 Aug 2026 15:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117546;
	bh=01oIQVm525qetP55Sl5Ikt9dd7iL+VE3RI2+yYVqss4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FF5fWLuBJkpOAXZyWyL90S6hXuEC1H1ROzfL8u4yPLSofA9INbrafJHlcQ/rszq++
	 m4jgpIS7rDKVW+Maq8+s5xj3RF9owjwaBQOx644Bx1euaslUi6pxVLYic3h61B1CGK
	 cLhFhKQ/cNv6p63Pvps6uz+AauInCEwBTacaxuqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.1 313/438] tracing/filters: Fix false positive match in regex_match_full()
Date: Fri,  7 Aug 2026 16:38:29 +0200
Message-ID: <20260807143434.641602347@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1027,6 +1027,9 @@ static int regex_match_full(char *str, s
 	if (!len)
 		return strcmp(str, r->pattern) == 0;
 
+	if (len < r->len)
+		return 0;
+
 	return strncmp(str, r->pattern, len) == 0;
 }
 


