Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FDC33F58E;
	Mon, 20 Apr 2026 15:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700235; cv=none; b=XaGEiM04aAXDxBQ7FqqgB7RhHbn0Cz8sKtvKWiv3pq1PQN034yaHCJQXTUVk6keMrmCvmH2p8HqZRE/cafOaNtVE3SuP0uXulFzZWfxtSFccfzQ/sdSzApmF/v3EDvHU+wDoj0HdrFZxnhmbaV6RpMTgP5hglPUsXjflfIjLJoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700235; c=relaxed/simple;
	bh=kDsftj0gUgmSJAh6rbQIPuV4YBfTXLWYxpvxMSGhoa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BmjRlSRQnvFOHmWzNIUHMuysVN7bN9GZiTagTrQRzCquPdKCeIoEXlXTptPbXLduy9RMCFWvFsJnsztSpTc/+DU/39CoJBkSclj+FZX32gWRQFLiI34aNUO8ecljV9kTUa62Fu2craJbZGz7bK4RM9Y31aEO/TIEOOmCUoM/4bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jQ/xV8/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jQ/xV8/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D15C19425;
	Mon, 20 Apr 2026 15:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700235;
	bh=kDsftj0gUgmSJAh6rbQIPuV4YBfTXLWYxpvxMSGhoa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jQ/xV8/BeMoAwGHuDza8k+4mz6fRZ+aBPs2yQdppym0jA1A2S1NA9spDh4kBlX5Wp
	 F33tH1GrQ1mJoctqUoOYaHN66Q9eQh4RYdIkLYI5nkwnr4pO+rOYaY2vcNaZxMrm0W
	 PrOmBHydt4T+VSTJPOadjDuvX5WGu73orOfW5XF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 093/220] tracing/probe: reject non-closed empty immediate strings
Date: Mon, 20 Apr 2026 17:40:34 +0200
Message-ID: <20260420153937.382541447@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 2f571083ce9ec..8dc495561c3f9 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -1069,7 +1069,7 @@ static int __parse_imm_string(char *str, char **pbuf, int offs)
 {
 	size_t len = strlen(str);
 
-	if (str[len - 1] != '"') {
+	if (!len || str[len - 1] != '"') {
 		trace_probe_log_err(offs + len, IMMSTR_NO_CLOSE);
 		return -EINVAL;
 	}
-- 
2.53.0



