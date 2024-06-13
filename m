Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5851E519;
	Thu, 13 Jun 2024 12:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282622; cv=none; b=QAn/g5SRn3WT8IID2OJIbqa5Qq0EboAjq32AQhqRB01pKdDoLu64vRKHOvyVzlrXsJEK+5cSX5Zuhg5WrPNAD460fHTwu6Y1yXNm0Q0XfyiD0ZyoBP6siEi4cvyK0ihvv+uYrgo8q52k50LsXVaXHBllEjBMiEHIqUneUa8/T0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282622; c=relaxed/simple;
	bh=fcDo0RL60RhYFaJPLlxV6MxLImBCRW8pehz2svH7SQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZlC6dgSGX+GT6m1zC3EN7zM/GbxGf+/lP0A4mc+TNfzNJX5UBNYa8ukWb4yf9pveeXu6zREn9VPfSzL59jys5Hbb0wDtl1+mnCF0VbDlO/dpkGBUVP05hzUWd8hRD6P+r8DHkkB9xyHHbTbFi1h0EodupFyCggqHp/o/AFDPUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mp1VBRKo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mp1VBRKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D252C2BBFC;
	Thu, 13 Jun 2024 12:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282622;
	bh=fcDo0RL60RhYFaJPLlxV6MxLImBCRW8pehz2svH7SQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mp1VBRKoG/9Ugd0Ewnz3kpXIOGBMWxr49EvSNTD2mfdoLnu8N9PQTHqCHF+z37+W4
	 7+rQLnAKBP+fe56VQI2d3YABxeVKdWrXgefkw6Rybqw/rhxMEUZfansyHNxOXsq5Gj
	 VPHanexGQmbNMLozmEvuF4G9GfAdhXvtO8qojXNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 339/402] SUNRPC: Fix loop termination condition in gss_free_in_token_pages()
Date: Thu, 13 Jun 2024 13:34:56 +0200
Message-ID: <20240613113315.358404828@linuxfoundation.org>
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

commit 4a77c3dead97339478c7422eb07bf4bf63577008 upstream.

The in_token->pages[] array is not NULL terminated. This results in
the following KASAN splat:

  KASAN: maybe wild-memory-access in range [0x04a2013400000008-0x04a201340000000f]

Fixes: bafa6b4d95d9 ("SUNRPC: Fix gss_free_in_token_pages()")
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1162,7 +1162,7 @@ static int gss_read_proxy_verf(struct sv
 	}
 
 	pages = DIV_ROUND_UP(inlen, PAGE_SIZE);
-	in_token->pages = kcalloc(pages, sizeof(struct page *), GFP_KERNEL);
+	in_token->pages = kcalloc(pages + 1, sizeof(struct page *), GFP_KERNEL);
 	if (!in_token->pages) {
 		kfree(in_handle->data);
 		return SVC_DENIED;


