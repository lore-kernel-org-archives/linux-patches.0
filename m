Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDA3196C6F;
	Thu,  6 Jun 2024 14:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683383; cv=none; b=kUyEr7AR42HkUPbOHzq3yRtdipZgwiKzKEaNYXHTqYz4A88EbX+1Xdk95O+zpC45chXgTIMcscD8nziFdwsTVnGYTrElj3L5W/Euu52hLSnF9JYSSj/uOsCN90YTJymDiqMTXDcYoXMjwxEnMPjcnizQ+npw51SUPwfA7/fvX0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683383; c=relaxed/simple;
	bh=D4wHis05izLIPl15EX/9GbyPL7vxRtaAiiD6esCHXVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IdP8VrSrpQcGZn3/Qi0plvpOngLQ2RH3TAohZPWkfOEuZ6XfhIw1yKgnOTKPIIPWtp4Ug+hA84aXN8L/Y3IiKoKXUBmU/zF/Oo65Y6UJmSPFSjRq4F4NGzNh0PTfpYg1sb3ucJhZVnwCca6CvbX1WsxPQPltHNumHECKae/bnts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e+cRZA8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e+cRZA8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8595BC32781;
	Thu,  6 Jun 2024 14:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683383;
	bh=D4wHis05izLIPl15EX/9GbyPL7vxRtaAiiD6esCHXVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+cRZA8sJCtcbaxHxmr2wJghLL7pQIh7odstIrnJscAB9qF2ty8rZOkkSK4tD/enu
	 Jh7DqmgtCUMxGC12wn/0fb3eDuyhXgtfChusIzARSzCT2SF+Cyb5NVuH48BvPKDt2e
	 l9OurmgIxS5ZBOUcpyb50MmjsJETQ8gaUzyUKGjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Trond Myklebust <trondmy@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 266/473] SUNRPC: Fix gss_free_in_token_pages()
Date: Thu,  6 Jun 2024 16:03:15 +0200
Message-ID: <20240606131708.737351102@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bdc34ea0d939d..9d045aa6805d7 100644
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



