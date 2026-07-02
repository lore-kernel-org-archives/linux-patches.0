Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDBA317146;
	Thu,  2 Jul 2026 16:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010533; cv=none; b=j+chrh/9eER76ytX1/euAiG+tWhC/FhdHMUfkTcpXu9feFoeXcf0xTn1ZUVy91y1ToU855I28VivJ8rdZFwaL/c/jaGpw35eOPDqJqnkdx3xR5nzcWTmewPjsQWHA9WeI8BoN78Qv7Z/dJX+rlcZPu9VyIMLyVuEF9swGDLG7Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010533; c=relaxed/simple;
	bh=n8UEPaffKFycbEP54eg89Mfex9yLDEfKt7Ny5kibDpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ismLAU13z0cqtn2NldA/Xph6Jpb7cXLJZX/+YJ51ewpY77TaIHwCZeffu4xq45QN55uGAcTzPvRcTIt3m38KHJdmS0yZ68ZSwM8YtFGPsNHRqzI1MEyW9zJb1zt7GjtUPyxgEjDvMjh29Yiy23rUzcB30VrnFh1rBtlAZozbxCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I5RLzaHc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I5RLzaHc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84981F000E9;
	Thu,  2 Jul 2026 16:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010532;
	bh=w9ax0GAcSxR/97JQX6x+MCRLz+Zdofhs3eTBCTB3g3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I5RLzaHc4ZzZqsp4mwBQc8VGvT//mGzd7VYSV2k9b5UO4viJOro/MtJv/gBWqLFrb
	 g/E+2mQag8OsVHGMknDhna2P8OutqW6JoN//Bg3gdtdh6g7ryWQTxhcJZwqYJ0oOLj
	 /ZwcmfeMozsU40u4I7up6oX4XnZqzKnPYzS5bS24=
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
Subject: [PATCH 6.12 144/204] err.h: use __always_inline on all error pointer helpers
Date: Thu,  2 Jul 2026 18:20:01 +0200
Message-ID: <20260702155121.676088851@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -52,7 +52,7 @@ static inline void * __must_check ERR_PT
  * @ptr: An error pointer.
  * Return: The error code within @ptr.
  */
-static inline long __must_check PTR_ERR(__force const void *ptr)
+static __always_inline long __must_check PTR_ERR(__force const void *ptr)
 {
 	return (long) ptr;
 }
@@ -65,7 +65,7 @@ static inline long __must_check PTR_ERR(
  * @ptr: The pointer to check.
  * Return: true if @ptr is an error pointer, false otherwise.
  */
-static inline bool __must_check IS_ERR(__force const void *ptr)
+static __always_inline bool __must_check IS_ERR(__force const void *ptr)
 {
 	return IS_ERR_VALUE((unsigned long)ptr);
 }
@@ -79,7 +79,7 @@ static inline bool __must_check IS_ERR(_
  *
  * Like IS_ERR(), but also returns true for a null pointer.
  */
-static inline bool __must_check IS_ERR_OR_NULL(__force const void *ptr)
+static __always_inline bool __must_check IS_ERR_OR_NULL(__force const void *ptr)
 {
 	return unlikely(!ptr) || IS_ERR_VALUE((unsigned long)ptr);
 }
@@ -91,7 +91,7 @@ static inline bool __must_check IS_ERR_O
  * Explicitly cast an error-valued pointer to another pointer type in such a
  * way as to make it clear that's what's going on.
  */
-static inline void * __must_check ERR_CAST(__force const void *ptr)
+static __always_inline void * __must_check ERR_CAST(__force const void *ptr)
 {
 	/* cast away the const */
 	return (void *) ptr;
@@ -114,7 +114,7 @@ static inline void * __must_check ERR_CA
  *
  * Return: The error code within @ptr if it is an error pointer; 0 otherwise.
  */
-static inline int __must_check PTR_ERR_OR_ZERO(__force const void *ptr)
+static __always_inline int __must_check PTR_ERR_OR_ZERO(__force const void *ptr)
 {
 	if (IS_ERR(ptr))
 		return PTR_ERR(ptr);


