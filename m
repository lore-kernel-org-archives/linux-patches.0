Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2640D3B19AF;
	Mon, 23 Mar 2026 16:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282715; cv=none; b=nIk4AHfOZecEiIT7G17dFQxEUM4+xXQcSwQZZgNUXk5lSmCdlV0d7eeCwOMi9XR0Mu0RJS5VHRr/J6eThIphAm2mQ25/IZm8bracb5HUJC21XVQRQx9pPq46Hs3MhONn+ofHL1p82VsaH43cNfG+7Jrlp1MfJuhNay6FiaJIn8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282715; c=relaxed/simple;
	bh=x+Xf6dLopFv7C8AUonRbl7Z0Q/AwxNgiIOrQBGWdsG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+7E34n6Yxk44P2fkTdDd3s5c/SE3PL8TB3OsvrzloZWd5uxeSq2NyUXVmRkUXiEgYYn+r+pCpyT21ywk1KrNVOXPSK3TA2mkcr2ibI/ysmRpMn3nezk7cXkf5M4Ho+NAi+6Y+ed35wQ7VFNhQLotAMAHlqm6zUtAnO+jXNgHmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KH+yfKa/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KH+yfKa/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB623C4CEF7;
	Mon, 23 Mar 2026 16:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282715;
	bh=x+Xf6dLopFv7C8AUonRbl7Z0Q/AwxNgiIOrQBGWdsG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KH+yfKa/eG4yY4MjOyZJ3or6+q4kF6Iu8ZmiUMJG45lAw/xK/V0Ck3TXen1r/IZCW
	 QVosSD50fu78D/8OOtNh1reG0Lv1cm6u0Q7Xzn4qBtRaQIdmYM8t0+KxqrPVOp8/Zt
	 v5SfTJT5Iieh4IDQRjCWNajN4NGTYIhwf9bYmfrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.1 259/481] lib/bootconfig: fix snprintf truncation check in xbc_node_compose_key_after()
Date: Mon, 23 Mar 2026 14:44:01 +0100
Message-ID: <20260323134531.463197442@linuxfoundation.org>
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


