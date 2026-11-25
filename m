Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617661;
	b=wEjIQ6JsH3CF6XepyjdwJBk28PRpxvwGPlnIZ420FjBwgBoGNYQQs/bgnlpe68fUsIqo
	 M2wtMTF8KTM7aYXMzRggYwb6KxkhPKEkUTJtmBaOwAWNBzCa/veifFfMfDFTGdrOqD+qX
	 f68pHtKgb1RD/pCnzxrLNFb00fSE4qUP4c3m7gMRWMxEMUkV/zTHc8tcJRl9WNpCGndbG
	 1WANWpGvsmhSER90aVpBln4KfwCiRNGpT/Fa9JQMZJaURGmQS7eTUAMiPV5tX8EDH0akg
	 lWI5AU4LHJ76JSUrTE1luzMr1B4kb05MhCs8UT+1RPPgAmHWSIjF/2sx8I5Li6ZFvhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617661;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S17qbo3ooiashb+iX9wiZvjP5PZAExVYnheVx+O9AWM=;
	b=kniK4NPyHkw9Jfy/73f4tOhkg+kmUhLKCg9RdFU06Gk9PpOa8iSv3H81lnq2unplThLl
	 qFw1Pp6PKA53vWKq9w+mI+KQsmhOmh+z1LuIPuWfOMweHRRQZ+4JT+DlR59GNAluSr4+w
	 X5YzhcQDqYzarwK8OEQyBJTsNiU0kgx3chmkgE29MBMhhnNnHXcASoMIiinUlemDqkgd/
	 nqcZAl8MRpXOIdm5neVaPCWNUWDXbLYjCcqww978CRPK0jb05d41lSL19h7HNVEVopFgd
	 Fsud3gP6g/nei2lyiho4uR4w92hmrSPeX9CKAFk2a/I8Hw2hIInZTpG48WIIJKRDAqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="XfbnV/dW";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8020606A691;
	Wed, 25 Nov 2026 14:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XfbnV/dW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5C51F008B2;
	Wed, 25 Nov 2026 14:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617661;
	bh=S17qbo3ooiashb+iX9wiZvjP5PZAExVYnheVx+O9AWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XfbnV/dW+4PKqpMOtqyMnScptkkymgSDk824Eh6+H8TZRPpcxw+Cb+2qMD1ttnYfN
	 bDLPrmNwlS3DbwEmKoxamwWw0TK7WvOm3ySEt0+wrJjXdul8uXQB1yVk+j+3Z7GGnp
	 2S3e12rm+uPzhuOgrkX/OyL7M5dtXHrQJXyooFEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Antony Antony <antony.antony@secunet.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0036/1005] xfrm: fix hw offload state leak on xfrm_do_migrate_state() error path
Date: Wed, 25 Nov 2026 15:22:54 +0100
Message-ID: <20261125143822.586715629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antony Antony <antony.antony@secunet.com>

[ Upstream commit da94223774ea012188ef76f89e0bd642b39ba517 ]

In the error path, the cloned state is dropped without removing its
hardware offload, leaking the offloaded SA entry.

Fixes: a9d155ea9b44 ("xfrm: add XFRM_MSG_MIGRATE_STATE for single SA migration")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 48b8a0af95e25..aac12991d2ca8 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -3511,6 +3511,8 @@ static int xfrm_do_migrate_state(struct sk_buff *skb, struct nlmsghdr *nlh,
 	xfrm_state_put(x);
 	return err;
 out_xc:
+	if (m.xuo)
+		xfrm_dev_state_delete(xc);
 	xc->km.state = XFRM_STATE_DEAD;
 	xfrm_state_put(xc);
 	xfrm_state_put(x);
-- 
2.53.0



