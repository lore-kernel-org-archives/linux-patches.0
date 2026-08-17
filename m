Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB8B44239E;
	Mon, 17 Aug 2026 15:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980012; cv=none; b=cqRYafsomiZmdoLycEcXbQybZ4ur+ew5QIb/NYNaD/EJm4NgX1FhMvBOtOeo7BSFRRwBg4LR3CCLkFpuJf9qFxkf1726GbvQedApl+l2xwjP4hqQX2DskSSY5krUcCU7A9kvG4VA02P86ahdi9PQcGzaFjXlnqhtYtODzrGgqoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980012; c=relaxed/simple;
	bh=8lxp5aXx4yE9Bxn6nZHT9Fh/JT/2cLmUMklg/4FoToc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCPYdHytQU8zQIWrDcdn3Ukr1j/Zzyj+BVTUpsOsPWTJ0QwIEgJnUta/J2ymhd1V4x8EFsrrVWSy2XGgS3a1Vqy185psnEo3hyQGVvf8yOmEXNxf8RrooLoOaBZpyNH69uQFl7viWqp1rl8mRFW7TaEj30GHNz76yvehQsOx22E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CRVBNfhX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CRVBNfhX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2C01F000E9;
	Mon, 17 Aug 2026 15:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980011;
	bh=QoTLJoS22Ojz7djsv4/TyyCQ/YUluOeFaYxLRUQKI4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CRVBNfhX1eJ7ELcHiwch2t4XtSjzm7I+4VqUz6LkCasC8V3tzlezy0sNKywRnECsV
	 JGULLi4VzcoNuypHKYgMZ60iiKBHF20O+CAAqt17aVW88DxD6eaJTijo7OI5LQ+zNu
	 7buzyjf7k95z5lSNJEfGvfs22qWErI1FYMEAiDc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.1 425/609] tracing/filters: Fix false positive match in regex_match_full()
Date: Mon, 17 Aug 2026 15:32:01 +0200
Message-ID: <20260817132558.326033360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -894,6 +894,9 @@ static int regex_match_full(char *str, s
 	if (!len)
 		return strcmp(str, r->pattern) == 0;
 
+	if (len < r->len)
+		return 0;
+
 	return strncmp(str, r->pattern, len) == 0;
 }
 


