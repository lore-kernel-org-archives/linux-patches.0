Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590257;
	b=L+5CmZ6oqrdUM9jjyrOuAvxT/XqR9q/ynQ3jUi1GrnIXfXdwkJt8GHY/NHYMLNKxAm56
	 snopmVKmbWOEee97b1xbPDVjJPHTRR/MtbhCgL9y1EAoVjt7QvJCfdLgWmutrmjYleMzE
	 cOM/V6i1we0T8nBjDoWwFKm3U7RScnp1Xa38MsjiPrATpIdQQwX6+ggxP6sPox6nWVSCO
	 CQFSDyykQmpl5SEPBwsSiK8ygotUBqNqna+626JbmMfKz8EUx2NLBRFQm8qrYJUcmD1N+
	 uV3gGdLe6e4Iyb5SQ2Zjhdb0YeqoZvHtKaQ5jRabMBoOjpZCPqpl/0g6gqEWoQg4OzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590257;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZS9kYYdPZjV7U+Ao91omIdJ+Up95OUMx3Wb/wVP4FUQ=;
	b=NlFS1D9hIQTRftr3x9QZiol7CN3KsoBrqNnTZDlks61Qzx0BTjK1+flW+FrmWl5SxTyT
	 QjszE4x7dztdbWejMpYkt1cxggicAwBi50yD03tmWO/Sk+12YJqbCpANbhIJG1nmx3xlw
	 kvB0eJ/GNj3lNWs7OEZ4/lY6f/1meZv2hCw7TcrbgwfzzyooiuxjnVM9pCid1tXMBGInN
	 QtPmEI5As8vDBSh079R3hjJKK0qSSuBXsIetaUcMRgtlNgcruIRZgRdXVbJdaC6EjZGsi
	 SnBGkXXmogo/I0DT/5ZU1b+dcLWumCwCw7eFq7TEcWjHchiGZ9bfFFCZO2IZb+9d9qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="q/TdCdhA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93D160A380C;
	Fri, 13 Nov 2026 17:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q/TdCdhA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7D01F000C4;
	Fri, 13 Nov 2026 17:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590256;
	bh=ZS9kYYdPZjV7U+Ao91omIdJ+Up95OUMx3Wb/wVP4FUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q/TdCdhActpiwlNgHqApv6Fh1c9RGiVTQl+DoJW/AM2uT9tbzg7G4lh0vt94gI30K
	 uAB9lro3VRNP1Sj0cxBgTcEENWmCKPBMhibHIvQHK4wqmjZg211OFN5mgHpxFArkwk
	 UcPOXklhGFmf/1TIpPQzn48Y9fDvAaP8Psn3V9HY=
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
Subject: [PATCH 6.18 251/686] mm/shmem: discard whole new large folios on fallocate rollback
Date: Fri, 13 Nov 2026 10:46:24 -0500
Message-ID: <20261113153829.547473134@linuxfoundation.org>
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
index a764a26b0adf2..675d45aa85f64 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1236,7 +1236,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 				if (!unfalloc && folio_test_large(folio))
 					folio_mark_dirty(folio);
 
-				if (!folio_test_large(folio)) {
+				if (unfalloc || !folio_test_large(folio)) {
 					truncate_inode_folio(mapping, folio);
 				} else if (truncate_inode_partial_folio(folio, lstart, lend)) {
 					/*
-- 
2.53.0



