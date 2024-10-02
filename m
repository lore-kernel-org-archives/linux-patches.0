Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B642F1D0792;
	Wed,  2 Oct 2024 14:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880146; cv=none; b=lC0udt8XM0QIKaIwa3Wj896KDgxkKc6ZF88IGcqKjLy977/5JpYQPWqxw8Nee5NIdfx5dGUcXEU3ZX+kmQ8fgatKpTIY/frExUieoNf+pPnrOgrcavXjRywKIWPEuiFIaYchwBUUUJ7cp7nkHqozavdTpXJresYV6rZ/TzJwW28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880146; c=relaxed/simple;
	bh=FxSJCWH62K/MtQDMOq7E6QfvVPtKqejAx/nq+Dp0nvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXWLEZBRg3qvvEBFI946j9Osep2y3208j0JS2umCB6NvjGQU8HDNHL7hdL6e+Scoj+F7r5Mxo3DsEWfDReVGm5NnihKzPkieSXlEeIpP823SP2yW45YcCQ9/ADf8Er+m91BPu0ns6VylUVlFpPFnGLvlYwJlJvZgEvt3ORECh5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=01hepeKT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="01hepeKT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409B4C4CEC2;
	Wed,  2 Oct 2024 14:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880146;
	bh=FxSJCWH62K/MtQDMOq7E6QfvVPtKqejAx/nq+Dp0nvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=01hepeKT6GPoizfxCbfa9yqS+6VEEl3qW3Ms32ioxgVvNMNFVzA+UpWztij2bvRil
	 7V481ahckEz8DsLk6NEwXJ9MglShqcc05p5jRd83LlaQWoAL/6c44zKurKhK/0z5rM
	 wNOatvDGTmNPhSAg2A3BdVm1+qm5BGz9VyW/IO4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangwu Zhang <guazhang@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 332/538] crypto: caam - Pad SG length when allocating hash edesc
Date: Wed,  2 Oct 2024 14:59:31 +0200
Message-ID: <20241002125805.536773284@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 5124bc96162667766f6120b19f57a640c2eccb2a ]

Because hardware will read in multiples of 4 SG entries, ensure
the allocated length is always padded.  This was already done
by some callers of ahash_edesc_alloc, but ahash_digest was conspicuously
missing.

In any case, doing it in the allocation function ensures that the
memory is always there.

Reported-by: Guangwu Zhang <guazhang@redhat.com>
Fixes: a5e5c13398f3 ("crypto: caam - fix S/G table passing page boundary")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/caam/caamhash.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 290c8500c247f..65785dc5b73b2 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -708,6 +708,7 @@ static struct ahash_edesc *ahash_edesc_alloc(struct ahash_request *req,
 		       GFP_KERNEL : GFP_ATOMIC;
 	struct ahash_edesc *edesc;
 
+	sg_num = pad_sg_nents(sg_num);
 	edesc = kzalloc(struct_size(edesc, sec4_sg, sg_num), flags);
 	if (!edesc)
 		return NULL;
-- 
2.43.0



