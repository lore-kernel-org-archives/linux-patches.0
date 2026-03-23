Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B37823DD;
	Mon, 23 Mar 2026 14:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275730; cv=none; b=b/eDO6BLrE2sOYnIPBInfROeiA9gbqXVN1/NVSgY9mrhngPA2WTmUMnX8E8XHIzCy3FKhDf321c4sLdD92pyOkboDbiTZSo++GNStpSD6sFfjPU861A00NZwEiSHSkx+xJVMB5mX83QM9JDJyKPr+Ujkcb2fF0D4indUT10t8ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275730; c=relaxed/simple;
	bh=fuSyvtyzrVV9mLSRuG1Ij3A+HQwZeShcCibMvPt3O80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GWQiEicpStDGfoWN0ZqkwQr7uGgGhZr+Eni8S2F27bH3/H2ANGxhfeRaJ/c6Pz/F1N4V4hj9DZFozOX7U2SODzivs8mAdoNkGxi1escF01g/PXonuWUABL+jH8cuEen9f4fHIBVduywRX2gdVm+xki2Gc6EWnEx78nvamuhkTwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UN4x9EoW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UN4x9EoW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E5EC4CEF7;
	Mon, 23 Mar 2026 14:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275729;
	bh=fuSyvtyzrVV9mLSRuG1Ij3A+HQwZeShcCibMvPt3O80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UN4x9EoWWvEn7ee4Rsl4YHT2fMmqexpwdsk66BqJioVzfgmUNKVV3MKojqV9v3Lw2
	 7WzqwfECb3RzLTfEf2mGpS9DbxhZ2slrSaHnvCvhoy2NKzs3A/lSFeEQ2L/J3ul/hY
	 DRaru+45U9qtCoXqkz6YSs9b4+HzfP8Y6lbhmDrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.12 192/460] lib/bootconfig: fix off-by-one in xbc_verify_tree() unclosed brace error
Date: Mon, 23 Mar 2026 14:43:08 +0100
Message-ID: <20260323134531.266771410@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


