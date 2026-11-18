Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046287;
	b=OBXjpsqKgH/f2TRXBJMgVLYtYZBpIwTHzJaSy0/MYkhTca/2H02sGKtTXDdl+fZKEBxX
	 w2QzjMyRv8N3I2WCTE1qwWSgQuAPIzk/mnIgfU5Tmk3xViMrEcF6dQTcY5Nzq0CgcBYMC
	 woN3BdKEFtA6/3IGq9LS+55IIvAyFwVDpMkEs1PV67EJKRNK6+luqjYQEueVSSoN+YIf1
	 aTJNJSz1ZEGCjOBW/keLpW7uOYhVVwL9/hkzso7pb5BTJfv06BRytfEfirGuPzX8btWu9
	 ChPMIvDW7RM8UlkwpH6FS449FtJWprDsSxNUUiKC9KQeJXjaYguzvPQ5cZu/fTMZ2GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046287;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PQTJ7VJsdEKf2qvQGNjA0v56fetswOIZ99/y/I4wIz0=;
	b=F61RL4E2xHb48MHseWgcEHWDASdVFLOLjlZKI4GDd4ON+OPeDCKi29RvDBiKjiasaRWB
	 5GQXpgDSLIEnplxmb+MACod4reblsmTEPHBZahZxnM1TuNgg3eFLDZNvbzrhk3caClp6m
	 zSChsTlIoIzYDAlCfXOT49SJ1BiH2Q5XbppIvMAAZdN5h9qrpv33/gsAMxEaly4xKp35/
	 C9yyQ+OjvqEkT5qS2YGYWnA7PCWc76aPcEqUUiuBrG8b4fSck2lE+wBeRy2JhbUueYEpQ
	 2dvyak3w6dFz92xtA3g05PcQ379AzZ+L2svfUPiLf0K6caNC9GWJFG1S+95R1vwI4Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vklWgdCR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740F2606A31C;
	Wed, 18 Nov 2026 23:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vklWgdCR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB4011F000C4;
	Wed, 18 Nov 2026 23:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046287;
	bh=PQTJ7VJsdEKf2qvQGNjA0v56fetswOIZ99/y/I4wIz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vklWgdCRr77x6ZiUoKc7zyYVxErpJ+uX+j6/V4iEYErWAdVwUpWtuFawYB4gBaL/J
	 CZevYS2uE8uQAJ4INpqaG3Kr723flfUqD33aQYPAGSzNACkzuYEvSQ7L4UbU5bomK+
	 Zggx9AuQXwO0GBJzGN+uUIDGTR/4jCQx6YaYb6vQ=
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
Subject: [PATCH 6.1 1227/2857] mm/shmem: discard whole new large folios on fallocate rollback
Date: Wed, 18 Nov 2026 15:37:41 +0100
Message-ID: <20261118150245.743231160@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d277144d15e13..be1a6dc9a3dfa 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1043,7 +1043,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 				if (!unfalloc && folio_test_large(folio))
 					folio_mark_dirty(folio);
 
-				if (!folio_test_large(folio)) {
+				if (unfalloc || !folio_test_large(folio)) {
 					truncate_inode_folio(mapping, folio);
 				} else if (truncate_inode_partial_folio(folio, lstart, lend)) {
 					/*
-- 
2.53.0



