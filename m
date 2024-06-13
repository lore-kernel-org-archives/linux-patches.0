Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5870E143C52;
	Thu, 13 Jun 2024 12:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280550; cv=none; b=BUE+DouD390a4nVOP5ht2P8ZHgqzpiXrH7J06Sb+6/Cq0cW9f7OvQFzpmtCAbeOn2Sw/oQKjE55PM0o9hhGP2RwBPJ/UUS8iAb/zrpDsDMOP738+SbBRh3kaSwbL6au0CAY62qs0RlpTNv5Iw0rnlbn9wx2aeAGYdyibchm7d08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280550; c=relaxed/simple;
	bh=U+KHdUEzNSsQiiZQibj2R+2daRv6eykYE7JMVrqA6Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3sF786P/G7uS89RNVDmh4tFSdEYFcLAmlcj0OfT3dVchu/fq1N05JEQwvmrfuNlGwcK2ziYrEZRxQvFRKquH/Xs1g6Z9AVaxRUAz9h9hP4yWOJtjF6xGstLIoZcuNL5NfW8Tk9noL5OFsNld5JEJBqSgz9DWetsTzesRE1s3xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g2Qa0vDB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g2Qa0vDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F42C2BBFC;
	Thu, 13 Jun 2024 12:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280550;
	bh=U+KHdUEzNSsQiiZQibj2R+2daRv6eykYE7JMVrqA6Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g2Qa0vDBwR8YK6GB8RAYSGAfGxyyNcRifayN4R4z1P+i1pXUXrJhtknH6WmuaXIRU
	 +RxPO6rOfIPx4AarLdmbctEE1ueaaOxWvNybiKphs4OWqtVXQbsU6lgHsVYK2K+usm
	 XLHgYfgpvGDNL1bZj3zfNPCpoTMCJwT1p5/1IDuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.6 074/137] filemap: add helper mapping_max_folio_size()
Date: Thu, 13 Jun 2024 13:34:14 +0200
Message-ID: <20240613113226.167278409@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit 79c137454815ba5554caa8eeb4ad5c94e96e45ce upstream.

Add mapping_max_folio_size() to get the maximum folio size for this
pagecache mapping.

Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
Cc: stable@vger.kernel.org
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20240521114939.2541461-1-xu.yang_2@nxp.com
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/pagemap.h |   34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -327,6 +327,19 @@ static inline void mapping_set_gfp_mask(
 	m->gfp_mask = mask;
 }
 
+/*
+ * There are some parts of the kernel which assume that PMD entries
+ * are exactly HPAGE_PMD_ORDER.  Those should be fixed, but until then,
+ * limit the maximum allocation order to PMD size.  I'm not aware of any
+ * assumptions about maximum order if THP are disabled, but 8 seems like
+ * a good order (that's 1MB if you're using 4kB pages)
+ */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#define MAX_PAGECACHE_ORDER	HPAGE_PMD_ORDER
+#else
+#define MAX_PAGECACHE_ORDER	8
+#endif
+
 /**
  * mapping_set_large_folios() - Indicate the file supports large folios.
  * @mapping: The file.
@@ -353,6 +366,14 @@ static inline bool mapping_large_folio_s
 		test_bit(AS_LARGE_FOLIO_SUPPORT, &mapping->flags);
 }
 
+/* Return the maximum folio size for this pagecache mapping, in bytes. */
+static inline size_t mapping_max_folio_size(struct address_space *mapping)
+{
+	if (mapping_large_folio_support(mapping))
+		return PAGE_SIZE << MAX_PAGECACHE_ORDER;
+	return PAGE_SIZE;
+}
+
 static inline int filemap_nr_thps(struct address_space *mapping)
 {
 #ifdef CONFIG_READ_ONLY_THP_FOR_FS
@@ -511,19 +532,6 @@ static inline void *detach_page_private(
 	return folio_detach_private(page_folio(page));
 }
 
-/*
- * There are some parts of the kernel which assume that PMD entries
- * are exactly HPAGE_PMD_ORDER.  Those should be fixed, but until then,
- * limit the maximum allocation order to PMD size.  I'm not aware of any
- * assumptions about maximum order if THP are disabled, but 8 seems like
- * a good order (that's 1MB if you're using 4kB pages)
- */
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-#define MAX_PAGECACHE_ORDER	HPAGE_PMD_ORDER
-#else
-#define MAX_PAGECACHE_ORDER	8
-#endif
-
 #ifdef CONFIG_NUMA
 struct folio *filemap_alloc_folio(gfp_t gfp, unsigned int order);
 #else


