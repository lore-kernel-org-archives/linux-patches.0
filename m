Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241A01D88DB;
	Wed, 19 Feb 2025 09:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957095; cv=none; b=MaT96t8iPHfS/E72yo85ICVJkxCq6RkDR54zmIQdeqFpH/ahn/8dsEbl6FXBuBGbAoSEnoSosNJHwscFt9jePv5ABqyQcoPW6/xMSw8wvbe1P5NOtCYrOdsHVO4DbL127SgZmt/X94LFLdNTDJKoCYTH42fEyAxD6O0HrrIOywE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957095; c=relaxed/simple;
	bh=wPANVUdaDutwTRysbWo/ZDfcjcjqwKvQXB5O8Qq1mpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GhEdSS1eoye3rilzjvZoj2b7mkoXJSMoaLNWib6S+zDS1y9e+tRXQ4tx6jkbYlvf9UvMt86p101xpKl/pD5WU5/f1lKsFGB1PCFmjbIScuayuIRP/BE8aRgkTBwows76V5Zc+isnPbONlWFgxsIvAGe2qR0giAXoEHrSL68Z0DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XcbgddFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XcbgddFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB5BC4CED1;
	Wed, 19 Feb 2025 09:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957095;
	bh=wPANVUdaDutwTRysbWo/ZDfcjcjqwKvQXB5O8Qq1mpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XcbgddFejH5mc3hWdu1CLaibD5926053ULt0hBSBhSYaqMJnQ+W2YUBczAu0ido04
	 wm2cXZHBSabOjLH8sqvGIzzhAVlqKsg7Zzt1towP0dcQVnqwnEzSnppcvYLlXgX97m
	 PMVTpvOzr9+L4DCz3wnNd7QVos62odWiVevwhpec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Christoph Lameter <cl@linux.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitriy Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 406/578] kfence: skip __GFP_THISNODE allocations on NUMA systems
Date: Wed, 19 Feb 2025 09:26:50 +0100
Message-ID: <20250219082708.995340925@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Elver <elver@google.com>

commit e64f81946adf68cd75e2207dd9a51668348a4af8 upstream.

On NUMA systems, __GFP_THISNODE indicates that an allocation _must_ be on
a particular node, and failure to allocate on the desired node will result
in a failed allocation.

Skip __GFP_THISNODE allocations if we are running on a NUMA system, since
KFENCE can't guarantee which node its pool pages are allocated on.

Link: https://lkml.kernel.org/r/20250124120145.410066-1-elver@google.com
Fixes: 236e9f153852 ("kfence: skip all GFP_ZONEMASK allocations")
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Chistoph Lameter <cl@linux.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kfence/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -21,6 +21,7 @@
 #include <linux/log2.h>
 #include <linux/memblock.h>
 #include <linux/moduleparam.h>
+#include <linux/nodemask.h>
 #include <linux/notifier.h>
 #include <linux/panic_notifier.h>
 #include <linux/random.h>
@@ -997,6 +998,7 @@ void *__kfence_alloc(struct kmem_cache *
 	 * properties (e.g. reside in DMAable memory).
 	 */
 	if ((flags & GFP_ZONEMASK) ||
+	    ((flags & __GFP_THISNODE) && num_online_nodes() > 1) ||
 	    (s->flags & (SLAB_CACHE_DMA | SLAB_CACHE_DMA32))) {
 		atomic_long_inc(&counters[KFENCE_COUNTER_SKIP_INCOMPAT]);
 		return NULL;


