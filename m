Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF13274B5F;
	Mon, 23 Mar 2026 15:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278549; cv=none; b=Hb9cYOTlsUpkY0oJaAMaz9gznhfIKROx1eL+bhkxhSaZEm6+fry1oauLFd9+9ryuXlDyVzdo+pp+w3WrEFt0TM5zp0U8XKYVoiyJe9XX35wqqNwRMaa5P9bLth03MQDHFvjIcneh0qDTgEGJkLNeakyUb0XC4oBw6IzOZ5U87/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278549; c=relaxed/simple;
	bh=aa0lYpD1CnLDB1KPFtzl2JRFTawwb0+7v+AQPpxqXAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDKtt5riZOtkLcNeLrCjQbbRFLmuFQ3uUq1zgobj1E4Mv87GBA5Nxn2QuASQRs/SkH8piANOhLe19fH3bGb8D+UxCbcL2iitkkgHa2l2wWchwFCeXYkq4w7CWzlW+ksGp4ilSnb+4kHhTD1hXx2gMxZD/oAjlEOMOv7kTvk10ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fB3MXkdH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fB3MXkdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4F2C4CEF7;
	Mon, 23 Mar 2026 15:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278549;
	bh=aa0lYpD1CnLDB1KPFtzl2JRFTawwb0+7v+AQPpxqXAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fB3MXkdHJMjPl2tAjojsZFWJDzhtpbCm2QAXXLpjpdy+QDxwVQst2vhzaMkfX2MlR
	 goIBXUnOUFZnCjxf3tyBbGxp90LW28mM/DNHRB8PeKjLWaiuiBKlXuC5JIeV/zgOj2
	 o8Yke3ciUSLGGWf3v/l0JHdjqL6521ibBoKZONjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.6 343/567] lib/bootconfig: fix off-by-one in xbc_verify_tree() unclosed brace error
Date: Mon, 23 Mar 2026 14:44:23 +0100
Message-ID: <20260323134542.321481353@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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
@@ -793,7 +793,7 @@ static int __init xbc_verify_tree(void)
 
 	/* Brace closing */
 	if (brace_index) {
-		n = &xbc_nodes[open_brace[brace_index]];
+		n = &xbc_nodes[open_brace[brace_index - 1]];
 		return xbc_parse_error("Brace is not closed",
 					xbc_node_get_data(n));
 	}


