Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621954;
	b=M5ZMOdS7idT23pJhP5INsEAkJxPVb1RUkug7KfC8w5irUZ7pft8N5hTB8E2JUvcvbHoU
	 1H/Ggc9Kkz58ssS5zdIxqi3XE8NeRaSlRKD48vCtxDyF76j9KGzgCXZ11t11ZmbwnADEZ
	 n6eZja6R7rUFgl5o7/OzAGZ+A0UEr1X8JeaX9m+IyA9IHWym5rBZo6YzByKCNEYviYo2k
	 Y1onOTccFWogDervdcAZiQlHO3Alyviy0tRUlbc777QRFPYhyGDZvmLaepsjw1V1GMRlf
	 z2bsNdXGh5HnjmwjHcnaL4QJcO30GbyxqRjYY3wBNFaZd3TaJItMJZCjNUKBeqe48MA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621954;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jQBex68K2QiXH3Kf/7MEl9XLPhgfuKiEV4NKzI4Jr8s=;
	b=auFwtQjKXvnRUHncdVrhQ6vfKKBX0oIgvH/14gXQLmblA8GM65lcaCFkEexr5CkuZn/u
	 /g+hBsxj/3JhoeYx0FUBNYf3/pMrmU54trI+MQisn/1skGjqvC0AKvOzSy8DAHAj8Doed
	 3pEdX48Nz4Y4r9KSej7+q7071h7FIyUxF2p9DtHVJZcbhkWLeuTYA5ujyjllWJHivNcGN
	 Uf/Yui+kQNgiQ+J8eh9d3PyH8haPlWReZa//znSsaffBtRkLyu9OnyETa6nEV/kKSYDrz
	 FlhszoWXLbB9cYfPoTeckEmo5+GbztJ4/2EYUavdV01TXDSzZnEZolUu1/aX0WOu65w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KPxPWeoD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F293606A321;
	Wed, 25 Nov 2026 15:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KPxPWeoD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB001F000C4;
	Wed, 25 Nov 2026 15:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621953;
	bh=jQBex68K2QiXH3Kf/7MEl9XLPhgfuKiEV4NKzI4Jr8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KPxPWeoDmbhG/8ObEvGbhpvbARltYsLnR/0pKcrhw9p2SO9RNNN91a4qDHRJKgqkb
	 YW/SzqwvfeK3ACCtaP4fZ9ltG66ACG1IwDfhaV/rzE5F17V/EMwjAyGzd4YhRXFE6c
	 BmPslh5OZcpNwY4LzghoXleAjsB+u1NgetT+M9YQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 383/990] NFS: restore directory index when resuming readdir
Date: Wed, 25 Nov 2026 15:29:10 +0100
Message-ID: <20261125143831.064845036@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index ca91e48dc7973..bd35069ffe5cd 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1255,6 +1255,8 @@ static int nfs_readdir(struct file *file, struct dir_context *ctx)
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



