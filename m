Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABCA38736D;
	Wed,  8 Apr 2026 18:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674371; cv=none; b=mbbgOQiMFxzQ0jpodPHZirx3pZqIv2DHBYG8o3sZ92ozSIRa7bLCns5J/Zi4s1zzRBzO2v6huEEXmqgekrGsNiJUvgiCEsYdyLKqYyHrh7SVyh+cr7Bj3xUrCXjtSpH1jio9uxDdIG1zFulE7kHTYqvOQLljmyz4Gg4DhVIcKPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674371; c=relaxed/simple;
	bh=MeuH0L2RJMYEcLveSRT88idnNiEdZxmpojaH1inIsQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bb5IwNBV2YvH6A/69BYiVwxFTOPgH0IkP5wHw3e24Wml6SMG3i4OXtkIixhQ0Vm/5nIHqxbnV728/n3K7qR8Ny6RDkjKc2CcVg4DixqnF9Fn5PWvyRbI/BEQft7a0lT3KxF92pdDnLj5EVahfd/RUXbAQNF7OEmdHDRCrDg5xrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xoomqg9s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xoomqg9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C33C19421;
	Wed,  8 Apr 2026 18:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674371;
	bh=MeuH0L2RJMYEcLveSRT88idnNiEdZxmpojaH1inIsQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xoomqg9s8Q2k1IvwZ2tREElH/qb0fAtiA6GJmF+uhKIsytX6b1lWL6RYTmMXFuQ2A
	 goZwwuFHe3P9DLOJ4W52lhhaMx42szTG3oyK05XgtqTH+QZxZ+YpltCmEXmXMHs8ds
	 4Cpi6lToBH1df8lX8jyT6poaIyXhOvufslesvBn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 039/311] crypto: af-alg - fix NULL pointer dereference in scatterwalk
Date: Wed,  8 Apr 2026 20:00:39 +0200
Message-ID: <20260408175940.874871658@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index e468714f539df..ace8a4dc8e976 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -623,8 +623,10 @@ static int af_alg_alloc_tsgl(struct sock *sk)
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



