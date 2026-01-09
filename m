Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B860B35A953;
	Fri,  9 Jan 2026 12:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960657; cv=none; b=Khz+Nj47nkaWaGXeALle0HkV+NDAsHvxfw/y+UN+fBrO1vP6HFLmyxuMruSUSHzHJZRdNiLjdk+PvUSTlU8hTz9v4wtIcVcv6PKG+7UBx5IrkWYN9wANVa1cpyChb7xJg+x4jAwdIYGwsXKOrzpAvz9ZVeGYeswjPCJwicyY4+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960657; c=relaxed/simple;
	bh=EtCqUqWLMi8+HjC78qX/nemPOTCP7Xp0NAQxCVrMEXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V06NphP+QgXHROIspiWGwe2UCz6W8vyv71U5fYz8+fMe6znsn+8DAhT4gJym0x+iXetws1FTPanbR0CSZ+EMGjnL9kT7xt2+k302bwGgKL38fVyY96bxV0yWOXLKWGV309E1VnCeRYQ/d2mJQxa/ir7eMM1XhA42AfOd6i54quk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GIrtqYXF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GIrtqYXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42606C19421;
	Fri,  9 Jan 2026 12:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960657;
	bh=EtCqUqWLMi8+HjC78qX/nemPOTCP7Xp0NAQxCVrMEXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GIrtqYXF5HhvDVYkTgfYMmaJINUKADMuDF31BwMYU3UvGCh1mn4pS5XLHvRN97XCU
	 vewotd0Bf0bwKiYk48K23iQey58lVZF+j+ciFuZGxE2oYiaQCbzh4oJWOMUTM5dXGM
	 Bl4awEntMp6GYn5suZwXySIJABSEjHeeO7kGSBtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Rogers <linux@joshua.hu>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 479/737] SUNRPC: svcauth_gss: avoid NULL deref on zero length gss_token in gss_read_proxy_verf
Date: Fri,  9 Jan 2026 12:40:18 +0100
Message-ID: <20260109112152.004365293@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Rogers <linux@joshua.hu>

commit d4b69a6186b215d2dc1ebcab965ed88e8d41768d upstream.

A zero length gss_token results in pages == 0 and in_token->pages[0]
is NULL. The code unconditionally evaluates
page_address(in_token->pages[0]) for the initial memcpy, which can
dereference NULL even when the copy length is 0. Guard the first
memcpy so it only runs when length > 0.

Fixes: 5866efa8cbfb ("SUNRPC: Fix svcauth_gss_proxy_init()")
Cc: stable@vger.kernel.org
Signed-off-by: Joshua Rogers <linux@joshua.hu>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1093,7 +1093,8 @@ static int gss_read_proxy_verf(struct sv
 	}
 
 	length = min_t(unsigned int, inlen, (char *)xdr->end - (char *)xdr->p);
-	memcpy(page_address(in_token->pages[0]), xdr->p, length);
+	if (length)
+		memcpy(page_address(in_token->pages[0]), xdr->p, length);
 	inlen -= length;
 
 	to_offs = length;


