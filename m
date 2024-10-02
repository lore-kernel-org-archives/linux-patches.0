Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0A21CF5FB;
	Wed,  2 Oct 2024 14:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878382; cv=none; b=EFPNjcN+xh/YH1bG+ppPR896mJ4cUarTFhF7DsZuGagW8f77C4esfxnXOUMZW2+Ps93xc9FyDURm0UYb1VP72MUraWSGjiLG7BTKQeJ2jzfGSiYt0imtFzMXXFXA8DA/77m33YoaRXt8hNVs/qiz2GRr2GvaOqeVgs43LknFeQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878382; c=relaxed/simple;
	bh=IX7FOI7w/CsS9RnBEP1WfHdtnBPeVdUVK5+4B+QXWf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3fusiIEKy0k5l836Y0XGzW5N5XJvXVuYl0L6adFKaTKzBs/bPTfo2E4PodPJLDjXvqB0AKR2AYU2KR1qsBUQdqKdOLE4ROzDV37ZX3/Jxa+RcchDvb31oT04VRA2IfF/+kwBVOzMhJqSEe28qqxUgAJBVuUFgYH23g6RHIhQ5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t4tagYUU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t4tagYUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA6FC4CEC2;
	Wed,  2 Oct 2024 14:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878382;
	bh=IX7FOI7w/CsS9RnBEP1WfHdtnBPeVdUVK5+4B+QXWf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t4tagYUUaTbajuGYBIsQQGDeSHYW+nJLsQMoVMuaJhbMrWaYYEHj5aUvFxz4RKGAS
	 W7+0lZseSen8hBrcB5RlqG8yMGZj8UOWMeKJoYkR9saku+NXkrNcW28Q9HYpVKblxL
	 q7e+rYE7sPrqQ8IYB+GvMW2QKuTTKvpfDFPBYG08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangwu Zhang <guazhang@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 394/634] crypto: caam - Pad SG length when allocating hash edesc
Date: Wed,  2 Oct 2024 14:58:14 +0200
Message-ID: <20241002125826.656025713@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index fdd724228c2fa..25c02e2672585 100644
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



