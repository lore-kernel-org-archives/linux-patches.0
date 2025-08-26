Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB26534AAF8;
	Tue, 26 Aug 2025 13:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216619; cv=none; b=obz5oowm4MRS9/A5LVFxMjT/lrnGveLlm+1pG+C6jOcb8oh/DvHSKT6Wre9zcekWh04eFcj4OhvOq+RXcwgHSc/1heKMqCVtyqzu3bEjCFwvLCd/8M528VRcgEo076BPO/0elQ8kUsyIM+CJCNGjPCFjA97vyKcgeWeZ/BbiDLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216619; c=relaxed/simple;
	bh=du8p+i2I9jHZSYew7mYXdtTAjHuThQcc20Dz1DFjyYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsANuoCYGaO63YkWngoCVr2X3zgiWYaO0lFdXmxdRYjNKKsDz2sZ40+raQZRDms76H9fmSqdeMw5of2rweqwM5y0W5oWSePeT3ebLBwmeu2oYdDdY0wQkz8Wugsvlu1yZYr/VabA7Ye2MCwHjjauo+axdBvvzYenzBS3Cjxib5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PxoQ1xZY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PxoQ1xZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237B0C4CEF1;
	Tue, 26 Aug 2025 13:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216619;
	bh=du8p+i2I9jHZSYew7mYXdtTAjHuThQcc20Dz1DFjyYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PxoQ1xZYWYNWb8v4/GRzr72yO5RVS6zkC2xVOB6Ef40n0rSXuZGIR66dzh3P5GJ77
	 6/HbDY7vx124qb0OQHUv4HA2bWJeT5E/sTccEIZ6dslYPaAgHTKxu/o1iZH8+H16Nz
	 WsnXx4s2R6ekuzqu9GiGoYAtzeKDYLKAKOdUqXB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 480/644] mtd: spinand: propagate spinand_wait() errors from spinand_write_page()
Date: Tue, 26 Aug 2025 13:09:31 +0200
Message-ID: <20250826110958.381973835@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

From: Gabor Juhos <j4g8y7@gmail.com>

commit 091d9e35b85b0f8f7e1c73535299f91364a5c73a upstream.

Since commit 3d1f08b032dc ("mtd: spinand: Use the external ECC engine
logic") the spinand_write_page() function ignores the errors returned
by spinand_wait(). Change the code to propagate those up to the stack
as it was done before the offending change.

Cc: stable@vger.kernel.org
Fixes: 3d1f08b032dc ("mtd: spinand: Use the external ECC engine logic")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/spi/core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -618,7 +618,10 @@ static int spinand_write_page(struct spi
 			   SPINAND_WRITE_INITIAL_DELAY_US,
 			   SPINAND_WRITE_POLL_DELAY_US,
 			   &status);
-	if (!ret && (status & STATUS_PROG_FAILED))
+	if (ret)
+		return ret;
+
+	if (status & STATUS_PROG_FAILED)
 		return -EIO;
 
 	return nand_ecc_finish_io_req(nand, (struct nand_page_io_req *)req);


