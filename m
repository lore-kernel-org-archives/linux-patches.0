Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E012318ED9;
	Mon, 17 Aug 2026 13:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974605; cv=none; b=PebY7o+y/WFbkQWyw4RTj2oc5jJePb7Xcvw68T5uFZMIB3VHyBYLnmMQlSZ5WCO6G54nEVegtsvheDUiDbokmftfPUUOySik4LOmRKDkbCOoBik0lo53JjYKlkijbD4rDU09FM+8k/2BecPDtaABGipdtWRtJ50TQ892aoCOKlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974605; c=relaxed/simple;
	bh=LZmK2q0V4tI3HMbXGODRbtrlA9MyDqhqwjBElVOt+j0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8w++ep2guYN7cIx90Cl9Dd51Ecp55KnipZDV7ltm5cJVsrdalCrvvhS2g8QU2eJSGtnCdUh+acxg5/aGHMX5t6sr4DItxETKHVNhS0bM1/BgsIFQwbUf4/RwCklSYZpJkxCV4VJfUVXbdv4wOrEQOXRLl+OnlLycDBuMrMUb+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pganJzIF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pganJzIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E75C1F00A3E;
	Mon, 17 Aug 2026 13:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974600;
	bh=mIpecN+Lsd5Wn+niz+bjXL/RS7JnNunY58klDJA5SXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pganJzIFyh/WM4MidV7LAS8uRlB36OQSowzC57zDoRmqj18UDX063+u+6YGT8Cftg
	 lahlYLNmfFP/T8cnJ9w0kx2a+A3xU8o8bmcJCw/2amJuhdCY84Amtxjv0BAtfPU11E
	 4qAVYj6PeYuv9CXf76G9BUy1zq6TwVM3gSjAjJoY=
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
Subject: [PATCH 7.1 262/271] mm/filemap: __filemap_add_folio() restore index before retrying
Date: Mon, 17 Aug 2026 15:33:07 +0200
Message-ID: <20260817132547.505037141@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -932,6 +932,12 @@ unlock:
 
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


