Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D8C27FD42;
	Wed, 23 Apr 2025 15:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420646; cv=none; b=RmHAXDIY2rlsGpasNK7Pyed++PVs4PCcXVKtSrmTeYrQ7N7iGs2/ldamozYyB2veGdzJ0sLuH2xNGYsihceHly9k/m0e8yd2KcEefLujtuKp+LTMkbAH0Wr0peQqCtX37URsP+gFBls70S1j8n5EM44Oz2f/5LWj9NsU6BPMopk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420646; c=relaxed/simple;
	bh=HPn6nQYW4Lc77o/HQlizEoKClyGAdvusAZZNXmYG7Yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQR8h0vxs3xhr3zn7r6CapOzdB6prsOMhQ/CCfK1HRgXzkqoi33jt1zABcCP07sL9BUIJm2CfZSoLa3yl63GRGUpC1OPS+wNgMLULavAwVloBg3sJ5BS6tcn6hA7+GfD61SjYSichFXv/KQPhSMHYzpYKazPDNg8KOF+NTFa8o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ksJAKqxW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ksJAKqxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F71C4CEE2;
	Wed, 23 Apr 2025 15:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420645;
	bh=HPn6nQYW4Lc77o/HQlizEoKClyGAdvusAZZNXmYG7Yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ksJAKqxWB4gH998ezEyICKJ1GAlbDorD3X7S/oZSWlFYqKrOCvAXLvLEMAi5unf8n
	 QS4yP4UF9rPTx2tXGb6HMd9hYKfeVoOzPLJpcfFeAcvAfk/B1HPO77ENBjSyC/UTEx
	 e1LzaW0kdnxIHjRSfNnni+IhMC/43IeeUA3s8y+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"T.J. Mercier" <tjmercier@google.com>,
	Janghyuck Kim <janghyuck.kim@samsung.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.14 110/241] alloc_tag: handle incomplete bulk allocations in vm_module_tags_populate
Date: Wed, 23 Apr 2025 16:42:54 +0200
Message-ID: <20250423142625.074999173@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: T.J. Mercier <tjmercier@google.com>

commit e6e07b696da529e85d1ba880555b5df5c80a46bd upstream.

alloc_pages_bulk_node() may partially succeed and allocate fewer than the
requested nr_pages.  There are several conditions under which this can
occur, but we have encountered the case where CONFIG_PAGE_OWNER is enabled
causing all bulk allocations to always fallback to single page allocations
due to commit 187ad460b841 ("mm/page_alloc: avoid page allocator recursion
with pagesets.lock held").

Currently vm_module_tags_populate() immediately fails when
alloc_pages_bulk_node() returns fewer than the requested number of pages.
When this happens memory allocation profiling gets disabled, for example

[   14.297583] [9:       modprobe:  465] Failed to allocate memory for allocation tags in the module scsc_wlan. Memory allocation profiling is disabled!
[   14.299339] [9:       modprobe:  465] modprobe: Failed to insmod '/vendor/lib/modules/scsc_wlan.ko' with args '': Out of memory

This patch causes vm_module_tags_populate() to retry bulk allocations for
the remaining memory instead of failing immediately which will avoid the
disablement of memory allocation profiling.

Link: https://lkml.kernel.org/r/20250409225111.3770347-1-tjmercier@google.com
Fixes: 0f9b685626da ("alloc_tag: populate memory for module tags as needed")
Signed-off-by: T.J. Mercier <tjmercier@google.com>
Reported-by: Janghyuck Kim <janghyuck.kim@samsung.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/alloc_tag.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -422,11 +422,20 @@ static int vm_module_tags_populate(void)
 		unsigned long old_shadow_end = ALIGN(phys_end, MODULE_ALIGN);
 		unsigned long new_shadow_end = ALIGN(new_end, MODULE_ALIGN);
 		unsigned long more_pages;
-		unsigned long nr;
+		unsigned long nr = 0;
 
 		more_pages = ALIGN(new_end - phys_end, PAGE_SIZE) >> PAGE_SHIFT;
-		nr = alloc_pages_bulk_node(GFP_KERNEL | __GFP_NOWARN,
-					   NUMA_NO_NODE, more_pages, next_page);
+		while (nr < more_pages) {
+			unsigned long allocated;
+
+			allocated = alloc_pages_bulk_node(GFP_KERNEL | __GFP_NOWARN,
+				NUMA_NO_NODE, more_pages - nr, next_page + nr);
+
+			if (!allocated)
+				break;
+			nr += allocated;
+		}
+
 		if (nr < more_pages ||
 		    vmap_pages_range(phys_end, phys_end + (nr << PAGE_SHIFT), PAGE_KERNEL,
 				     next_page, PAGE_SHIFT) < 0) {


