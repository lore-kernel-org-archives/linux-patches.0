Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585529;
	b=IlTC0yMbYatXKOtHne27/H0B57bqDbTmCZwTu3HkQIvMhWjqru1nJEbbI7EtNKNjeFQm
	 TspFy1dum7plA+f/l01Pa3ejCZeyBvw7G+trTK62a1tjHtSoijH59y4uORbNJQGaWRgjy
	 SXz2aVXOO2jUJ5i+CreJ3J5AYichOQ00BZu63cAqL1iohW+qXTdDUddmgnlByC+qlGbF/
	 bthoyCoOCTVx+EBU1twKFO5b2SJhfCs5t0azYGvApaa0ReBROYRXCxcOGpL5soMQCU3ez
	 4YkRiM6P2MydBdpqJvBhhzYUD/vd6b9O+KZV5oTf0/ZbJHolveuP5jWMx1GnTBWHVvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585529;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UJ28QbOD8npzRwc2Gg4KUzQlXL20/RHDadxFZwqW9Ao=;
	b=zbxyUCQUfwown5y4IfWD/UeMe+wYwKhKMOdVoLnp/2SpOjcCvboTnqlWlypOX4bjrQ97
	 7vEanndHiZ7eFFzRrOU0TTw1sfCRDFUhWllKqyw2r3DfVS15HUB3rDuALHEkIPRxrec/p
	 54BjsjEuDLLnLp3S6mcuScOmzQmnAFIS5GZV9CfHE9iV4Bo0AyzjcifXUOLA7u5tsJ67T
	 fPLg2b8YV/OARdtCcnEt171tRYMk323a/xoNwQ4KkiVLP9oBPgqdlI2ctDgKukB9CAIZ9
	 0LrD3VVJZVssO9lCoo6Z4CgnHKJe+/TZBXuEFDJINIrqj59/EX5yBmAyud3gnJJeFYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=No4pjW0b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B54606A331;
	Fri, 13 Nov 2026 15:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=No4pjW0b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC9E1F000C4;
	Fri, 13 Nov 2026 15:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585529;
	bh=UJ28QbOD8npzRwc2Gg4KUzQlXL20/RHDadxFZwqW9Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=No4pjW0b7EFfVVeEpwfXotA2INhgPWhYnRQehXpYGSAPn1MOG3Y6O3u+Hz1meMERA
	 h4yLXEAj1S0cDl+AgL+acnEHmB8J86XWsgTo95LeOF9ZvQBLSvcbPDC7rdDa86C3gh
	 yeZKfVe0IBiyfuqQonbK6Ejq4qUccYf8zOhrIV10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 144/507] mm/shmem: fix truncation of files containing only swapin-error markers
Date: Fri, 13 Nov 2026 10:47:28 -0500
Message-ID: <20261113153759.316393043@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit 59511d630a6942356ac4b6984797998a8f3a9017 ]

It might not be very common, but we can end up with shmem files that are
composed only of swapin-error/poison markers.

Such markers are not counted in info->alloced. Consequently,
shmem_setattr() can skip shmem_truncate_range(), leaving the markers
behind.

Truncating the file to zero and growing it again will result in reads
failing with -EIO instead of returning zeroes.

Check whether the mapping contains entries, in addition to
info->alloced, before skipping the truncation. Keep the info->alloced
check so that shmem_recalc_inode(), called at the end of
shmem_undo_range(), can fix up accounting after reclaim has emptied the
mapping.

Fixes: 6cec2b95dadf ("mm/shmem: fix infinite loop when swap in shmem error at swapoff time")
Cc: stable@vger.kernel.org
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Link: https://patch.msgid.link/20261029-fixes_shmem-v4-15-392fc715d8f6@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 31103314b6b62..199e8a9c2a2b4 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1384,7 +1384,8 @@ static int shmem_setattr(struct mnt_idmap *idmap,
 			if (oldsize > holebegin)
 				unmap_mapping_range(inode->i_mapping,
 							holebegin, 0, 1);
-			if (info->alloced)
+			/* Swapin-error markers are not counted in alloced. */
+			if (info->alloced || !mapping_empty(inode->i_mapping))
 				shmem_truncate_range(inode,
 							newsize, (loff_t)-1);
 			/* unmap again to remove racily COWed private pages */
-- 
2.53.0



