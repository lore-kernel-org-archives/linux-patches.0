Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4DB221F1F;
	Tue, 17 Jun 2025 15:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174555; cv=none; b=Rkf2xuQ8ACngxvCTagE0RyaFl7tX2AqdJGH5Ny/LJ8UrE8vod5BXUyYJyoqWwD9HisSAtxsvKAvbLQ3++k3EJcqZB/s+0/eFUsKMngJn51BBxU2YdR8YcWgh4z7qQpwoBJGdcDtOjfahibvQi9TucW+E1j2liXvrA8zNIvOAQqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174555; c=relaxed/simple;
	bh=YvDKIIfWs/BKx8FEWoGZ9xNSVy95NOjuxmEUlLBv854=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1TaPaIbowPQbkYou8leydpVXU26qPpSXJ38Nxsp6XMPdfRq72MDmurtoKD+9+i2zdJl3vpQgI2lwMZd3JSfHe8nPpBDuwux+ZrdCwjbfZgjeq6R9zS4pzjMNkIDVDsYNEsJkAs3aizCkfw/Q7PL8p5TT4d+TJkgQyX3W6x0trk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gNnsKV02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gNnsKV02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2898EC4CEE3;
	Tue, 17 Jun 2025 15:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174555;
	bh=YvDKIIfWs/BKx8FEWoGZ9xNSVy95NOjuxmEUlLBv854=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gNnsKV02CHRiKsqqbsJObJOVPloCcbLADIuHhGWgV7Hzqq+8+tQvoQMiRAPJDvZU7
	 fwSgQG6NF1GzChbuUIY4H5HrYE/gtuCFR/QiRLEU8etlay+lebdfakGpl/2FgbeBmA
	 CXR3jE9UH9Imh1V/E44/WEEzr4H/dZDJ+I45lR+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corentin Labbe <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 011/512] crypto: sun8i-ss - do not use sg_dma_len before calling DMA functions
Date: Tue, 17 Jun 2025 17:19:37 +0200
Message-ID: <20250617152419.985132737@linuxfoundation.org>
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
index 9b9605ce8ee62..8831bcb230c2d 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
@@ -141,7 +141,7 @@ static int sun8i_ss_setup_ivs(struct skcipher_request *areq)
 
 	/* we need to copy all IVs from source in case DMA is bi-directionnal */
 	while (sg && len) {
-		if (sg_dma_len(sg) == 0) {
+		if (sg->length == 0) {
 			sg = sg_next(sg);
 			continue;
 		}
-- 
2.39.5



