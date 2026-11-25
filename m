Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625195;
	b=kGog1a4spOVSsuKB3oc+eJfpA1cbziLhaxHoDFKhq+FG9TVdidC2so+e4rSnhVKjNfP4
	 FhOoT+TnDs/u7RwL9ix32iI3zFRFkDnLv8nWFJ/twAH1Tq0qPfuy90E15nas2PizBaWL8
	 pr8Ux5xPMso8YDGD6ig19XUcIiKzJZK3ENwhMMLGqdgYN4oNxiX5ah8GJ1MH4HLV0IBjM
	 pNLnQcc2/VMpbnoDJjW5qpnyYGWNQj+Ty123svBLpPEKNFq4azvLhhYilBjVXLBuS+i+W
	 R0qVM+cwNqB9dr4WnMJQ0hXDx+ZhvmkybqsKodwRt5D9fu8w7dUndmY5SCFAz0g3BnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625195;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=pPHeuEF1d/XLSq289i2b/G0o8P7SVVVRLhFv/6TqOBA=;
	b=YjxFxHmFkNA4JB/B4MJQB5CGnpYBXtPm/S7NTddNa3EHItDbhHCvituk2wcp1E8c0YSy
	 GJZmsTWB0O9Ww2HAWtNS/Dy+0JmUwYPoWjeyWLG8xstpJgwud6e+c1m4hQJlYaf7sGvjz
	 Gi99jAT64Fdg+EUFI0WUQaSndNr69gRU5OCzRl7m6uIUhXWWcmQHg4OtKIsQTecRmMPAX
	 bv9yrQPFhP9rL2P4vNT291fYU+MOWGKlPlaFeMw7UA4SYmHr+YULQC7Onx/FrR0PiushL
	 cQUaKsRwwb79Da05zz6z34FKjYP8fDnQl3OkFmNWB/M4aKvLUzAdhMNKNaY/XYwRKpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nhS1kSTK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CE7606A321;
	Wed, 25 Nov 2026 16:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nhS1kSTK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB90C1F000D8;
	Wed, 25 Nov 2026 16:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625195;
	bh=pPHeuEF1d/XLSq289i2b/G0o8P7SVVVRLhFv/6TqOBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nhS1kSTKXgUSlUSN2cqM+HTUCtbFoDMYGzeusuM5ncqEyvI1olGNEhxb7+HoVNxLG
	 Nte/3NhSfQ2qh3VG5cULPgltE/pAhNtub0GDSnb8otc58M4U+8Q32qiYj7m0/2C5nz
	 FbvkIhIRRnLeaTnFMuPXy/YMD4TyG+1iNwL9zt6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 437/816] tools/nolibc: fix FD_SET(), FD_CLR() and FD_ISSET() on 64-bit
Date: Wed, 25 Nov 2026 15:33:05 +0100
Message-ID: <20261125143859.306361040@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danish Khateeb <danishkhateeb03@gmail.com>

[ Upstream commit 929ea5b3481fdbbb419f3986703280fb2b819504 ]

Since commit feaf75658783 ("nolibc: fix fd_set type"), an fd_set is an
array of unsigned long, but the FD_* macros still build their masks as
an int or an unsigned int: 1 << n in FD_SET(), 1U << n in FD_CLR() and
FD_ISSET(), where n is the fd modulo 64 on 64-bit architectures. So:

- FD_SET() of an fd with n == 31 sets the bits for n = 31-63, as
  1 << 31 is negative and gets sign-extended.
- For n >= 32 the shifts are undefined. x86-64, for instance, masks
  the shift count, so FD_SET(40) and FD_ISSET(40) use the bit of fd 8.
- FD_CLR() zero-extends ~(1U << n), so it also clears the bits for
  n = 32-63, whichever fd it is given.

select() on fd 40, for instance, fails with EBADF, or watches fd 8
instead if that one is open.

Build the masks from 1UL.

Fixes: feaf75658783 ("nolibc: fix fd_set type")
Assisted-by: LLM
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
Link: https://patch.msgid.link/20260925211600.119116-3-danishkhateeb03@gmail.com
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
[ sashal: Edited the FD_* macros in types.h instead of sys/select.h, since this tree has no sys/ directory; the three edits are otherwise identical to upstream. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/types.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/include/nolibc/types.h b/tools/include/nolibc/types.h
index 30cc9fad57ecf..ba8668a5f567d 100644
--- a/tools/include/nolibc/types.h
+++ b/tools/include/nolibc/types.h
@@ -127,7 +127,7 @@ typedef struct {
 		int __fd = (fd);					\
 		if (__fd >= 0)						\
 			__set->fds[__fd / FD_SETIDXMASK] &=		\
-				~(1U << (__fd & FD_SETBITMASK));	\
+				~(1UL << (__fd & FD_SETBITMASK));	\
 	} while (0)
 
 #define FD_SET(fd, set) do {						\
@@ -135,7 +135,7 @@ typedef struct {
 		int __fd = (fd);					\
 		if (__fd >= 0)						\
 			__set->fds[__fd / FD_SETIDXMASK] |=		\
-				1 << (__fd & FD_SETBITMASK);		\
+				1UL << (__fd & FD_SETBITMASK);		\
 	} while (0)
 
 #define FD_ISSET(fd, set) ({						\
@@ -144,7 +144,7 @@ typedef struct {
 		int __r = 0;						\
 		if (__fd >= 0)						\
 			__r = !!(__set->fds[__fd / FD_SETIDXMASK] &	\
-1U << (__fd & FD_SETBITMASK));						\
+1UL << (__fd & FD_SETBITMASK));						\
 		__r;							\
 	})
 
-- 
2.53.0



