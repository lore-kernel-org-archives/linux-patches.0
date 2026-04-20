Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FD52DE6E3;
	Mon, 20 Apr 2026 16:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700952; cv=none; b=O6G4qGSEqDm6OuTpPSdgNIAmcS1KtkevwLj5LtD5cQ+CTpnt/BEOfCqwQNjoB8Hx3wU5jn7BxoDLdMX+vKcVIwCw8d9tMDYHA36kVFZt2yzAUuBNeKmDVnA3J+AaaUR8Zv8ZRSCJCYrNCIWzJx1Gl/M6f9/59BlM76fvOYY6HdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700952; c=relaxed/simple;
	bh=y9JQ5LL/JUPNCgmgbrtXGP8id9fZWubCBCtNwfXw7D8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E6MBND+aV9MaCkfwIFQSMfrMTjI4hfE+NbVguRkn/9tNtrkWGh33VkdDB6O1ro2Q/wo715OQTCfKlb1y6raBCbp4fMiakg4vYpWXc5RRo0OQgyUWUVuVy8l8CZ0fSd3JE4hXeWf4Yh+KXB/sBxt2g6nJ4ilU6JtsNzRSmLEQiq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zxnRUT2R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zxnRUT2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F4EC19425;
	Mon, 20 Apr 2026 16:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700951;
	bh=y9JQ5LL/JUPNCgmgbrtXGP8id9fZWubCBCtNwfXw7D8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zxnRUT2R6nnfFaGqE/LqCLr685ZjXl8EUDCEGSErYjFbG/LpCkylKRxtmaLKUC06h
	 QUMX8uaIU5hutiRJGmniggvnFmQue63UFmGqiKPS7WLUZg6Aku9R4d7DrNLZ71fahh
	 ZD6kHqbT1AoDjNjga/TDXE9QnjAIo7dVZZ9InIb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 124/198] i2c: s3c24xx: check the size of the SMBUS message before using it
Date: Mon, 20 Apr 2026 17:41:43 +0200
Message-ID: <20260420153940.071708569@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit c0128c7157d639a931353ea344fb44aad6d6e17a upstream.

The first byte of an i2c SMBUS message is the size, and it should be
verified to ensure that it is in the range of 0..I2C_SMBUS_BLOCK_MAX
before processing it.

This is the same logic that was added in commit a6e04f05ce0b ("i2c:
tegra: check msg length in SMBUS block read") to the i2c tegra driver.

Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Andi Shyti <andi.shyti@kernel.org>
Cc: stable <stable@kernel.org>
Assisted-by: gkh_clanker_2000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/2026022314-rely-scrubbed-4839@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-s3c2410.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -503,8 +503,13 @@ static void i2c_s3c_irq_nextbyte(struct
 		i2c->msg->buf[i2c->msg_ptr++] = byte;
 
 		/* Add actual length to read for smbus block read */
-		if (i2c->msg->flags & I2C_M_RECV_LEN && i2c->msg->len == 1)
+		if (i2c->msg->flags & I2C_M_RECV_LEN && i2c->msg->len == 1) {
+			if (byte == 0 || byte > I2C_SMBUS_BLOCK_MAX) {
+				s3c24xx_i2c_stop(i2c, -EPROTO);
+				break;
+			}
 			i2c->msg->len += byte;
+		}
  prepare_read:
 		if (is_msglast(i2c)) {
 			/* last byte of buffer */


