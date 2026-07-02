Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194514DBD7E;
	Thu,  2 Jul 2026 16:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009704; cv=none; b=SYtvf3VmZpB3Z78lvq0fdJ2r3V10B25cpA32E71VaPRzBejIyFVMTqb1/s8w0uA/IvpMvZ2TOdadNOT0jKKisx5LrcI5c+5OerhV2O52Ecxr94ZiNf3H4t2rDh24o/BZpSKA9utjpVN88mTdbx17TxqWjT+aK6kGNWYihHRuAQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009704; c=relaxed/simple;
	bh=iMfAKLDw6LqjT2A5HLJ4aR/L2ma1yCcHJ38iiDfE9WA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7+tEzvFnr1yxqo+b8ZqqB+Sh2PP5GIqxK4PqpnoDgmlUBuvu+eYP1N7f4eLWOdTL3ATdC/K0s5DhqI7FnkXtjsYJr0FYzffXH5BVpycxlZq18FkKrZfhioLHQJO2YMQPLYMv+b7k2RmR1CHYdoToQcbG/EvAOuf1qIBDi/fDn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A2gF5+3y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A2gF5+3y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4175C1F00A3A;
	Thu,  2 Jul 2026 16:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009701;
	bh=ohxvcfw8k8CD37beKyCMlU7og9PbtCfwcBJSoypidDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A2gF5+3y8iQQzF90P6I8ACMhUEBaw9KfzVk5ksFA2mzP9dEDuogWnY/3H00G+DcQt
	 922fSQ/k6HYv+HOBB+3tjktEmjFmKXx5D2r8rNKUY/Sm4FYlNo6uCDJUW1dhQycrAg
	 vfeq84jaepXD95Vs8MI6qp3be0/0fQBEf1Ovj3Jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Alifa Ramdhan <ramdhan@starlabs.sg>,
	Bing-Jhong Billy Jheng <billy@starlabs.sg>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 56/95] crypto: af_alg - Set merge to zero early in af_alg_sendmsg
Date: Thu,  2 Jul 2026 18:19:59 +0200
Message-ID: <20260702155110.385915989@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 9574b2330dbd2b5459b74d3b5e9619d39299fc6f upstream.

If an error causes af_alg_sendmsg to abort, ctx->merge may contain
a garbage value from the previous loop.  This may then trigger a
crash on the next entry into af_alg_sendmsg when it attempts to do
a merge that can't be done.

Fix this by setting ctx->merge to zero near the start of the loop.

Fixes: 8ff590903d5 ("crypto: algif_skcipher - User-space interface for skcipher operations")
Reported-by: Muhammad Alifa Ramdhan <ramdhan@starlabs.sg>
Reported-by: Bing-Jhong Billy Jheng <billy@starlabs.sg>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/af_alg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index b66a1681692d6e..bbd47d04f89dc2 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -892,6 +892,8 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 			continue;
 		}
 
+		ctx->merge = 0;
+
 		if (!af_alg_writable(sk)) {
 			err = af_alg_wait_for_wmem(sk, msg->msg_flags);
 			if (err)
-- 
2.53.0



