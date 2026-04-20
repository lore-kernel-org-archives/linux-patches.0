Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF292FE56A;
	Mon, 20 Apr 2026 15:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700775; cv=none; b=MoF26/sSyZOdeFIRAX/oMP83FFrk2V8pi0Bm9mxk0DBZmF51UcSdT+U4s7padY4zejMPKLoF0BI19TQq5Mbn6oMbzrTgbxDxi5K1W65amHsUPJfhD2gu56NhG4+W1bmv+Q3VTzdVYXrN1Z7h1VjL+eEletSs9MZyBhf7mFyDnyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700775; c=relaxed/simple;
	bh=RO5FWeSbrdDATNd7vVeUwx17JDo7x3apiwbFSRV2GCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bYqP95aEsDzfIOvfaH0VEwasWuhFV8JCS7kYFZmaErZoU8eUlKI9YlnogYlvZPCub9o5QpqxVAbJ/KGqStCWJyKyiJIil2rvKu3nea1XZK8cQHGgT2b8qiXHnUJD7XHVdaIlLk6xvYDVktNDJcCY3HgL4BAFMKinh47e+jA6+Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p8gdPFcb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p8gdPFcb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C65C19425;
	Mon, 20 Apr 2026 15:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700774;
	bh=RO5FWeSbrdDATNd7vVeUwx17JDo7x3apiwbFSRV2GCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p8gdPFcbmfE9uY8IdzH5Y1LcCrhO4iKbnrwBZGD6KRG5gf8K/2x2HiGC8CMezquKT
	 Q9q7dVlG3zCwAe+AYaliLGErT3ZU2yt21ORLAnsAZrHhxlQzV41x5yHi2Rf3jqUFbO
	 ywJ055yjUEoPsaW0q8CkeiZsEPsUHcO85e5GA6Ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 083/198] tracing/probe: reject non-closed empty immediate strings
Date: Mon, 20 Apr 2026 17:41:02 +0200
Message-ID: <20260420153938.596179180@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5cbdc423afebc..d7adbf1536c8b 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -1068,7 +1068,7 @@ static int __parse_imm_string(char *str, char **pbuf, int offs)
 {
 	size_t len = strlen(str);
 
-	if (str[len - 1] != '"') {
+	if (!len || str[len - 1] != '"') {
 		trace_probe_log_err(offs + len, IMMSTR_NO_CLOSE);
 		return -EINVAL;
 	}
-- 
2.53.0



