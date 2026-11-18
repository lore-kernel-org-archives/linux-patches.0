Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021188;
	b=vBAkMYhOWuJCUGVvN8RWDjgFhULF8Ewu9rkT99CTTfYDJP3Kb/DeYFxnrG1MaL3jm2Uq
	 7A1hdFazkXfMXpro4dtHDY12EBnoPbXMaueFuEUCpx4xqnP3+Ii9py4IWBoMN9qQ8g/mh
	 V+qhrCSwDGktQ1ccX45bHJ9ymKj2vaE43Pecdk8nhorZw91comwznqBr84tcti/GW688k
	 PU3Ysr7Hp8bX/fdIGFlt8Q8yj2e3idTu0ZeP2921TvbcSGcy15xeUwVOLVVA9ZGycoetQ
	 IXuhH1hXwdhGf4EbGY3OIoz/lrlZlD7IDkeEzWRoizVLgncYud07a6AvbAQ9F5gLeBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SrnSz4kBzHVUF32UsRvw92YSOdQ+gZwknR4I/N962QU=;
	b=aUfWanX28hudLj82tCtQgyJ2BwNJqASvPjSmszlXguFf4kH1rjsbI6lEVCpFn3Jz7cMc
	 QfPryfE3tBUsBd8tCeevyK6q/ZmvXUZCyPNzMzBGM5+Gvn1eAe8OHY3VYofVUiTGLDR6/
	 fHhvnNsIf2+oF4PPAb36ofJpha+Yo4cUay5R7920quV85xBrvdIuoh1QjaNRnLzAf3Xar
	 NQmDXR8XUoUQcemxTt4id+xGJu480h9ggYm9jCNhnQdwSnOrTJQSVY0JIsbZJLDdz90he
	 r9GwZHf2/2LkTkMgFd4p7u1VPnAdI3HKXVCtxGCxoN/4Irv+MVA6CotOX3El08wbrJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OKL+OSF8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6047606A32F;
	Wed, 18 Nov 2026 16:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OKL+OSF8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39091F000C8;
	Wed, 18 Nov 2026 16:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021188;
	bh=SrnSz4kBzHVUF32UsRvw92YSOdQ+gZwknR4I/N962QU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OKL+OSF8Aul7EzcGkm0q5xW12VKlN16l7BAHs1NG/GUG8LW0JY6mPd8lj/kHUFKLW
	 yWfRhpprafDd0oEhUB9aN4V4aDIRnCwxEr3gSFdXnawOAtG0WYOlHXN51g4ghmgla/
	 wA9aop+V1uOnYusQwteSqs16lieyaojjrfkWLWyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2217/2651] ntfs: do not refuse fallocate() when the MFT zone is empty
Date: Wed, 18 Nov 2026 15:57:37 +0100
Message-ID: <20261118150405.422464266@linuxfoundation.org>
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

From: Matthias Goergens <matthias.goergens@gmail.com>

[ Upstream commit 540fe7e8cf432a7de22064a50bb8c33d1240c1e9 ]

ntfs_fallocate() fails with -ENOSPC whenever the MFT zone has shrunk to
nothing.  The cluster allocator gives the MFT zone up when it cannot
find free clusters elsewhere, and nothing restores it before the next
mount, so after one such failure every fallocate() on the volume fails
with ENOSPC, punching holes included, however much space is freed.  The
allocator failure fixed by the previous patch was enough to get there:
afterwards a one-cluster fallocate() failed with ENOSPC while 123 MiB of
the 128 MiB volume were free.

write() and truncate() do not look at the MFT zone, and
ntfs_allocate_range() already fails with -ENOSPC when too few clusters
are free.  Remove the check.

Fixes: 9c87959601e8 ("ntfs: update file operations")
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/file.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index bb8b5613c7a5f..20b6019e6bd19 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -1163,9 +1163,6 @@ static long ntfs_fallocate(struct file *file, int mode, loff_t offset, loff_t le
 	if (!NVolFreeClusterKnown(vol))
 		wait_event(vol->free_waitq, NVolFreeClusterKnown(vol));
 
-	if ((ni->vol->mft_zone_end - ni->vol->mft_zone_start) == 0)
-		return -ENOSPC;
-
 	if (NInoNonResident(ni) && !NInoFullyMapped(ni)) {
 		down_write(&ni->runlist.lock);
 		err = ntfs_attr_map_whole_runlist(ni);
-- 
2.53.0



