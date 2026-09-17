Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0244ABBC1;
	Thu, 17 Sep 2026 16:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660931; cv=none; b=IQD5hOZrrPbNPELQVr8z5bn5VvKGBrzhBOxiST9r4ts0qGAYEayu0bsrQ5IfPYnMzVaGSfX/e5/qGijCBVJLS/dJbVt4GxQw7A2zJsAt87zDmhXcG1clnf2mVaCMZdOzg+j4YIWXIKtbXd2bdM7J3+G3ufw4NQy9FDQUrQFh2pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660931; c=relaxed/simple;
	bh=SjqJ5KbBXr1BYj8M9Woa7q68WA6Dsx0bVaRBudj5U9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J3mZKvlTEyV12uDTKcHNlxzU2x3OP+x7MDBwGdGhmCo5GpTD0NvDcMvcbqUcT5zUKm4UMTbYvYP52rjacZGe6yKC2cL1Ti7ewQN/O2lZZ5TBELneSlqPp85t0B63i252vnAfYGz21SowOeok6ZBKSulKnsI9xNNUHBgKX9CW2Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ytjDnaTi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ytjDnaTi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3691F000FF;
	Thu, 17 Sep 2026 16:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660930;
	bh=wFaDTbSnmGuORDtK/MQZp0ZZb+n9i6F1meQpFbFEBqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ytjDnaTix63i90SazgdrMiQN2pbj/TXHBmKNkNkhjsmHa9DOoUtwUDKdsTijN5Enk
	 iziTdb/vRk7DqgrLrvjiqZ7Ym4pHKd4pB0zrHdnsG33Wnh4gj4tZKivtgJFwSv4bPy
	 VV3D8Uzgkc54dbRGDbEYu0ALoRAUIiosYjzIkHRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Willy Tarreau <w@1wt.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0025/1250] tools/nolibc: avoid call to wcslen() in _start_c() inserted by clang
Date: Thu, 17 Sep 2026 15:57:00 +0100
Message-ID: <20260917151552.608665228@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 4c6826ee7d04f489ad6fcf46ae6dd595fe9c6295 ]

Clang may convert the loop to find _auxv into a call to wcslen() which
is missing on nolibc. -fsanitize needs to be disabled for this to
happen.

Use the same pattern as in the nolibc strlen() implementation to avoid
the function call generation.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Acked-by: Willy Tarreau <w@1wt.eu>
Link: https://patch.msgid.link/20260418-nolibc-wcslen-v1-1-671271b8ea63@weissschuh.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/crt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/include/nolibc/crt.h b/tools/include/nolibc/crt.h
index 961cfe777c356..d4e726ed80765 100644
--- a/tools/include/nolibc/crt.h
+++ b/tools/include/nolibc/crt.h
@@ -71,7 +71,7 @@ void _start_c(long *sp)
 
 	/* find _auxv */
 	for (auxv = (void *)envp; *auxv++;)
-		;
+		__asm__("");
 	_auxv = auxv;
 
 	for (ctor_func = __preinit_array_start; ctor_func < __preinit_array_end; ctor_func++)
-- 
2.53.0



