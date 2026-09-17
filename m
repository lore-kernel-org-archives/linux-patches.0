Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B0819F40B;
	Thu, 17 Sep 2026 17:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667206; cv=none; b=PXz6dF0ZoinTuJcrTfEZdkA8YVKoNZH5Avt9mv+unXaYYXcMktKgalEXZvqDP/houO5tGKrKD8mHVyLNiBKKs3ksygFzR50wvCzT4CERLMdTCXyObEIWsOBO9sUI/It5mDnmHTzvhNa8N/erz0vcV3Ollwv7FsoGgjwrOb1yp+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667206; c=relaxed/simple;
	bh=o15mcJhwuNDQW2N5Hphla5OkUppaDzeNplNNkbOfAnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PVJLuSyN+xc1WkBFEDJ507scv/dB/L7KJLhU8VIFX0gpNFcTkAWheb0v8qf4qhyj98usWSq579r+y+a5mVItzYJ2615b3DgvKUnnmja1ddTvGHLLbehViv++BCHNlJ9lA85Xn0kFrRHKn1wUuSGut8OqWSWuEvxSF4SRNpbLeFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XEsEOjap; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XEsEOjap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059D81F000FF;
	Thu, 17 Sep 2026 17:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667204;
	bh=VtaLwlT7KilUbnzz/24w7SdKEBGBZjA63fWEbt82baw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XEsEOjapEfyrLGrjnQPXpav6k2mx+K638k3V0yDgyyuq8E8VIHdJ0vEwVXdSCHoPV
	 oFp00H5aiwujfsY9JkE0VRqmlfuc1L3hxXgNjCP96eFiDb62o7G0UElj8Ltq0YDtz6
	 GTsYfihd7IkOShBb2cDWGZe/4lS8OKgSpGDXrjnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Willy Tarreau <w@1wt.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0016/1102] tools/nolibc: avoid call to wcslen() in _start_c() inserted by clang
Date: Thu, 17 Sep 2026 15:59:19 +0100
Message-ID: <20260917151539.833667688@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bbcd5fd09806b..90e29999d4d98 100644
--- a/tools/include/nolibc/crt.h
+++ b/tools/include/nolibc/crt.h
@@ -64,7 +64,7 @@ void _start_c(long *sp)
 
 	/* find _auxv */
 	for (auxv = (void *)envp; *auxv++;)
-		;
+		__asm__("");
 	_auxv = auxv;
 
 	for (ctor_func = __preinit_array_start; ctor_func < __preinit_array_end; ctor_func++)
-- 
2.53.0



