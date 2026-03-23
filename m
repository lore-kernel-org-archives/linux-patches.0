Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF133B27C1;
	Mon, 23 Mar 2026 14:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276862; cv=none; b=INenpmmjNDsy6noxdWgvB4fWIwVms32vojCRhidXyQ7TRRoFlhaoaZOzCAFyyt2dSXKcIkCpzBKHYtCXrkC4PgoJaUuBnajnEk6J2BUty405aZmJx2xQo0HyZw44Rw01twxeFwHftKoO5Fx+juPPEJjNNJN9LbBfrSDlMvopCPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276862; c=relaxed/simple;
	bh=L6IJcBX5zoCCMVdNCUtBRC6IIQrI5VBhdd1BX/rAejA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOHOx2EUGbNZ1EWbdv3iOx6BANpjXmuEkCs2PyIMajVFgggcdI8RZ4nW7ONk2SC2p8S5dBfJWfuhMH1SuQ8l1w4wqb2M0KQ7L7+ETh2hh9jpVqaeoZ/2wm1bD0P1L5z0OdhBF4NfIs4LQ08E3RRnvSboSH3yOd5I1kUAJodG1i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MJN30IkY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MJN30IkY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29EDFC2BCB5;
	Mon, 23 Mar 2026 14:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276862;
	bh=L6IJcBX5zoCCMVdNCUtBRC6IIQrI5VBhdd1BX/rAejA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MJN30IkYyy1LFdW3BewrFygF/I239z0sWZPG8H85fRAcfgg4cqW6I6frbwlnRjEQ0
	 FZiz9CQxtzEF6x7LTo3BJQhpPUF516cfQxq6Og7sRE6yD3G0ZtS4m3QBWVPdvh1vI8
	 stGQt4QosT85JmzJ38dysCrE11rwA6qFgWkctlEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.12 195/460] lib/bootconfig: fix snprintf truncation check in xbc_node_compose_key_after()
Date: Mon, 23 Mar 2026 14:43:11 +0100
Message-ID: <20260323134531.338512938@linuxfoundation.org>
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


