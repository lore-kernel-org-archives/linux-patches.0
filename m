Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591069;
	b=xqXnezbagdKWeR0sdlePX5mox8s1QQcVThTGlCMnnMAOjjOkQ/jAebP8F+XmOvZXrpr7
	 uc66ZbSdsxt5Kwrg/fdGF+ilhKzxRLu2utmCorWpcxWTNAD3BFWoEvctnmp41QAOkxsGC
	 5gO/mO0PpQ6EI9mSdXcALZqVSitlXf+BZ9UDqN7GZdEOrH3ZZ50P5bXj45vcMP5Xj5Yzf
	 R3qlsYN1YkZQ7ose1gzATxxDbarAT1jUJXesgROkS/U0Ucvi3/6+3JsaOJM+RK6MkM5Z+
	 qPGzox8xc6LDnG91l00ODfq28jOX6eFps2MLJ5I7wDeT9uLKDksv3GHde8NNTdZ6WMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591069;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jPAvbA2iNJWHWzXUWhtj3K1kgmsggy40kSktIANrYTg=;
	b=Fhl7a6+DmgzDtZWq9YovNAnvNPQepUmxTvDodO64QspP5/EC0mzgchnINLY+9TOZd+df
	 Tw0NB/VdbUWqbmUasj4Dj06kRNIRpJCARMXGk2SxoKDQV/5Nyv6IkuPoI58l4zDK1VRnc
	 dCf2Hy9hi1JsPTXPQTj2b6udjdtLuEeuX32vRzmetWFu/ss8vwDVQMq58cwFd8d87FrDB
	 tIfzlFUX63w8PDwZleG+vB3MRrngRHGtF2Ux4svwa+OWVZ5AyiGOx1LfCrltMlAN7vThh
	 jnQe8dZAWzTKZwcgihOPcuL4MURd5djA/nC9sg8dFfEyVdcXpZtWCL3XwIBZa25ujGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HPyX6UM4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660E0606A8AD;
	Fri, 13 Nov 2026 17:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HPyX6UM4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163B71F000C4;
	Fri, 13 Nov 2026 17:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591069;
	bh=jPAvbA2iNJWHWzXUWhtj3K1kgmsggy40kSktIANrYTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HPyX6UM47W4NGAInLXHACq3T6PQpg0OSGaF6Ksj5CeD693x85HP+Xc7J3nXHLBshr
	 Cbkr3/+7uR28n0rB4kdoprhrQqpFEj+M5kcdCoNfCvjD5GAHgUoF8JZgj37Y49/Yhd
	 hRZB7FmYdzxJGIPRpYWHV9d6KjFcWWHdw8Tv9wGo=
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
Subject: [PATCH 6.12 227/670] mm/shmem: discard whole new large folios on fallocate rollback
Date: Fri, 13 Nov 2026 10:46:31 -0500
Message-ID: <20261113153819.564051724@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b058e20bf018a..319830fead85b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1164,7 +1164,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 				if (!unfalloc && folio_test_large(folio))
 					folio_mark_dirty(folio);
 
-				if (!folio_test_large(folio)) {
+				if (unfalloc || !folio_test_large(folio)) {
 					truncate_inode_folio(mapping, folio);
 				} else if (truncate_inode_partial_folio(folio, lstart, lend)) {
 					/*
-- 
2.53.0



