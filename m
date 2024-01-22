Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED5912E56;
	Tue, 23 Jan 2024 00:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970644; cv=none; b=OawUqfIz1JGGi2jxbOpMKOO0iQ105TEQwkFPAUEHHHrGnf4oPOZcGTU4nz5iH7RN78bhFTvVEUQFYXRZUMj5wwgEUKyKKp67SAbqzR1rZ5Z99Qd5/8hvhML5kX54SdyVXZQK0pMaoHTQ2tDzG6Bv8IW/ctaSC0SEmrNEYAySMMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970644; c=relaxed/simple;
	bh=ey5lNtK6eCYFDE+aiqGEk3roiPR71ZyjDRUUp0ANSfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g2YWiU+/1zv41oUyNVFRVAxk2GAhTPGbvaaP5MZ2Rz7520/3K00LDlVrsktueJF7PKhSDYLRVUwdwfpyOqsUau/icC3bchRT2S1igI6QxoD9rPlY99HgS8vnCcxrswLUoEcSGerm9SFjYkrnHl6EHXWHX1P8nOh47Fo+iMnpseg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lVBJV6Fa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lVBJV6Fa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD73AC433F1;
	Tue, 23 Jan 2024 00:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970643;
	bh=ey5lNtK6eCYFDE+aiqGEk3roiPR71ZyjDRUUp0ANSfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lVBJV6FaP/oR6N9wTtzjMYU7uZexwTY8EmpVaN1AwCvnNMkJc8x6F37WWd0NouSMG
	 17FfhGsFCQykjBXa9jfKvf3fz3cie5jCZEWAplzOtIC9oDF5sVIM6ERbQl/uluJAV2
	 rzW8GUMRuVRPeNwwOIpBFkvfKLnsvlI3tVEaHSU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/417] crypto: sahara - improve error handling in sahara_sha_process()
Date: Mon, 22 Jan 2024 15:53:47 -0800
Message-ID: <20240122235753.752719523@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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
index e2b1880ddeb0..6e112e41a0c7 100644
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



