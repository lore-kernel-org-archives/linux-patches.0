Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BBF39B94C
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302514; cv=none; b=DqtyrFzRnjlP3Y6QCYdf+gb5iWDmS28LQ8i/1bQwQx9UHTZq28lJv9qsn49O4m8MQXXNIfAv5CdtEYdjBtj+hAyMBpAsqhY8PBmgruZhqIxq20t67AMZrc699EGgZTuSCMvKHjMa+DgFUDIKbtiCACDK1vHDLktwfjSIy5PP4EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302514; c=relaxed/simple;
	bh=xDaX9oiFMsjUA0rDPMJ4cZdWFw9xgX7mRXhjYX4NcBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axrDnJZVM4X4Z/HxJMPtEfFwHD6XQd0F9B7vE2pvwDjncEsbRgHHs9sVebDIH4LWgdwoVze9wlyxs5/XyVUx6eGunR1rRfYRF5DBsmY28B/ldd3AIB3JENuoo7xqVN4Z9rQUifyEjGLRpFjsBV7ru4ks9oBQ7dUAcmLx7jy0Vhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=leZMU5yA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="leZMU5yA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B99C116D0;
	Sat, 28 Feb 2026 18:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302514;
	bh=xDaX9oiFMsjUA0rDPMJ4cZdWFw9xgX7mRXhjYX4NcBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=leZMU5yAhIIj8oIr7y5SZwgHiLdNyQI7DuR6687b1SDmsm5nldob3aUvATZrf4euX
	 8LE/u93/NyP6gp/AtMttRjuDb34cKt7zIUubMvL7v6UZOwvO+LRFLAcfLMZH36A1Jy
	 fVOJ/vsfu1uxJ8bBpP5m6j9Anoj4EKlCUoidHankLNmz+QShCVJTImg7f24xYlbUgi
	 Z0yVTudN06xyKn0jmRo/bExVToLWf/GI3eVBsP6mv0e97AE9HqzkugHcE763yGAE+i
	 dw8ifM1Lf6GnhBrkRIaCRSski4yXuXzEC75Var2f3VCqIiF29OUFzMC+XBL7CN3Kq1
	 Okcg7dm2CjASw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alper Ak <alperyasinak1@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 010/164] tpm: tpm_i2c_infineon: Fix locality leak on get_burstcount() failure
Date: Sat, 28 Feb 2026 13:12:29 -0500
Message-ID: <20260228181505.1600663-10-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alper Ak <alperyasinak1@gmail.com>

[ Upstream commit bbd6e97c836cbeb9606d7b7e5dcf8a1d89525713 ]

get_burstcount() can return -EBUSY on timeout. When this happens, the
function returns directly without releasing the locality that was
acquired at the beginning of tpm_tis_i2c_send().

Use goto out_err to ensure proper cleanup when get_burstcount() fails.

Fixes: aad628c1d91a ("char/tpm: Add new driver for Infineon I2C TIS TPM")
Signed-off-by: Alper Ak <alperyasinak1@gmail.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_i2c_infineon.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index a19d32cb4e942..cabc9e1b49321 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -543,8 +543,10 @@ static int tpm_tis_i2c_send(struct tpm_chip *chip, u8 *buf, size_t len)
 		burstcnt = get_burstcount(chip);
 
 		/* burstcnt < 0 = TPM is busy */
-		if (burstcnt < 0)
-			return burstcnt;
+		if (burstcnt < 0) {
+			rc = burstcnt;
+			goto out_err;
+		}
 
 		if (burstcnt > (len - 1 - count))
 			burstcnt = len - 1 - count;
-- 
2.51.0

