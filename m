Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED9E223DCE;
	Mon, 13 Apr 2026 16:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098887; cv=none; b=L4rokCCkUM/BtdG3ARqHZXem71FTeB3rXLHtHq+U/NTNAzHCjRf5Jsz/ANJ6gRvn9f1B5OOx3VYx8O7Ooo7bSN5qir1omsXCuyTVPia+HcFtnS/5PJVGptm/U7XP/+Jmvb/NR0ACVOeiT/r1o/Ixt1QUFtAg63w+T/WyDgZ3mHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098887; c=relaxed/simple;
	bh=laTk7RDqdzyeV8quHG9sZKyFtQi+U4gb65rrGYMsnWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AzFq3EoXV+kmUt643aTjng15FQ1JBGo4yzmIdAPkHqyoAKqflZ+yvQyI7AufQ0XbQfH1EW3hSUAHRM8TAVp5b+Rb8YJ/igYO8Xi/E5/tEaWpV7544eXtcJrdA0Y2pOKclcWmwcTDea6a4J/efP2cFBhSeF+zc53Edt5J8LZPKlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OSWKL6uL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OSWKL6uL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA854C2BCAF;
	Mon, 13 Apr 2026 16:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098887;
	bh=laTk7RDqdzyeV8quHG9sZKyFtQi+U4gb65rrGYMsnWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OSWKL6uLRumFDzIbXl7t5Q/b4ohbPGFiAe6PmHDOaqwYtXqsDH2uluAQtsLGyH5Nu
	 PEuoHMZijq7Hm2GtQtjk12TD+NAm7Kap/rXTxoYfsDh7m+3XYPBH2M7EdS0GfyJ2Eu
	 VjRDLYaLUEPsPxDRSkxRpu+MNkzxQ9SeHZYZCaOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 5.10 127/491] lib/bootconfig: check bounds before writing in __xbc_open_brace()
Date: Mon, 13 Apr 2026 17:56:12 +0200
Message-ID: <20260413155823.796415287@linuxfoundation.org>
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
@@ -436,9 +436,9 @@ static char *skip_spaces_until_newline(c
 static int __init __xbc_open_brace(char *p)
 {
 	/* Push the last key as open brace */
-	open_brace[brace_index++] = xbc_node_index(last_parent);
 	if (brace_index >= XBC_DEPTH_MAX)
 		return xbc_parse_error("Exceed max depth of braces", p);
+	open_brace[brace_index++] = xbc_node_index(last_parent);
 
 	return 0;
 }


