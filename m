Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EEB43559DB;
	Tue,  6 Jan 2026 17:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720519; cv=none; b=ClnAUVXR8HkkDK6nH9rHOnmKxsP69UZ2p+GlQqq3ClwxCCipqjLOYtUUsbwJYFlbCqp4PNePzhj1jLhqnUGKUr/x/GhiesJp9vWfNLxc9r7VYxRRSsAJanjPtJEpjbqvfRhdobW3fsR7xXS/yxt5o1y5I/Y9/xYptMGxZVF+MEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720519; c=relaxed/simple;
	bh=RpF04C8CeEfBTc/civPBvJWNWekb6YI0jsNefNH+x/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EEuIwk6R8JOVBrYaSMnXNj5feiM+AOHUAXkp2IbXs4Qe8cypuiZZOYUEcM5FuQA6TzUq9f+RZ47O53VZYWiqMY5RCFgLMW594gvirTiN6hXVE2xCFuTTwM/3Peta8oDHArMMmHlCAEnHkTo105Fw5HxeO5Qmjpicq2oKuxTQ9TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QP7O6JR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QP7O6JR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB38FC16AAE;
	Tue,  6 Jan 2026 17:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720519;
	bh=RpF04C8CeEfBTc/civPBvJWNWekb6YI0jsNefNH+x/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QP7O6JR9WSFaENp1rZa6c05gPAbA3FEVBTaLcMhvL1/8H/kEp3Rbv/QXjiH+BZTdo
	 fxCPwjlecDeHJht4muC/ibo3EAF8D/eEpK9H3qtUm9PFAkJsxxp62OxwPfCvt2J0aW
	 aBoESFl4+8njuTMmMphPMFnOVsykmNMsfAKNX1nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Rogers <linux@joshua.hu>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 244/567] SUNRPC: svcauth_gss: avoid NULL deref on zero length gss_token in gss_read_proxy_verf
Date: Tue,  6 Jan 2026 18:00:26 +0100
Message-ID: <20260106170500.340897765@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1083,7 +1083,8 @@ static int gss_read_proxy_verf(struct sv
 	}
 
 	length = min_t(unsigned int, inlen, (char *)xdr->end - (char *)xdr->p);
-	memcpy(page_address(in_token->pages[0]), xdr->p, length);
+	if (length)
+		memcpy(page_address(in_token->pages[0]), xdr->p, length);
 	inlen -= length;
 
 	to_offs = length;


