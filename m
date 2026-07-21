Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E92E3B71A0;
	Tue, 21 Jul 2026 21:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670358; cv=none; b=NBSPsYVowE11xx09SCLkQ2ueTgKTZOOwrCSkGttftFcyJf1ZfqzBti1YIBhhumg3wemg7DvUimc6MUh6PNrt/x3bkMsm5d6e+VZynAdNEaHmtwJf6jMHdsF+AgCK8nEGe7rCFr9KZ0EDLkuQ/JkTE/rgNy5eMkWx2iSzjFzSBWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670358; c=relaxed/simple;
	bh=/Y6H5IfV4TiL3TpMeW5PtoOkGjXc5UxM/JsLZ+AU9nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=McrrP2KL6V8intOEbRusYea4Dfwda2fatS3iflAWt+Fboy+24c3jKDxHiVvlwddeFwv8m8fbd1xVRa7jonFuR5CIc7rAzZ45uBQ6SHJMzuOjC8B2FWRkEUGWWQAvuaGxo+Xiy/qabOrG9Aoqgmxf0BFy6NWyg3EeHd+SqKwm8Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2TsEb7W5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2TsEb7W5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C064A1F000E9;
	Tue, 21 Jul 2026 21:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670357;
	bh=miXhPKcLZOCE8kOmkyX8GsrxVUC6oQCPsWmK8G+wlXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2TsEb7W5jNAJI9uHW1E/L4HGeu+QtIiTEa6M/CU4V0LliPzfiEerDFiT/kblY3frt
	 Lo7z3oydxnm0gdQKBl4jk+xBhru9lEz9hZFSbGBjaDuaG86O12k+hig9d8P/k0sQRG
	 yksKX6U42dLvTPeR2k+RSfX3f1fj/Rszt3A7O0fI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.1 0903/1067] tracing/probes: Fix double addition of offset for @+FOFFSET
Date: Tue, 21 Jul 2026 17:25:04 +0200
Message-ID: <20260721152444.735394831@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

commit 9a667b7750dda88cbf1cca96a53a2163b2ee71f7 upstream.

Since commit 533059281ee5 ("tracing: probeevent: Introduce new argument
 fetching code") wrongly use @offset local variable during the parsing,
the offset value is added twice when dereferencing.
Reset the @offset after setting it in FETCH_OP_FOFFS.

Link: https://lore.kernel.org/all/178217905962.643090.1978577464942171332.stgit@devnote2/

Fixes: 533059281ee5 ("tracing: probeevent: Introduce new argument fetching code")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -433,6 +433,7 @@ parse_probe_arg(char *arg, const struct
 
 			code->op = FETCH_OP_FOFFS;
 			code->immediate = (unsigned long)offset;  // imm64?
+			offset = 0;
 		} else {
 			/* uprobes don't support symbols */
 			if (!(flags & TPARG_FL_KERNEL)) {


