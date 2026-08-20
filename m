Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFCC25C6EE;
	Thu, 20 Aug 2026 16:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244535; cv=none; b=fMegBM8UgikE6CCbMfyA+Igwyti7kw8jtn1PG4Y0mlZerUnIJf7zQC9aeuaTd17/x4cS+mu8qr5rjUkNuIdGAthSEBCWY9w8Kx1y233JinUlJ7O9gnf0Xp/MBtXFD4HevLR32usQA6EZ8u0edi6w9HK18gDwm89+oSxBcprudnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244535; c=relaxed/simple;
	bh=6zR+jzFjVnrVcu/EwDkSqJdsWDtWh8G5valdZ66AVbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GD9ogqH4kmDtRIl6oFORrIaOGrDBif1UsI2hTn0Qeme4yR/oRv/7zcK+IRZq9NdX0vzufL5B6IhjAb8N/4aXDITfklhU2KXTVrwZE2Rx+w5Vt80oi/ppA3lsN6NuuRkKyhTB0edNHAqtbG2eEHohAaTwaM61jyU/+LnPXGtEQw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qefctc3Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qefctc3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5CAF1F000E9;
	Thu, 20 Aug 2026 16:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244534;
	bh=KZLEb9SdeBSuHoi1J8yZYqFNd0Yl3GZsSC+47EEGh0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qefctc3QiPpqWJrP8AUIwKJ2dm8Dxa3kjHdC4OuBMg5tO273G0gEarG0fA28+Ceu0
	 pB4X3x3ZYV0ORBWto13bdHOYpXDVF3Qj6GgjYCzJUXh7kkciAq3GuZH6Ftl+bEvlql
	 uHl0Ke/2A4CGV3OdxcLz+hVwzG8JrXOGOD8lLO/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 202/235] i2c: bcm-iproc: remove printout on handled timeouts
Date: Thu, 20 Aug 2026 16:57:18 +0200
Message-ID: <20260820145222.681086328@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 796e2c260187e32530cf343546ba1cdf2e2f5491 ]

I2C and SMBus timeouts are not something the user needs to be informed
about on controller level. The client driver may know if that really is
a problem and give more detailed information to the user. The controller
should just pass this information upwards. Remove the printout.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Stable-dep-of: 98f2e9e6d6f9 ("i2c: iproc: reset bus after timeout if START_BUSY is stuck")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-bcm-iproc.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/i2c/busses/i2c-bcm-iproc.c
+++ b/drivers/i2c/busses/i2c-bcm-iproc.c
@@ -789,8 +789,6 @@ static int bcm_iproc_i2c_xfer_wait(struc
 	}
 
 	if (!time_left && !iproc_i2c->xfer_is_done) {
-		dev_err(iproc_i2c->device, "transaction timed out\n");
-
 		/* flush both TX/RX FIFOs */
 		val = BIT(M_FIFO_RX_FLUSH_SHIFT) | BIT(M_FIFO_TX_FLUSH_SHIFT);
 		iproc_i2c_wr_reg(iproc_i2c, M_FIFO_CTRL_OFFSET, val);


