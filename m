Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73DBE56B;
	Tue, 23 Jan 2024 00:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968361; cv=none; b=tH9cbrnLjh3mbAjTBDOQbuIpuy6YTiLsayqQVSunT2zAZOT4DxaeTv60K9FvmH1mXeroqzY+4hFjETjMMfsqnTf38rGxIUa6TTV6Ki2DY4C180wbn36xfZ2OAeEZdJkBIkMQDxdsAKylVPxYPQkCdoQyQfKUDIjeZHUcnAyBHhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968361; c=relaxed/simple;
	bh=NXyfWxtnpEBeRA+WRlHc7Cu9YEG660gYPgABCvhirfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U48SXvadWNtwV8Lr22X2WcBjYUscoWab2u1jk0+HrTR8Bmf6D61w6zcV05MEl8NoZXqkKgZ5RQX2M0iUt8r2VYvY5XccKKAj44Ym2UtRHkC/6byDMgXBwdRbq6txUd9ZXOy0d8mZaV+nyxOBRjkXLLj+PyZEM9wk1IyiqBSWolI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LmEk80OK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LmEk80OK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72664C433F1;
	Tue, 23 Jan 2024 00:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968361;
	bh=NXyfWxtnpEBeRA+WRlHc7Cu9YEG660gYPgABCvhirfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LmEk80OKr6CiowwOy6TElUZ2QfjgNJ549w/ceXhs1g51JhWY+1DgfQ+shfgDJ2Vl+
	 CJdETptMlHK9c/AgOyBAe6Ekqmgrfrg7jTTN6l0qpu8DAXWYrPQ2uwc4qNkveq6aA0
	 2yzpd6IORdau8EfLZ5/MEtJm2Vp8KucvfQ7shLK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 059/148] crypto: scompress - return proper error code for allocation failure
Date: Mon, 22 Jan 2024 15:56:55 -0800
Message-ID: <20240122235714.801846735@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 6a4d1b18ef00a7b182740b7b4d8a0fcd317368f8 ]

If scomp_acomp_comp_decomp() fails to allocate memory for the
destination then we never copy back the data we compressed.
It is probably best to return an error code instead 0 in case of
failure.
I haven't found any user that is using acomp_request_set_params()
without the `dst' buffer so there is probably no harm.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 744e1885922a ("crypto: scomp - fix req->dst buffer overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/scompress.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/scompress.c b/crypto/scompress.c
index 968bbcf65c94..15641c96ff99 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -174,8 +174,10 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 	if (!ret) {
 		if (!req->dst) {
 			req->dst = sgl_alloc(req->dlen, GFP_ATOMIC, NULL);
-			if (!req->dst)
+			if (!req->dst) {
+				ret = -ENOMEM;
 				goto out;
+			}
 		}
 		scatterwalk_map_and_copy(scratch_dst, req->dst, 0, req->dlen,
 					 1);
-- 
2.43.0



