Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D37E13DDB5;
	Thu, 13 Jun 2024 12:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282112; cv=none; b=vC3iSypsL9023xhMml0Mm0TLclB2GFjOOW7Qh1dftMD+1Mopq6S85+FAvWA2ZDfhrRnqy8aUadVAj4jMKnTfmaK56+2HVkHSFd4/MQOf+ya4dgisfvursqRd0bfvAGms18cnuOXBwAoI9LZ26rGUKTjwIzeCyEweuPlcv2Ug4+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282112; c=relaxed/simple;
	bh=jXQf566/3Z89zLHWM/1JHccMRh41XKpKQdUnBvUlLwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WUt/FsfoK7lyC4HVPVhoYXiBscirmp+exjTzEO1Jeu27rvScfwyUQM5D712uFpoopf3Wwro2l44Jb0YNaZuOzEwtmfsdb7K5CxduGD/BzbK8GwWhv1UfH88seX3hUCQklsKiegZShT4aEd4LHJHV98aCIvmuP9fFiy4NrKjJabE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nz5/7QTu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nz5/7QTu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8EAC4AF1A;
	Thu, 13 Jun 2024 12:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282112;
	bh=jXQf566/3Z89zLHWM/1JHccMRh41XKpKQdUnBvUlLwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nz5/7QTuO/eBCGJdp9gRqt66g2F9ZBKRMXkbk88KyVsdwrGs0fH5L2KHiTs3uLKLM
	 pgMTxZncAU2yd+QSL741PNqp29azL5ugq4kOv9mBknAWEjXKSO3FbSEuwPNWwFgrMi
	 RjKRQg0Bm+7iA8SQsyLgaR+bYDNx9KlmrHHeVQCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Trond Myklebust <trondmy@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 167/402] SUNRPC: Fix gss_free_in_token_pages()
Date: Thu, 13 Jun 2024 13:32:04 +0200
Message-ID: <20240613113308.651626196@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit bafa6b4d95d97877baa61883ff90f7e374427fae ]

Dan Carpenter says:
> Commit 5866efa8cbfb ("SUNRPC: Fix svcauth_gss_proxy_init()") from Oct
> 24, 2019 (linux-next), leads to the following Smatch static checker
> warning:
>
> 	net/sunrpc/auth_gss/svcauth_gss.c:1039 gss_free_in_token_pages()
> 	warn: iterator 'i' not incremented
>
> net/sunrpc/auth_gss/svcauth_gss.c
>     1034 static void gss_free_in_token_pages(struct gssp_in_token *in_token)
>     1035 {
>     1036         u32 inlen;
>     1037         int i;
>     1038
> --> 1039         i = 0;
>     1040         inlen = in_token->page_len;
>     1041         while (inlen) {
>     1042                 if (in_token->pages[i])
>     1043                         put_page(in_token->pages[i]);
>                                                          ^
> This puts page zero over and over.
>
>     1044                 inlen -= inlen > PAGE_SIZE ? PAGE_SIZE : inlen;
>     1045         }
>     1046
>     1047         kfree(in_token->pages);
>     1048         in_token->pages = NULL;
>     1049 }

Based on the way that the ->pages[] array is constructed in
gss_read_proxy_verf(), we know that once the loop encounters a NULL
page pointer, the remaining array elements must also be NULL.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Suggested-by: Trond Myklebust <trondmy@hammerspace.com>
Fixes: 5866efa8cbfb ("SUNRPC: Fix svcauth_gss_proxy_init()")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 48b608cb5f5ec..6ad1757718505 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1132,17 +1132,11 @@ gss_read_verf(struct rpc_gss_wire_cred *gc,
 
 static void gss_free_in_token_pages(struct gssp_in_token *in_token)
 {
-	u32 inlen;
 	int i;
 
 	i = 0;
-	inlen = in_token->page_len;
-	while (inlen) {
-		if (in_token->pages[i])
-			put_page(in_token->pages[i]);
-		inlen -= inlen > PAGE_SIZE ? PAGE_SIZE : inlen;
-	}
-
+	while (in_token->pages[i])
+		put_page(in_token->pages[i++]);
 	kfree(in_token->pages);
 	in_token->pages = NULL;
 }
-- 
2.43.0



