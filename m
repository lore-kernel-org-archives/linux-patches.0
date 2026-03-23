Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A0C388377;
	Mon, 23 Mar 2026 15:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278559; cv=none; b=BgJv9lsOX2Z8REgi1XB1l/FZDLLe5H6GdM2YwukP4t6LLCkbroF19j2Q9zihgx9/zsEr6NMLGogVkuzYCLjTi7iD2HD0jjsfI/hTM3fxS5JcrbRW3QZVcjTi2hM+lm2LvvhVolO9ubR3SN5CA5nN8rlz8ZDHiy05DpUdjmwEgyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278559; c=relaxed/simple;
	bh=ZgzUWQeKa9xepPtm2/tkGzTDYGQTe08RtbCv7iHJEoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jjc0zRcbxw4uSxA8cufZnbkOACgZDlhETOEFQTrdDtWqNeeI2IQR6b2/XE7msINKKkag0SaWT+g5werE8Dr3fvbZMeE/lAP+yoy5CO/5gPE8yXMfHF/G3dKlVvzmV0ibHERaOiho1OTyFGSDKQNEUc/c2TLlalU0DoWKOf8X6Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cquHWbHo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cquHWbHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD2AC2BC9E;
	Mon, 23 Mar 2026 15:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278559;
	bh=ZgzUWQeKa9xepPtm2/tkGzTDYGQTe08RtbCv7iHJEoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cquHWbHoF5awcDpORj243Z1O7uErnQb+aorxAc8BjHQ6RZeVSWTdz1FDtjHJzenkQ
	 4u3QmL/CKfka0R0vr7Y8KSYKkkpjl4YNZhK7bHYt74IH/S4FlroNBKMrlU6RDdaI/c
	 PMVMwgTjAjsnyxb+6nXwwnnjQevyrll1S9wjTzpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.6 346/567] lib/bootconfig: fix snprintf truncation check in xbc_node_compose_key_after()
Date: Mon, 23 Mar 2026 14:44:26 +0100
Message-ID: <20260323134542.397932907@linuxfoundation.org>
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
@@ -318,7 +318,7 @@ int __init xbc_node_compose_key_after(st
 			       depth ? "." : "");
 		if (ret < 0)
 			return ret;
-		if (ret > size) {
+		if (ret >= size) {
 			size = 0;
 		} else {
 			size -= ret;


