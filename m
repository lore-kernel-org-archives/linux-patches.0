Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626374;
	b=Sbyg0Q+VXNAIAcMcbb8GwHALEu1Qxam099MheM959vTe/aQHN7HhlyIdDGaC8CnEyosM
	 vlBSsI05Cw3Q6I9BuaLiq9X1vLfo2JjINeUYu2APtUQ0gLzzFlbtSdvqHqzGSyKVk4tuM
	 klDbLa4AFq9mMEuGp7AqmvyJldQ+5ZuUrbPfIIj9bvIk+7pObup4+HAvEePhbgt7F7ZXM
	 eTXGYnu5XeROL4sX+hUKd+2n0PyIiNmhXrE/BE4EYxAyytnIrMEmrixSLDlk0+Ufaj7GO
	 2bzEF8fa1V692FljtXhUyi8juMkJtAnoqCJwBUMf7mhIU8W2GVdHGnviFUXr6qROOOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626374;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kyBdlZOD8/ecoIDpwHWs2JNhzprwW4P683GDZFfwFzg=;
	b=AkKk5PZctNFZVaFxSprS6WpGQuhLMGasZLWIVYZ9aB+x0PuukEMGWnTpRTm2ZC9mVrck
	 W2Dso2lYUKxsi91DMQzkamaFgJSqZ8dHk8XEgsWfr67InFj5mSkuthaiUKvSA2/OVfnXR
	 yd3sEzj5vT2NlKD2EyF82ptS992LnYBBKWyF16HIdw0kW6i4Iz4xySKFcZJdGQmFAzZ/H
	 nTVIxKVt6bPpzSJv3aP/yujb1R5ztwr/CJXgNdqUPH+8d+UwA2oIDwianRzjoCcWdKkOm
	 2prVO4sbzgpNLO8Ag85+7+lzzQ6RBtwIeOEJlzF68cxzlSg6yv3OjUIei5/nP3e6Z8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QilR4UQh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E423F606A329;
	Wed, 25 Nov 2026 17:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QilR4UQh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9C11F000CA;
	Wed, 25 Nov 2026 17:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626373;
	bh=kyBdlZOD8/ecoIDpwHWs2JNhzprwW4P683GDZFfwFzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QilR4UQhXMPPHUcLpCQxlJxXgIsNTQ+91dGK9TpckCBq9trP81n1GByF4gcJrO8r1
	 vXHFn+IEWdf52XSZi2gewyUwL9g22Niwj2J/VWiWYCV2w6fpBE7BuJ/JhEWnzmDi+i
	 081AoluJmvTUMQYw0cIvJlhol4Wmcw+FTqQn6jiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 6.12 807/816] 9p: fix memory leak in v9fs_init_fs_context error path
Date: Wed, 25 Nov 2026 15:39:15 +0100
Message-ID: <20261125143907.849881092@linuxfoundation.org>
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
@@ -310,6 +310,9 @@ static int v9fs_init_fs_context(struct f
 	if (!ctx)
 		return -ENOMEM;
 
+	fc->ops = &v9fs_context_ops;
+	fc->fs_private = ctx;
+
 	/* initialize core options */
 	ctx->session_opts.afid = ~0;
 	ctx->session_opts.cache = CACHE_NONE;
@@ -343,9 +346,6 @@ static int v9fs_init_fs_context(struct f
 	ctx->rdma_opts.timeout = P9_RDMA_TIMEOUT;
 	ctx->rdma_opts.privport = false;
 
-	fc->ops = &v9fs_context_ops;
-	fc->fs_private = ctx;
-
 	return 0;
 error:
 	fc->need_free = 1;


