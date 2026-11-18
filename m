Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795014991;
	b=vpOe5CkW9XDvhwDQSC8kSN+PdivxApC0a8+YZn8M63LopGq+zacXAMGu47KjKFajwr88
	 34u2y01pCMerdWtanxLYdR2gX34CXCE6HYMOvXB+0lwo3uYBlIJuUb/n21O1EdPHEy9Ao
	 4qyQ81qRz+PDC0PBmZgMdin6GnzIOsALufW9NDkhnYnMDkv32ADOXGvWoqk143EiS1c1p
	 GyM9jC6AoIkVNNVm06E9SGltstGaau1eXYwblXRCwU6W5Jkj9DmI8FrTKmBuoVvJZq+IT
	 /rHqOkShMvsOPu4wljSPuLOpDIEa/3JiOpol4XujyPA34t0Mx2mbj4CfGxUdHj6RleQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795014991;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+w/Pcd8wJr7m5IvFwEPHIYDeN78TSlyzA6HBjZZAcLg=;
	b=Zs7SgOkWV6x68IHXder/tgIve4OH4hvesLQMlHxRPYs4pjS0HqM+V36eWyR3XIMoX0Ol
	 LCxnbDiu4tLeCBjEIdza5CNSvbeKekJzyA3gA8fAMn9ciL0nvVXuQ5Lt8C4XVyjFrsGK2
	 pARNegM0KLQid/GZirKa6COepTt0UaQSNYyjV41w51guy2rrlNUXkTZq0a2UjaNUjuhWe
	 ylRZh9HTQ5ns6iLMn7Y2WbALzd3GeMHuV3ljKu5RcCiHolucG4pf5FOZAYYQXOhZt0+vN
	 uF4uSwEMi//ZNthw6AvEgI7oKXWT8L1I2VpbWmUgAXd1RlKSsudOOqNJibancHf1tug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y98FjQ0Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6679606A320;
	Wed, 18 Nov 2026 15:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y98FjQ0Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FEB1F000C5;
	Wed, 18 Nov 2026 15:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795014991;
	bh=+w/Pcd8wJr7m5IvFwEPHIYDeN78TSlyzA6HBjZZAcLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y98FjQ0ZRiSe6nkF+9Zeuqq5qHhjk7mEHBCwPGhbQmWlMlUcX1ncJw4gcZiTcqN3b
	 xZc4VxhLGtZ5iMKBlYfwMExRBCOhUiZ/AXxYrsAN7Ua5bImHyzHT2AmW+dZZSg6nyw
	 nJiypqAllnuHcRO8ALHJsDnzrppqElHtea1gnpCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0014/2651] f2fs: fix to fetch ino via ino_of_node() under cache lock
Date: Wed, 18 Nov 2026 15:20:54 +0100
Message-ID: <20261118150248.509664981@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
[ sashal: adapted cache-entry operations in f2fs_writeback_node_caches() to folio operations in f2fs_sync_node_pages() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index e166c5a5d1703..dff42b74d66f8 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2195,9 +2195,11 @@ int f2fs_sync_node_pages(struct f2fs_sb_info *sbi,
 
 			/* flush inline_data */
 			if (folio_test_f2fs_inline(folio)) {
+				nid_t ino = ino_of_node(folio);
+
 				folio_clear_f2fs_inline(folio);
 				folio_unlock(folio);
-				flush_inline_data(sbi, ino_of_node(folio));
+				flush_inline_data(sbi, ino);
 				goto lock_node;
 			}
 
-- 
2.53.0



