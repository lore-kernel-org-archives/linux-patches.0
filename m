Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BF0BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB87C433EF;
	Tue,  7 Mar 2023 17:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209429;
	bh=BIhkWpejoZ3l+rZwaG1tUWyCBcb8lBzrRwfwYwceka4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zEObMeA9I0w/6lMxpxr+fyn8zSZ6G/RT2DQZjG73V+vIZthhnPwZk7GSjOLXboMjB
	 R/d1aLAXrPCywwzykV0GExR7Cpx3rUqX/sk2GcKHLK2JIPh8HLnUXP9Y8qgFKqHXIS
	 6MCymq0tLoXk8HyMp5lpaLw/cD4ePiRcYIG641uI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0216/1001] crypto: seqiv - Handle EBUSY correctly
Date: Tue,  7 Mar 2023 17:49:48 +0100
Message-Id: <20230307170031.252408940@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 32e62025e5e52fbe4812ef044759de7010b15dbc ]

As it is seqiv only handles the special return value of EINPROGERSS,
which means that in all other cases it will free data related to the
request.

However, as the caller of seqiv may specify MAY_BACKLOG, we also need
to expect EBUSY and treat it in the same way.  Otherwise backlogged
requests will trigger a use-after-free.

Fixes: 0a270321dbf9 ("[CRYPTO] seqiv: Add Sequence Number IV Generator")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/seqiv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 0899d527c2845..b1bcfe537daf1 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -23,7 +23,7 @@ static void seqiv_aead_encrypt_complete2(struct aead_request *req, int err)
 	struct aead_request *subreq = aead_request_ctx(req);
 	struct crypto_aead *geniv;
 
-	if (err == -EINPROGRESS)
+	if (err == -EINPROGRESS || err == -EBUSY)
 		return;
 
 	if (err)
-- 
2.39.2



