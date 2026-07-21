Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B7546AA9D;
	Tue, 21 Jul 2026 15:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648474; cv=none; b=maLjUrRe/cgh4ybN+ya18Gz19wJiGs1eNVM8gNUjJCHWe9XxEts3pXh8nzIa7chg7mMSOq9OwCCVvcT0XYjhldzR/V/pVbuMKJxhnT3Sj7x0WlZXGQ8/4sGyg+Mus28j9qxFjaxawRnst9uOeU+Qvk8mYiybNmAFBYHnVpcvz9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648474; c=relaxed/simple;
	bh=97qOz6sI291hr0SO5DtojiqVzuItGUjymMQxDYLoSFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJfExuPguBaTYvgEbOH4xUM2lfIYSq8bCV1gOeMjwnMSYilviC5VgdBoThM6ttqyPiNmM+ERFK+9AO8R35Xoxlpl4++5na+wmid8C3ha0MWdxBwUvbNAefjfZLFH/fgXU2rphKTVHPC6MXc483i33Qq5r2adv8O3Hf8Pj9CwiHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t0sYwnjb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t0sYwnjb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A9F1F000E9;
	Tue, 21 Jul 2026 15:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648473;
	bh=ZH9fVHmhzmc0IbWVfIWFGRFxwMZxdHfHwcSemwHkEns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t0sYwnjbG2Z0WCsFDrwH3clefbKG+RSfcHamROtd7ywWEhwCl9DUsMdp6BSz8r2M9
	 eZrxOEffxND7CYFF/rUvtl0PwE47t+BmbX0YYN1se4tsIXkg+EjRv17Ja3PM5IQRPp
	 wFW3BStH4AWlaiTLS9+c7QzpvNkDIVOAWh30rtEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0212/2077] crypto: af_alg - Cap AEAD AD length to 0x80000000
Date: Tue, 21 Jul 2026 16:58:05 +0200
Message-ID: <20260721152557.680098886@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit e4c06479d7059888adf2f22bc1ebcf053bf691a2 ]

In order to prevent arithmetic overflows when checking the TX
buffer size, cap the associated data length to 0x80000000.

Reported-by: Yiming Qian <yimingqian591@gmail.com>
Fixes: 400c40cf78da ("crypto: algif - add AEAD support")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/af_alg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index fce0b87c2b6521..48c53f488e0fd3 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -584,6 +584,8 @@ static int af_alg_cmsg_send(struct msghdr *msg, struct af_alg_control *con)
 			if (cmsg->cmsg_len < CMSG_LEN(sizeof(u32)))
 				return -EINVAL;
 			con->aead_assoclen = *(u32 *)CMSG_DATA(cmsg);
+			if (con->aead_assoclen >= 0x80000000u)
+				return -EINVAL;
 			break;
 
 		default:
-- 
2.53.0



