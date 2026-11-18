Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038826;
	b=1xMZ9aMQFX1kd73icjrSlon6MVTPOBWt40cjmCTmeXWGBZwRlTvqknOr45UJI+9Oobaw
	 vj3CbsQGAKI0Qah09VApjkIpdmlK5ox18bvT/3uRXveJI9Pb0KZcuwdIIS+FtRme0wvLD
	 IYkwpschCT+742FgiToSLEfyPYvPIbSjsXYaSvQJc7xHtrI/3qFZC/wsF3bZlk/NF9ZCW
	 gKTEViOWWYBI/vGsKaRv7MJiyJE2zKumV2wnG9qTfuGq0R8iH8WPjqyfnpg/1mMaBkVtm
	 rp9G9auhx+6eeKC8uWG/Spb5pOVxFg5bQfuVVg+DibxLDpEpokt5e5xHkpYL3QjQD5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038826;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NiajgWqGAXnHNa3vNE3u7sKNkFKyHF1qUvban+cCqGI=;
	b=iCA4bYwT0BUzsyNAqRQpTFmwoXbVEFVlgogESc48gfZdDsQcvjBDqnlYWz59/S6YZpdM
	 /E5KKvMZTigBo+lBNrzvOObzTMYLlLV3A2+xAfJbPSsitXA+kKZXbnXNKYAHE7kIBode7
	 t1iB4/cJ2liJ2FAH7shWLaWaFRE1DvDwywl/yHyneyVgd45pq5Q2g1dzmPzYgppLMyme4
	 A1cOVqEw9+EMoHnPbvixHBkKFwgC8m1S4ZIaQcWt7h4iIClVoF2bxmJffiydIX3m0m9lx
	 yGpl+JLJphfRruaS5ThAL+lGuLJn7GRebMagsZMsDpG6qwIrCQeit2STIrBq11IifVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pyyy0yEM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A546D606A32C;
	Wed, 18 Nov 2026 21:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pyyy0yEM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078031F000C4;
	Wed, 18 Nov 2026 21:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038826;
	bh=NiajgWqGAXnHNa3vNE3u7sKNkFKyHF1qUvban+cCqGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pyyy0yEMet6ffr3+eix5+/GlN+55tkcMoN6YW9GUb1VJ+CVmkdU8UR9nzH03Uw3pd
	 g3DL616DSaaywRTHwRZBzCJLRTEgBRkDmZwYMvS/lnFh8xGynCPLHsN4QSP4FftINa
	 4aIG7xEzYW6ATQ9b2pcP17AfUaxzKSrHkugZTKQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1882/3318] f2fs: fix to fetch ino via ino_of_node() under cache lock
Date: Wed, 18 Nov 2026 15:41:44 +0100
Message-ID: <20261118150418.447617823@linuxfoundation.org>
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
[ sashal: adapted cache-entry handling to page-based access in f2fs_sync_node_pages(), using ino_of_node(page) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index c57d89f3664b2..f4422790923e7 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2088,9 +2088,11 @@ int f2fs_sync_node_pages(struct f2fs_sb_info *sbi,
 
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



