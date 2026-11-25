Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624761;
	b=HJqOviTY0tYFijILMKmQoxQ4eBmFzXVXEgFio5/Q3SP9pwx61nJsa0e3nzOMSqbSZbwY
	 2IQuu016lps65w35nbh12CnuP1nzBhWwEKqZpI3BOytzAkuOyf28Mds7thgZapyUOl6Qc
	 BAecjwv0wjMN0GCQZrkZlIjRWzzJRu6tJElv98eZscy2yZc5OZO/m0egmK2KblsPJ8IYC
	 2L0FBra3A8N2ws5CMELJqaRZJaf3NqQYLuA7iRsqOiQ17/Z0x/UabYa/t+bXaAxLd24Cx
	 sQLhr+NZCoXNHhjgzSvtlwNRdrxgKDVHYehFMyTM38lud0tpsNL4ktddC8j1k9+mROw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F8C3ialbPiiD3ypXIIgsc4Bonz35n0KbppJxm/Oql1w=;
	b=fhnYy9bDC+VamuGciNr6Y4DEwMffmJB9AQtCodyG1/d4qVnddq3AiPzzAIYNsMfeVWDC
	 H6laECtp804fG05kGEW1WO3zArJUI+9A/tz9omPmCV4YGzIZy4n+6dSR6HqNBePUJF+ux
	 P6ObnjaLdx6r/xOvEUtpODvPgqyD7HZTXV2O8+DwqAoNrWY+ELAhG5BSdQ0N6ERNZnd58
	 lvLURWyO0p8f/5cz2Lr43rLXh6MjZFlpiMq70YVClPcki/oMV6JtAKXW1f8x8DHXm+cT5
	 Y+cxzCvsnQvmCcFsGp6k3qag8iqw4c0BP59BoEv7cS3u5FbKIRih4KDxTEk26uJG3dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TZNKR5Ii;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA6B606A33A;
	Wed, 25 Nov 2026 16:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TZNKR5Ii
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F211F000D0;
	Wed, 25 Nov 2026 16:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624761;
	bh=F8C3ialbPiiD3ypXIIgsc4Bonz35n0KbppJxm/Oql1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TZNKR5Ii7wqcuN3AjiuOIs9XNwOlQfj0irrCd0VZ2rpR3x/H/WM+OW5Y95NcfQ4aP
	 cj389D/umcrL4L/3n9LlPod59FQzgkf5lBvm7Se84cLn1ClIsZn3mwhwTVbwFIj8UX
	 S2EthQewpuiiCUC/yvZvSZFu5oUbR298b2NWl03w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 299/816] NFS: restore directory index when resuming readdir
Date: Wed, 25 Nov 2026 15:30:47 +0100
Message-ID: <20261125143856.126941862@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 89b91409b2342e7629b1271eba315a0f06495247 ]

nfs_readdir() restores the cached folio index and cookie when
resuming directory iteration, but leaves current_index at zero.
In 32-bit index mode, nfs_readdir_search_for_cookie() then
reports a folio-relative offset instead of the absolute entry
position.

Restore current_index from the saved logical folio index before
searching the cache.

This solution relies on the current behavior of
nfs_readdir_seek_next_array(), where folio_index advances by
one and current_index advances by nfs_readdir_array_maxentries()
for each full, nonterminal folio.

Fixes: f648022faa68e ("NFS: Convert readdir page cache to use a cookie based index")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 1824cc9040d02..2026cab075817 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1253,6 +1253,8 @@ static int nfs_readdir(struct file *file, struct dir_context *ctx)
 	spin_lock(&file->f_lock);
 	desc->dir_cookie = dir_ctx->dir_cookie;
 	desc->folio_index = dir_ctx->page_index;
+	desc->current_index = (loff_t)desc->folio_index *
+			      nfs_readdir_array_maxentries();
 	desc->last_cookie = dir_ctx->last_cookie;
 	desc->attr_gencount = dir_ctx->attr_gencount;
 	desc->eof = dir_ctx->eof;
-- 
2.53.0



