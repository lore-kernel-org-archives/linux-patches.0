Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB0413C8E8;
	Mon, 18 Aug 2025 13:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525323; cv=none; b=F9OAxhE1qzjNqQS6wFIqltsY4VMbYsTbo8CQWbfmvC632Vax/z9Gh1sxC+yfGvrDy3QcrYgTE0jEixszq60tzb1nAQ6nn5vpr9m1wGVUrbXSiVzQI02L7P6mMME/anVXYHyYBoryug8dcbYh5pW4T23/oPR6uz2vEpQp+yZjF2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525323; c=relaxed/simple;
	bh=pSEluvsubI9+ypkGAm+0tAdG4XkukuDjBuUEKRT57zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AbFmgn9UIoFPPenfmOiV8umjLs1/E33mc6FntgGo7l9UXYpBOJz14qYQruDTxXGGEX2WAPnI9H2U6kHdl52xPLU5p52mBz13UrgU7jb5WOmAAr3EuVoMewwvu6gX+1nDM+4IiL9DP7DWRmVCM8BAtBUvLIs07nFUVGgwSFlof9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D2sKYegC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D2sKYegC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56554C116C6;
	Mon, 18 Aug 2025 13:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525323;
	bh=pSEluvsubI9+ypkGAm+0tAdG4XkukuDjBuUEKRT57zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D2sKYegCN8pTLbIaTIsOocDfPowXpe2L1x3xa/s0j17R54vrfuyE9WylHLDCUfbym
	 AjZ+4raqlZ8AtXYli3+Rs0rQol14CuOxtSk+V9iHQrATbofDwDxEQXfnXuiP54qaRD
	 cr4GdZoJjaCJEc9Df9z6S7FdeLUjiqjWYqgWKM5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matteo Croce <teknoraver@meta.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 227/570] libbpf: Fix warning in calloc() usage
Date: Mon, 18 Aug 2025 14:43:34 +0200
Message-ID: <20250818124514.569615426@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matteo Croce <teknoraver@meta.com>

[ Upstream commit 0ee30d937c147fc14c4b49535181d437cd2fde7a ]

When compiling libbpf with some compilers, this warning is triggered:

libbpf.c: In function ‘bpf_object__gen_loader’:
libbpf.c:9209:28: error: ‘calloc’ sizes specified with ‘sizeof’ in the earlier argument and not in the later argument [-Werror=calloc-transposed-args]
 9209 |         gen = calloc(sizeof(*gen), 1);
      |                            ^
libbpf.c:9209:28: note: earlier argument should specify number of elements, later size of each element

Fix this by inverting the calloc() arguments.

Signed-off-by: Matteo Croce <teknoraver@meta.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/bpf/20250717200337.49168-1-technoboy85@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 6401dd3bd35f..8fe427960eee 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -9221,7 +9221,7 @@ int bpf_object__gen_loader(struct bpf_object *obj, struct gen_loader_opts *opts)
 		return libbpf_err(-EFAULT);
 	if (!OPTS_VALID(opts, gen_loader_opts))
 		return libbpf_err(-EINVAL);
-	gen = calloc(sizeof(*gen), 1);
+	gen = calloc(1, sizeof(*gen));
 	if (!gen)
 		return libbpf_err(-ENOMEM);
 	gen->opts = opts;
-- 
2.39.5



