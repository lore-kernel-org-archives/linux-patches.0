Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038124;
	b=SavxQrbjURWRj6sOaHASkbnLBs7CLSYu9l/R7bWdKD/yShfm4gmljr5A9eUrM5HXhCdF
	 oigYa7PS8hxjO++8kA6lG5zIzaKqQoBXRMraBs0FfO+HtBvJlEDLBioSpWlDWsucb7i/9
	 upjweiY3EA58QpLYxeZEWsSOpf/yfC7kO5An2a9SHL/dAjYgp+r/ejxQv5xSXmTpNtcy+
	 laGuK3jhIG43JwabzcSzDr0754ib3D1ZchmNkvAdELxwLm6zs8vZ1RwRm6K/qjc0eBVLX
	 jcd4CEDJzj7jX04Xw9Feka7RN/k+7naBukDNHGx1D+XyqPbZAb3i/hnl0DYvfmJoKFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CE5gReciEYm4/agKNgTiEZYtk0IbhOnbWd1suMEhZyo=;
	b=qZ19X0SSIwaUwrrbA560qlW2ol9rQybL/dZOva2F/8MhEcrYBI1HP/ULTJuOfDAqz7uu
	 ccFMlFoGjPSXdNtDBtphy98uVmJvAeHqsMR7R2B8MvIgAaOvdMdvRw08fCflipokZySP5
	 KHD3T2C63BfhX0uCuNl/cADaM/6JEgD8d2/4P/CGbFFaohiLdh5w6iKhukaJ4iA1eLU45
	 J3Ok2zMqJd9S69HJPlU3Z3ZMzKWxyIy8V/vxYedfNelkDKX6jndHN9RqSogyCdpeesLbh
	 Bd1teXCMRMq6voTYVpnaN89tdZNYv0AAppS9ELWSFfqckdShNdNIrVw3ukjnRPCbHeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C7mtbw2X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6798E606A325;
	Wed, 18 Nov 2026 21:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C7mtbw2X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F61E1F000C4;
	Wed, 18 Nov 2026 21:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038124;
	bh=CE5gReciEYm4/agKNgTiEZYtk0IbhOnbWd1suMEhZyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C7mtbw2X5DYBTaC8mDc05uXgy3ixXFz+7uXg5bHVdw07Tjvrl7ijQmPuihGxPXyfB
	 kzhfEa5e745juPMF2EOkvL21SSYsspJRKfWS4j4OU7NyfIUnT317uEnNgdQ78t3oAQ
	 Kkp/cKBhAYQhhnSQZMR7Tbzuztya+eUpV3/wcF20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1633/3318] f2fs: fix to check continuousness in f2fs_sync_meta_pages() correctly
Date: Wed, 18 Nov 2026 15:37:35 +0100
Message-ID: <20261118150410.737854376@linuxfoundation.org>
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

[ Upstream commit 1383cff4ccf3c8833c6255edffa29eb67c6419bb ]

In f2fs_sync_meta_pages(), whenever i becomes zero inside while loop,
below check may be skipped, it failed to check the continuousness:

	if (nr_to_write != LONG_MAX && i != 0 &&
		folio->index != prev +
		folio_nr_pages(fbatch.folios[i-1])) {

Cc: stable@kernel.org
Fixes: 580e7a492608 ("f2fs: convert f2fs_sync_meta_pages() to use filemap_get_folios_tag()")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ sashal: adapted cache-entry handling to folio batches using folio_nr_pages() for index increments ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 74bdce66f866d..ff8d336c8bffd 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -406,7 +406,7 @@ long f2fs_sync_meta_pages(struct f2fs_sb_info *sbi, enum page_type type,
 				long nr_to_write, enum iostat_type io_type)
 {
 	struct address_space *mapping = META_MAPPING(sbi);
-	pgoff_t index = 0, prev = ULONG_MAX;
+	pgoff_t index = 0, next = ULONG_MAX;
 	struct folio_batch fbatch;
 	long nwritten = 0;
 	int nr_folios;
@@ -427,9 +427,8 @@ long f2fs_sync_meta_pages(struct f2fs_sb_info *sbi, enum page_type type,
 		for (i = 0; i < nr_folios; i++) {
 			struct folio *folio = fbatch.folios[i];
 
-			if (nr_to_write != LONG_MAX && i != 0 &&
-					folio->index != prev +
-					folio_nr_pages(fbatch.folios[i-1])) {
+			if (nr_to_write != LONG_MAX && next != ULONG_MAX &&
+					folio->index != next) {
 				folio_batch_release(&fbatch);
 				goto stop;
 			}
@@ -458,7 +457,7 @@ long f2fs_sync_meta_pages(struct f2fs_sb_info *sbi, enum page_type type,
 				break;
 			}
 			nwritten += folio_nr_pages(folio);
-			prev = folio->index;
+			next = folio->index + folio_nr_pages(folio);
 			if (unlikely(nwritten >= nr_to_write))
 				break;
 		}
-- 
2.53.0



