Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7C34E3258;
	Fri,  9 Oct 2026 14:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557407; cv=none; b=DI2Mfk16ZaIOLJa3OecByjBmjKAdBniWiDFFJT+t2l6whBRHRR6+VJIY2cFXt8mKNQbhXNjUcHod47U2muwRnjEymWx/2WZjHFqZvQnC8AxkSvkQQogxerT9eiSiFoRDNGcSufKdn1VuRltnB7Z7HYKvZTggvBqtUVZdi1zGyN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557407; c=relaxed/simple;
	bh=OSndrVQkYSk52Bka+Jm+2YOH9NbD6W6mT/nUcNFXJLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OiF5GJNBr2OR5xk5sLnJZ4VicQogFVmVxHUNJJ2LX5SS1nFUQj1DMIXWOqnfSn/nAmhWJvAUC+gMUTo+qC6gGm1xHyAqJNZ511x+/m/PbEl9ZCAHrTJV7UMrIyNRvGwDVgAV2seddU67U1zEZGzyztzhf5MhWzYbGu2eWE8VNgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RxqlVU6b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RxqlVU6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1676C1F000FF;
	Fri,  9 Oct 2026 14:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557406;
	bh=mknl4IJYXDGkD504YuKpA7WdBGokWHyfWPrHM5I9zKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RxqlVU6bTy8ls1QxPLSDSxKJ1wE08I8P43pRvAWYyyf/okabHx7PVSLFakQEpyZL1
	 RJvJvy5YqaUh4x8cMsGB5/ZN8EpDXaiEERxQTAjKmUwrk/yO8r0MGQx0Ee63rmLgx4
	 kEIg0UHIAxPt5+WQaRCNsdhqZowyF/F0ZUCTeAbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Michael Walle <mwalle@kernel.org>
Subject: [PATCH 7.2 306/428] mtd: spi-nor: core: Fix mutex leak in spi_nor_rww_start_exclusive()
Date: Fri,  9 Oct 2026 16:10:43 +0200
Message-ID: <20261009140952.839717863@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit 44b8a0bf5f96e8393312fc34b956766882341f16 upstream.

Use the same guard(mutex) pattern as the other RWW helpers so nor->lock
is released on both the busy and successful return paths.

Fixes: 03e7bb864d9a ("mtd: spi-nor: use scope-based mutex cleanup helpers")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
[mw: rephrased commit message]
Signed-off-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -1310,7 +1310,7 @@ static bool spi_nor_rww_start_exclusive(
 {
 	struct spi_nor_rww *rww = &nor->rww;
 
-	mutex_lock(&nor->lock);
+	guard(mutex)(&nor->lock);
 
 	if (rww->ongoing_io || rww->ongoing_rd || rww->ongoing_pe)
 		return false;


