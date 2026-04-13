Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749472E11B9;
	Mon, 13 Apr 2026 16:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097548; cv=none; b=VPdW4Bo183HVwCqfTGikmmxRwc8oWW/aZ73XPt61eiqvaIXDfnRSjDmpWmRHy6T63WK0F9U/sD9ug6SXA6tTy0SICJVaGWMmxUyrswtwW1ctVh+/wFi96eux6bBqB+gmmO8x2MvRuDekNfK4p33yzCHzkBfwdNJyZpU8YxEQ3Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097548; c=relaxed/simple;
	bh=mbwFRQWgIwqG2VU86OladrMKdLJ/UL16oaST9ztwHI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKPfuVB6a9iU7JeOtMutNp5oiYA2qhZUYwqMm+CP7TbChMc2HIRPG26dpi65kqvktDBQeR7UUjDaGfCxq4zJwTNXYv1P9j2nprFgyUIe93BlLFlMzuPnOBuRHmHYnwdlrTfiu7jx0NzoafhhI+jnMUPMAGIAjdEe6MRvYoM7uRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g4JRv05Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g4JRv05Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0207CC2BCAF;
	Mon, 13 Apr 2026 16:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097548;
	bh=mbwFRQWgIwqG2VU86OladrMKdLJ/UL16oaST9ztwHI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g4JRv05Y7Luk6l7fEJG8NZ+hN8B+UotE8gvNtNe73PQrVUSkNUho5SLmHhtHkg/24
	 HI0Q4ulqy6KwpxbLv7NS0tysZfeAaPTxxZrpcG/g5AtcAopN7lVJtSl/739b3Lwau+
	 iNc9213f7jhm9Khu6F/xTZ7W+VRXzJY7K9s12fTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 5.15 179/570] lib/bootconfig: fix snprintf truncation check in xbc_node_compose_key_after()
Date: Mon, 13 Apr 2026 17:55:10 +0200
Message-ID: <20260413155837.162071869@linuxfoundation.org>
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

commit 1120a36bb1e9b9e22de75ecb4ef0b998f73a97f1 upstream.

snprintf() returns the number of characters that would have been
written excluding the NUL terminator.  Output is truncated when the
return value is >= the buffer size, not just > the buffer size.

When ret == size, the current code takes the non-truncated path,
advancing buf by ret and reducing size to 0.  This is wrong because
the output was actually truncated (the last character was replaced by
NUL).  Fix by using >= so the truncation path is taken correctly.

Link: https://lore.kernel.org/all/20260312191143.28719-4-objecting@objecting.org/

Fixes: 76db5a27a827 ("bootconfig: Add Extra Boot Config support")
Cc: stable@vger.kernel.org
Signed-off-by: Josh Law <objecting@objecting.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/bootconfig.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/bootconfig.c
+++ b/lib/bootconfig.c
@@ -250,7 +250,7 @@ int __init xbc_node_compose_key_after(st
 			       depth ? "." : "");
 		if (ret < 0)
 			return ret;
-		if (ret > size) {
+		if (ret >= size) {
 			size = 0;
 		} else {
 			size -= ret;


