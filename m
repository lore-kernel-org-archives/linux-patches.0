Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530093F23DD;
	Tue, 17 Mar 2026 17:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766861; cv=none; b=XKhfOlGR/JCJCguGY0+ERto+TTc1IhLa9gGD33d+GupNGCm/KI1cl/spsjSm2P89q6Gtm0wk8WI2zfwcn62m3Nr1SkQyB3EwS/cJuYfvnlMUlHVu7laY02UiLO4A0bFEsvmLGKaj64M4TsMrZRG5a6AmvWx11iBfvTSbMAtP+Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766861; c=relaxed/simple;
	bh=UdZZUpQtNtdeLV383KGGzHd/qRjNhmWRxMSfIJt1dXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GkTstPxnl2mfolUIC4C4QfN1vgHmEJDbRhgw7c+J/xdLb/koxU9QDSUbn1CyYGP0vtDOLEIqOtK6hmWCtGgZ6hwig2jB8arWNFIkHxZR0aNqPYal8QZSjuc5ndK75vsZCJYJ0iMYWFv5m/e6M4yHbj49oObd+lq2jNN4+hqSM7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ViHI2zOE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ViHI2zOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A5FC4CEF7;
	Tue, 17 Mar 2026 17:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766861;
	bh=UdZZUpQtNtdeLV383KGGzHd/qRjNhmWRxMSfIJt1dXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ViHI2zOE3pgOeRU3nNdx057x09NZdV3J8o74ATmZ0dJd67wwpEq33ysIMJ38wu67G
	 5HEb3+Z6JmarUcbgqlYSOiWfn6ldy19hxNYJuDpMLMzklbLdJEMGT028doWVRCDGIL
	 8AAET0kuWfk1QcwF9D33fF/316MY7Lpx6WjWfOkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.19 336/378] lib/bootconfig: fix snprintf truncation check in xbc_node_compose_key_after()
Date: Tue, 17 Mar 2026 17:34:53 +0100
Message-ID: <20260317163019.344329848@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -316,7 +316,7 @@ int __init xbc_node_compose_key_after(st
 			       depth ? "." : "");
 		if (ret < 0)
 			return ret;
-		if (ret > size) {
+		if (ret >= size) {
 			size = 0;
 		} else {
 			size -= ret;


