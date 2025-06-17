Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF632F236D;
	Tue, 17 Jun 2025 15:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175079; cv=none; b=KX+k0b3VTxqq41A7/T6Yxg5WP1oSIvNoQqiQdI4SVTq25x81y/Tp9KJ/ETVwBvR8wHMGLL3xhCJehtuY/Hq0U/lA1XdzrrmDRTETvgR21wTZ2bVT4SG00HKSil8UHsSrOFQA0Zyk9Uyho9AfLiHH/YZj2GGRhrUNAHZ2Kq4LY5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175079; c=relaxed/simple;
	bh=xJ+mGR11zND/9+4N2S6C89kf0XgulVHLKIYQaX5GrQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sX3wQzrabETMAqJSzUxH4iYJ7CayWKAk15pVht86rvqkW2H/fNT56AIRPalmeV1CaCViwZVin5p4UXtQI+J1o0ThIeLEhQpQZco0CmateJqNQGm8N3zXMsgc9pLGvfal5Dv49FG8bjWmWEDvhrMQVYBN7bcJevNrgRCLd3Js/I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lag9uMIU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lag9uMIU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07480C4CEE3;
	Tue, 17 Jun 2025 15:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175078;
	bh=xJ+mGR11zND/9+4N2S6C89kf0XgulVHLKIYQaX5GrQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lag9uMIU6zPsJA8FwKmTdMcHwV+FKQaVdJnZCDRZ6oCE0Vvwz1rbd9oOQzf5DDNiN
	 +z9BnI205UbFC/h589OAAfunK5SrIO3xWYeqbw7wlODKxNEytHUxtt5Bhzj37wl3Xr
	 YbsdysHIj3H+SO9rEQQz1VhF/G36lS9dq66op/Qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 047/780] crypto: sun8i-ce - move fallback ahash_request to the end of the struct
Date: Tue, 17 Jun 2025 17:15:55 +0200
Message-ID: <20250617152453.412591636@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



