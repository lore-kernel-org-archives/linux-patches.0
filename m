Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9747417555;
	Sat, 30 May 2026 18:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165252; cv=none; b=aEnEpxiFvMNxBnB5TtySc+Bg964q3xMjRwhlkc6tTNUA0P5MZr4zoktwKkxZlybZUsAhv78yno0PwlN/fgcZlWAaxjkpLjwqFdGIH1G/TWOYnYShRVMYvgENylSQgsbhN5AFpPdLoCdbRp9YLYcfBOJTfqKzzI6YIdMjZ9T0VOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165252; c=relaxed/simple;
	bh=1oxxrKSKtcwYbxkTPmWktkoZm7LxdtUS5FnA5jgdbN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LI+ziGFDjfP3VHLWrCQnCcARN3ulYCYqaUXio9zeeY1O+kQM5qnSYx6gV0UQ9AtH4sVZOHVp7kDEdoRXN1oY02fDDkX9fZEeP3qx3q4JJdAbUWzfGG3nWl69DXA0M4dEwagOU60HcPSHPVSX/VOOkBsnqEHod1STLDNt4eFXMeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TwrlHG6e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TwrlHG6e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9CE1F00893;
	Sat, 30 May 2026 18:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165251;
	bh=PKFGNGzWBfq8zb7LB7XAbLYKJpmh2UPxK+Fb9CaPqDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TwrlHG6ejDHLJ9n2AR96HIZWRVB7SN+29SZmxZmWjpE8RvCNCzIs3fRQM+1ESd5pI
	 dkpzqoZQSjrmibpSzURJPTsmpJZ9akn+OHwe4bfIFO6CpOiH8fjYeU4B1tCScmwrIq
	 U+BdUESotIXzm7kGWX//fqP9E+dg1WiAqBKAr3HA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/589] tracing/probe: reject non-closed empty immediate strings
Date: Sat, 30 May 2026 17:58:25 +0200
Message-ID: <20260530160225.220108920@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1893fe5460acb..698eb997b37ea 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -341,7 +341,7 @@ static int __parse_imm_string(char *str, char **pbuf, int offs)
 {
 	size_t len = strlen(str);
 
-	if (str[len - 1] != '"') {
+	if (!len || str[len - 1] != '"') {
 		trace_probe_log_err(offs + len, IMMSTR_NO_CLOSE);
 		return -EINVAL;
 	}
-- 
2.53.0



