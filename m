Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE0B3BF66D;
	Sat, 30 May 2026 17:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162674; cv=none; b=OdieLa4hAHyLZWGswOw23q+IciBWDD5eyXjbybjZ97QoAdnkjrKibGYt9ugle/SCnACRKbjogMb0xjJ9PpIaBnnXLypmY5QlotmLmEYpYdy9JM1LXyeBQLoHF9/8QwDLJRhC+L3w7GS1svLzb0i5pM3xi1HOwjk4ZkPtANi7ysI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162674; c=relaxed/simple;
	bh=jZJYqZicGrDD56w8Mkl74nNS3Y3hEalccDat48oeCuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENAPxQFsvj5KaxK0umPv9Z9FTeA8j+oKofjsoUXHB7X7227g4O2qgVkQH+4CRUHqO9LgiUPlsz4X9nCoJnmqqg0JaY7dJFSAqtQE2kX3H/x1NqnjJyt6cbLwXNwu2+ELj1kPxF/B40zBgp+UFvPVNXV7vQznLCm/mJ9PtlvEI7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QsOsNdXl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QsOsNdXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02AF51F00893;
	Sat, 30 May 2026 17:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162672;
	bh=zAkX0Yw9Ftbdg2ZxYlbM3mRQLCJj5B3/Ua04N9CyguQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QsOsNdXl8WHODglh0O2dl0ltD9Uvo4jWOLowAI/xcLCxgMfWdaF9pqF5JTNXk0AL1
	 vDrdERReAoZrxiML+WyeyhB4wfC/wcmDkkvYABQQumVUcR7pB5MAboR31jIt9uS1pY
	 pk8piht9g9JT4RxaKNmq0icDpnltMyzpHdDt908I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 029/776] tracing/probe: reject non-closed empty immediate strings
Date: Sat, 30 May 2026 17:55:43 +0200
Message-ID: <20260530160241.023595299@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 4346be6577aaa04586167402ae87bbdbe32484a4 ]

parse_probe_arg() accepts quoted immediate strings and passes the body
after the opening quote to __parse_imm_string(). That helper currently
computes strlen(str) and immediately dereferences str[len - 1], which
underflows when the body is empty and not closed with double-quotation.

Reject empty non-closed immediate strings before checking for the closing quote.

Link: https://lore.kernel.org/all/20260401160315.88518-1-pengpeng@iscas.ac.cn/

Fixes: a42e3c4de964 ("tracing/probe: Add immediate string parameter support")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_probe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 38fa6cc118daf..47044927a7269 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -362,7 +362,7 @@ static int __parse_imm_string(char *str, char **pbuf, int offs)
 {
 	size_t len = strlen(str);
 
-	if (str[len - 1] != '"') {
+	if (!len || str[len - 1] != '"') {
 		trace_probe_log_err(offs + len, IMMSTR_NO_CLOSE);
 		return -EINVAL;
 	}
-- 
2.53.0



