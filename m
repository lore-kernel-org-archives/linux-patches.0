Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8613E1CDFAC;
	Sun,  7 Sep 2025 20:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275674; cv=none; b=SEa587vHfW80IoluZl6PYSQw9qgjX3sGzm+WSpEp3m6kKAYbX8PQXI5P6UG0Ba2MS+47DdGuwK04gls8sxSuoUlrS2x1DhSLV00AmgF/hc1RvNKN3NC2vKilaZWX/jaB/epWfmIWp41UB0MaOIdXH1+ybVuoHTcCdtwiRm9SU08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275674; c=relaxed/simple;
	bh=JVPYUKgwvLZxrAaAJVCSYQlG4IyI6BTwWZ+lXUvK48M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b41wJAB1CYtKQUlE3e5uZQV8GdYPqfO64ARnSqG59CDQJkSgXJEN2J163EgsQ5YLppZh2sRquVTutNnfDcRPNqZumwJQBQJS4qRzClPWnuJw7ITE8SHkBUvlndukIvjxK4N+r/Yp5fI7lSwS0GfT6h6qJhHfnckxlAjqgFOsvgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dcn/iyk9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dcn/iyk9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A31C4CEF0;
	Sun,  7 Sep 2025 20:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275674;
	bh=JVPYUKgwvLZxrAaAJVCSYQlG4IyI6BTwWZ+lXUvK48M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dcn/iyk9V5dQabBl161c1zeaKk70483syfMqEDIsrGrQqsjlDTHkgrs6Vxp1RHZd4
	 eoCNzAveLrcKhE0ur2Rh2Ibe3FwQ/EImS6bjxgDZs4d8Y7MH85jLs+f5TogOaFR1GS
	 jD+UA4cT751XqULAn9no7W+8dMuZK2TVBYC++0mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiong <liqiong@nfschina.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 28/52] mm/slub: avoid accessing metadata when pointer is invalid in object_err()
Date: Sun,  7 Sep 2025 21:57:48 +0200
Message-ID: <20250907195602.805897148@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195601.957051083@linuxfoundation.org>
References: <20250907195601.957051083@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Qiong <liqiong@nfschina.com>

[ Upstream commit b4efccec8d06ceb10a7d34d7b1c449c569d53770 ]

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
[ struct page + print_page_info() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -729,7 +729,12 @@ void object_err(struct kmem_cache *s, st
 			u8 *object, char *reason)
 {
 	slab_bug(s, "%s", reason);
-	print_trailer(s, page, object);
+	if (!object || !check_valid_pointer(s, page, object)) {
+		print_page_info(page);
+		pr_err("Invalid pointer 0x%p\n", object);
+	} else {
+		print_trailer(s, page, object);
+	}
 }
 
 static __printf(3, 4) void slab_err(struct kmem_cache *s, struct page *page,


