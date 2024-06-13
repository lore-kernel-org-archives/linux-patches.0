Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA43145B1E;
	Thu, 13 Jun 2024 12:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280162; cv=none; b=NKS/PaaY9AC+14baDBnk6rz2pYfwyqpXrCNbyUsEpQKnNIHLzi0DY6MeXV+qX1/vFCNYIrZmh8frOM0wRQuMoTfVYsVBa8aEdH6wt5EdV8q70e8TZqerCwzYgJSysDInbkO63tP7Htw4BciXTVERcOoX9yabtx2b5F3xqO3paSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280162; c=relaxed/simple;
	bh=BCXBKZXCu6xdr50PA/DYa2Lekf4Mdb09Zor1RG6tUDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oe0MCYs5DByQhF/23R9F2iYOf+V5XX/wF1bU6lSJ2xvY2qRJKdBHQ9VNttwBAFiMRtbFHU4hnUwCxl9ViejL8baIHqJhvMN1DWqj/HctldZhej0DzfhbcNmptRWuOFIlCCvt36FYuJhacBOWV6lpuEtfgFVOUdadS2WKaYOXRGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GBBWBqFG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GBBWBqFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AACDC2BBFC;
	Thu, 13 Jun 2024 12:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280162;
	bh=BCXBKZXCu6xdr50PA/DYa2Lekf4Mdb09Zor1RG6tUDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GBBWBqFGFTfYFSHf6Fx43E5ACRYL4T9ry4Nip2aP9gXHjHseZ2VRKxNKuhbM60or2
	 HaLEP99I4vHv0sW5gT8zvE+XQzZ50CRSNrttm5il4kRkTIiaZFnLsd8ulHlt3MF8P6
	 LhFmYoUtUXal37sFbJj3qfz2LELTgQj22+1bi41k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.4 164/202] SUNRPC: Fix loop termination condition in gss_free_in_token_pages()
Date: Thu, 13 Jun 2024 13:34:22 +0200
Message-ID: <20240613113234.077217645@linuxfoundation.org>
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
@@ -1104,7 +1104,7 @@ static int gss_read_proxy_verf(struct sv
 	}
 
 	pages = DIV_ROUND_UP(inlen, PAGE_SIZE);
-	in_token->pages = kcalloc(pages, sizeof(struct page *), GFP_KERNEL);
+	in_token->pages = kcalloc(pages + 1, sizeof(struct page *), GFP_KERNEL);
 	if (!in_token->pages) {
 		kfree(in_handle->data);
 		return SVC_DENIED;


