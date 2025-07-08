Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494DA8F5B;
	Tue,  8 Jul 2025 16:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992947; cv=none; b=o4QrNppwx7T8MD4lgkAkpE0ZHMgDNBeWX2lG6GTFtGCDrI9vnD9xkOwCWHzxaWqThxllrcGZP4JFtQC38x1bLJbrwJ7E3xQNCj7hbJ7TxeX0RRAr2juVR6b7M01fAXd70EKhql2ZOLAKtwFcqe+CKoRetzlfKleRxuA21kQ1vVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992947; c=relaxed/simple;
	bh=SLxwoHI8APVvwUETMiSNlRP5LikjWsbOQpbltXgR/kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iwkg/2HyglpcQuCtxLWD7xwfro7tqj/USvD4YRB/KFvgPSBrOMmN8srYkkavef8c8+I/X6GBmd8p/gY/xZETfAHzxluV23pg69qD+PuyQm83SYGB/v6DiGkDPNeAkmYrVGqMEoVj4TZOCbD/W0LnIFHxQ9CycyJDP1bxPMiz0oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s83MgYVX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s83MgYVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48EBC4CEED;
	Tue,  8 Jul 2025 16:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992947;
	bh=SLxwoHI8APVvwUETMiSNlRP5LikjWsbOQpbltXgR/kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s83MgYVXtG9TZn71mcpbi6rUctnF1NI4Gy4m5ePIl4UazbdCb2rSQvHTm3Hf2bjft
	 FYwk7k8U3EHY4nQRW+4d+IXViG1dCy9I+Tg07v+yK/OyYUyr9wGAev5V3sQRtsaNMG
	 Fk0Esf+KrWWnVp/km85SpsvWE/CwBBY0w7BVwoLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/232] crypto: iaa - Do not clobber req->base.data
Date: Tue,  8 Jul 2025 18:21:31 +0200
Message-ID: <20250708162243.934641891@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit cc98d8ce934b99789d30421957fd6a20fffb1c22 ]

The req->base.data field is for the user and must not be touched by
the driver, unless you save it first.

The iaa driver doesn't seem to be using the req->base.data value
so just remove the assignment.

Fixes: 09646c98d0bf ("crypto: iaa - Add irq support for the crypto async interface")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 711c6e8914978..df2728cccf8b3 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1182,8 +1182,7 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 			" src_addr %llx, dst_addr %llx\n", __func__,
 			active_compression_mode->name,
 			src_addr, dst_addr);
-	} else if (ctx->async_mode)
-		req->base.data = idxd_desc;
+	}
 
 	dev_dbg(dev, "%s: compression mode %s,"
 		" desc->src1_addr %llx, desc->src1_size %d,"
@@ -1420,8 +1419,7 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 			" src_addr %llx, dst_addr %llx\n", __func__,
 			active_compression_mode->name,
 			src_addr, dst_addr);
-	} else if (ctx->async_mode && !disable_async)
-		req->base.data = idxd_desc;
+	}
 
 	dev_dbg(dev, "%s: decompression mode %s,"
 		" desc->src1_addr %llx, desc->src1_size %d,"
-- 
2.39.5



