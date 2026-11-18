Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022500;
	b=LisWXb3sqB8KqjcxTxs34OWYuwIIUQ+/O10sD4KI/+6Hep2HUpJCm+ziiH87h2OPSC82
	 TB95teKup+DCcrQasxvJwgnIU15/lJIOcaB738Z8EiWF0fpIx2xH+eWDEJHgQXetyYjHy
	 UQCdsMGHYTUEwRUNIZnW/JC/5wTuDRVH9J2PeWu6+bj0EDG0OanEH/miNgLyeIPJgwJAy
	 /KptyyH6RUgjHN31hpZ/VjA9eSxuNEw/VLjLxzUOMiHYnvSmF1G8KsCoPvUhTNQcJHzI/
	 wXpOuIFEpTWWX/8haT0aCTydFcgKuNtIJ4fxw0azjfViePKmn8BvaGNwzeeJmUgsVBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022500;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=21vLpaBW2scw/5KkIvaWy4gAgznNJ6iJNG/6jgS5UiI=;
	b=Y66iERQlQzNPVAZmk7S7iHpBHM/rK4OVF8yGeiUOzUXZOCJp6HHUmHyr+EShS0YcYJsd
	 y50lcLo9QfN8+YF3Oiesyq8xQ4qOn3Rio83gj6kKY2yt9rqvdptBD0B9NbrUoTWLJEnmp
	 HxAzQJN0i1F/qtwCpEXmr9bHsy5lO/24OCmMjQ8o/rFFQ6CfvZFnCtGicM3x3Y1pAoVMS
	 ujLKVO7vvOeWn8rxPu/bkhKYEJL5eqyh2P99qQAggKFQpXomPeT6KdMLJfLqT7uN04xlE
	 zsGWO5rcbwcbU4gVf1s8BiNZXluUlhwaZeVSbya4gMqzdEfjkYOEz0GgnfwNcVDjG9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UPnDvVoc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9581D606A32A;
	Wed, 18 Nov 2026 17:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UPnDvVoc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC2F1F000C8;
	Wed, 18 Nov 2026 17:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022500;
	bh=21vLpaBW2scw/5KkIvaWy4gAgznNJ6iJNG/6jgS5UiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UPnDvVoc8fXdqmyAbEwwJBHG9j/o440mDBxrCbATtkmtfXB7l/7uCXKuv3xJC6u0m
	 JDfa4zGsA3y9u9j7GkkxqL8+9Y2DnArOdx8Un8XVIwtpGf3cb2H3E8AePfhiJbfmHA
	 nlHqXoCSGvOCV7CBzLGgw2NPbthbq0YLx81bVMaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0034/2151] f2fs: fix to fetch ino via ino_of_node() under cache lock
Date: Wed, 18 Nov 2026 15:29:29 +0100
Message-ID: <20261118150122.898660601@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
[ sashal: adapted cache-entry handling to folio-based handling in f2fs_sync_node_pages() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index ad59d52f17aeb..25e6e3c4bf01b 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2167,9 +2167,11 @@ int f2fs_sync_node_pages(struct f2fs_sb_info *sbi,
 
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



