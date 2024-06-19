Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A0D14D6E4;
	Wed, 19 Jun 2024 13:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802051; cv=none; b=cJTX4KD/+nsvJ/E07bI6SKXTFwEfra/Ky694/rmeRvKVGyCearKrhRgTKouyfs8WrTyFiKgb3rAOXGh4UU3zGez0tRXppwJgofAgOtXqR5vnAwqTD8h/J2FRDGgyNcTmfd2eOXmYh2n1ywtRMijqE/CIfNntRhBmUFNWFJazSrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802051; c=relaxed/simple;
	bh=axUfFpHwJrFyTHvGaxH95dMic7J77YJ2nrB2qqktzZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uub00wEdslKSNq9y9ekutYrASNvlwaWmeqyBlLslChkHsrpLORKIASljneiHc6SYjfQFY4jalWIlALocf+Oobk7mOud61yelnyDPKQ2pplXHmjQuTTtqBBc1bKh2AZfDowm8P+Vb1zqczEqhTi3VZ1PQTjj4tYR9GnGh2pFAMAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qLHRfU7V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qLHRfU7V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CAB7C32786;
	Wed, 19 Jun 2024 13:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802051;
	bh=axUfFpHwJrFyTHvGaxH95dMic7J77YJ2nrB2qqktzZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qLHRfU7V6j3E4nIVS1rRPk7SMVKenB8gMTNYhJUNNN6HZwqTOk8zPwZR9vTKpA9lZ
	 //3qsH0Hsjh4xPzrpnzNoEr/U6GOqZ5n0deXJk6MgkwrreO0CPDxKI787P+AyTs9t5
	 QiDvrw/vI83h4+qF1ply+02zWMuzaGg9v1pXu9XU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/267] memory-failure: use a folio in me_huge_page()
Date: Wed, 19 Jun 2024 14:53:37 +0200
Message-ID: <20240619125608.890499839@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit b6fd410c32f1a66a52a42d6aae1ab7b011b74547 ]

This function was already explicitly calling compound_head();
unfortunately the compiler can't know that and elide the redundant calls
to compound_head() buried in page_mapping(), unlock_page(), etc.  Switch
to using a folio, which does let us elide these calls.

Link: https://lkml.kernel.org/r/20231117161447.2461643-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 8cf360b9d6a8 ("mm/memory-failure: fix handling of dissolved but not taken off from buddy pages")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory-failure.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 5378edad9df8f..9c27ec0a27a30 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1193,25 +1193,25 @@ static int me_swapcache_clean(struct page_state *ps, struct page *p)
  */
 static int me_huge_page(struct page_state *ps, struct page *p)
 {
+	struct folio *folio = page_folio(p);
 	int res;
-	struct page *hpage = compound_head(p);
 	struct address_space *mapping;
 	bool extra_pins = false;
 
-	mapping = page_mapping(hpage);
+	mapping = folio_mapping(folio);
 	if (mapping) {
-		res = truncate_error_page(hpage, page_to_pfn(p), mapping);
+		res = truncate_error_page(&folio->page, page_to_pfn(p), mapping);
 		/* The page is kept in page cache. */
 		extra_pins = true;
-		unlock_page(hpage);
+		folio_unlock(folio);
 	} else {
-		unlock_page(hpage);
+		folio_unlock(folio);
 		/*
 		 * migration entry prevents later access on error hugepage,
 		 * so we can free and dissolve it into buddy to save healthy
 		 * subpages.
 		 */
-		put_page(hpage);
+		folio_put(folio);
 		if (__page_handle_poison(p) >= 0) {
 			page_ref_inc(p);
 			res = MF_RECOVERED;
-- 
2.43.0



