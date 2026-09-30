Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FCC51AFD6;
	Wed, 30 Sep 2026 18:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793999; cv=none; b=PmEiyv4p/ibWFv1Hwc5JxX0eKrDDkejqDiNbm6Fv+yfLGGE+wxKF/11lP2FC5dUkv6u1zh8sa1tmMTZ5llxUR9Yr0y8rweIiXF9aTIpKZyYMoXGp5Co8A8mdLjzcSaomkHHTCfa8Il2BydNWUdBUYyrm+qLE0dikML3NJwS4QwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793999; c=relaxed/simple;
	bh=T3/zA0cT4Lx4P110I1+pSImMy0dm9S/TLv7/YXwiOuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WVzD+LjhImEFNIxgNbp0T1u1ShXldiI+6146EEv2VXcrwvUu3Yi0twH/XuuBTpnySFCt42IzhQW6hmXFZzrGoWvepKVKlL0T341XI/c5LkZVKkiiKizd4RSoOVx2fiqqHp0TwH5i8STuL1qYvMLh72xqUihDwfY0FpzR1mbVLd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ApDTS0/Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ApDTS0/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF0D1F000FF;
	Wed, 30 Sep 2026 18:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793997;
	bh=6Yi8HK1Ez3AoLwtCiDiZZQORuAndtE8D49kdFrLkt8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ApDTS0/Z0qAyq3FIgEw9nzcXWV6YK/DcFkVwK10lkTqpHaoB25aOrkqSLIkSJVZ7N
	 3tB6LjyXWBe8XJyh3A0WEpoYLDPaNtYUvh70NhoeqH96dgUQWbmPW4J7ddYJ7GpckR
	 otQWOUwALvASw2J7oyPbVzOLuzRmbujc3RsGPzwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Willy Tarreau <w@1wt.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0011/1193] tools/nolibc: avoid call to wcslen() in _start_c() inserted by clang
Date: Wed, 30 Sep 2026 17:11:35 +0200
Message-ID: <20260930152434.556895896@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a05655b4ce1d7..d72ed7b37adbb 100644
--- a/tools/include/nolibc/crt.h
+++ b/tools/include/nolibc/crt.h
@@ -52,7 +52,7 @@ void _start_c(long *sp)
 
 	/* find _auxv */
 	for (auxv = (void *)envp; *auxv++;)
-		;
+		__asm__("");
 	_auxv = auxv;
 
 	/* go to application */
-- 
2.53.0



