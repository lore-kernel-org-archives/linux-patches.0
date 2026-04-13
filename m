Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAF7223DCE;
	Mon, 13 Apr 2026 16:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098885; cv=none; b=ZGYuxPbPh97vs6d3xXn0U7x2KbbXBy3hToVrKAyyvcUdFlDT+yDNeIBDIBQTjasXUMH/VI49+wGZTsTGD/BAXaAiuAAiy5Xub68qzvseZgDu4YVtTPy4CBaGpmKH853VmvgyQnZgu/nrFu1ZhGZ2EL31R0tiyM/porP8T+CeXPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098885; c=relaxed/simple;
	bh=bizKiEYqvnFN0O0kEWSQTCfq0h6yjToNvUIiFQ6naxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vrbe0kRr0MvVKBVwlmUgArCoJF+WRMFbv0Gyuk6Ai6s3IQD0biCOGJUVcy5cwfMUmHznvEwodJM6WxIPC+JCUdMRFnc5pC5Ctvn6QtPyYPvlQeLeYqk9jsml9akldf2FgD8k6ZXGrx9TyirFG/e1NUDILArHBrQhqD1I8tLdazw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eaeybo7E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eaeybo7E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F464C2BCAF;
	Mon, 13 Apr 2026 16:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098884;
	bh=bizKiEYqvnFN0O0kEWSQTCfq0h6yjToNvUIiFQ6naxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eaeybo7E3bdFEKHxR+icC+znWbKYx/ElC+WWrzXn6lfg/CUeQY05MQpuvGYUNjtak
	 iZUxZ0a716RWw26RFgignosE27H8PWatmWgpxQMDw/i72Ln4PN0GpiUepHucQRXx7O
	 RWDRc6LCfM80IDzp9bpcUIAycTWYzhpbZpH7uN68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 5.10 126/491] lib/bootconfig: fix snprintf truncation check in xbc_node_compose_key_after()
Date: Mon, 13 Apr 2026 17:56:11 +0200
Message-ID: <20260413155823.759720109@linuxfoundation.org>
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


