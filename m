Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5553332ABC0;
	Mon, 13 Apr 2026 16:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099473; cv=none; b=RkAQe9DaW0I1Q3VyNuWuG8WcMxwLnthPS2v/1vZMlFiXmlUnWgITHioBSNa97zYHFVXadPWPYmoDxGris38V/FahCqDQhD9AgQZ8HaidzdS1VhqyrJrn+0KcuytVOEMQz2Lea8e8mQ6xtujrtFGAir67is60kaBpf4/VB2eHntI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099473; c=relaxed/simple;
	bh=Mp1ktWPFOfgghCVDTqzkKAUc7IvXi5JL/UL0bX76jJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ii/qfCXqmVTjRU/oKvWOqBOW0eNYlP+IzsVfxqK7ZvlTLGuKQ5M9MxNobWCpxCiOxKRlDa6FLH6EPL9DjOSR+e04QT51sOfbQ2mHKxakAesmr5rTc/gKsJw4oXwNusH05c+zMCNZd+3JizjwqL10bHrvGx5zHgmGvKQd2cwRVFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qf7HYe73; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qf7HYe73"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B48C2BCAF;
	Mon, 13 Apr 2026 16:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099473;
	bh=Mp1ktWPFOfgghCVDTqzkKAUc7IvXi5JL/UL0bX76jJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qf7HYe73mLT6x1Jc2B/J9P+oOnhP7JqFOSF7ezZ3Vak0GFl8xYr91sPGDJO39eMue
	 rQLdNKltO7WsKulmBqKmC83ufizNWTUZwVK5CeAQaq1A9DVbL0k6cWXuunRiFsoaOo
	 XxcKPR3le+eSkx+vbQAOPwQhtPNaMbaO8Lqc9e/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 321/491] crypto: af-alg - fix NULL pointer dereference in scatterwalk
Date: Mon, 13 Apr 2026 17:59:26 +0200
Message-ID: <20260413155831.062046246@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3d622904f4c3d..5e0fe58f8bdd9 100644
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



