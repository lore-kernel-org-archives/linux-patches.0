Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD86019A288;
	Fri, 24 Apr 2026 13:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037716; cv=none; b=TWY779BP3hRdvPT6F2NgQYeaUCll9u6skT8ibO8Ykfs+RJSN6H+w7UonoGlqUpaZxW7MiFuHX6f+V2kT5xmtRPi2d7h2h6c+AFIdtioebb1twOjdjmY0SWQm0YfEeeKMPfdXAGM6pqfahfR8/nvKNY9M2aGSFjmJVxcpGRZsDio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037716; c=relaxed/simple;
	bh=BFFkso9IPGSkOKFElFROKOokO/1hI6PApG+Pmyt58So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVBeHA7GqQ8TM1w90NTnnMDdrT7+1mw7ykSlsQLI8hKYDzWhWoUdQvokwJAAHz5I+zjibrgp/+PGZ6E0a6oCACEXDhxU99BzNyfVchrcNNWAecvAJnu0CcEIWpkS5dhYKhIq58KJeFp0hnszc0XLIy6AvXTNgqQ4u7jK6Q7kPUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bjCsYEuk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bjCsYEuk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41606C2BCB2;
	Fri, 24 Apr 2026 13:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037716;
	bh=BFFkso9IPGSkOKFElFROKOokO/1hI6PApG+Pmyt58So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bjCsYEuk3yqpRO+ECpvdYcQE2YPRN1B95QfjBy/MwqR7pJvniwxK3rMeShmQ3CysZ
	 XzFmCU1buyZornmjipta3ucR47sPI5NybWeayPFn67GF3DsxrSFvrGqBgGzEZJq6YK
	 XUlTJ2aW4VOqu9kEYcKqon6P36CFyxUm3Po/3g6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/166] tracing/probe: reject non-closed empty immediate strings
Date: Fri, 24 Apr 2026 15:29:15 +0200
Message-ID: <20260424132541.453115471@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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
index 187b1fc403c13..d46a1033ba5b3 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -1039,7 +1039,7 @@ static int __parse_imm_string(char *str, char **pbuf, int offs)
 {
 	size_t len = strlen(str);
 
-	if (str[len - 1] != '"') {
+	if (!len || str[len - 1] != '"') {
 		trace_probe_log_err(offs + len, IMMSTR_NO_CLOSE);
 		return -EINVAL;
 	}
-- 
2.53.0



