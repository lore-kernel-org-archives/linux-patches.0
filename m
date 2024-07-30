Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A57A18A6D9;
	Tue, 30 Jul 2024 17:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359710; cv=none; b=SgjrsUmM+mf5TpiCVC4lNhWr7Ojr5eyU8VtDM57UAqX9aaU/Msoab8ctUiy9WYykIAeTcyVE12z+q0iibklvTjuMrpBgLRvHu0+iJlfH/jClsjGMO+N+0FrhN8PfJt8M4MjHBH4e6+gx2HSq7wQaTTnEcWmYwhZHU6wa684svkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359710; c=relaxed/simple;
	bh=FRvHyH+a19ySFVQRsj8nRj5aGcMASmcUepwXwQblZ8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZtIhqRCN4YYwv4QR1W6G2Ex4UfJilAcGFB0JkNa6gCEcgoSTgsLi2Jed1IVtEYi0CeOqDlt7C1I0IUxkaAcblNlIEY+521cihfmbP2GCdPurdDxxPA6RNhy7zolrMLV4QcX3v7Ri0Es5QFCXkAuiWDxXAODMO8QRxbaogRLoqr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0AmnqEd7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0AmnqEd7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C666C32782;
	Tue, 30 Jul 2024 17:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359709;
	bh=FRvHyH+a19ySFVQRsj8nRj5aGcMASmcUepwXwQblZ8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0AmnqEd7JmgxLfik+zsAxWIgf2xQUF6MawOzqXFeb7fzThOSil4qFXNWqpiarEduW
	 c6lHSzaR0HAEivxAh0cIpPCarUHol5/D5qUgJeFauH8BaNRINb2Yy5UFgR5EcKf7JU
	 jMNzgBkRf5LTNMhlz2yFsSmsHUWOp+ukUKqOSLyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suren Baghdasaryan <surenb@google.com>,
	Kees Cook <keescook@chromium.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Sourav Panda <souravpanda@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 522/809] alloc_tag: fix page_ext_get/page_ext_put sequence during page splitting
Date: Tue, 30 Jul 2024 17:46:38 +0200
Message-ID: <20240730151745.356260946@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

[ Upstream commit 6ab42fe21c84d72da752923b4bd7075344f4a362 ]

pgalloc_tag_sub() might call page_ext_put() using a page different from
the one used in page_ext_get() call.  This does not pose an issue since
page_ext_put() ignores this parameter as long as it's non-NULL but
technically this is wrong.  Fix it by storing the original page used in
page_ext_get() and passing it to page_ext_put().

Link: https://lkml.kernel.org/r/20240711220457.1751071-3-surenb@google.com
Fixes: be25d1d4e822 ("mm: create new codetag references during page splitting")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pgalloc_tag.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/pgalloc_tag.h b/include/linux/pgalloc_tag.h
index acb1e9ce79815..18cd0c0c73d93 100644
--- a/include/linux/pgalloc_tag.h
+++ b/include/linux/pgalloc_tag.h
@@ -71,6 +71,7 @@ static inline void pgalloc_tag_sub(struct page *page, unsigned int nr)
 static inline void pgalloc_tag_split(struct page *page, unsigned int nr)
 {
 	int i;
+	struct page_ext *first_page_ext;
 	struct page_ext *page_ext;
 	union codetag_ref *ref;
 	struct alloc_tag *tag;
@@ -78,7 +79,7 @@ static inline void pgalloc_tag_split(struct page *page, unsigned int nr)
 	if (!mem_alloc_profiling_enabled())
 		return;
 
-	page_ext = page_ext_get(page);
+	first_page_ext = page_ext = page_ext_get(page);
 	if (unlikely(!page_ext))
 		return;
 
@@ -94,7 +95,7 @@ static inline void pgalloc_tag_split(struct page *page, unsigned int nr)
 		page_ext = page_ext_next(page_ext);
 	}
 out:
-	page_ext_put(page_ext);
+	page_ext_put(first_page_ext);
 }
 
 static inline struct alloc_tag *pgalloc_tag_get(struct page *page)
-- 
2.43.0



