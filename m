Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590258;
	b=oHHtO4+oo3+5YhoSJuSywQzuSOoDWTo8rE8rEMtq/yJZIHWrPGki+UcVXjkfUVwYKsbp
	 32GYFmDK5QYiTM98W6LwDnHQAEOimGWciEhkACBc4W76G/nijBIJ6g3zzSiMJ0MvGwHiM
	 AbL1QAUTkHIBSCSXr0/b5Xf8KtVMk8BR/JLcGY1BHxcI5z/JE3Ra1IGMf524AEzkDWNpJ
	 ZHh/PWrhIffBykNoOlMImwFPJ0GIVLhyv+WDBvwT6uvms0PfcIBeZfsfIX96MyCCSF6c/
	 8pBdvoOlF8Dr15yfPaLtIy2WV53DIGikyv0Bnywads9T40IJlna7e6E24kPhG2g8JDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qi6XiGdy7YyMJ1tgfmhoad5S3KzhyY9XqHkxTPQq21o=;
	b=AbVYvscDidHhVKYyb0KPCokHVf27voN2pDg1300h/g2lj0+YcQhpJ3HlDSH30y0Fx44V
	 jQLl77N/ADH9DzRhvrZ/8FPJpSd3ZALKRl72xKp3VVwzxTtQulBzQ4yKzHym1T0qByO0J
	 ejOJ9nu0aWg+d5h8TbrlztHh5cNZoDV3NJ5HNd8tqKYJy2ypkGE5CJLkW6OR6ExFWMFPr
	 8xB40gWZREAzxg85XIxKXUuQTU8GgnBS7vrQHZorHlQs2/OcithXB6Yu+mO3qkyVd3T5u
	 wWnXP7MhPuP7uOBdxbu5S9R9o2H315GPxlWthRPACskyHTyCQyvOV5p8DThObWxUs/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kGzAczLo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257FD60A380C;
	Fri, 13 Nov 2026 17:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kGzAczLo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1611F000C4;
	Fri, 13 Nov 2026 17:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590258;
	bh=Qi6XiGdy7YyMJ1tgfmhoad5S3KzhyY9XqHkxTPQq21o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kGzAczLomYFJtlGBcq4ZY7MKjwyTZ8aC2dVuv6XeT+WESHT5GFi9YOcVUhTaG6FAv
	 GAhn0A8/7xL+ywRe8FbJeLCz7IxS8jQ+znqrnrouVb3aq1WqLBp65GiCkOogT51Dkk
	 Lkp2Y1z4oRaXcG6vxasIoaS4e7K3OkhBcwOymEFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Zi Yan <ziy@nvidia.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 252/686] mm/shmem: rescan after nonuniform folio splitting
Date: Fri, 13 Nov 2026 10:46:25 -0500
Message-ID: <20261113153829.579870658@linuxfoundation.org>
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

[ Upstream commit f0d67b3d0a464847337d5063766d55e16041323e ]

The final scan in shmem_undo_range() restarts after a successful split
only if the original folio is no longer large. A nonuniform split can
leave that folio large, so the scan skips the newly created folios.
Hole punching then leaves pages within the hole allocated even though
they could be discarded.

For example, a fault below the hole can allocate a 2 MiB folio after
boundary handling. Punching a 1 MiB hole at offset 64 KiB splits the
folio successfully but leaves the original folio at order 4. The scan
continues past all 512 pages, leaving 2 MiB allocated instead of 1 MiB.
The hole reads as zero, but the pages and their block charges remain.

Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operation")
Cc: stable@vger.kernel.org
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Link: https://patch.msgid.link/20261029-fixes_shmem-v4-10-392fc715d8f6@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 675d45aa85f64..c598daacb5efa 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1240,18 +1240,12 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 					truncate_inode_folio(mapping, folio);
 				} else if (truncate_inode_partial_folio(folio, lstart, lend)) {
 					/*
-					 * If we split a page, reset the loop so
-					 * that we pick up the new sub pages.
-					 * Otherwise the THP was entirely
-					 * dropped or the target range was
-					 * zeroed, so just continue the loop as
-					 * is.
+					 * The folio was split. Retry the scan
+					 * to find the split folios.
 					 */
-					if (!folio_test_large(folio)) {
-						folio_unlock(folio);
-						index = start;
-						break;
-					}
+					folio_unlock(folio);
+					index = start;
+					break;
 				} else if (folio->mapping) {
 					/*
 					 * Splitting failed, but the part in the
-- 
2.53.0



