Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5EE3BF31C;
	Thu, 15 Jan 2026 17:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498625; cv=none; b=g79EQCtHOqGump0mlpenCPBPa+ZRRMHU9WXYJswSt5i9jf4y2sDyVQKP82sLNOSarahA8qt4TlCTwuXob0PnSXKw0aVg52+ZrxYcvtVYlNK7KnJYgsaEWnirvm2kTE3Wf1D1Nj430/Y7CkQYF1PxfW5a3NPKaEaY1S/gcWVYOX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498625; c=relaxed/simple;
	bh=KfSAHBxB6jm+gJYT0lr0WEu1Uh1i1KXTGRA9eK/CQXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2IAHOg7UgJamKOznsjXnEKFaxLVoM/k6eCfI01L9CHlcG5dHXaw0N8DWxTY/3kO7Cyr/CmwMqwX/pMN1GCqIS1uJk3YxIzrrDTnmeP0/IWFwMfqq96WsMC9TN4jdrWtCodF32+l/VdaGjP79HuE3fTs3882VGUdhInwqSWsPGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U890mrUj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U890mrUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A221C16AAE;
	Thu, 15 Jan 2026 17:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498625;
	bh=KfSAHBxB6jm+gJYT0lr0WEu1Uh1i1KXTGRA9eK/CQXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U890mrUjiXYHu+3TOan235X7u3uHxPvXmUaWq3zgIYyu8xXkwVwugiEDCpYG/Zxvr
	 XYynwoNalcId/jR7aH6TNyuWY4SekC0PSX4gELmtsN7IElXR5DJWR94zjwygz9NmuE
	 E17yLCtfF8jDRRFbRzyPCNI5VKh3tioVHbMkSm/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Rogers <linux@joshua.hu>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 455/554] SUNRPC: svcauth_gss: avoid NULL deref on zero length gss_token in gss_read_proxy_verf
Date: Thu, 15 Jan 2026 17:48:41 +0100
Message-ID: <20260115164302.745455934@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Rogers <linux@joshua.hu>

[ Upstream commit d4b69a6186b215d2dc1ebcab965ed88e8d41768d ]

A zero length gss_token results in pages == 0 and in_token->pages[0]
is NULL. The code unconditionally evaluates
page_address(in_token->pages[0]) for the initial memcpy, which can
dereference NULL even when the copy length is 0. Guard the first
memcpy so it only runs when length > 0.

Fixes: 5866efa8cbfb ("SUNRPC: Fix svcauth_gss_proxy_init()")
Cc: stable@vger.kernel.org
Signed-off-by: Joshua Rogers <linux@joshua.hu>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
[ adapted xdr buffer pointer API to older argv iov_base/iov_len API ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1179,7 +1179,8 @@ static int gss_read_proxy_verf(struct sv
 	}
 
 	length = min_t(unsigned int, inlen, argv->iov_len);
-	memcpy(page_address(in_token->pages[0]), argv->iov_base, length);
+	if (length)
+		memcpy(page_address(in_token->pages[0]), argv->iov_base, length);
 	inlen -= length;
 
 	to_offs = length;


