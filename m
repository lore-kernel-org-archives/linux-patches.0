Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76F22D8DDF;
	Mon, 17 Aug 2026 14:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975379; cv=none; b=RyTipWI23Koj6mxC+MKlI+tD547KTQPhlJJdsmYYQWunO54FQX2y5F7vkku28vVOxXct4T4S4O5vj+JBMdWIf6pWjXa0CVradmIT3iTJTcLWAPhAevVbGrHL1EbB5p2z20SbhAZPUMSDutGbpJXL7uoAOXEIb8O44FcI/jPCQkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975379; c=relaxed/simple;
	bh=5aWzV10u9isWyFqCwFLyTwC6TmVe4/i7NOIwJqkex8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DioVfeg4bW4Fay+YrwKrLSYS45ZUzkjoaehURyzXAA6CqKyl6JplOJCU/qDgzf/wYOYbyAGl/BkZH03rEvRplsyydOmzpLnQ+OWQ1ia1jGcmhZX8xgSlXNAPCXvrOXbuoZ3LREepYkkWnKuwkfeRUFtOtr93qmbfYdmiIIFLVGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XkQphHhN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XkQphHhN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5671F000E9;
	Mon, 17 Aug 2026 14:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975377;
	bh=0BpZet8IIt9bkQ8+qAoJ3zCcPmwCgjQG7HbwuNamwvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XkQphHhNahrtDMFT0DdxZfRdyEErMkrYlu7Pki2keNYk44Q0MhHDK6ILhofegGFje
	 jMIzMpFCjQxYRAKaHCtHYt9CMl/ZiWyLs5YqEHoxSXU3GK3TXnViKz29Eg9aRzI/yn
	 THSYaQlCUXOUhhKum4ZQ5pcSfbdny5ikD24W8wTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugh Dickins <hughd@google.com>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Zi Yan <ziy@nvidia.com>,
	Chris J Arges <carges@cloudflare.com>,
	David Hildenbrand <david@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Kairui Song <ryncsn@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 239/250] mm/filemap: __filemap_add_folio() restore index before retrying
Date: Mon, 17 Aug 2026 15:33:20 +0200
Message-ID: <20260817132546.251337591@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

commit 86da3f7e1e609e1e8bfbab198af68467c5a015a5 upstream.

In __filemap_add_folio()'s split-a-conflict loop, xas_set_order() is
applied repeatedly: each application modifies xas.xa_index, rounding it
down according to the split_order attempted at that stage: and if all goes
as intended, it eventually (or immediately) converges on an
xas_try_split() to the required folio_order, with xas.xa_index now the
same as index: then xas_store() puts the new folio into the xarray there.

But if a new node was needed, and GFP_NOWAIT allocation did not get one,
the lock is dropped, xas_nomem() used to allocate, and sequence retried.
If (that part of) the xarray is unchanged when the lock is reacquired, no
problem.  But what if the conflict was meanwhile resolved by another
thread (perhaps even doing the same thing, inserting a folio at that same
index)?  Isn't there a danger of now putting our folio into the xarray at
an intermediate rounded-down index?  With !folio_contains() bug to follow,
when CONFIG_DEBUG_VM=y is checking for that.

Fix this with an xas_set_order() to restore the original xas.xa_index at
the bottom of the loop, so the retry does a full re-evaluation after
reacquiring the lock, and cannot reach xas_store() with the wrong index.

Production was suffering from rare SIGILLs and SIGSEGVs, executable text
found a page away from where it belonged, !folio_contains() bug hit when
debug enabled: symptoms not seen since this patch went in.

Link: https://lore.kernel.org/562fbfa6-dd6d-0b6a-2461-ed2ff1173bc8@google.com
Fixes: 200a89c159a7 ("mm/filemap: use xas_try_split() in __filemap_add_folio()")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Chris J Arges <carges@cloudflare.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -944,6 +944,12 @@ unlock:
 
 		if (!xas_nomem(&xas, gfp))
 			break;
+
+		/*
+		 * Lock has been dropped: start again with the original index
+		 * and order (but now with the memory reserved by xas_nomem()).
+		 */
+		xas_set_order(&xas, index, forder);
 	}
 
 	if (xas_error(&xas))


