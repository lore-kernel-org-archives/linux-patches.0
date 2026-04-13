Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0252E2E11B9;
	Mon, 13 Apr 2026 16:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097541; cv=none; b=Dl1eDQPCLJeb/qh5XryOm2CL8PyHLQr0YghoFbJZOjLNFOvbGg4OhNaZ9ODCK0+2Pi6f73tg2BG0ahplPnoHQKuDxeN+ufQFJIRu6u5NGuxyr4pBf2Bgm3BRRk8G8PZva/3Galg0uiMNzXTsNg7KjOxcEF4rxRfzMi/vzXV4CWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097541; c=relaxed/simple;
	bh=KpEf4MZR/3yvNHDNguCDoSwQXN35290e7jg9rdzSFOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ESFQ9lf1usYQH/ZqSXulyRCpI1X54H13amqYx4kJN5hcLTs1hU3m4hmbfpfb3oFmOSjt2kWZd3FvjzS3hfBlAz1w/mNJ6Aj6mRCHlnrN/LSEmayKBUy2uNl00NsLwMRYxWa+CgQw5ubLFZrbaBINOuNfWg2G6+pwpBVmkd/u9uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gxadQttD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gxadQttD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52603C2BCB0;
	Mon, 13 Apr 2026 16:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097540;
	bh=KpEf4MZR/3yvNHDNguCDoSwQXN35290e7jg9rdzSFOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gxadQttD/i/eWwNkovWMprxonWOOCzk8V21cQosnA48J/QxesWNmef2VeH3sJE0qt
	 k8KgyVJRB+a99SI5xT2Qiq73iv6c/USWKFtjuvmn2K4GPO7TtWrevueBPkzFOec1XB
	 xsYlDxuqP2YhgVFwGLIwbiZxgGyuQrsk1uGtWUMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 5.15 176/570] lib/bootconfig: fix off-by-one in xbc_verify_tree() unclosed brace error
Date: Mon, 13 Apr 2026 17:55:07 +0200
Message-ID: <20260413155837.050067189@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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
@@ -725,7 +725,7 @@ static int __init xbc_verify_tree(void)
 
 	/* Brace closing */
 	if (brace_index) {
-		n = &xbc_nodes[open_brace[brace_index]];
+		n = &xbc_nodes[open_brace[brace_index - 1]];
 		return xbc_parse_error("Brace is not closed",
 					xbc_node_get_data(n));
 	}


