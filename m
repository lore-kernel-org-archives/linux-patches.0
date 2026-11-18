Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048471;
	b=pSe26h0+RONkc6PINkA4tbFStCU7WUD4jAdrLen2y/WGU7LNbRh/kyZlXTyA8eIQkSma
	 puWALmW27gIKaYil7Ssl5+0HDBPDzmUxBYZi0sUJlDfyCIIPl5U8zDQ3YWLKQKKX3Q5jl
	 oq6/I7LSYJgI1ooO4CEtIl7JEaZyyc3/cqj20PkO9xXgA5zfW5mVfx++HT3nF7MgZMiBN
	 B8LJAIsJ3MxVidzWpI7mXzMyB5Bj68KXCCrZSt6r/BfO8bv8pePx00qpLv21LmfhsKMLn
	 K/I/h4XiTQBbnOT44eFReruRWmpREAztlzIiXMO1SIZbpYO1pQOeDX/pDXsEiAXTdBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048471;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mvqG7uIGDHWSQhZKEGZleUw0IskAEdehCYeUa8y9sCc=;
	b=yuzgt7kRkY6JIjoxOJpwFeYzJhnH16fv3o4gjeCtW1bsyGV+Yv6BOrS/7HYmC0Br33tn
	 UL4EJLIMklsi21u+Hdehu+PCgs2FrD9NqEyEg5wFyYzOTZ8MHx6hq8LMwGa0kBxNSjvTZ
	 nna9OnhZLnKea9f4Wp/9aimSz08fJIo8AXsOTaOILO6wm5qSYgt2mFscvb8NsdEJvnhH7
	 QtnVHSHKBLaA9o0xBxakKz5b6jLO9BhvuZiP8ORQrUZDO5mBwEdqrCkB+AXOuIdWr5Sx/
	 NtKB45Pw5NHL7rZWTqibTMpuyefDz51/+YwOeJSTeHssHSP3dLC2OAyR7CDSflNv7sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jMT3c/Vt";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDD4606A31C;
	Thu, 19 Nov 2026 00:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jMT3c/Vt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628DB1F000C4;
	Thu, 19 Nov 2026 00:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048470;
	bh=mvqG7uIGDHWSQhZKEGZleUw0IskAEdehCYeUa8y9sCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jMT3c/Vth2org5NK+wMhx7m51dQ7ehNV6Hx+HdSHNG2mtJCcb8cQpO/dT1ELEAwUP
	 V2cF/1/J6/2OrtsPzarO/mx7SKX65E/tTQqM2Xzeli+hxKtB7aAWUX7Ep+1tn44S8b
	 zRiYhIyA/VOie56dVGgMv31PJCmTnzDKEOfJayxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1989/2857] KMSAN: fix memset() when using fortify-source, again
Date: Wed, 18 Nov 2026 15:50:23 +0100
Message-ID: <20261118150312.990600529@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5001a11258e4d..0fe311013efa2 100644
--- a/include/linux/fortify-string.h
+++ b/include/linux/fortify-string.h
@@ -341,10 +341,8 @@ __FORTIFY_INLINE void fortify_memset_chk(__kernel_size_t size,
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



