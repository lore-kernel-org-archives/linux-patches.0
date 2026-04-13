Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B931D5AD4;
	Mon, 13 Apr 2026 16:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098212; cv=none; b=iizpokAvLYD5jBm/huVGbrzizDNEC+7ZKSBbCIDjH9b5RoMYN/qq2ytwnt8LUEoagqzU2bctQY/IMbz+uMaGfVl8AHznKNeqbf9EyG3TJqW8Zgwa/Mzo/psmjQchIna0UdDIqCQ2ej9KsLClOw99+t8wUr8fbFH9ZSob7Efdh/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098212; c=relaxed/simple;
	bh=6kAjUKiMFTSODBFwZJket+lBZkZd6hdF0o9iWKYxWF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJcWcIfSjHhVFEo+vRYT6Y/KuK8iYj/4djHbO7K93fqy/pOeT9xySbTmuHi7d1k9moS2BKm5wNkIb2HuUkXankZhEmYtevt2iB/xQW1hZE2PkVgELh2enIcDiNcnhIyWvOrOQL7Jca+kInHnZcazCb+YYVNETIJ0+3NlkIV/rKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nEh290H6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nEh290H6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A588C2BCAF;
	Mon, 13 Apr 2026 16:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098212;
	bh=6kAjUKiMFTSODBFwZJket+lBZkZd6hdF0o9iWKYxWF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nEh290H6pkVgGLkSt4dDZ8a0c3KaioTI+VnxxTIk6wlfubH5s4p+LVScWvw8cRZDf
	 xIBMduAC7noU4xvrP1KBxezR+kBo9X2+AeN+fsSqJs4x4k9/A4W+NxM0iaEpzyLNW7
	 j6WDkktWXr/NkJWQ2j95pcb5vJJFXBvjCmRQnGX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 405/570] crypto: af-alg - fix NULL pointer dereference in scatterwalk
Date: Mon, 13 Apr 2026 17:58:56 +0200
Message-ID: <20260413155845.639993339@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Norbert Szetei <norbert@doyensec.com>

[ Upstream commit 62397b493e14107ae82d8b80938f293d95425bcb ]

The AF_ALG interface fails to unmark the end of a Scatter/Gather List (SGL)
when chaining a new af_alg_tsgl structure. If a sendmsg() fills an SGL
exactly to MAX_SGL_ENTS, the last entry is marked as the end. A subsequent
sendmsg() allocates a new SGL and chains it, but fails to clear the end
marker on the previous SGL's last data entry.

This causes the crypto scatterwalk to hit a premature end, returning NULL
on sg_next() and leading to a kernel panic during dereference.

Fix this by explicitly unmarking the end of the previous SGL when
performing sg_chain() in af_alg_alloc_tsgl().

Fixes: 8ff590903d5f ("crypto: algif_skcipher - User-space interface for skcipher operations")
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/af_alg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 658d5c3c88b7b..631ee6a220d5b 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -515,8 +515,10 @@ static int af_alg_alloc_tsgl(struct sock *sk)
 		sg_init_table(sgl->sg, MAX_SGL_ENTS + 1);
 		sgl->cur = 0;
 
-		if (sg)
+		if (sg) {
+			sg_unmark_end(sg + MAX_SGL_ENTS - 1);
 			sg_chain(sg, MAX_SGL_ENTS + 1, sgl->sg);
+		}
 
 		list_add_tail(&sgl->list, &ctx->tsgl_list);
 	}
-- 
2.53.0



