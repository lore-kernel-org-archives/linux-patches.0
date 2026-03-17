Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142832DE70D;
	Tue, 17 Mar 2026 16:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766449; cv=none; b=foZW/UMuyax5KIZuhayI+xXSncZ14FPTvnBXl4OpUg45ZSSyQTDQ+qRKGcWw1JwJqk3I8qPGg2Ylo7anH76VaPQbtNIZqiXvUfShkvxBLBFez65oTqUWYKhhTA9P7EzUqj7jl4/rcVhobFl3kNnu4ZDZTFEw2ijE8XP3yMYkRZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766449; c=relaxed/simple;
	bh=7GllyNPEf3NJTRZGQPMJjYIj/jZMSpv4bwjXgtAo4/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OF+xotbMVUeHw4Mph/PgjyibWJzbQ12lQxC2t04dgeGPmLcT++yf1EqxF7pvfKO4j9Ppv2BIKxliM/ZXu0LbrQfCIgOOwWub359NdJo4wo7GY3OjSXldu/uaLsAicYFKdBS3uBgM0smxfoU5RxgQZOto84Ektab3YC7D0K93RxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DDb+aW9m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DDb+aW9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F9BC4CEF7;
	Tue, 17 Mar 2026 16:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766449;
	bh=7GllyNPEf3NJTRZGQPMJjYIj/jZMSpv4bwjXgtAo4/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DDb+aW9m8CnD/2vCF4dXlDSWnwltBV8f5VTxBDSLrbp/ZfVIhOEEtRO9EeagXLUTs
	 q9ft4S0wBhEqKnY7qtY82KhC3RyiJ9E7vr/mw1rxgfNEJPxNDdwcCUL4LuiMYuJbxK
	 nAVeMuWLiltJbrClxJkWdXtXaS7zBdnHz3C2sC+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Pratyush Yadav (Google)" <pratyush@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.19 249/378] mm: memfd_luo: always dirty all folios
Date: Tue, 17 Mar 2026 17:33:26 +0100
Message-ID: <20260317163016.181330127@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pratyush Yadav (Google) <pratyush@kernel.org>

commit 7e04bf1f33151a30e06a65b74b5f2c19fc2be128 upstream.

A dirty folio is one which has been written to.  A clean folio is its
opposite.  Since a clean folio has no user data, it can be freed under
memory pressure.

memfd preservation with LUO saves the flag at preserve().  This is
problematic.  The folio might get dirtied later.  Saving it at freeze()
also doesn't work, since the dirty bit from PTE is normally synced at
unmap and there might still be mappings of the file at freeze().

To see why this is a problem, say a folio is clean at preserve, but gets
dirtied later.  The serialized state of the folio will mark it as clean.
After retrieve, the next kernel will see the folio as clean and might try
to reclaim it under memory pressure.  This will result in losing user
data.

Mark all folios of the file as dirty, and always set the
MEMFD_LUO_FOLIO_DIRTY flag.  This comes with the side effect of making all
clean folios un-reclaimable.  This is a cost that has to be paid for
participants of live update.  It is not expected to be a common use case
to preserve a lot of clean folios anyway.

Since the value of pfolio->flags is a constant now, drop the flags
variable and set it directly.

Link: https://lkml.kernel.org/r/20260223173931.2221759-3-pratyush@kernel.org
Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memfd_luo.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 1c9510289312..b8edb9f981d7 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -146,7 +146,6 @@ static int memfd_luo_preserve_folios(struct file *file,
 	for (i = 0; i < nr_folios; i++) {
 		struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
 		struct folio *folio = folios[i];
-		unsigned int flags = 0;
 
 		err = kho_preserve_folio(folio);
 		if (err)
@@ -154,8 +153,26 @@ static int memfd_luo_preserve_folios(struct file *file,
 
 		folio_lock(folio);
 
-		if (folio_test_dirty(folio))
-			flags |= MEMFD_LUO_FOLIO_DIRTY;
+		/*
+		 * A dirty folio is one which has been written to. A clean folio
+		 * is its opposite. Since a clean folio does not carry user
+		 * data, it can be freed by page reclaim under memory pressure.
+		 *
+		 * Saving the dirty flag at prepare() time doesn't work since it
+		 * can change later. Saving it at freeze() also won't work
+		 * because the dirty bit is normally synced at unmap and there
+		 * might still be a mapping of the file at freeze().
+		 *
+		 * To see why this is a problem, say a folio is clean at
+		 * preserve, but gets dirtied later. The pfolio flags will mark
+		 * it as clean. After retrieve, the next kernel might try to
+		 * reclaim this folio under memory pressure, losing user data.
+		 *
+		 * Unconditionally mark it dirty to avoid this problem. This
+		 * comes at the cost of making clean folios un-reclaimable after
+		 * live update.
+		 */
+		folio_mark_dirty(folio);
 
 		/*
 		 * If the folio is not uptodate, it was fallocated but never
@@ -174,12 +191,11 @@ static int memfd_luo_preserve_folios(struct file *file,
 			flush_dcache_folio(folio);
 			folio_mark_uptodate(folio);
 		}
-		flags |= MEMFD_LUO_FOLIO_UPTODATE;
 
 		folio_unlock(folio);
 
 		pfolio->pfn = folio_pfn(folio);
-		pfolio->flags = flags;
+		pfolio->flags = MEMFD_LUO_FOLIO_DIRTY | MEMFD_LUO_FOLIO_UPTODATE;
 		pfolio->index = folio->index;
 	}
 
-- 
2.53.0



