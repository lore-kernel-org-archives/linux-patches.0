Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4883A144D36;
	Thu, 13 Jun 2024 12:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281557; cv=none; b=E+09DN6AjymGB9dESUAl9UxFNbXVTa1oHyfuO7SWIZP1X+Se5Mo8Bv4D09yu1WEhyE7zo48talTkRarWa8inA7sFf0RLwz1//qr0496jZJdXWJ1JydroMY51nATjGMGq/1DYipd6C5kBnMZ1pjfYGd+RdEMMyUailOhhs//jOHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281557; c=relaxed/simple;
	bh=EmiQLzKVasI57P+d4cKW6HPM5hnMWGjq7SmLFmztrXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFkPf0epL4P3x93U3CvJhRpLFFsrmFLoEfElerMS2CCU1ES8mS4pCu8k8NttxYRXkwOZvONM8pWO6ZHyZT6+R1M5I67P9RBZALKFC5MfEvEfO1KIg5vY8LdargP7MpTlYGaCFwKJv+XuZFziEuC/72IBAll3ejR/LpRp07psJZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RIctlhnV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RIctlhnV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B811BC2BBFC;
	Thu, 13 Jun 2024 12:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281557;
	bh=EmiQLzKVasI57P+d4cKW6HPM5hnMWGjq7SmLFmztrXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RIctlhnVAmrZeGbc6gq1FZyZMfvEuf86tiQC/komvA8vW+ysUP4cfiNvw2s8VKuPo
	 twkbMOa5C0Jlz//JMIaGxi1yEVd3hvse7tvvtz5SNLoFF15x+qMM6HRACtoY9uVmYq
	 tOKvX5ms3ty5Dqhrhw5hzSbAGsqtI2rMdmr+8BwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 265/317] SUNRPC: Fix loop termination condition in gss_free_in_token_pages()
Date: Thu, 13 Jun 2024 13:34:43 +0200
Message-ID: <20240613113257.797368956@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1156,7 +1156,7 @@ static int gss_read_proxy_verf(struct sv
 	}
 
 	pages = DIV_ROUND_UP(inlen, PAGE_SIZE);
-	in_token->pages = kcalloc(pages, sizeof(struct page *), GFP_KERNEL);
+	in_token->pages = kcalloc(pages + 1, sizeof(struct page *), GFP_KERNEL);
 	if (!in_token->pages) {
 		kfree(in_handle->data);
 		return SVC_DENIED;


