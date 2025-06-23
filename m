Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD30D254B1F;
	Mon, 23 Jun 2025 13:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685252; cv=none; b=pFw8Ds9QHRPvrXwiU6h8FhqgBAzEPfTc/BA9whtyt9aXhWCKT7NfTF3P18xPgtPwMUDl4R6mrIAu0nt806VAOXayeAPOHryw7TrtwDv0RmT2aLoXzEsyHGLKrrwGh/awRgggguXRLwMecM3c78NBESgg9INrXzAGBzl7i7z3mek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685252; c=relaxed/simple;
	bh=5DYoyWam9YTy8aOGcOwDkwSXqKhQYhQH4I2HApxhQ5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GY4Vyae8au87XlzPucpPWGwPML2wbTpZ2YicFvBDOZS8BKo5sveSGfDBI5GTQCgo2EYRoO8EKez1PqY+mFhqO+UYkgPDVTc0X5Z4BHnNxaiidygwV2iKQYQw2h3jlBd05RGgAFnBk9GUbAXevyncLpe3XEtPK1ICLKfaB3faJ1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MefFX6Nn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MefFX6Nn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04F8C4CEEA;
	Mon, 23 Jun 2025 13:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685252;
	bh=5DYoyWam9YTy8aOGcOwDkwSXqKhQYhQH4I2HApxhQ5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MefFX6Nn3gqoA0LGIzMGEPkqJavyAvzb1c8Q2M6bA7tJkDNZ+qNQwZAVWGRPy3sPv
	 LWUOwRj+Plm81lIhoTqTVPDv1gI6BxLh6s/2B4dwVqktNzmd4qunnWqR+xZ3V84tZL
	 Q6MaGAODCNs9EkAfgm+zEnx161D4ldQqRxxvTuuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/411] crypto: sun8i-ce - move fallback ahash_request to the end of the struct
Date: Mon, 23 Jun 2025 15:02:44 +0200
Message-ID: <20250623130633.608720149@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index cec781d5063c1..d87d482cf73ba 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -296,8 +296,8 @@ struct sun8i_ce_hash_tfm_ctx {
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



