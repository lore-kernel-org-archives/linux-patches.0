Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037572;
	b=MYJX0K1E7zjIAhW2YfjZcJUHssoYTyqAQGmRUfNdRVzmOe7Xv6G3to5xRBHY8ZIBBNi/
	 qrbuOWjB21BRZ+G6hJUODC+m5OpUmLEPyI+wAXraKixbM/ZRGut+ikKj0UGoVhykjFX/a
	 vN23YG8cDpJYmHndriTSDumgvg4+q/N2LxrFY/h5hz9F9o/6L/bQJ8xG7aP0vkFrvrMMJ
	 N8a2EkHy7X/8jXioUA0Wi/bXaCE7FKXOl+hKlwvwWJz/6Y98bl1yRyENh1qqNOXGCtrZz
	 4nSyFZzUoePI0x1E69gOzv6kqClTjhNJynrUVaYBDZfOyp46odqI8zkkohdqVRB3EvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037572;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VztF2kW0on9fhxMmGY909Ha8SEFGXT31G4C6axFptb8=;
	b=DCEcDKQrP61uOftkY21up+D8+aLiF6kMbyXUACpQMVS0rnFxY+uHJoe+ISl70Ud6Tj7r
	 tvw4B6Ln03EVWsXz8PXKpSa82SNK08cByrD8JRsES5defYVR3+RyNj4r+QAv/ANvoOHvU
	 rbPbHniwSA1qIit69kq+BzD8uTWNgC9Czlccpy78J20jPvKtgCiJ6UJ2Hga5VWYRVgCka
	 dDazNtdqgS7xjAqtjklmaARC0tEwvpbVZyXdsfJXt0dP+ZSgT5mXSifsWaFyxn8+l/jQl
	 Qr/4z8BBRsFAlXoqaomsoxkV2hS4nrO3KwjQRyz+vICDgpgpGV6jZPSYHzmlBfNn+cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zjt2f+mt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7162606A320;
	Wed, 18 Nov 2026 21:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zjt2f+mt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448561F000C4;
	Wed, 18 Nov 2026 21:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037571;
	bh=VztF2kW0on9fhxMmGY909Ha8SEFGXT31G4C6axFptb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zjt2f+mtwYRPntgVMiUU1e1v4iGFg1NYQ761JpfgNhvwURlWvLrOfmHFa9LkxYgkm
	 sPZDbufvWtkNs6K30YCuchu0CxW+LepQRSKIAPa0Iabuh3QrlZdVOO/QSBo5s2/6eD
	 8lf/eov+8bgjB8EyWWnuvPobadWvR8w4nDHw6FSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zi Yan <ziy@nvidia.com>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1444/3318] mm/shmem: discard whole new large folios on fallocate rollback
Date: Wed, 18 Nov 2026 15:34:26 +0100
Message-ID: <20261118150404.154400665@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit 23f2a880c0b9518fcb7e7e2ad54a29c0a2c4fba0 ]

When undoing a failed fallocate(), shmem_undo_range() must discard each
newly allocated folio. Its second scan instead passes large
folios to truncate_inode_partial_folio(), which does not necessarily
discard the entire large folio, but instead tries splitting it to
discard only the requested range.

For example, with huge=always, a failed allocation starting at offset
4 KiB can leave page 0 allocated in an otherwise empty file.

Discard the whole folio when unfalloc is set. Note that we enter this
path only for folios that are not uptodate, and can consequently be
dropped without losing any data.

Fixes: 55ac8bbe358b ("mm/shmem: fix race in shmem_undo_range w/THP")
Cc: stable@vger.kernel.org
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Link: https://patch.msgid.link/20261029-fixes_shmem-v4-9-392fc715d8f6@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b81d9c789d11f..96c36c3d4a0f5 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1112,7 +1112,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 				if (!unfalloc && folio_test_large(folio))
 					folio_mark_dirty(folio);
 
-				if (!folio_test_large(folio)) {
+				if (unfalloc || !folio_test_large(folio)) {
 					truncate_inode_folio(mapping, folio);
 				} else if (truncate_inode_partial_folio(folio, lstart, lend)) {
 					/*
-- 
2.53.0



