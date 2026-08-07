Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341FA3E9C12;
	Fri,  7 Aug 2026 14:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114242; cv=none; b=Iwbi5N/QfXbId+1PeE8OB5WPrfLwdCp5lmftLWzE5yVDPuc9RkB3BCSAduG9fYs4PVft3rN0h3s/3qeSWigS9Ylj1QRq/xdudPi2IWLGItCdq8tkzw2PiBZJg/Oaou5tDjSwh7rknJlRaaG2g6H5aN3lyXDWHvTCADgSOd4LyLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114242; c=relaxed/simple;
	bh=Llaktl9kvh+DDH7PhqvsmZAnEAtXQUmw/zk7excgScw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fN3r4nZA8xugA0dRqoFosP3fJwp5En75C71Sn2xJ1umyT0cCBrgTJl+zXtzCmw76/YWEHCLUW/qpFK7NC76khSFaowAi/hR6erka1AMpIt7QfGP25yji4MzsamluaKKg0dYHqemPdFSVGdzo1c5G/2tYkG4tg2W10H0acEdo1GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mn8V6alb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mn8V6alb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8348D1F00A3A;
	Fri,  7 Aug 2026 14:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114238;
	bh=LSnkupG/B5OOX3JtUJubOquMZn72F+FFOV1zUElQvHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mn8V6alb/OBoouLMO9pQJXe7HkG8K2KSMepYrxhXucW5He3Cupd+ENyi7VQ1ennwo
	 0qNqtZf2u71db4tu4/vY9Cz/sJz19fEBDjQrkHxkYJP8ivuWTU8Ci5e9yQcv9zZEIf
	 gjP/i4q0K+7bXOHq5sfNh8K0K3NCn1xI0avqEcWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 193/337] tracing/filters: Fix false positive match in regex_match_full()
Date: Fri,  7 Aug 2026 16:36:36 +0200
Message-ID: <20260807143422.740843382@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


