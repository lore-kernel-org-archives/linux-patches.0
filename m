Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C551428FC;
	Thu, 13 Jun 2024 11:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279440; cv=none; b=NFjFdtdfFY+vYxwPdZ0UWTc5wbYrwBD/HQGJ19umlRJ9U94G/MI5Gew21ZK90aicNiyNKpimC14uy17zTJP1VzO9Gs9ktuZCevapV5gkGxd8uH8SdTH2gKA7k25CZII3ajJcvW3v94Vhxt2gXgOfuCvFHX4VdkE5EpI1z3nePQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279440; c=relaxed/simple;
	bh=V9fl3khetk4kRC5Jw1ZN+ArSNqv1spUAmoJ1g13tvQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkIcK1vj5JkQIc8n6QLwz7s4NyM8twQF8WNBzeeHY5EBs5sQ/3Kda/dB5O/8sb/l9PV2wk2Jq2zTxX7bHR88DHEjanxQc5rEe5LbrX4MjznZogZYcb53JDhulHXCLSOAyebbCM6MQkBb3tLOo/jyoloIXd34nhkQQcpCW+GKW4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EtucGcn0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EtucGcn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DCDC2BBFC;
	Thu, 13 Jun 2024 11:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279440;
	bh=V9fl3khetk4kRC5Jw1ZN+ArSNqv1spUAmoJ1g13tvQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EtucGcn0a2OJZWgQ1H4PGiOm5MD0YrBE5aQhoCb9fwXdNf9ne9THW7oEBPcYa5RTY
	 IiyjmjiFocTOCtQYCNeTpDACF/AkwjcI9I0kqB+HFGQW63WvkIiBmp006FsXZsifdy
	 CRDzgarRsQkl9hUD6FT4Hf/vEQfkcWMYF69GNwEk=
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
Subject: [PATCH 6.9 076/157] filemap: add helper mapping_max_folio_size()
Date: Thu, 13 Jun 2024 13:33:21 +0200
Message-ID: <20240613113230.363189584@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -344,6 +344,19 @@ static inline void mapping_set_gfp_mask(
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
@@ -370,6 +383,14 @@ static inline bool mapping_large_folio_s
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
@@ -528,19 +549,6 @@ static inline void *detach_page_private(
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


