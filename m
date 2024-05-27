Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F24015FCF0;
	Mon, 27 May 2024 19:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838628; cv=none; b=Q8k8nVyvs12qD4Gb4BAwzCTEpQrG/tV/dB+K2vrzamy3zZI58O+HHlQqNGJw+XyV0RqdHGfWuzNq5FqCjJaoAnSpmYh/hgI02t/5NZsVmgHZbWf77xnLj8rgSixBAu8VjF9yEJM3JdcVO3QXbvKf4nJb53ZeCw4eZ/bVh0e2q/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838628; c=relaxed/simple;
	bh=+Sbm/4QnhbO2wCIXkHzfjJuNGrczSqkKMLiC3TgCF8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DSi3fwRHhyKU4WwyFpt+XriUaKCstkp0ykiShfaG3TWjOGxoTnB0FRDH05POYkT0GfuS8dkqUfo4xj3glO33m7e/j7xPwA7lvYpfe/e9GuptYcg8AQc54eDYY77qmsGL7DGh0ZJ4xFU0WRGVaQ6/A3SGsJuLqkkroZMbdhXKTX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DBxpoobv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DBxpoobv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05205C32781;
	Mon, 27 May 2024 19:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838628;
	bh=+Sbm/4QnhbO2wCIXkHzfjJuNGrczSqkKMLiC3TgCF8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DBxpoobvX/cXWnKnM7ed3taCvlte3gnjq93oGoBrvUi3bBUEdcEW1HJIET9c69Sk3
	 lG52tzci81oPLxVIq/oLnWiF0GDcfz2d0o7YhuSI4/rL3rhMmNWoQiuzprqP6cp3LL
	 +cvekD+Nk0SNybeCufvI6c5ZsCTBkUiJJ3bYKlPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Trond Myklebust <trondmy@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 465/493] SUNRPC: Fix gss_free_in_token_pages()
Date: Mon, 27 May 2024 20:57:47 +0200
Message-ID: <20240527185645.396003594@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 24de941847003..96ab50eda9c2e 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1033,17 +1033,11 @@ svcauth_gss_proc_init_verf(struct cache_detail *cd, struct svc_rqst *rqstp,
 
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



