Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCA820F090;
	Tue, 17 Jun 2025 15:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174701; cv=none; b=bpk1ZJaOG55XCkTn0qj9tDwpYOQJxkAThACYx+MX9RJgTzh3vybp3Q1TErzbzobw28S31Vesjz11U+xRm148K2SH9UE1H7PhbLqjy1RmGXJnf2Q6wlnAMKAbeh/nxYnMiwzoDOVid+2NZOPpGHdUkHcK1wlNRpoBdRNsASc3xzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174701; c=relaxed/simple;
	bh=XHD6z/FZLerpbr3pTIQCEPhnijP8Uhv7EmichDEbZbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MFhqkS0DxMcajZE/beNJT+8UnQCKt0HvlckRFOFnv9WwjgdoOBMYjcR0mLA7waqNi9slunRu5YRus6v1oiRhVjguzBFn9tO+1cX2aV5UbJGR/KJC2ORvXJTjSGkS5FLU4/qkQr1f3cyRGqprxPkxLRoxCg6gZLGLhtImUsy7EyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iGy4ApU2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iGy4ApU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9DEC4CEE3;
	Tue, 17 Jun 2025 15:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174701;
	bh=XHD6z/FZLerpbr3pTIQCEPhnijP8Uhv7EmichDEbZbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iGy4ApU2yhpNMr9k0aigXi5ByT+GJTgJs6/w+rbCjO66BKhkcR/Ss4Pker/SxZM9i
	 IWTwlCkNLqG2CYS+7ZQl+mYsTTKlzqGDBDKISbsegqbd2T8iZCs1Qv0por/ScVPnZh
	 UW6//zervm8Vo3BP5xMOYJpcuEYUIKwtyB78362Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/512] crypto: sun8i-ce - move fallback ahash_request to the end of the struct
Date: Tue, 17 Jun 2025 17:19:59 +0200
Message-ID: <20250617152420.898131012@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>

[ Upstream commit c822831b426307a6ca426621504d3c7f99765a39 ]

'struct ahash_request' has a flexible array at the end, so it must be the
last member in a struct, to avoid overwriting other struct members.

Therefore, move 'fallback_req' to the end of the 'sun8i_ce_hash_reqctx'
struct.

Fixes: 56f6d5aee88d ("crypto: sun8i-ce - support hash algorithms")
Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index 3b5c2af013d0d..83df4d7190531 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -308,8 +308,8 @@ struct sun8i_ce_hash_tfm_ctx {
  * @flow:	the flow to use for this request
  */
 struct sun8i_ce_hash_reqctx {
-	struct ahash_request fallback_req;
 	int flow;
+	struct ahash_request fallback_req; // keep at the end
 };
 
 /*
-- 
2.39.5



