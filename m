Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001AA7BAFB;
	Wed, 21 Feb 2024 13:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523724; cv=none; b=rQt9WDAcAIE/R28FVdf9AIJAuPzhC4M7mpC8CRL1yJAQFUuD6fvF+EP5eAeJsKW1cbZDOLImqk8+CGRvyg479JO4U/UMqACPHwOMWa8+BniJ2c159tLB+agFdAbY8IWwd5rlJDkHyzR7unstNgyCFDxyP9dpZdzuzf/xGHfdzN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523724; c=relaxed/simple;
	bh=HSFlTWYLrggUnjhdp3I1yDa+Vv1FzqVsZ/pzg5z7qrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RwD2FcMQxpXhZA9GlNNl5W6uxYnTEi/m3FRa4Km/W436zQn0U4OiLqOg1FHG0YDgfhmlUgmh0BYU/BRB31iTjYpAZQeHhd8Np/uPSOFoS5dkl1XfGYz6QloDi39g+E0vKHL4S9Q8Ae3Lo5MbbiGWDDFnK0ThH6jknfsgYiEBxF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=swOI2eeG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="swOI2eeG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCC6C433C7;
	Wed, 21 Feb 2024 13:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523723;
	bh=HSFlTWYLrggUnjhdp3I1yDa+Vv1FzqVsZ/pzg5z7qrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=swOI2eeGWbpImpOmPzQGFOxz6jTFo3e1BAuwxHs879H8WLv+4B98sys+xv2T7JkAW
	 T4wjeS97A9NrvclI19CY8ZCp/b8OaoMbVjvyAzPpIEGiOoYU96YBkNYT2+8oVP+PVm
	 I/u/ryrkdakTGSqMZkgUp6XWjD5hKx/S/WKr1Yxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Hocko <mhocko@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexander Ofitserov <oficerovas@altlinux.org>
Subject: [PATCH 5.10 040/379] mm: vmalloc: introduce array allocation functions
Date: Wed, 21 Feb 2024 14:03:39 +0100
Message-ID: <20240221125956.103618087@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit a8749a35c39903120ec421ef2525acc8e0daa55c upstream.

Linux has dozens of occurrences of vmalloc(array_size()) and
vzalloc(array_size()).  Allow to simplify the code by providing
vmalloc_array and vcalloc, as well as the underscored variants that let
the caller specify the GFP flags.

Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Alexander Ofitserov <oficerovas@altlinux.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/vmalloc.h |    5 ++++
 mm/util.c               |   50 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -112,6 +112,11 @@ extern void *__vmalloc_node_range(unsign
 void *__vmalloc_node(unsigned long size, unsigned long align, gfp_t gfp_mask,
 		int node, const void *caller);
 
+extern void *__vmalloc_array(size_t n, size_t size, gfp_t flags);
+extern void *vmalloc_array(size_t n, size_t size);
+extern void *__vcalloc(size_t n, size_t size, gfp_t flags);
+extern void *vcalloc(size_t n, size_t size);
+
 extern void vfree(const void *addr);
 extern void vfree_atomic(const void *addr);
 
--- a/mm/util.c
+++ b/mm/util.c
@@ -686,6 +686,56 @@ static inline void *__page_rmapping(stru
 	return (void *)mapping;
 }
 
+/**
+ * __vmalloc_array - allocate memory for a virtually contiguous array.
+ * @n: number of elements.
+ * @size: element size.
+ * @flags: the type of memory to allocate (see kmalloc).
+ */
+void *__vmalloc_array(size_t n, size_t size, gfp_t flags)
+{
+	size_t bytes;
+
+	if (unlikely(check_mul_overflow(n, size, &bytes)))
+		return NULL;
+	return __vmalloc(bytes, flags);
+}
+EXPORT_SYMBOL(__vmalloc_array);
+
+/**
+ * vmalloc_array - allocate memory for a virtually contiguous array.
+ * @n: number of elements.
+ * @size: element size.
+ */
+void *vmalloc_array(size_t n, size_t size)
+{
+	return __vmalloc_array(n, size, GFP_KERNEL);
+}
+EXPORT_SYMBOL(vmalloc_array);
+
+/**
+ * __vcalloc - allocate and zero memory for a virtually contiguous array.
+ * @n: number of elements.
+ * @size: element size.
+ * @flags: the type of memory to allocate (see kmalloc).
+ */
+void *__vcalloc(size_t n, size_t size, gfp_t flags)
+{
+	return __vmalloc_array(n, size, flags | __GFP_ZERO);
+}
+EXPORT_SYMBOL(__vcalloc);
+
+/**
+ * vcalloc - allocate and zero memory for a virtually contiguous array.
+ * @n: number of elements.
+ * @size: element size.
+ */
+void *vcalloc(size_t n, size_t size)
+{
+	return __vmalloc_array(n, size, GFP_KERNEL | __GFP_ZERO);
+}
+EXPORT_SYMBOL(vcalloc);
+
 /* Neutral page->mapping pointer to address_space or anon_vma or other */
 void *page_rmapping(struct page *page)
 {


