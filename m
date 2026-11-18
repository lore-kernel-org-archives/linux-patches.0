Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039944;
	b=Y3iGUuE841JfYdJAjGlbqqujrfqH/wzhdsPl4HzvXpQRxqsHTzfPk5r0opPModA2Ic9P
	 CO3yaGtmDMm86dRC8h07iSf+Fd7hzBwwFTHXzUWKV3JdDC+vqYc6IaOGJu12iJsdlxMOj
	 ZkXY2SXR259Av6MeByuNNEvze9IW9Ht+IXWCw2HphVRJbHIHLjCkgLgsyXqjV0oYyqIrh
	 pRHMAY/4BKuCYqvFDza6O0xh183+lm3jjmiWBmC/GtRqBhiNmy/3I0r44Cpx7ZH/b0dGt
	 2f+a2aFuyZBn1yHtFp502zwkR1BaKbQr8Lz6ZKXYwxAeo2JBsXXISGhyroNH+GSTrsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039944;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dx3DFWL7sFA0IWvmHUDqb9vV5btdmhG7L35If0HhlcU=;
	b=u96uZ3FAZ4ww8NCyHlAssDUsMAB/L1JP5e59DD3pxI+VqEdk7tELMVnru9yva1tBk3uN
	 gUESuK5pTF90H35BMhgev52ZcvC0CBA4LzWfHuQGnLHOkvsHDfxmbsLXv+sAhfA/1Pp2h
	 Vd1Xu08b9yRF8TZtFq/AOa7IL0KFy4MYPxVxrgM431uBDteTK8syHMjtDP6A7U6A2IvLD
	 It/x4m72CpmdswBPtABbY/AIKh0Lx+O6A2EAkXV9f4ZwcaW36v6zbwQaYMUHL4UMWvKLE
	 r80YsHCAF9u8LyqWx9kQpI6KKNWKKvnMgWnJu6ztIWRjGhLsenkRDrnG84vi5/j2ZCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YLozU38f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC4A606A325;
	Wed, 18 Nov 2026 22:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YLozU38f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32191F000C4;
	Wed, 18 Nov 2026 22:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039944;
	bh=Dx3DFWL7sFA0IWvmHUDqb9vV5btdmhG7L35If0HhlcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YLozU38fOtTUcji/8x4ZPSkBbQLlTA5898nO+zbHH3Ax0dNCQ4/9ch5dhTNVeJ8HD
	 8OC1zHK8Gkk2NCEEiciQxINV8AcYecL6eqHB4P7AyHRDk2/BEEWmGd1N46MM1BewRM
	 p7kKyVy0FQIYxnsNgOupbzrShluorBlYPNlFeaao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2282/3318] KMSAN: fix memset() when using fortify-source, again
Date: Wed, 18 Nov 2026 15:48:24 +0100
Message-ID: <20261118150430.227352563@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 3555409e524a0279845f91273ba714998658c163 ]

Both kmsan and fortify-source replace the memset function. When both
are enabled at the same time, the kmsan version gets used, which triggers
a warning about fortify-source being nonfunctional:

warning: unsafe memset() usage lacked '__write_overflow' symbol in /home/arnd/arm-soc/lib/test_fortify/write_overflow-memset.c
warning: unsafe memset() usage lacked '__write_overflow_field' symbol in /home/arnd/arm-soc/lib/test_fortify/write_overflow_field-memset.c

Commit 78a498c3a227 already tried to address this, but this seems
to only have worked for memcpy() and memmove() but not memset(),
which is still lacking the macro definition when KMSAN is enabled.

Remove the incorrect #ifndef check around the memset() macro.

Fixes: ff901d80fff6 ("x86: kmsan: use __msan_ string functions where possible.")
Fixes: 78a498c3a227 ("x86: fortify: kmsan: fix KMSAN fortify builds")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20260618142951.1739694-1-arnd@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fortify-string.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/fortify-string.h b/include/linux/fortify-string.h
index f7e1895367fa1..c32fd135cf053 100644
--- a/include/linux/fortify-string.h
+++ b/include/linux/fortify-string.h
@@ -534,10 +534,8 @@ __FORTIFY_INLINE void fortify_memset_chk(__kernel_size_t size,
  * __struct_size() vs __member_size() must be captured here to avoid
  * evaluating argument side-effects further into the macro layers.
  */
-#ifndef CONFIG_KMSAN
 #define memset(p, c, s) __fortify_memset_chk(p, c, s,			\
 		__struct_size(p), __member_size(p))
-#endif
 
 /*
  * To make sure the compiler can enforce protection against buffer overflows,
-- 
2.53.0



