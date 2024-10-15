Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925261EB9EC;
	Tue, 15 Oct 2024 12:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994165; cv=none; b=DvUnlw5O3ZCD4QwQYhFNuGjiBLhuED8tugv2eB6IUCsuNnQs7PMQl+PAy8tmEj+V7Lgi/WHUmScc0KcyWvhpixDS+2fmX8RuqdIqVUueWBJ8YxLjgmF2AwAy5bDRytTiezGpGUweoT5+gXrkiViFsIRFuKfwaqUojOxqr5MF+hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994165; c=relaxed/simple;
	bh=3BwV1dRZDS4QyLleOnrdaAEEcxiApkDLcQj5R1zdwBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eKjbuY2J+0WnAJJazpVHkqTcSzJCGaFXRhCLWVVnpwpofDKqMjXTXumqqAEkcjDl79v83qr8CMv6uUmHgp9xenS1fT+ttW6E1+t5a7sfmz86e66PovZjDLPvfeJg5RKcZWERaLYBo5GJjWP3qh3psVe0V1oDw47trIcvbLrV24o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zKtb66Yl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zKtb66Yl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73E2C4CEC6;
	Tue, 15 Oct 2024 12:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994165;
	bh=3BwV1dRZDS4QyLleOnrdaAEEcxiApkDLcQj5R1zdwBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zKtb66Yl9GoTNNJ9hP3Sok2FO7Cd714sLFIcUSqXpIQogwEapVZGXrhCkQUUMHbMX
	 KFUZ+EZWHmolIXTUaV/50JzkOrUGzvDQh7c2KZFqq0GIdXBQ+d8wx7Ce5JO7ZqMby+
	 dF7ZR6QJL3A2pYto9RCZjI8BOypke/nc2V5l3hqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 626/691] SUNRPC: Fix integer overflow in decode_rc_list()
Date: Tue, 15 Oct 2024 13:29:34 +0200
Message-ID: <20241015112505.177921203@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 6dbf1f341b6b35bcc20ff95b6b315e509f6c5369 ]

The math in "rc_list->rcl_nrefcalls * 2 * sizeof(uint32_t)" could have an
integer overflow.  Add bounds checking on rc_list->rcl_nrefcalls to fix
that.

Fixes: 4aece6a19cf7 ("nfs41: cb_sequence xdr implementation")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/callback_xdr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/callback_xdr.c b/fs/nfs/callback_xdr.c
index d0cccddb7d088..fa519ce5c841f 100644
--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -372,6 +372,8 @@ static __be32 decode_rc_list(struct xdr_stream *xdr,
 
 	rc_list->rcl_nrefcalls = ntohl(*p++);
 	if (rc_list->rcl_nrefcalls) {
+		if (unlikely(rc_list->rcl_nrefcalls > xdr->buf->len))
+			goto out;
 		p = xdr_inline_decode(xdr,
 			     rc_list->rcl_nrefcalls * 2 * sizeof(uint32_t));
 		if (unlikely(p == NULL))
-- 
2.43.0



