Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029824;
	b=rbH4B9dR0H5cLWvz8usZdpmIExzSzUsE+mLHs/KF6lO9/hibZGgcLeYEtC+Z9sti7G5+
	 sWf6Mo+Gv8VAXfxyptnYmfbOPbK65ed+9Fx5KijynsndQRh+3oKqBSaAHBoWEoZd4WxNx
	 qD/+HaTv9SMWxhGIR6YkmP2bXwFHZHqQ0/rNND4br7jKvgXrQb40pqeyfV6xwH4o3WX6l
	 TSG46ocGmU7uitI4qkg4hpCA4UOM9ogSVEnecgcFXc1frX5aaVhqV35nvlH8ZU0Sn8doU
	 VHz3AdTtiNs3ouL5sbIunjPtpuAEfD0YbZ9lwpzwSGppH/EaNVq7qOKbvyKhAts4z0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zfAInx1ntc+T+YftIAZgRWwdieFyKRfhHARuwhsOjTQ=;
	b=nfFlrRjpya/PGlErkdk+ztBd/J3HVcGxempbyHu0yrmDqLLjIKjsGPnig4HKKZAhEbKu
	 0ml85hzouTtoTn+M7Lr1bUrJG84Tak3NKRphfks5w0sPLAwkdqCwCS9k3wO6l8dMEOdzb
	 ECSwzvGzNtgraTw2gToSRQTIoeA+Giy22tfpoE59N2HVkVIcEkiB+vDJ897jFMRY5NzQt
	 DAJd7lDxWNqN/Q2Dgk4DN1UlE0N10TDPLIJo/ngWvUZXCzKPyfD8+2DHTLKv3RY070Jrx
	 F0QPcIAq+YPTchg9mqyZZ+a87j5UY8+asuAyXlnodeQ8jqtQRtzCxhRy0ZYVZKgcBRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lf+G3qRq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AFB606A320;
	Wed, 18 Nov 2026 19:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lf+G3qRq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34491F000C4;
	Wed, 18 Nov 2026 19:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029824;
	bh=zfAInx1ntc+T+YftIAZgRWwdieFyKRfhHARuwhsOjTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lf+G3qRqalcAd/YSHAeERHPy9OyBB8mdnbYHu/9CKgNRiqfvCDF7NrPdtlXfWkE2L
	 CGnDTaHYhEzMxjtnx0hMTpDtIAfEil6pai/OIz15IDJz6e+ShPfsXPEmACcPanNVRJ
	 Wcc6Ilweq25TpKsuX/gor0uFbXzlqMxkG2VTi8QE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0487/1756] KMSAN: fix memset() when using fortify-source, again
Date: Wed, 18 Nov 2026 15:43:34 +0100
Message-ID: <20261118150028.412554105@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 71f9dcf561282..bed58ec5363ff 100644
--- a/include/linux/fortify-string.h
+++ b/include/linux/fortify-string.h
@@ -508,10 +508,8 @@ __FORTIFY_INLINE bool fortify_memset_chk(__kernel_size_t size,
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



