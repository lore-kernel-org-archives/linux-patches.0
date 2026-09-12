Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12E82AD3C;
	Sat, 12 Sep 2026 16:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231990; cv=none; b=RuSvZNj2Uu6icqXjzWYWJ5+VMbrhHHZVEos/tPk+/RXxZhzLu6ozG0awO9o3k1Lzu06a7ZPGVRSVeBplBS4AJxqOoUetPGzPa3IXLyXvOW8SrZozuoQ4hQvH6BSHE61KZbPB5TVZrTmbtTyti3SUQYSqgyoFQ+AnejVouoqM5D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231990; c=relaxed/simple;
	bh=o16EaVm5gJqwHmIgJmf+79zppyy2vJd19nOuTkFOEKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVMJRbe5IKQvIL+wTZ/YvwZG6wa0DvqEa00suZ8lKi0zYD3YS29kKbrCMakkeVH4fZSOUnL0jSiufeW/7e1FbCa7aBGl5ifuVCMg2q27qwrkIVfZXvBXy1rDVdi04jteP0m1V9PIBBud4pxFDsrF9cHfQ9mqt27zHhrXkQp2WjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VP9h0OMI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VP9h0OMI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7831F000FF;
	Sat, 12 Sep 2026 16:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231988;
	bh=NoG98aM4hziBgim4Vfbeq/LT1/vRjGReq25les4Uc48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VP9h0OMImuJLjC9AhAHGfwtSZkk+61w5kj8hH4eUv+z0zEiObJEXwkKaUXFB+cgIo
	 LCDUIdnUIJ+5hbGDXqMhHdzw4UOPJhKohOXvpJkpgl8w0gqYU9TiUns/WNltlxeV83
	 ArK4LBO+mdCa2bjmWCTFk/OPaCUQJ5X+8WkY0pB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1112/1191] tpm: st33zp24: Validate locality read result
Date: Sat, 12 Sep 2026 09:04:00 +0200
Message-ID: <20260912065613.128904209@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 264216889d39df509b9c8045df53529480b0b718 ]

check_locality() treats every nonzero transport return as success. SPI
errors remain negative, while the I2C path can convert a negative write
error through its byte-sized status variable. Either result is nonzero
even though the TPM_ACCESS byte can remain unwritten, so indeterminate
ACTIVE_LOCALITY and VALID bits can falsely report an active locality.

Require recv() to return exactly the requested byte before examining
TPM_ACCESS. Transport errors and short reads now report an inactive
locality, while successful reads retain the existing behavior.

This issue was found by a static analysis checker and confirmed by manual
source review.

Fixes: 251a7b08213a ("TPM: STMicroelectronics ST33 I2C KERNEL 3.x")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Link: https://lore.kernel.org/r/20260813153032.3951878-2-ruoyuw560@gmail.com
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/st33zp24/st33zp24.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/st33zp24/st33zp24.c b/drivers/char/tpm/st33zp24/st33zp24.c
index a1f795158715d..fbb1120e2bd00 100644
--- a/drivers/char/tpm/st33zp24/st33zp24.c
+++ b/drivers/char/tpm/st33zp24/st33zp24.c
@@ -105,10 +105,10 @@ static bool check_locality(struct tpm_chip *chip)
 {
 	struct st33zp24_dev *tpm_dev = dev_get_drvdata(&chip->dev);
 	u8 data;
-	u8 status;
+	int status;
 
 	status = tpm_dev->ops->recv(tpm_dev->phy_id, TPM_ACCESS, &data, 1);
-	if (status && (data &
+	if (status == 1 && (data &
 		(TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
 		(TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID))
 		return true;
-- 
2.53.0



