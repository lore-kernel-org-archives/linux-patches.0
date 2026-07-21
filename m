Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BAA282F31;
	Tue, 21 Jul 2026 21:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668677; cv=none; b=Py0pj6gU9wLAh7NLsQi2t4zH7yqq2TRdnMfaplU4lzLRv8lIz2klVvYG5vlu4i1WpPqGLyx+1X81WVcy/FYNgxxBwx7CNiXbwBIfyW1SNVYlMzeEcS1WL/kI5R77vT2r5E9UuAu/lMYBG0TXMlSj7EnoVpWOd0+0vWjr756607k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668677; c=relaxed/simple;
	bh=Nw4bUU075cvOwI9c8UUOQOqqIfZ+5FJNFvT6S+kkn+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EsVJIJ6XB1hqZwwSxnoe8uNETczQhJFK9jVNLghrpt6WRnauHVCKPvz42xhBaGriOLzmFLzIu/HWqmhvcn9Gti7zHEdIMLndUmjrXR+cvuj4j2lOC9TDSJmfo3xjDvO5N9OBrfXo1LY7A0p0Mlj66UJzVZJI1jbnKpKYSNT1Uic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FaMLWSZi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FaMLWSZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C004C1F00A3A;
	Tue, 21 Jul 2026 21:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668676;
	bh=/+QdDXID52btZitbnZmFG2vMm3uUH0cHfeEs52aMMXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FaMLWSZi41M9G+VOmSb341naIG0OVZN3wWwb+KaMrAKpwyEQ/UqaO4NuNBqucGJPb
	 ipjYkDI4p2DJyL+sTWxRmA3N2clJ3Lf6BCLW76R9tezmCBwi9aEJRj6irR5JB2y+dH
	 2TWEk6jkgFp1R0ORhoUbU+8Wm+9UxYxufH9dIGIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taeyang Lee <0wn@theori.io>,
	Feng Ning <feng@innora.ai>,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0266/1067] crypto: af_alg - Remove zero-copy support from skcipher and aead
Date: Tue, 21 Jul 2026 17:14:27 +0200
Message-ID: <20260721152430.544385269@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit ffdd2bc378953b525aca61902534e753f1f8e734 upstream.

The zero-copy support is one of the riskiest aspects of AF_ALG.  It
allows userspace to request cryptographic operations directly on
pagecache pages of files like the 'su' binary.  It also allows userspace
to concurrently modify the memory which is being operated on, a recipe
for TOCTOU vulnerabilities.

While zero-copy support is more valuable in other areas of the kernel
like the frequently used networking and file I/O code, it has far less
value in AF_ALG, which is a niche UAPI.  AF_ALG primarily just exists
for backwards compatibility with a small set of userspace programs such
as 'iwd' that haven't yet been fixed to use userspace crypto code.

Originally AF_ALG was intended to be used to access hardware crypto
accelerators.  However, it isn't an efficient interface for that anyway,
and it turned out to be rarely used in this way in practice.

Thus, the risks of the zero-copy support in AF_ALG vastly outweigh its
benefits.  Let's just remove it.

This commit removes it from the "skcipher" and "aead" algorithm types.
"hash" will be handled separately.

This is a soft break, not a hard break.  Even after this commit, it
still works to use splice() or sendfile() to transfer data to an AF_ALG
request socket from a pipe or any file, respectively.  What changes is
just that the kernel now makes an internal, stable copy of the data
before doing the crypto operation.  So performance is slightly reduced,
but the UAPI isn't broken.  And, very importantly, it's much safer.

Tested with libkcapi/test.sh.  All its test cases still pass.  I also
verified that this would have prevented the copy.fail exploit as well.
I also used a custom test program to verify that sendfile() still works.

Fixes: 8ff590903d5f ("crypto: algif_skcipher - User-space interface for skcipher operations")
Fixes: 400c40cf78da ("crypto: algif - add AEAD support")
Reported-by: Taeyang Lee <0wn@theori.io>
Link: https://copy.fail/
Reported-by: Feng Ning <feng@innora.ai>
Closes: https://lore.kernel.org/r/afYcc-tZFwvZZo76@ans-MacBook-Pro.local
Reviewed-by: Demi Marie Obenour <demiobenour@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[Backport-notes: this actually does nothing on 6.1, since zero-copy
 support was already removed from skcipher and aead accidentally on 6.1.
 Namely, a commit that changed af_alg_sendpage() to use MSG_SPLICE_PAGES
 was backported, but the actual implementation of MSG_SPLICE_PAGES
 wasn't backported.  I'm including this commit anyway since people might
 think this is missing on 6.1 if it's the only LTS kernel without this.]
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/crypto/userspace-if.rst | 31 ++++-----------------------
 crypto/af_alg.c                       |  2 +-
 2 files changed, 5 insertions(+), 28 deletions(-)

diff --git a/Documentation/crypto/userspace-if.rst b/Documentation/crypto/userspace-if.rst
index b45dabbf69d685..90dbbd56c4e355 100644
--- a/Documentation/crypto/userspace-if.rst
+++ b/Documentation/crypto/userspace-if.rst
@@ -328,33 +328,10 @@ CRYPTO_USER_API_RNG_CAVP option:
 Zero-Copy Interface
 -------------------
 
-In addition to the send/write/read/recv system call family, the AF_ALG
-interface can be accessed with the zero-copy interface of
-splice/vmsplice. As the name indicates, the kernel tries to avoid a copy
-operation into kernel space.
-
-The zero-copy operation requires data to be aligned at the page
-boundary. Non-aligned data can be used as well, but may require more
-operations of the kernel which would defeat the speed gains obtained
-from the zero-copy interface.
-
-The system-inherent limit for the size of one zero-copy operation is 16
-pages. If more data is to be sent to AF_ALG, user space must slice the
-input into segments with a maximum size of 16 pages.
-
-Zero-copy can be used with the following code example (a complete
-working example is provided with libkcapi):
-
-::
-
-    int pipes[2];
-
-    pipe(pipes);
-    /* input data in iov */
-    vmsplice(pipes[1], iov, iovlen, SPLICE_F_GIFT);
-    /* opfd is the file descriptor returned from accept() system call */
-    splice(pipes[0], NULL, opfd, NULL, ret, 0);
-    read(opfd, out, outlen);
+AF_ALG used to have zero-copy support, but it was removed due to it being a
+frequent source of vulnerabilities.  For backwards compatibility the splice()
+and sendfile() system calls are still supported, but the kernel will make an
+internal copy of the data before passing it to the crypto code.
 
 
 Setsockopt Interface
diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index ca54f29270636f..80a8d3a4a3cf73 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -977,7 +977,7 @@ ssize_t af_alg_sendpage(struct socket *sock, struct page *page,
 {
 	struct bio_vec bvec;
 	struct msghdr msg = {
-		.msg_flags = flags | MSG_SPLICE_PAGES,
+		.msg_flags = flags,
 	};
 
 	if (flags & MSG_SENDPAGE_NOTLAST)
-- 
2.53.0



