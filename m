Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00E91BC08A;
	Tue, 27 Aug 2024 15:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770988; cv=none; b=SfNFtiID8XfFtSGbsotDf35l6SwTrznJzvD6E8gIkYCtqmt8j/9nDBK24tzf1b3XPKONpPdxnjpkZzW1UImgXA3oQUcT+eoePaYfaxsPEwd5wqyDwHt12rDKhOKdhV8JUMVJL31+LyVY0ogpAbg2g5Ygmqo+GBl45NHmANg0CZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770988; c=relaxed/simple;
	bh=beSGFQJgSQZTh5T02Q7808bb/hDN8ckHoLDTKWrlCKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9qYw368vZRmFp+lIlRfmokYkNUd7oC0QmY/n8Xu/ykViDoi0NHbEwQ49Nd559wilbqboNR8orFOk0uOYho9OemrvWkGwScP0i/26MKZOyAyzPNfhCAzOazkULWu5y/SAQxpbu1itSjtCJ2yydW4VwcBHjRH5xPwxLEQCTOpdKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PJ/90oOb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PJ/90oOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4778DC6104B;
	Tue, 27 Aug 2024 15:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770988;
	bh=beSGFQJgSQZTh5T02Q7808bb/hDN8ckHoLDTKWrlCKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJ/90oObfJDns1vwGfNLiJ667Lsr4N0X1zJE+AMKWAFZz2V0FYdjV0bp8CzFFtiG7
	 a2A3meUzoFj96kB6f0TpvZJY8RX6tysmJACFafaILfu8JXYK4Q5/XO4gVoMVKRK1yl
	 UzU2mtzKM5L50OBzyLdTKSXmE6JK0vv/vZkcSuGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suren Baghdasaryan <surenb@google.com>,
	David Hildenbrand <david@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Sourav Panda <souravpanda@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.10 053/273] alloc_tag: mark pages reserved during CMA activation as not tagged
Date: Tue, 27 Aug 2024 16:36:17 +0200
Message-ID: <20240827143835.417314211@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suren Baghdasaryan <surenb@google.com>

commit 766c163c2068b45330664fb67df67268e588a22d upstream.

During CMA activation, pages in CMA area are prepared and then freed
without being allocated.  This triggers warnings when memory allocation
debug config (CONFIG_MEM_ALLOC_PROFILING_DEBUG) is enabled.  Fix this by
marking these pages not tagged before freeing them.

Link: https://lkml.kernel.org/r/20240813150758.855881-2-surenb@google.com
Fixes: d224eb0287fb ("codetag: debug: mark codetags for reserved pages as empty")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>	[6.10]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mm_init.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2293,6 +2293,8 @@ void __init init_cma_reserved_pageblock(
 
 	set_pageblock_migratetype(page, MIGRATE_CMA);
 	set_page_refcounted(page);
+	/* pages were reserved and not allocated */
+	clear_page_tag_ref(page);
 	__free_pages(page, pageblock_order);
 
 	adjust_managed_page_count(page, pageblock_nr_pages);


