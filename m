Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBC73AF647;
	Mon, 23 Mar 2026 16:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282720; cv=none; b=My4MND0WJreK+58dj2MuT+P2tQh7b4wlk6Iit9KjzrDliqvs8l8SxgNFQW+8GOuyaj3v74zJLDvxCDQjWtbpxzNh33kGa9NreEPhlgT6aTBnHHmjUe/tUYXV9JMLBFY9JGfa4mwY7MG89QSEJNP3WjJK9OLo8FAYcinqpPxvquE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282720; c=relaxed/simple;
	bh=Ruz0ozznDgR3C1X9NGzUbQQmirYYhlIhpyVEl2SIfD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5LCH9O0c0mxwvukgUw0DMiewYOBnompvt6N1UFprqfp3bDpfNs1I+GZYqlvskJzEXC4JNXAGExQJvmhy+lujfAInEFqkBVOI5160JQnS8GHXdG4knYLMU6JL+OyhYBv0FtIAwOEKinxPXSO0jlPvY8vRI1nQkNSNVjkMg7ykds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C+ZxPSCq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C+ZxPSCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A67FC4CEF7;
	Mon, 23 Mar 2026 16:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282720;
	bh=Ruz0ozznDgR3C1X9NGzUbQQmirYYhlIhpyVEl2SIfD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C+ZxPSCqBuCNmREAAZj9Hv4JEBJ1bAGXv8WcsRV3UYIcVU55Is2ZIDymlmQYZF9R4
	 egSXB8KnutqgNsppoQXVXH1A6xBn0QSE65D1cbBzPjRpv2LpPletwRkTJyip4MYCFI
	 u59A8drsE/KhSxe4UPlXE3LK/TRPLaqGBTsOh/nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.1 260/481] lib/bootconfig: check bounds before writing in __xbc_open_brace()
Date: Mon, 23 Mar 2026 14:44:02 +0100
Message-ID: <20260323134531.486024508@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Law <objecting@objecting.org>

commit 560f763baa0f2c9a44da4294c06af071405ac46f upstream.

The bounds check for brace_index happens after the array write.
While the current call pattern prevents an actual out-of-bounds
access (the previous call would have returned an error), the
write-before-check pattern is fragile and would become a real
out-of-bounds write if the error return were ever not propagated.

Move the bounds check before the array write so the function is
self-contained and safe regardless of caller behavior.

Link: https://lore.kernel.org/all/20260312191143.28719-3-objecting@objecting.org/

Fixes: ead1e19ad905 ("lib/bootconfig: Fix a bug of breaking existing tree nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Josh Law <objecting@objecting.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/bootconfig.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/bootconfig.c
+++ b/lib/bootconfig.c
@@ -534,9 +534,9 @@ static char *skip_spaces_until_newline(c
 static int __init __xbc_open_brace(char *p)
 {
 	/* Push the last key as open brace */
-	open_brace[brace_index++] = xbc_node_index(last_parent);
 	if (brace_index >= XBC_DEPTH_MAX)
 		return xbc_parse_error("Exceed max depth of braces", p);
+	open_brace[brace_index++] = xbc_node_index(last_parent);
 
 	return 0;
 }


