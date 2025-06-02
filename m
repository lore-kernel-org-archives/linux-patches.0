Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D853214A93;
	Mon,  2 Jun 2025 14:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875929; cv=none; b=dg9H7q5tj6cSejIMRUlwGJP/9OhnmWRT1qvaCZFshzuT1Rikmu+CkVoQngXWjQS6jxAn3nvJfev8ZR5KzVD7Nh+9JSVOoa84snq0Ebn1tzPy2bKgdFhsYlW0s9QgaHmj3mi2tiXI+oI2HZABgmappMdfMD7liVOs7aHfNs1mMzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875929; c=relaxed/simple;
	bh=PzRG9qXSN2yksuqIOV5se9GNIf+hZ4HE8ahsG18beCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrgPio+NcX31SxJfnV4AgsYyVmz5Cxk9Egdo7qEiu0JplhEKqlETOSzf83xQ2g+nnksTpWeIf04s6fCd2zORkzvStfcO9oa8QLLQQY5ZUUEiL8kN8KmrfrlMK59PMT8L/V5xR31oDgitG+rbUOC1iqghSGCzjTgLgkTDOt4jwOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D7mRAteE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D7mRAteE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F9BC4CEEB;
	Mon,  2 Jun 2025 14:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875929;
	bh=PzRG9qXSN2yksuqIOV5se9GNIf+hZ4HE8ahsG18beCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D7mRAteE0mrmD6YaZ+jXcVOH+X6pE6iYjJ6HNKBJ8HQqByqOEnbqdFFFYxzehkbMv
	 tbgoFREFADTOJbmsls/2LSm9yTzwgS4bpUiyjnRYE+7YIS0Oe+nKzI6BhUuipmzbbI
	 FKfvpA4+wpV/iR2GAVPWS+pLOgx07IUZwE6G4wZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/207] dma-mapping: avoid potential unused data compilation warning
Date: Mon,  2 Jun 2025 15:46:15 +0200
Message-ID: <20250602134258.904958514@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit c9b19ea63036fc537a69265acea1b18dabd1cbd3 ]

When CONFIG_NEED_DMA_MAP_STATE is not defined, dma-mapping clients might
report unused data compilation warnings for dma_unmap_*() calls
arguments. Redefine macros for those calls to let compiler to notice that
it is okay when the provided arguments are not used.

Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20250415075659.428549-1-m.szyprowski@samsung.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/dma-mapping.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index fe3849434b2a2..d7b91f82b0dce 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -595,10 +595,14 @@ static inline int dma_mmap_wc(struct device *dev,
 #else
 #define DEFINE_DMA_UNMAP_ADDR(ADDR_NAME)
 #define DEFINE_DMA_UNMAP_LEN(LEN_NAME)
-#define dma_unmap_addr(PTR, ADDR_NAME)           (0)
-#define dma_unmap_addr_set(PTR, ADDR_NAME, VAL)  do { } while (0)
-#define dma_unmap_len(PTR, LEN_NAME)             (0)
-#define dma_unmap_len_set(PTR, LEN_NAME, VAL)    do { } while (0)
+#define dma_unmap_addr(PTR, ADDR_NAME)           \
+	({ typeof(PTR) __p __maybe_unused = PTR; 0; })
+#define dma_unmap_addr_set(PTR, ADDR_NAME, VAL)  \
+	do { typeof(PTR) __p __maybe_unused = PTR; } while (0)
+#define dma_unmap_len(PTR, LEN_NAME)             \
+	({ typeof(PTR) __p __maybe_unused = PTR; 0; })
+#define dma_unmap_len_set(PTR, LEN_NAME, VAL)    \
+	do { typeof(PTR) __p __maybe_unused = PTR; } while (0)
 #endif
 
 #endif /* _LINUX_DMA_MAPPING_H */
-- 
2.39.5



