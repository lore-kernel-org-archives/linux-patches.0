Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EDF7D07D;
	Mon,  8 Apr 2024 13:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582837; cv=none; b=r9GRvvV1AaAhdUmHik6dYEv0ucVrAztEZdMezhmNba2ubOJjU6v1BnLUsaYf0kZmTZfxKlSawou39BkR6iT9wM9vnoTROd51rMApq4cMuk62RYKAx3mRuw4uKLhoyJ6rG1C75LqQXXxIVOQmL8uA977OB6Q2G1iwJpd3eDILhCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582837; c=relaxed/simple;
	bh=OJvyWPFM+Uisvzvkv5POpUlVz8xXncqH5N7PQ1UPico=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOAg90KHMwhzZD4XUj5mPVtdithy7Dz9+lS74lj77W+6e1dot1OF6hu2BWUJCghPdDkkWWpCxUVw7pGUj5tf8uG6xIa8W3Voq5J+Rp59NkzhnyMdIm/vmONXXj9PANvW++IieI2d/8dRREtEMRj9MzlhL1efK9NBCX7dB0wZr/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZkvMJeNo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZkvMJeNo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70716C433F1;
	Mon,  8 Apr 2024 13:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582836;
	bh=OJvyWPFM+Uisvzvkv5POpUlVz8xXncqH5N7PQ1UPico=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZkvMJeNorwAL14OJGg5YZZA+Oq1aWFvMxSJ6alMlraTAc7viQrc+rIv7MdI4azQLE
	 if5WVFXGIQCJPM9Q65J4yHwSF5iYwWUXJNAE+Ha+uioE9wKxa1s23B65vJDublyiG7
	 tke9sY46bUJOinqcN4dmZGd4WR6Ks+6JHbYm90dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	xingwei lee <xrivendell7@gmail.com>,
	yue sun <samsun1006219@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Lorenzo Stoakes <lstoakes@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH 6.1 137/138] mm/secretmem: fix GUP-fast succeeding on secretmem folios
Date: Mon,  8 Apr 2024 14:59:11 +0200
Message-ID: <20240408125300.488795726@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

commit 65291dcfcf8936e1b23cfd7718fdfde7cfaf7706 upstream.

folio_is_secretmem() currently relies on secretmem folios being LRU
folios, to save some cycles.

However, folios might reside in a folio batch without the LRU flag set, or
temporarily have their LRU flag cleared.  Consequently, the LRU flag is
unreliable for this purpose.

In particular, this is the case when secretmem_fault() allocates a fresh
page and calls filemap_add_folio()->folio_add_lru().  The folio might be
added to the per-cpu folio batch and won't get the LRU flag set until the
batch was drained using e.g., lru_add_drain().

Consequently, folio_is_secretmem() might not detect secretmem folios and
GUP-fast can succeed in grabbing a secretmem folio, crashing the kernel
when we would later try reading/writing to the folio, because the folio
has been unmapped from the directmap.

Fix it by removing that unreliable check.

Link: https://lkml.kernel.org/r/20240326143210.291116-2-david@redhat.com
Fixes: 1507f51255c9 ("mm: introduce memfd_secret system call to create "secret" memory areas")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: xingwei lee <xrivendell7@gmail.com>
Reported-by: yue sun <samsun1006219@gmail.com>
Closes: https://lore.kernel.org/lkml/CABOYnLyevJeravW=QrH0JUPYEcDN160aZFb7kwndm-J2rmz0HQ@mail.gmail.com/
Debugged-by: Miklos Szeredi <miklos@szeredi.hu>
Tested-by: Miklos Szeredi <mszeredi@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/secretmem.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/secretmem.h
+++ b/include/linux/secretmem.h
@@ -14,10 +14,10 @@ static inline bool page_is_secretmem(str
 	 * Using page_mapping() is quite slow because of the actual call
 	 * instruction and repeated compound_head(page) inside the
 	 * page_mapping() function.
-	 * We know that secretmem pages are not compound and LRU so we can
+	 * We know that secretmem pages are not compound, so we can
 	 * save a couple of cycles here.
 	 */
-	if (PageCompound(page) || !PageLRU(page))
+	if (PageCompound(page))
 		return false;
 
 	mapping = (struct address_space *)


