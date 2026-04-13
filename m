Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA6D223DCE;
	Mon, 13 Apr 2026 16:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098879; cv=none; b=ZeCwXFLB5Sd5EZRkxa7RL7rxP2MVPU5I7qPpJ6K+mi1QYKdWz/ZPk3elZdr7NMOWHUyF+xpYFp3YLAufGqrQLon/Vla2EW4qm/vuQE7qGrPgQe+i/aqoT2e1ykMM6aA3qRoZYkBttJWOHM9oB277bL5sjA6zySuAVQfSaTBZ6g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098879; c=relaxed/simple;
	bh=BqrBHHPEvEx5dBMTNiJuUDr0BDDCd3jpC7Bo0OOWG0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eARdyrW8cJgm/fvVyMld/oOHuoD9mv0jn0bieShHtWH3irJgBfn3iTrMg6Y6QFt3tlKCHIAEjziuwKccNC2SfwaCxS8Pt03+FS4isb6eYK2bUQXQUpigMimNBu1UBvdvtw7B0cXKCW0obqHe7a0KKj8Khft5yB/ZeCRl8aFfnOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LbuDtPHx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LbuDtPHx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15436C2BCAF;
	Mon, 13 Apr 2026 16:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098879;
	bh=BqrBHHPEvEx5dBMTNiJuUDr0BDDCd3jpC7Bo0OOWG0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LbuDtPHx7tgT0Itz59YOhbkK11lcAbBLCJN+pGUqVU7khzkiG6fGPHP8duCJfmA59
	 iXbRchv0JALprlzYoIpPegGl4RnrzrSjgFPU7ru3J4EFVsrLAowlDlI4KHHddev2u9
	 V7Xk+7B/4msGwytegQ+D0TlPC09tr/pFzpvlBeSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 5.10 124/491] lib/bootconfig: fix off-by-one in xbc_verify_tree() unclosed brace error
Date: Mon, 13 Apr 2026 17:56:09 +0200
Message-ID: <20260413155823.684983663@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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
@@ -685,7 +685,7 @@ static int __init xbc_verify_tree(void)
 
 	/* Brace closing */
 	if (brace_index) {
-		n = &xbc_nodes[open_brace[brace_index]];
+		n = &xbc_nodes[open_brace[brace_index - 1]];
 		return xbc_parse_error("Brace is not closed",
 					xbc_node_get_data(n));
 	}


