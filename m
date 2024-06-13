Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7243143C6B;
	Thu, 13 Jun 2024 11:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279133; cv=none; b=pImznk4CeRk/X6vc2rslCfbnEHedbEERutsWdMJ6b0JbR2GbDDLdG2SadBv9xZ+ttav+aXO8oodwM07CNABocBFsZEH33V/RTfp6JknMB45j2qdQaNL2rq/S0ckp0n6aCLZSqYYsdM8kukjFnwYDQrp8E9+KsgnBNcwziOpr2uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279133; c=relaxed/simple;
	bh=2oNmCH+mJ19B0NmuPoDqj0TPtbjyFK0Gc9+UWPWFXb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYKpCiRXt+L1eT66nsJ3cD+cKjyBtgyv8P9eSoQipRE8HhzpuAHCNchqgQnxzczBe6m5OJb1NNpfo14uf2JDRdBxmP/CtgXGKaa7TzWxKao9MTkBx8CtM3q+yMyrpMDMmDJ0PIvlaf8O3OyZUrpye3b6axoljBEJClP2Az4Tr0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WRQinrdc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WRQinrdc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508ACC2BBFC;
	Thu, 13 Jun 2024 11:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279133;
	bh=2oNmCH+mJ19B0NmuPoDqj0TPtbjyFK0Gc9+UWPWFXb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WRQinrdc2tMpSiDs6L8O8ZLDlFX07bb4O6ZJcZuiMuhUzC1QWYswY/zXlBgu30XOk
	 2l1afzloBFb5ERsvE47GIzsd2VL/UL2mg7VcRoQ0gu3wMJmJm8uiwegGnC5B29I3x8
	 0pJiMBRkr8q41Z1gifatr7sNYoP181QbeqaglqDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 4.19 145/213] SUNRPC: Fix loop termination condition in gss_free_in_token_pages()
Date: Thu, 13 Jun 2024 13:33:13 +0200
Message-ID: <20240613113233.583360252@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1088,7 +1088,7 @@ static int gss_read_proxy_verf(struct sv
 	}
 
 	pages = DIV_ROUND_UP(inlen, PAGE_SIZE);
-	in_token->pages = kcalloc(pages, sizeof(struct page *), GFP_KERNEL);
+	in_token->pages = kcalloc(pages + 1, sizeof(struct page *), GFP_KERNEL);
 	if (!in_token->pages) {
 		kfree(in_handle->data);
 		return SVC_DENIED;


