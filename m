Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AF12FA63D;
	Tue, 17 Jun 2025 16:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179506; cv=none; b=rgxPeJeZ350375eE3cQhAkYi1b6QJYw+BrwIc7OCdOwvGGuE2OtmBPct+XBcoImiC/hDTsdDlMwkWadwGPbtePhw1sItvXmoBN2eg8Pkh/8/QsC7a1jBLSeHFwkhoJO5kxBxi/jv3/3pFsl9vgfD7cxvUs9JW1RcQkYrBIzRSa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179506; c=relaxed/simple;
	bh=sk434CqTBnWWivcJs7kUsPMCxc9ussCOtaXYMYsAI2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bi6qPyWi+cMQIdrq1x8ecM8YT28wUCZP3DzFRPyA329xXr2n9LckAiPpgptUUTFLFYVX/aW1oWvDEKCWNcdsDhrbdibwg2OBuZ86O2VnuvOpD5xpNZay6tZI5xn1HKw294AkbfI4IJS80975PuF+qPJ82o221OBKDmmo1+K6AgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J1WZHWsZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J1WZHWsZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC45BC4CEE3;
	Tue, 17 Jun 2025 16:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179506;
	bh=sk434CqTBnWWivcJs7kUsPMCxc9ussCOtaXYMYsAI2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J1WZHWsZWnJNiHjw1D1wcl2L3z7wohJClBYS5ZQnvTNEomA9EiLR3PKn6QJHEG7tQ
	 uJg4Sr8VFBk4eSd+rWig7V0HNYc5cg6pkPBtqyxL/VsTWJMIo7ISTk/nRvYkOX2AIS
	 +jp9fhePc/wRo64H+XgBxM8kQOLaMd9dr/FapSzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trondmy@hammerspace.com>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.15 765/780] mm/filemap: use filemap_end_dropbehind() for read invalidation
Date: Tue, 17 Jun 2025 17:27:53 +0200
Message-ID: <20250617152522.670973983@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 25b065a744ff0c1099bb357be1c40030b5a14c07 upstream.

Use the filemap_end_dropbehind() helper rather than calling
folio_unmap_invalidate() directly, as we need to check if the folio has
been redirtied or marked for writeback once the folio lock has been
re-acquired.

Cc: stable@vger.kernel.org
Reported-by: Trond Myklebust <trondmy@hammerspace.com>
Fixes: 8026e49bff9b ("mm/filemap: add read support for RWF_DONTCACHE")
Link: https://lore.kernel.org/linux-fsdevel/ba8a9805331ce258a622feaca266b163db681a10.camel@hammerspace.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Link: https://lore.kernel.org/20250527133255.452431-3-axboe@kernel.dk
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2644,8 +2644,7 @@ static inline bool pos_same_folio(loff_t
 	return (pos1 >> shift == pos2 >> shift);
 }
 
-static void filemap_end_dropbehind_read(struct address_space *mapping,
-					struct folio *folio)
+static void filemap_end_dropbehind_read(struct folio *folio)
 {
 	if (!folio_test_dropbehind(folio))
 		return;
@@ -2653,7 +2652,7 @@ static void filemap_end_dropbehind_read(
 		return;
 	if (folio_trylock(folio)) {
 		if (folio_test_clear_dropbehind(folio))
-			folio_unmap_invalidate(mapping, folio, 0);
+			filemap_end_dropbehind(folio);
 		folio_unlock(folio);
 	}
 }
@@ -2774,7 +2773,7 @@ put_folios:
 		for (i = 0; i < folio_batch_count(&fbatch); i++) {
 			struct folio *folio = fbatch.folios[i];
 
-			filemap_end_dropbehind_read(mapping, folio);
+			filemap_end_dropbehind_read(folio);
 			folio_put(folio);
 		}
 		folio_batch_init(&fbatch);


