Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371844315A;
	Sun,  7 Sep 2025 20:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277723; cv=none; b=XwqntP7fitC5dxOiIHDeEFqF4OKiWVjqK9xPwYnezWjJla0NwQbjjhcJ0TE8oVaeqDJBOhROcQeELTM6jR94VVOvzNHQMkwfZF30pJrdNJkwPkCfJfYO0FnK9on95bOmjq0e4c3NGpnAFqlyCC8/0i+eo78cAaSK8IjWsVaHshY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277723; c=relaxed/simple;
	bh=yetg9vO4HPMF4bPzu8Kj1qTuDMIFzFq6QAwivpL7uTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FH+AP7UlrDMIWCzvfn39JQ76zAXj/WKJLWoykVKrOexS8SAvfRc5rUz0KGhWp7MKG95iA45FX5jbIvLLKrpKZ47xq4GSs22wcTI83yP3eGE6LvnrkDLgGE0NEJ28qnQdO30/qEHCjbEOXXZex0sT/tARzLUhVQE6NYGH7rpIokw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a+gpG5Lc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a+gpG5Lc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86676C4CEF0;
	Sun,  7 Sep 2025 20:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277723;
	bh=yetg9vO4HPMF4bPzu8Kj1qTuDMIFzFq6QAwivpL7uTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a+gpG5LcYQWyYqcNmRONYxgwEtSBbMCNvXYLW7kSHGhdoSqwXJSREZYSN+msJl9uv
	 bMelW5Dte5g74RMOPCK3LGCdn5rSHB8fG1xHUj4ZyCTOkZTQOyG7oWOAjZaXK5cy2U
	 FfPrO5I0WYzadRfuXO2Fqb+s9KJlsvrGcyU2/dKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiong <liqiong@nfschina.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 6.16 102/183] mm/slub: avoid accessing metadata when pointer is invalid in object_err()
Date: Sun,  7 Sep 2025 21:58:49 +0200
Message-ID: <20250907195618.212876035@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Qiong <liqiong@nfschina.com>

commit b4efccec8d06ceb10a7d34d7b1c449c569d53770 upstream.

object_err() reports details of an object for further debugging, such as
the freelist pointer, redzone, etc. However, if the pointer is invalid,
attempting to access object metadata can lead to a crash since it does
not point to a valid object.

One known path to the crash is when alloc_consistency_checks()
determines the pointer to the allocated object is invalid because of a
freelist corruption, and calls object_err() to report it. The debug code
should report and handle the corruption gracefully and not crash in the
process.

In case the pointer is NULL or check_valid_pointer() returns false for
the pointer, only print the pointer value and skip accessing metadata.

Fixes: 81819f0fc828 ("SLUB core")
Cc: <stable@vger.kernel.org>
Signed-off-by: Li Qiong <liqiong@nfschina.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1104,7 +1104,12 @@ static void object_err(struct kmem_cache
 		return;
 
 	slab_bug(s, reason);
-	print_trailer(s, slab, object);
+	if (!object || !check_valid_pointer(s, slab, object)) {
+		print_slab_info(slab);
+		pr_err("Invalid pointer 0x%p\n", object);
+	} else {
+		print_trailer(s, slab, object);
+	}
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 
 	WARN_ON(1);


