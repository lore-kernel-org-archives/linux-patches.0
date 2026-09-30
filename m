Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820363644C1;
	Wed, 30 Sep 2026 17:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790228; cv=none; b=ZkZEz8anEqHuVZGis2cmEq9kHi4hFayXu8XlPFxI1N1dOwBJH/nhT6O4JVzcHN/XP1RGI3NNLuamEDgpZzswwROhhyGHuRr10bwco1eSoO1GyjIKbV2LbqyidMI+DA/h5W6CQRi7x7Rcxhu762uRgjsLXv8E96ovXmhbUop5QMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790228; c=relaxed/simple;
	bh=UtaOYMmryecEO+6aa/jTStrOk7Nbnt8o+a+/qcIcf6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C90+W8d1B131KsLGjnTiCPa5PdYOadnW5jLRhy4humbLP3cjePTlquPYBO9erzQNDBSmPG944tGsIViGJ2LVtutyNh0Riwki4pRpVC3NM5pp0v+21tJHJcd0WSFHI+W5b40T3qI4Q0GjIpuV5718WZy7sapYi9O1DwyMYZ1lFu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VcAd7p8r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VcAd7p8r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC36C1F000FF;
	Wed, 30 Sep 2026 17:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790227;
	bh=9/nDBqN8wb35DtkrO8yO3/kb7T/YedtHTwYcOLfrEXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VcAd7p8rrnpbsHO+JWuvUldcL4kUJaxeF2XrxMFyD5KWuVj1jscez/nWkWI/sQpVr
	 8OTC1AZvqNxwj7CdUPIB6BcbFSloLh87PJOnQYOMUeUCDOBXu9S1gIFp0yauJUyLq2
	 tQgdMM1EHn5dLE++yPp2cSSJktukjVK3xIOO06gQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 755/877] netmem: add a couple of page helper wrappers
Date: Wed, 30 Sep 2026 17:27:46 +0200
Message-ID: <20260930152430.990892427@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Lobakin <aleksander.lobakin@intel.com>

[ Upstream commit 9bd9f72a74344b54cfb6fcabf1173e6c6e5c6952 ]

Add the following netmem counterparts:

* virt_to_netmem() -- simple page_to_netmem(virt_to_page()) wrapper;
* netmem_is_pfmemalloc() -- page_is_pfmemalloc() for page-backed
			    netmems, false otherwise;

and the following "unsafe" versions:

* __netmem_to_page()
* __netmem_get_pp()
* __netmem_address()

They do the same as their non-underscored buddies, but assume the netmem
is always page-backed. When working with header &page_pools, you don't
need to check whether netmem belongs to the host memory and you can
never get NULL instead of &page. Checks for the LSB, clearing the LSB,
branches take cycles and increase object code size, sometimes
significantly. When you're sure your PP is always host, you can avoid
this by using the underscored counterparts.

Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://patch.msgid.link/20241203173733.3181246-8-aleksander.lobakin@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: b814dfbfeb0a ("bnxt_en: Propagate TPA buffer allocation failures in bnxt_queue_mem_alloc()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netmem.h |   78 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 76 insertions(+), 2 deletions(-)

--- a/include/net/netmem.h
+++ b/include/net/netmem.h
@@ -72,6 +72,22 @@ static inline bool netmem_is_net_iov(con
 	return (__force unsigned long)netmem & NET_IOV;
 }
 
+/**
+ * __netmem_to_page - unsafely get pointer to the &page backing @netmem
+ * @netmem: netmem reference to convert
+ *
+ * Unsafe version of netmem_to_page(). When @netmem is always page-backed,
+ * e.g. when it's a header buffer, performs faster and generates smaller
+ * object code (no check for the LSB, no WARN). When @netmem points to IOV,
+ * provokes undefined behaviour.
+ *
+ * Return: pointer to the &page (garbage if @netmem is not page-backed).
+ */
+static inline struct page *__netmem_to_page(netmem_ref netmem)
+{
+	return (__force struct page *)netmem;
+}
+
 /* This conversion fails (returns NULL) if the netmem_ref is not struct page
  * backed.
  */
@@ -80,7 +96,7 @@ static inline struct page *netmem_to_pag
 	if (WARN_ON_ONCE(netmem_is_net_iov(netmem)))
 		return NULL;
 
-	return (__force struct page *)netmem;
+	return __netmem_to_page(netmem);
 }
 
 static inline struct net_iov *netmem_to_net_iov(netmem_ref netmem)
@@ -103,6 +119,17 @@ static inline netmem_ref page_to_netmem(
 	return (__force netmem_ref)page;
 }
 
+/**
+ * virt_to_netmem - convert virtual memory pointer to a netmem reference
+ * @data: host memory pointer to convert
+ *
+ * Return: netmem reference to the &page backing this virtual address.
+ */
+static inline netmem_ref virt_to_netmem(const void *data)
+{
+	return page_to_netmem(virt_to_page(data));
+}
+
 static inline int netmem_ref_count(netmem_ref netmem)
 {
 	/* The non-pp refcount of net_iov is always 1. On net_iov, we only
@@ -127,6 +154,22 @@ static inline struct net_iov *__netmem_c
 	return (struct net_iov *)((__force unsigned long)netmem & ~NET_IOV);
 }
 
+/**
+ * __netmem_get_pp - unsafely get pointer to the &page_pool backing @netmem
+ * @netmem: netmem reference to get the pointer from
+ *
+ * Unsafe version of netmem_get_pp(). When @netmem is always page-backed,
+ * e.g. when it's a header buffer, performs faster and generates smaller
+ * object code (avoids clearing the LSB). When @netmem points to IOV,
+ * provokes invalid memory access.
+ *
+ * Return: pointer to the &page_pool (garbage if @netmem is not page-backed).
+ */
+static inline struct page_pool *__netmem_get_pp(netmem_ref netmem)
+{
+	return __netmem_to_page(netmem)->pp;
+}
+
 static inline struct page_pool *netmem_get_pp(netmem_ref netmem)
 {
 	return __netmem_clear_lsb(netmem)->pp;
@@ -158,12 +201,43 @@ static inline netmem_ref netmem_compound
 	return page_to_netmem(compound_head(netmem_to_page(netmem)));
 }
 
+/**
+ * __netmem_address - unsafely get pointer to the memory backing @netmem
+ * @netmem: netmem reference to get the pointer for
+ *
+ * Unsafe version of netmem_address(). When @netmem is always page-backed,
+ * e.g. when it's a header buffer, performs faster and generates smaller
+ * object code (no check for the LSB). When @netmem points to IOV, provokes
+ * undefined behaviour.
+ *
+ * Return: pointer to the memory (garbage if @netmem is not page-backed).
+ */
+static inline void *__netmem_address(netmem_ref netmem)
+{
+	return page_address(__netmem_to_page(netmem));
+}
+
 static inline void *netmem_address(netmem_ref netmem)
 {
 	if (netmem_is_net_iov(netmem))
 		return NULL;
 
-	return page_address(netmem_to_page(netmem));
+	return __netmem_address(netmem);
+}
+
+/**
+ * netmem_is_pfmemalloc - check if @netmem was allocated under memory pressure
+ * @netmem: netmem reference to check
+ *
+ * Return: true if @netmem is page-backed and the page was allocated under
+ * memory pressure, false otherwise.
+ */
+static inline bool netmem_is_pfmemalloc(netmem_ref netmem)
+{
+	if (netmem_is_net_iov(netmem))
+		return false;
+
+	return page_is_pfmemalloc(netmem_to_page(netmem));
 }
 
 static inline unsigned long netmem_get_dma_addr(netmem_ref netmem)


