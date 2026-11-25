Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623824;
	b=zzBdJ4xXqP1tm18fXoTsXGFuWkYmCZbbc36/Rh2J7V7IJmNJ/Bm4i0OT1H92pq9rCU8P
	 WQD2aynWV3ulef5W3W5+KN02u/TB/K7UxouYzN9AcskAH2LX3ZHxwI/LR6IP0JKKt6DXY
	 RnIhULNnvGWlaOH6Blle78M1tcNsrz64Ro2VN5YdMxfRy32Rf2sLyIFD5/Z4579mFJMV+
	 1Ow+sohH6HozMqetijB7zWP0fqnImphC5USL+WDkaUdZbxbtoAzAbO99tzL0XPedPvRkM
	 +4YJTwWZY9jpvI6Pcfez2nF4XGBNYaOkPwAf3Xlmb+PRl9BTyVkJ9JWwc3Yvq5ez/4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WQEKMJKAkkXvI51g1h2lRoA7nM5WyB7pKJ7ODLiTQLA=;
	b=sO4IaMcOZha4OW/msn3+gaiSXXT5dbHtAA2ddT+WFqr0ZvIpo6w4tle5LhEfc4DsvMT3
	 tmCGsR3Ym2FG8DCYodByv9wowJIEDXfDpc7hL+o+3eIzAsrOHfhvg3XtOVR1FxTXh8zP5
	 sSUrYBNnEOPRYzH2+elghBoFW80+w113c6K3qsjDY9OmMi/hMlBepV7Dt0XiWjCDwmDlQ
	 of+9ELvYcAUXbCi9pD0dItHCOOcOrYJscbKhA+sR9PIuRertMzZsllZCHCdzJY0QiUc5T
	 k8VH0d4+kQZIUR90EGQfYWB9xV1pEief3EJlxGYtUDvY5esH+Rriyq9rgxCsQ+JlBjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eaUyW3ws;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B31606A323;
	Wed, 25 Nov 2026 16:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eaUyW3ws
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23AFD1F000C0;
	Wed, 25 Nov 2026 16:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623824;
	bh=WQEKMJKAkkXvI51g1h2lRoA7nM5WyB7pKJ7ODLiTQLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eaUyW3wsMidDeXS+od2g6vJgz+rTSlPzYSvEsl/R78GtSuNXKaxVoGXLmJH1lTaRi
	 eycj1Oo15MSl0ImhR41bGKT7D03C2NLg4Cc/i/JOCrbnCzsJnLxaweIwGiUkoD29g0
	 XnhUDa1cLX/gIFeYvMtMB5YE5/b5TV62N7+dbQ9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 6.18 976/990] 9p: fix memory leak in v9fs_init_fs_context error path
Date: Wed, 25 Nov 2026 15:39:03 +0100
Message-ID: <20261125143844.845991855@linuxfoundation.org>
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

From: Sasha Levin <sashal@kernel.org>

commit 0fd76f1be20d19ac593138ceec502cb044c909bd upstream.

Move the assignments of fc->ops and fc->fs_private to right after the
kzalloc, before any fallible operations. Previously these were assigned
at the end of the function, after the kstrdup calls for uname and aname.
If either kstrdup failed, the error path would set fc->need_free but
leave fc->ops NULL, so put_fs_context() would never call v9fs_free_fc()
to free the allocated context and any already-duplicated strings.

Fixes: 1f3e4142c0eb ("9p: convert to the new mount API")
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Sasha Levin <sashal@kernel.org>
Message-ID: <20260225135745.351984-1-sashal@kernel.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/9p/vfs_super.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -312,6 +312,9 @@ static int v9fs_init_fs_context(struct f
 	if (!ctx)
 		return -ENOMEM;
 
+	fc->ops = &v9fs_context_ops;
+	fc->fs_private = ctx;
+
 	/* initialize core options */
 	ctx->session_opts.afid = ~0;
 	ctx->session_opts.cache = CACHE_NONE;
@@ -346,9 +349,6 @@ static int v9fs_init_fs_context(struct f
 	ctx->rdma_opts.timeout = P9_RDMA_TIMEOUT;
 	ctx->rdma_opts.privport = false;
 
-	fc->ops = &v9fs_context_ops;
-	fc->fs_private = ctx;
-
 	return 0;
 error:
 	fc->need_free = 1;


