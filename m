Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02796149010;
	Tue, 23 Jan 2024 00:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969190; cv=none; b=gMZjcdRTnaSfxcxTE9eGurdM/uNB4RnK97DlumH6an/2lLu6mbt7t5aqa0IkYl11ecka/nMmYlofKhwuzU+u5oumyQGmVlaElb7k5QbfY7RhOoq2e1rbuLe8152AeVBQOp+WZ2ltiK3/HjaulCmxCkMrytUtJvFJ3oZdKVazkOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969190; c=relaxed/simple;
	bh=cmiiN/CJG2UTMh61cwJb8/71mFUi9bRC64Hs3H0pTZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hMpLSfNK7vnI9Hp38+qSgsoVS/v+k5Zt5CdmExcpAelOnGG5kSOay7bFBh9C7/ko5nnllf/xAz2Crs+QA5v9Cf6ADSDkglt/0ebFBGlMBAHXh2TgPxkF6XyYJv2gz51cKAPptJZU7dJB4WoZRTpOvCuiKU0PQR/WPACsTaWSREA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g4kXbcX9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g4kXbcX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B677EC433C7;
	Tue, 23 Jan 2024 00:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969189;
	bh=cmiiN/CJG2UTMh61cwJb8/71mFUi9bRC64Hs3H0pTZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g4kXbcX9X4IZAW+ssPn/J19H8XcYokPSXTtz27ZLNlmbmi+ODAcf3TyiJJxz++Puv
	 c+AjfYsod3358JaTofXYgjM9SEY/i7EDhTqPVbLyodHBpwtO5tvhwJFQhe1Deskl3s
	 efTFGEk6VoNNPIyc7BQPXV4det2jqlJeZJNE7olg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 079/641] crypto: sahara - improve error handling in sahara_sha_process()
Date: Mon, 22 Jan 2024 15:49:43 -0800
Message-ID: <20240122235820.502137818@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait@windriver.com>

[ Upstream commit 5deff027fca49a1eb3b20359333cf2ae562a2343 ]

sahara_sha_hw_data_descriptor_create() returns negative error codes on
failure, so make sure the errors are correctly handled / propagated.

Fixes: 5a2bb93f5992 ("crypto: sahara - add support for SHA1/256")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sahara.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 3661f02d131a..cfb02905c1ab 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -987,7 +987,10 @@ static int sahara_sha_process(struct ahash_request *req)
 		return ret;
 
 	if (rctx->first) {
-		sahara_sha_hw_data_descriptor_create(dev, rctx, req, 0);
+		ret = sahara_sha_hw_data_descriptor_create(dev, rctx, req, 0);
+		if (ret)
+			return ret;
+
 		dev->hw_desc[0]->next = 0;
 		rctx->first = 0;
 	} else {
@@ -995,7 +998,10 @@ static int sahara_sha_process(struct ahash_request *req)
 
 		sahara_sha_hw_context_descriptor_create(dev, rctx, req, 0);
 		dev->hw_desc[0]->next = dev->hw_phys_desc[1];
-		sahara_sha_hw_data_descriptor_create(dev, rctx, req, 1);
+		ret = sahara_sha_hw_data_descriptor_create(dev, rctx, req, 1);
+		if (ret)
+			return ret;
+
 		dev->hw_desc[1]->next = 0;
 	}
 
-- 
2.43.0



