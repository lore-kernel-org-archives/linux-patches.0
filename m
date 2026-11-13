Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590328;
	b=YjRFa9cxWyd4TTkFZoctdrSaKVqrNFVbY7o9SzQpTfVwwZXtgqS82/xO4aFclwzzbjJt
	 /wyxWTuyc3U+dYn44YpbVMnjsNrqYXY9y6RFIvqzTRTWzqEjB1/KdEvBUvF2bu9iBhQHo
	 08/NBTJX9+yERIU5JItZk8jI+uTscYcR9j7Ff1cdkhea2rqXZC1PtElJjw3vCE2yYEBMy
	 C5JxvGMTE7WrEn8lMbXxcWYwxrl9WkfbFUsNvX+oYjh4/XREvIuX9x1NqHVxb/U3QdaiV
	 Y1K7pB5a2+9FWjkysndsnYd+vhhxO6IuJNHOmgVacBPVwlO4KS2M/r9ZRFcafIRtLsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AYsEevfoOySRVMXbui7mnI4rBEl3twK4G7h8gBsLZ4A=;
	b=ZPtIoW85tE5hRZefvIoJzXPg/60BzKgebWWXPc4QvMgRUgs8aNsqlbBqkYa0ndIQvPh2
	 B2p+nzOBl84ZMIlKpIUomdaP3+TYVx0MYDJ2lufLxUJP2M+SXaZeMD4WHhMWzJtnwjC1U
	 ae9Xc/bsK1qRETJUiEOx97QIIJA+nueaXkyQM1vwJmrAIPSZKJPBlOSj6rJ0Pps6vs2qE
	 nP8yVTm9zX6xgsDlN4a6r8jNqHWE/5vZNsUiFcpQ5AImd7ofTOyfgMhhKTuffC5yCr7bb
	 T6T0It2UkZHkheqEHEyOGQGtM/iwzm0zRkuoANlgBGQsOuNV5AOPfvjhhFx35tzLJKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zMeKI+K3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60966607EE78;
	Fri, 13 Nov 2026 17:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zMeKI+K3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031A41F000CD;
	Fri, 13 Nov 2026 17:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590328;
	bh=AYsEevfoOySRVMXbui7mnI4rBEl3twK4G7h8gBsLZ4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zMeKI+K3TlKrC1iv4+eX+RBx53sZjnXO1KXuengd6ENqlCn9mlFmuQSPPj4WZTWjh
	 0SMt73Tq1c0zWtUvTRFAvf+op76rJuCh+AZBZh+5l25J5gLSxgLjtO395ng3jWmTsx
	 btSR5KEmOV0oJmVRtO2LC9GzU8Ls3XOfZNm63/VU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Usama Arif <usama.arif@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 308/686] mm/khugepaged: flush deferred unmaps before dropping a failed folio
Date: Fri, 13 Nov 2026 10:47:21 -0500
Message-ID: <20261113153831.384658878@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 854e5ff8b3ce2a776586cabebaeae645c992345b ]

collapse_file() can fail its reference-count or dirty-folio check after
unmapping with TTU_BATCH_FLUSH.  Both paths put back the isolated folio,
then unlock it and drop the lookup reference before reaching the common
try_to_unmap_flush().

The page-cache reference does not keep the folio stable once the lock is
released.  Another collapse can replace and free it.  With its PTEs
already gone, that collapse cannot flush the first task's per-task TLB
batch, and retract_page_tables() skips short or unaligned VMAs.  A CPU can
therefore retain a user translation to the freed folio.  This has been
reproduced with unprivileged MADV_COLLAPSE on a memfd.

Flush at out_unlock while the lookup reference and folio lock are still
held.  The common flush continues to cover the accumulated pagelist on
both success and rollback, preserving batching on successful collapses.

Link: https://lore.kernel.org/20261007041001.43181-1-kylebot@openai.com
Fixes: 6d9df8a5889c ("mm/thp: collapse_file() do try_to_unmap(TTU_BATCH_FLUSH)")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Hugh Dickins <hughd@google.com>
Assisted-by: LLM
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/khugepaged.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index cc3a09a0c2596..8ed9b2a3e8f07 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2068,6 +2068,11 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 		index += folio_nr_pages(folio);
 		continue;
 out_unlock:
+		/*
+		 * The folio may have been unmapped with TTU_BATCH_FLUSH.
+		 * Flush before releasing the lock and our last reference.
+		 */
+		try_to_unmap_flush();
 		folio_unlock(folio);
 		folio_put(folio);
 		goto xa_unlocked;
@@ -2078,9 +2083,8 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 xa_unlocked:
 
 	/*
-	 * If collapse is successful, flush must be done now before copying.
-	 * If collapse is unsuccessful, does flush actually need to be done?
-	 * Do it anyway, to clear the state.
+	 * Flush before copying the folios, or releasing them in rollback.
+	 * This is a no-op if out_unlock already flushed the batch.
 	 */
 	try_to_unmap_flush();
 
-- 
2.53.0



