Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E551474B3;
	Thu, 13 Jun 2024 12:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280051; cv=none; b=u3eWe0QgWDvfQjy6B452CoCoJLSu3uE7XKX8byEj9a2dm1rgykS1/cdLFaM2xAE/FyrPSVgI6KqsCGL4WLr0nlIqMPUipllN9ttZhppAFPl2AC/Vh5yZQagUWFqGxNQRQOHaVrwn08yauBQiGAhwBx7w8/CDvJ8FB0vHX9NoyK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280051; c=relaxed/simple;
	bh=0s/9zkknJwXEE08sHrR1Rn/8VKFU5oTPHSClTDT7P5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=orFS9Sbu+neA3I4/l+SmRYcuKJM/Wbiv6H1ZdFhqeJzQYkBn1jfvPJgdx38xc+HU5qn/A60cRTmeE73Ew1JvbLjG9v3VLwL9uiYcMW8LZ4PwrYVGLmtSoyZYYDqiZas9HdJIcZrad7MFgSaJJb8FF/RWjMVaMuqZqaqTKMSd+rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JxNyg2GT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JxNyg2GT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5057BC4AF1A;
	Thu, 13 Jun 2024 12:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280050;
	bh=0s/9zkknJwXEE08sHrR1Rn/8VKFU5oTPHSClTDT7P5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JxNyg2GT68ONHGr8Wv3XtTusFtikytBUMu20jil0ZrMQujftf+Q3ND9JPHGvMWGhk
	 61S8DOia0kCAqaZQ8h8QeFQJm/SAlVFtSFZcCjZLvnzsoivA3iSpYEwtOLA72z25o7
	 atPMhyLLi2kwVl02VVK6mYXzNdUZmUCN93PA90ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Trond Myklebust <trondmy@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 085/202] SUNRPC: Fix gss_free_in_token_pages()
Date: Thu, 13 Jun 2024 13:33:03 +0200
Message-ID: <20240613113231.051917942@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 1a869a203d520..053c65da04bca 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1074,17 +1074,11 @@ gss_read_verf(struct rpc_gss_wire_cred *gc,
 
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



