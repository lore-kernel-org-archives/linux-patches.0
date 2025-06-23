Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A67D252910;
	Mon, 23 Jun 2025 13:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685183; cv=none; b=PKJdkuvc1q35Jf2eWas2JAMci/qEefBSnlbtP00JmyqEbe9L6pUA4S1IqVqX8nr/rD2nrbxWXXwqutxmbO13SDWGIdVhA0XvaHx6tTx3hslmjXFzb5hxckKNJ4Njky7lCNI/0vy3/U0z9qbRQcBV+6eN9PJ3Zch6Jft1TcHaWS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685183; c=relaxed/simple;
	bh=gPqpNsv2vvVKeB+4HQdU0nL9IRL4W3DFkUuc3aKvCxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxRoCJ98fXxCDt6TfCOWuYibKrnJfTedRIXjVNpbAtYeKrgrA+B+txVo0zUk8q2W3T1/M5QtMcq7m8DzuUvVTL2IaHf+wHUo02XWDAF3EAfWMeA2hngsOOQmJIHwPMmisomPNOOR43VquHQ3Dg9YVX/wY2UYcHpopKwePKLm+Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=awdkZKac; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="awdkZKac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E40C4CEF0;
	Mon, 23 Jun 2025 13:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685183;
	bh=gPqpNsv2vvVKeB+4HQdU0nL9IRL4W3DFkUuc3aKvCxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awdkZKacB+d30LX9b+PCR7gCuXKMiJkkpM/a2RnaAX8B3CxpsiMoqqt3wHDs/z9qk
	 5vBz/mGXPl3rN+AprbRKjDfLReK4BmPTl3TE0BjPpumRzYUDhXnDdtrg8VKwqdSVQn
	 ma7Es8Rm2SsNEs650EvV1jIZxh1cuMK46E0ETyZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corentin Labbe <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/411] crypto: sun8i-ss - do not use sg_dma_len before calling DMA functions
Date: Mon, 23 Jun 2025 15:02:38 +0200
Message-ID: <20250623130633.420984626@linuxfoundation.org>
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

From: Corentin Labbe <clabbe.montjoie@gmail.com>

[ Upstream commit 2dfc7cd74a5e062a5405560447517e7aab1c7341 ]

When testing sun8i-ss with multi_v7_defconfig, all CBC algorithm fail crypto
selftests.
This is strange since on sunxi_defconfig, everything was ok.
The problem was in the IV setup loop which never run because sg_dma_len
was 0.

Fixes: 359e893e8af4 ("crypto: sun8i-ss - rework handling of IV")
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
index 0cc8cafdde27c..3bf56ac1132fd 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
@@ -117,7 +117,7 @@ static int sun8i_ss_setup_ivs(struct skcipher_request *areq)
 
 	/* we need to copy all IVs from source in case DMA is bi-directionnal */
 	while (sg && len) {
-		if (sg_dma_len(sg) == 0) {
+		if (sg->length == 0) {
 			sg = sg_next(sg);
 			continue;
 		}
-- 
2.39.5



