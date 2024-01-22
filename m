Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318CC1852;
	Tue, 23 Jan 2024 01:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972189; cv=none; b=By4LfiJtbxpQZZ6qgssYwCHNd6LK4DxFbxK0y355qP7xJOJ/cxqd6CTMPLLJjLVCP+BKx4yAhREe2iYZLI0eck5LcV/wDVRm4+2hA2UDPBfb0m4AyVNKYRNxwKXip0BfwwaSKH+estLmsRCaCZQazgcje3+Mk/Ql2ej02Wu0ya4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972189; c=relaxed/simple;
	bh=xxbKOe+aw592RS5cxKgpvJzKgjszxST54QFXiFZB6Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YwszK4WU4ScPxI5RfOelNS9VF/NwTN9nLt7INN7cKc6D/15BjupH/DyO1L/IFweAvXmSf9tUrTOuM+SnVCchLNJEGpCRE7rv6ePWgrCwi5CuQ/NTmHfCq0s6TRs1ChLQlUkVeyluOja9FmQC2hRZMDzs9JmTTrnpY/gNz407bLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nw8A+A8G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nw8A+A8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EEEC433C7;
	Tue, 23 Jan 2024 01:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972189;
	bh=xxbKOe+aw592RS5cxKgpvJzKgjszxST54QFXiFZB6Bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nw8A+A8G4r8I1kvRFHuRdEWj5Ao5MdgFC2fzfswEmNGrhHBp+ZMGiwdYmatPMQoXN
	 +aHCksOBTXTaNeP4KFdK4RKUiBHuCcqskrPyqoHCpMN9PqatSCeq2z9yyUd71antvV
	 8EnIfSjV2RC3D6OEJgY+6RleCMLSfT1dHpc5Tz7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 111/374] crypto: sahara - improve error handling in sahara_sha_process()
Date: Mon, 22 Jan 2024 15:56:07 -0800
Message-ID: <20240122235748.496253384@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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
index a5c40ef6d8af..434c7e17d273 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -988,7 +988,10 @@ static int sahara_sha_process(struct ahash_request *req)
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
@@ -996,7 +999,10 @@ static int sahara_sha_process(struct ahash_request *req)
 
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



