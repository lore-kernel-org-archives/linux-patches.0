Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064A579F0;
	Mon,  8 Apr 2024 13:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583958; cv=none; b=USeGPDLSsAstlq7XJcxBcvzaChUf5j+a9ukvbnb71Of3TPpPcBgbBdGoARHMM6oH3WRl9B5ixjy2XnfELgFV0Htbn6pgX3YbYkPYstoU8tk5bHOoQZXh3F6KAVBVLAamkzlGCmYQM+yqZU9rxIaan1XgwsdF5U9r0w5huUGOco0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583958; c=relaxed/simple;
	bh=5j8S+x3AZ5OFa5Vjg+l3kzRs2Hc64ZxI27gJdJm9AOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W56pCyKzosnFpsRK6O3jJ6ekWyzB2/xjTroeoArvBVvdVDPUw7nV1iqInb3vjS8/hvb1eYhvykETaOkxiIHUBdaM7kD7DcJkAlvcq/dv/+f4QTTJeKWdu6CMaXgAvRZ1+gQufhV13uyXCjgrPh5Aco1s9XQQ7Zts4LJgjp5Im1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I4FvKtDr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I4FvKtDr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815E7C433F1;
	Mon,  8 Apr 2024 13:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583957;
	bh=5j8S+x3AZ5OFa5Vjg+l3kzRs2Hc64ZxI27gJdJm9AOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I4FvKtDr1447ucjJERzRirxqT6zdJMXE8HKUuuii536DuOnZxl3SJIF4pNcrjXthf
	 KUb71hJOFi4ofNPwpzmyNdtduIPkUlpMW+vJpD16A9P26kPXz2uPAKNNkNFNxyMDhg
	 DHla+LgJehmlI1qvGnMZFISbpZruoVzMVesGca6Q=
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
Subject: [PATCH 6.8 238/273] mm/secretmem: fix GUP-fast succeeding on secretmem folios
Date: Mon,  8 Apr 2024 14:58:33 +0200
Message-ID: <20240408125316.822250966@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/secretmem.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/secretmem.h
+++ b/include/linux/secretmem.h
@@ -13,10 +13,10 @@ static inline bool folio_is_secretmem(st
 	/*
 	 * Using folio_mapping() is quite slow because of the actual call
 	 * instruction.
-	 * We know that secretmem pages are not compound and LRU so we can
+	 * We know that secretmem pages are not compound, so we can
 	 * save a couple of cycles here.
 	 */
-	if (folio_test_large(folio) || !folio_test_lru(folio))
+	if (folio_test_large(folio))
 		return false;
 
 	mapping = (struct address_space *)


