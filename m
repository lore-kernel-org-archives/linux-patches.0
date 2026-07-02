Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F075526F46F;
	Thu,  2 Jul 2026 16:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011558; cv=none; b=PXib5mqH9LAYmcm68lmEMYiV2jJuP4Tyj70VkW19BacTsy1bTU7snDEPg/pCkmIJtg92AwHEjzEsoifuRlGen1sAFLJt1/sfcTxNxLJFUSCuNhmkKU/1UlYdmhUSXrBLhBsIH2RJt52kyAy+ef8LNx5PcceiBH63B5j/5OqrpGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011558; c=relaxed/simple;
	bh=WtSLI9Lx9E1QXstZ7nfy6gjsDd/GUt+1s5SoLJpkgsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r6X8oPWYiUdu1fTyRnU012wzR9A+3wQXPQ69hDmdy0R19b+RXxLqiuLKnNVRZYbrYsROcJhao2RuknO5mlHniiVrrgPzwnECHyLlcP7QZ/bi7vPXibaFOfPjPEuoSh5L9XponXVnl6db+R7ubbI8rVejXxRy9Q4Os0pmZI1gCeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gShFPmUY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gShFPmUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6962C1F00A3A;
	Thu,  2 Jul 2026 16:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011556;
	bh=Qn1BQayygGiiwxpK5tu4/3YayJ0zXtds+B6f/iGDgEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gShFPmUYOnHacC9gw4wt8l5NDh4KtDtD5u/yDb4M68HDW57ZFZ3FWTtuovChZJr4L
	 sbvQW95Mq9Iv6bVJzn9CJo+gBiR6EqdlAiAO6SfqM349/QuawBhR9Fj9Uq3tXj+kdb
	 6HsIOPeoQR26z0Xrf+ned7Meq49SZksmnlFFd9Tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andriy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Ansuel Smith <ansuelsmth@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 043/120] err.h: use __always_inline on all error pointer helpers
Date: Thu,  2 Jul 2026 18:20:39 +0200
Message-ID: <20260702155113.852401466@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 94bfc7f3b0c7c33331ba4ff6cc64ff309dfcbce8 upstream.

While testing randconfig builds on s390, I came across a link failure with
CONFIG_DMA_SHARED_BUFFER disabled:

ERROR: modpost: "dma_buf_put" [drivers/iommu/iommufd/iommufd.ko] undefined!

The problem here is that IS_ERR() is not inlined and dead code elimination
fails as a consequence.

The err.h helpers all turn into a trivial assignment of a bit mask and
should never result in a function call, so force them to always be inline.
This should generally result in better object code aside from avoiding
the link failure above.

Link: https://lore.kernel.org/20260526101851.2495110-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Tamir Duberstein <tamird@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ansuel Smith <ansuelsmth@gmail.com>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/err.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/err.h
+++ b/include/linux/err.h
@@ -36,7 +36,7 @@
  *
  * Return: A pointer with @error encoded within its value.
  */
-static inline void * __must_check ERR_PTR(long error)
+static __always_inline void * __must_check ERR_PTR(long error)
 {
 	return (void *) error;
 }
@@ -60,7 +60,7 @@ static inline void * __must_check ERR_PT
  * @ptr: An error pointer.
  * Return: The error code within @ptr.
  */
-static inline long __must_check PTR_ERR(__force const void *ptr)
+static __always_inline long __must_check PTR_ERR(__force const void *ptr)
 {
 	return (long) ptr;
 }
@@ -73,7 +73,7 @@ static inline long __must_check PTR_ERR(
  * @ptr: The pointer to check.
  * Return: true if @ptr is an error pointer, false otherwise.
  */
-static inline bool __must_check IS_ERR(__force const void *ptr)
+static __always_inline bool __must_check IS_ERR(__force const void *ptr)
 {
 	return IS_ERR_VALUE((unsigned long)ptr);
 }
@@ -87,7 +87,7 @@ static inline bool __must_check IS_ERR(_
  *
  * Like IS_ERR(), but also returns true for a null pointer.
  */
-static inline bool __must_check IS_ERR_OR_NULL(__force const void *ptr)
+static __always_inline bool __must_check IS_ERR_OR_NULL(__force const void *ptr)
 {
 	return unlikely(!ptr) || IS_ERR_VALUE((unsigned long)ptr);
 }
@@ -99,7 +99,7 @@ static inline bool __must_check IS_ERR_O
  * Explicitly cast an error-valued pointer to another pointer type in such a
  * way as to make it clear that's what's going on.
  */
-static inline void * __must_check ERR_CAST(__force const void *ptr)
+static __always_inline void * __must_check ERR_CAST(__force const void *ptr)
 {
 	/* cast away the const */
 	return (void *) ptr;
@@ -122,7 +122,7 @@ static inline void * __must_check ERR_CA
  *
  * Return: The error code within @ptr if it is an error pointer; 0 otherwise.
  */
-static inline int __must_check PTR_ERR_OR_ZERO(__force const void *ptr)
+static __always_inline int __must_check PTR_ERR_OR_ZERO(__force const void *ptr)
 {
 	if (IS_ERR(ptr))
 		return PTR_ERR(ptr);


