Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E899823E6E1;
	Thu, 12 Dec 2024 16:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019952; cv=none; b=HSFdY5cXblOZmVWe6sBnMyWLGUrMOPuCIWTPLoIHibEpIOpzNt7qyuXWNg4pMe5X/ULgxfoei+1lBTso2n0pUV2W2XAAZ9TYeKivk+O+OAjuRieUPLLQ/Gs2MtYolxeVVFbgCPWZYZD3PLaLybUdMjhRUvL4luQzyL3YZ5pdVrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019952; c=relaxed/simple;
	bh=33ltpPNuJc7Sm9jYiAeBlbERv2QfcP9IiTvmVUh/Kw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YA8xUcASxe/0bCy2EUQ7nF0bsqZOnHU7RQ/OU5YTfnVveoOF2/mdLcHZyPBdSx1uvBlnrYBjKQrylEt3YSEIwkjTs3Z8rtBNbOz485bbupLh6CRwGGxN0nrDIsTTn1Itwb5nnFzRMg3cOJB7JuuzNG/nl/0t6o2leWgHXPb/8Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A56VdTUz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A56VdTUz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056EAC4CEE0;
	Thu, 12 Dec 2024 16:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019951;
	bh=33ltpPNuJc7Sm9jYiAeBlbERv2QfcP9IiTvmVUh/Kw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A56VdTUzrSEFMu/Y2OSbBccP8z91j3ZSjgwXI1h0ElfRe1Or+WKNcH6zQUbDVjCb2
	 SikabEIvDNVbZCD3TM13p5kFA7JIUt3zS/yOYYeEiKCTyVQgPvbIa0nAC87PwltOx4
	 NOwO5vXjj+kmffG7z3T+BddCSa1LDaCXFiHKBKI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 322/772] rxrpc: Improve setsockopt() handling of malformed user input
Date: Thu, 12 Dec 2024 15:54:27 +0100
Message-ID: <20241212144403.205057318@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 02020056647017e70509bb58c3096448117099e1 ]

copy_from_sockptr() does not return negative value on error; instead, it
reports the number of bytes that failed to copy. Since it's deprecated,
switch to copy_safe_from_sockptr().

Note: Keeping the `optlen != sizeof(unsigned int)` check as
copy_safe_from_sockptr() by itself would also accept
optlen > sizeof(unsigned int). Which would allow a more lenient handling
of inputs.

Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/af_rxrpc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index ceba28e9dce62..9b3efe6d580fe 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -641,9 +641,10 @@ static int rxrpc_setsockopt(struct socket *sock, int level, int optname,
 			ret = -EISCONN;
 			if (rx->sk.sk_state != RXRPC_UNBOUND)
 				goto error;
-			ret = copy_from_sockptr(&min_sec_level, optval,
-				       sizeof(unsigned int));
-			if (ret < 0)
+			ret = copy_safe_from_sockptr(&min_sec_level,
+						     sizeof(min_sec_level),
+						     optval, optlen);
+			if (ret)
 				goto error;
 			ret = -EINVAL;
 			if (min_sec_level > RXRPC_SECURITY_MAX)
-- 
2.43.0



