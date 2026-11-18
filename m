Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016727;
	b=zE17FSUoy+8OaiUdO4+ePHvKW3IgzcJUoo/alNG6mQrEx2TS2qK36TlkdSnriiRwn/6y
	 AhRPgoYzQ+Te51sd/Yw3QMp8XwcnU/lwdlHVC587SkUYkpvNNHCuJz7Yg8WAZCpb2ZK8m
	 GkVu4KtVTalaiDJLjsbTAoGFCYTV9sUv8lYNNY1G48P4TSUsbnn3LJz/60z2RR45W200P
	 W5qbfKxenmRKY09DFTKHAhTqWxtFVW5NPZiUWusYfn/KwniiaDX3q3Eqy7oHKmNRnENYQ
	 PzaY38LysupUV88HfLg6Lm1WrmMwKStY4XVMqZSX1n7UqM/T7j4M3WYtuJaVb5ocWAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016727;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OelCJUDm+fe+1vPQAPlmPG0KJCeQP/scdJKi0MDEQ+4=;
	b=lAT+TVFE5kCc3xhrppp9GTaewc6NqcJEFUc5e3v9egvojqPoQYZI990MxiqsM++sIbh2
	 o7nxBLnjhLn039OMpim8OzN1ELK+L682eQSu4fX0A5H6Mw5uAPZbib2AE1lkKkCJm11Z6
	 snoOda+AnclMh6CcRiUudDk9SLBrioIJVnn0gvjjMvdm3BBkNBJnSANGz7m6qnkO2fEni
	 /gyfXrprlijprkSV4Tu7ZeVTfd3p+fmr2o42fvJR1R4zacJR2WPrPx8uB/pxn9MSuZjhO
	 51ctDLqX+yvkx529ykV2XVkjMcj1DJVZ1mOU/+heAewVDwye+7qEvYScksbkk35OFkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=diX8vES3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F171B60A2603;
	Wed, 18 Nov 2026 15:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=diX8vES3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495031F000C4;
	Wed, 18 Nov 2026 15:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016726;
	bh=OelCJUDm+fe+1vPQAPlmPG0KJCeQP/scdJKi0MDEQ+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=diX8vES3bx9zsr6hQSvXrioIV37/3L1iHOOEZvn6sr0fbhbgygnU3tnARPYFDPfy/
	 3ALI6xywkev2/UOIZcbjjfYC8awZOLrcl/OkCFUUcKLGHOaRZLsxwJfbHYxMXZeJcp
	 Z8TKM/ReJwE4Yq1yDEHA1syEVfHNNlQGyjf3s3y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0631/2651] KMSAN: fix memset() when using fortify-source, again
Date: Wed, 18 Nov 2026 15:31:11 +0100
Message-ID: <20261118150310.403172526@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index cf841dc71feff..7e7c369e0a6cf 100644
--- a/include/linux/fortify-string.h
+++ b/include/linux/fortify-string.h
@@ -458,10 +458,8 @@ __FORTIFY_INLINE bool fortify_memset_chk(__kernel_size_t size,
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



