Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D16194A6C;
	Thu, 30 Jul 2026 16:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427796; cv=none; b=A4BwoSsD4y0giuDJuXcw6XkSLjdHKDe6i0A06+k2enbtiKgj5thjuMTmfXR53EdMptBUYMRlPKRY5xEHM4oj8HOb9C/rRdCrPPtvzCY2QT3jy41IPNBcXHtiyvAMVDDxgVrX/ldX1otv+ri4LTtyabx7RdAgcZD2PN3tDLJcnWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427796; c=relaxed/simple;
	bh=sb20eJpkAszgKJsH+jA+F1AGvhuxouevMOG7pwcmFAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IAW9p4buaZ5IqX2tM+s/2L3HYniMKe+Fv6rZ3Dj3WO2Qckmi79PfNXEHcEdqyKDu6hAANMZ7pFpVGAsTw2Mz3b3AaZIe8fzH/Yv4bN1RlRv8Fxlt3PmzpViRy5H5JK3hijCoT0Q2nHZ+Pk07OEUPP59yPaBsk7NJxN7J+FL2wSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HjpfJerl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HjpfJerl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A611F000E9;
	Thu, 30 Jul 2026 16:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427794;
	bh=6du1FhWA/NZlQ2/jbr3EN6/CCq0TxEXxU38YjsQrVyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HjpfJerlv6k26q7Jk7RxD+rZ+n+BzqP5J8Lq/ig9i5ltxeso6pxlbKVYbhrRVdvn/
	 UH5PqNx0CQS8YwG8bMqOakVWTvwEKESCRtAgz19SrWtpj9F4Zqgo1V1pao44RdRUe7
	 RthOnupjnD7hDpCZL7NZtjoEWiDiDL8YvwVvFyOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.6 296/484] tracing/probes: Prevent out-of-bounds write in __trace_probe_log_err()
Date: Thu, 30 Jul 2026 16:13:13 +0200
Message-ID: <20260730141429.924109419@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit a9d6fb284039a5d3858a1d9f9a0d7e46cfb7c2d4 upstream.

If trace_probe_log.argc is 0 in __trace_probe_log_err(), the loop
constructing the command string will not execute and p will remain equal to
command. Writing to *(p - 1) will cause an out-of-bounds access before
command. This should not happen, but better to be treated.

Reject if trace_probe_log.argc is 0.

Link: https://lore.kernel.org/all/178454233992.290363.18323091580600697731.stgit@devnote2/

Fixes: ab105a4fb894 ("tracing: Use tracing error_log with probe events")
Cc: stable@vger.kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -186,7 +186,7 @@ void __trace_probe_log_err(int offset, i
 
 	lockdep_assert_held(&dyn_event_ops_mutex);
 
-	if (!trace_probe_log.argv)
+	if (!trace_probe_log.argv || !trace_probe_log.argc)
 		return;
 
 	/* Recalculate the length and allocate buffer */


