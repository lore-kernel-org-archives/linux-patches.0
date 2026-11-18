Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054326;
	b=ExFeamFPhUovyfu9fIx7PufbRzskyqy4Bhx4NfoOYebpCC4Ktrl/T9TxlDedRYv9bFq/
	 EuK5IXgUu+T8hzcLwJOjF4fJfGl2CkMm60jm/bwsnLfR20ud0RdNaU79b/I0+d2K8ooNa
	 4yrp5hyRrmMuwS5cQ3nJeqZYYKeBXIb2YzwISc0Y7N2GLronFVrjWfPnPXa5envsyO9Y8
	 mglyHhLpx/x36SJj/zTKqgHx72NtG5lKKRelvTOjdtTg9g1aNZ1dbnkdtaPe5+yY6Cm+F
	 F8RMOsMB/yux/rQpPLBgg5ySRpl8nYTasNwzHxL7/+PZNbuHUmz4JtGb9DEhdvoNWhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054326;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KgOcka8yEry1AAqJD63uFXq1o/Z2qNvBsuUwlAIGTlE=;
	b=3hiRQ2voBT9R5qffp96JacdZzsMC4bz1ZYWWUsjeGhg3NTu1h1K/oXHxJ+TzcERoY1ek
	 4+5PWQQt7uG3fDr/1IHpU4KZWeEBHwMlJhabj5huovoV5LPtT9LP/MeBHZAFtHHemAgD6
	 SKAgjT/M3/dVqslEdLqD0Ljv/njdnVEzCse7gxKEYZHs+WiT9H7iRvzhP/k4nUTDItt1f
	 A700PqLqdWsYMuHcSXE1+OIIDBwGRy54R0iTK9bYjrdygsodBH4fcb09Da4znLjQBx6wW
	 v/xJr0d+At1qoZxNuLE4sp41MAL3clY38RU7oIw3qFssk9dNK/XFEQPpbQTUjrRq6gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="x/JISPDF";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3323606A325;
	Thu, 19 Nov 2026 02:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x/JISPDF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD861F000C4;
	Thu, 19 Nov 2026 02:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054325;
	bh=KgOcka8yEry1AAqJD63uFXq1o/Z2qNvBsuUwlAIGTlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x/JISPDFn19/be/9p6ij9mBv8vR99zVPrPMhT4v89qle69VpaR8XgKfNFGfvY1RTb
	 409eS/cjzaH2q5nNBLi9YzEqlRS0mLr+5LgtrTj87WrAsbnmBk0u12IaWv+Aq5jnlQ
	 kZmqfgOmIG9rr+ZU+0khJAZJHF4xNtDY4LD85QJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1234/2214] f2fs: fix to fetch ino via ino_of_node() under cache lock
Date: Wed, 18 Nov 2026 15:48:30 +0100
Message-ID: <20261118150101.107236742@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit cd6d8b1891395b681f2060916a4b83880b765698 ]

In f2fs_writeback_node_caches(), it's better to fetch ino via ino_of_node()
under cache lock, otherwise, node cache content may become stale after cache
is unlocked due to racing w/ truncation.

Commit 493b9dc8b52c ("f2fs: cache: use node cache") fixes similar issue in
f2fs_flush_inline_data() introduced in commit 34c061ad85a2 ("f2fs: Avoid double
lock for cp_rwsem during checkpoint").

Cc: stable@kernel.org
Fixes: 2049d4fcb057 ("f2fs: avoid multiple node page writes due to inline_data")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ sashal: adapted cache-entry handling in f2fs_writeback_node_caches() to page-based handling in f2fs_sync_node_pages() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index cd2ffc8e1e94e..24b49cd174571 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2025,9 +2025,11 @@ int f2fs_sync_node_pages(struct f2fs_sb_info *sbi,
 
 			/* flush inline_data */
 			if (page_private_inline(page)) {
+				nid_t ino = ino_of_node(page);
+
 				clear_page_private_inline(page);
 				unlock_page(page);
-				flush_inline_data(sbi, ino_of_node(page));
+				flush_inline_data(sbi, ino);
 				goto lock_node;
 			}
 
-- 
2.53.0



