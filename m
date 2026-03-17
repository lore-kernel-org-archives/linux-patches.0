Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636AA255F2C;
	Tue, 17 Mar 2026 17:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768302; cv=none; b=Jkv/ncTz+TSGyG+GJVcs7Xil1gbQwq9NzxyblXS+4wcg4f9bRYyC0OR7AeWmsy4gldxFLgQqU0nZb5jaaSnP3AI1SNuFuRRC1VjVTZOeP7RT0CpQT5zZcoB26khImQLBGeiJ5kUZhYZGeDhcxGhsa9Orsdjr5U/4RvR50KGawuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768302; c=relaxed/simple;
	bh=6eiPEGgpAUQurugTJlZroVbcgJOjv4XiLr7A1m439tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QO6YwbpXzsau2dWbdqnZvZjEYKh3b9EOttc7ycdHiQQJK5TsZQkKwGYyMiXUnqJakfxvSnHSwPEdpNro2a0idVcBhHFZKsVTX/ZzEbznAHU4ere89s61skACP391T3BfBJ8MoHo0V+3GWWllDAs/UqAWB1Ku53OdIcsL/T+W4nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OUEs0Gcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OUEs0Gcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A951C4CEF7;
	Tue, 17 Mar 2026 17:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768302;
	bh=6eiPEGgpAUQurugTJlZroVbcgJOjv4XiLr7A1m439tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OUEs0Gcf/YxYEdFCguCcUQHhumC0T/7hONeKsa4gkf9zjU1vzUx0TxYgkQU2t9lKi
	 l+n01vxmOWHrA7fgfT+keYNr2BvjAnoYrSUUJlg5SXdg6DZLqQSQgTewNSPn7EEO+l
	 C4Pl7Ho0LqT4mZd0idlIWV4gIFVFTdgO1ITy86ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.18 278/333] lib/bootconfig: fix off-by-one in xbc_verify_tree() unclosed brace error
Date: Tue, 17 Mar 2026 17:35:07 +0100
Message-ID: <20260317163009.703743020@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Josh Law <objecting@objecting.org>

commit 39ebc8d7f561e1b64eca87353ef9b18e2825e591 upstream.

__xbc_open_brace() pushes entries with post-increment
(open_brace[brace_index++]), so brace_index always points one past
the last valid entry.  xbc_verify_tree() reads open_brace[brace_index]
to report which brace is unclosed, but this is one past the last
pushed entry and contains stale/zero data, causing the error message
to reference the wrong node.

Use open_brace[brace_index - 1] to correctly identify the unclosed
brace.  brace_index is known to be > 0 here since we are inside the
if (brace_index) guard.

Link: https://lore.kernel.org/all/20260312191143.28719-2-objecting@objecting.org/

Fixes: ead1e19ad905 ("lib/bootconfig: Fix a bug of breaking existing tree nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/bootconfig.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/bootconfig.c
+++ b/lib/bootconfig.c
@@ -791,7 +791,7 @@ static int __init xbc_verify_tree(void)
 
 	/* Brace closing */
 	if (brace_index) {
-		n = &xbc_nodes[open_brace[brace_index]];
+		n = &xbc_nodes[open_brace[brace_index - 1]];
 		return xbc_parse_error("Brace is not closed",
 					xbc_node_get_data(n));
 	}


