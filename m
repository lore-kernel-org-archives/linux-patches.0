Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585490;
	b=gLBMDsEYy5iGiHvr+aToILrTu0kmrY/1GO1XexYXGUlZuzACsaanXXzIweIi02RclbSW
	 Mw8Tw2IBJJ6q5OBBq67I1kEDxV0MCC9xfX2HhNYW1z6KQQLQzmvlv361GnSl9ZvQ5OovZ
	 2Nx+ZRMhttBQ+Wi20TdvziRdRgLGuZ65VcvYs6CySCUTECDqKjgWMl21UsfP846NhPo21
	 XIJNeq3/mzQdEBcAptjVHlJsrk8ICZALzfbKGzb3u6obV8dhzQZLzfZUGKjgdZbHYLPKd
	 ES16HJPCK0tyPggnovQXQNE/pSfqsG/kmm+6K0daJOwQGgLu9aOnscZFDDg3YaQBpvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585490;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y7u+7QxuR1WGWuqWKUGjNMsj//Rg/E1hs4ZLPJtis/E=;
	b=NLf8GQdSC9pJHnMkFHx1IewRoBTnph0ZFlqmnk5YFae6OIAmu19DhUuPeE1ts1qm2rim
	 muAqb5LKqqMqogWiQvthJqb/zDxcSYmt6YL4EJoMJtwymsPfdjvowwsESSyHYFU0J5da/
	 XwPcGTFm0toldKNLQy+TZ5wNJ1A0VK5PGWHC4CqbCwNKP9zKsXruO97nv3fmHQ9ydmb1R
	 XMLtG2d6EocfVOctBE0X0RVcJvFx9nwpXzidYs3+n7oqr+aC+YHA2Ud4T8VbMZzZDoMs9
	 8AX9xS9PFaNi1Fe/II/JrS62Ezb4o5jtZuaWvsEdRXT/nsqnEZQLH9YsUG1TPJgy72g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="vUpn+c/9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB6B606EBAC;
	Fri, 13 Nov 2026 15:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vUpn+c/9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEBA01F000C4;
	Fri, 13 Nov 2026 15:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585490;
	bh=y7u+7QxuR1WGWuqWKUGjNMsj//Rg/E1hs4ZLPJtis/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vUpn+c/94N6cnREMLy5BaWCHIblJ5R7XvGrvISO5Ma/+0pT0Fe/dAN1q4p1KeIvea
	 ceG35SKkSOG7q3dQQA4UPGsqpbJryZnSq4D5Pf+o4MikjVZPVn6ZF93tBA+JWFUMZH
	 qLDMmm3DX89VEo7hRdT9LWAQ65ytelBQZbVSZ/Wo=
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
Subject: [PATCH 7.3 138/507] mm/shmem: discard whole new large folios on fallocate rollback
Date: Fri, 13 Nov 2026 10:47:22 -0500
Message-ID: <20261113153759.128453739@linuxfoundation.org>
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
index de4d9424f0596..7d9083c482a4e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1268,7 +1268,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 				if (!unfalloc && folio_test_large(folio))
 					folio_mark_dirty(folio);
 
-				if (!folio_test_large(folio)) {
+				if (unfalloc || !folio_test_large(folio)) {
 					truncate_inode_folio(mapping, folio);
 				} else if (truncate_inode_partial_folio(folio, lstart, lend)) {
 					/*
-- 
2.53.0



