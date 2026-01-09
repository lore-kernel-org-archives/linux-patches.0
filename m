Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5A22FD699;
	Fri,  9 Jan 2026 12:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961088; cv=none; b=GTBx8y8Kl87younDqTsx+l0t9jdFosfw1BtJmkvKY2vPmbfSgtuFfZ+31ZevC7+772EBzSv29F10AXnluxin8bRY9KfEMNb6K2gD2+1ehjmezyYrbjiDgWKwT443vGy07q2c8qwct+05dWfg5+rvmptWggZ44KxihulCjqgDriI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961088; c=relaxed/simple;
	bh=h42mAY9zLMqmzLiS4SuLR+EiTgPaJ1W1OZyggG5hbkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=II/qg6BvV8WstdoBGXINATEwQjztr4QGoAXwluxapyFxSSJBaXgyUkoiVQ1VDVmlQzCeigumMK18K4ll18UULHUUUG7OIIsc4Xzm2DCBIfa/tfOzA8h8pMTYLCSP5WGW8/2rTXxOqbFmbVPTToU0BvHARE239MB+jxKAyVnmaQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cq5qYcwM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cq5qYcwM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B330C4CEF1;
	Fri,  9 Jan 2026 12:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961087;
	bh=h42mAY9zLMqmzLiS4SuLR+EiTgPaJ1W1OZyggG5hbkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cq5qYcwMGZVLSymlbbMhCBlQsIftKmIsKBeiWauFsXl6suVHTISyYracYcMiRn2Tc
	 /6QwmT3GB89eprA/YKxwyiZH/qAz1IA0k81tdyGcbmVOMEkk9YeQdQ9lGPLP5qgDbk
	 kc5VYCrTccrkwN/jix2HsYnnHMLG5R7MWOY2yBsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Sokolowski <jan.sokolowski@intel.com>,
	Koen Koning <koen.koning@intel.com>,
	Peter Senna Tschudin <peter.senna@linux.intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 603/737] idr: fix idr_alloc() returning an ID out of range
Date: Fri,  9 Jan 2026 12:42:22 +0100
Message-ID: <20260109112156.691158163@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit c6e8e595a0798ad67da0f7bebaf69c31ef70dfff upstream.

If you use an IDR with a non-zero base, and specify a range that lies
entirely below the base, 'max - base' becomes very large and
idr_get_free() can return an ID that lies outside of the requested range.

Link: https://lkml.kernel.org/r/20251128161853.3200058-1-willy@infradead.org
Fixes: 6ce711f27500 ("idr: Make 1-based IDRs more efficient")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Jan Sokolowski <jan.sokolowski@intel.com>
Reported-by: Koen Koning <koen.koning@intel.com>
Reported-by: Peter Senna Tschudin <peter.senna@linux.intel.com>
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/6449
Reviewed-by: Christian König <christian.koenig@amd.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/idr.c                           |    2 ++
 tools/testing/radix-tree/idr-test.c |   21 +++++++++++++++++++++
 2 files changed, 23 insertions(+)

--- a/lib/idr.c
+++ b/lib/idr.c
@@ -40,6 +40,8 @@ int idr_alloc_u32(struct idr *idr, void
 
 	if (WARN_ON_ONCE(!(idr->idr_rt.xa_flags & ROOT_IS_IDR)))
 		idr->idr_rt.xa_flags |= IDR_RT_MARKER;
+	if (max < base)
+		return -ENOSPC;
 
 	id = (id < base) ? 0 : id - base;
 	radix_tree_iter_init(&iter, id);
--- a/tools/testing/radix-tree/idr-test.c
+++ b/tools/testing/radix-tree/idr-test.c
@@ -57,6 +57,26 @@ void idr_alloc_test(void)
 	idr_destroy(&idr);
 }
 
+void idr_alloc2_test(void)
+{
+	int id;
+	struct idr idr = IDR_INIT_BASE(idr, 1);
+
+	id = idr_alloc(&idr, idr_alloc2_test, 0, 1, GFP_KERNEL);
+	assert(id == -ENOSPC);
+
+	id = idr_alloc(&idr, idr_alloc2_test, 1, 2, GFP_KERNEL);
+	assert(id == 1);
+
+	id = idr_alloc(&idr, idr_alloc2_test, 0, 1, GFP_KERNEL);
+	assert(id == -ENOSPC);
+
+	id = idr_alloc(&idr, idr_alloc2_test, 0, 2, GFP_KERNEL);
+	assert(id == -ENOSPC);
+
+	idr_destroy(&idr);
+}
+
 void idr_replace_test(void)
 {
 	DEFINE_IDR(idr);
@@ -409,6 +429,7 @@ void idr_checks(void)
 
 	idr_replace_test();
 	idr_alloc_test();
+	idr_alloc2_test();
 	idr_null_test();
 	idr_nowait_test();
 	idr_get_next_test(0);


