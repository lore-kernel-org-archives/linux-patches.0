Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8697A41F7CC;
	Thu, 16 Jul 2026 14:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211223; cv=none; b=t+lFoInORlo+KZz/I4jj8E+uNgt5PMHWlU+8Ltf5ypuxtQdXUqf2oH2Ll05N6+2sWr1gmbjLktSCwo+f67hhvSistwB0e8H46wRk+UsItQE2G5hbij0qOpYSJGulSW3478eIxUyNPvz5YG+PzuJ+drf4l4jbxdhrH7SHtTn78Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211223; c=relaxed/simple;
	bh=jLXOixdcz6GUpbHfkNYgmPFCkOFj2gFhO9MXs2NpdjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vGS1giVwrBKGftq6TmproPrF/uWApGqM2X0540DrrBIe3zo5B22g42agW4CLOGh3hDush+/5+nkLnnKAYq6ayX9mgkSE3LpTVbdl5rnLpzVwXvLE4RfjeKVznz8+GLRBfnXfk2+lVLhEb6xzJukGZX8bdPKDT8gszyheE5end1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EvQGTkw0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EvQGTkw0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC07B1F00A3A;
	Thu, 16 Jul 2026 14:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211222;
	bh=zXj31aeEZJh4+wskAYIT/j/4AqkVoNp2TxD273/K6KE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EvQGTkw02L6lxv0Z674SgoAkUC29CkndapaVhtQK8krREKjzJYhdvCfPJTiJyUJHk
	 746yLVKFiD2nkkOwwIHvvB72yyu03F9mtZgDbBRI1tlIejb+Q0Y4zT3qmJ1lQvjSIW
	 vD591MSUZ3yTmYEGFq0cLhvVZIT+MiOoVWW2jFCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taeyang Lee <0wn@theori.io>,
	Feng Ning <feng@innora.ai>,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 346/480] crypto: af_alg - Remove zero-copy support from skcipher and aead
Date: Thu, 16 Jul 2026 15:31:33 +0200
Message-ID: <20260716133052.294198920@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/crypto/userspace-if.rst |   31 +-------------
 crypto/af_alg.c                       |   71 +++++++++++-----------------------
 crypto/algif_aead.c                   |    8 +--
 3 files changed, 32 insertions(+), 78 deletions(-)

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
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -977,7 +977,7 @@ int af_alg_sendmsg(struct socket *sock,
 		ssize_t plen;
 
 		/* use the existing memory in an allocated page */
-		if (ctx->merge && !(msg->msg_flags & MSG_SPLICE_PAGES)) {
+		if (ctx->merge) {
 			sgl = list_entry(ctx->tsgl_list.prev,
 					 struct af_alg_tsgl, list);
 			sg = sgl->sg + sgl->cur - 1;
@@ -1021,60 +1021,37 @@ int af_alg_sendmsg(struct socket *sock,
 		if (sgl->cur)
 			sg_unmark_end(sg + sgl->cur - 1);
 
-		if (msg->msg_flags & MSG_SPLICE_PAGES) {
-			struct sg_table sgtable = {
-				.sgl		= sg,
-				.nents		= sgl->cur,
-				.orig_nents	= sgl->cur,
-			};
-
-			plen = extract_iter_to_sg(&msg->msg_iter, len, &sgtable,
-						  MAX_SGL_ENTS - sgl->cur, 0);
-			if (plen < 0) {
-				err = plen;
+		do {
+			struct page *pg;
+			unsigned int i = sgl->cur;
+
+			plen = min_t(size_t, len, PAGE_SIZE);
+
+			pg = alloc_page(GFP_KERNEL);
+			if (!pg) {
+				err = -ENOMEM;
 				goto unlock;
 			}
 
-			for (; sgl->cur < sgtable.nents; sgl->cur++)
-				get_page(sg_page(&sg[sgl->cur]));
+			sg_assign_page(sg + i, pg);
+
+			err = memcpy_from_msg(page_address(sg_page(sg + i)),
+					      msg, plen);
+			if (err) {
+				__free_page(sg_page(sg + i));
+				sg_assign_page(sg + i, NULL);
+				goto unlock;
+			}
+
+			sg[i].length = plen;
 			len -= plen;
 			ctx->used += plen;
 			copied += plen;
 			size -= plen;
-		} else {
-			do {
-				struct page *pg;
-				unsigned int i = sgl->cur;
-
-				plen = min_t(size_t, len, PAGE_SIZE);
-
-				pg = alloc_page(GFP_KERNEL);
-				if (!pg) {
-					err = -ENOMEM;
-					goto unlock;
-				}
-
-				sg_assign_page(sg + i, pg);
-
-				err = memcpy_from_msg(
-					page_address(sg_page(sg + i)),
-					msg, plen);
-				if (err) {
-					__free_page(sg_page(sg + i));
-					sg_assign_page(sg + i, NULL);
-					goto unlock;
-				}
-
-				sg[i].length = plen;
-				len -= plen;
-				ctx->used += plen;
-				copied += plen;
-				size -= plen;
-				sgl->cur++;
-			} while (len && sgl->cur < MAX_SGL_ENTS);
+			sgl->cur++;
+		} while (len && sgl->cur < MAX_SGL_ENTS);
 
-			ctx->merge = plen & (PAGE_SIZE - 1);
-		}
+		ctx->merge = plen & (PAGE_SIZE - 1);
 
 		if (!size)
 			sg_mark_end(sg + sgl->cur - 1);
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -9,10 +9,10 @@
  * The following concept of the memory management is used:
  *
  * The kernel maintains two SGLs, the TX SGL and the RX SGL. The TX SGL is
- * filled by user space with the data submitted via sendmsg (maybe with
- * MSG_SPLICE_PAGES).  Filling up the TX SGL does not cause a crypto operation
- * -- the data will only be tracked by the kernel. Upon receipt of one recvmsg
- * call, the caller must provide a buffer which is tracked with the RX SGL.
+ * filled by user space with the data submitted via sendmsg.  Filling up the TX
+ * SGL does not cause a crypto operation -- the data will only be tracked by the
+ * kernel. Upon receipt of one recvmsg call, the caller must provide a buffer
+ * which is tracked with the RX SGL.
  *
  * During the processing of the recvmsg operation, the cipher request is
  * allocated and prepared. As part of the recvmsg operation, the processed


