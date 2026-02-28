Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3173834A3AB
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302668; cv=none; b=DwCA+1c/wuTijSGW1JTedEecpMi1Xx3kxySCdwxhubn4xEZ99EvFgLQh+sR2mu5neD4g4Tkq5uy9zk8SIyjMFwO7fflRDbbsAvPICunBJWB18QVLcKsq2h30uryScYxPoCDbQOpBvEjo3bRtTB3x0zoBlksZUR3nPbLEDj1AOWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302668; c=relaxed/simple;
	bh=xDaX9oiFMsjUA0rDPMJ4cZdWFw9xgX7mRXhjYX4NcBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2VQabY8r1ket4nmFZc3psN7rasAAtzKG2Bvapn8MdDI+c7bdz4n3oIqNGkvO7ZEKyI/3Uh7vM1ZiiGQVXpN72ZUhRdqeOQ6lgV4eca5awqF6NAb+IOp7EBFcfMIqsIghp1Q2+hmM9bbFi2geZKXZl40Cx/ox7Qe+U8W/Zqm7wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cJkI6ktd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cJkI6ktd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94527C19424;
	Sat, 28 Feb 2026 18:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302668;
	bh=xDaX9oiFMsjUA0rDPMJ4cZdWFw9xgX7mRXhjYX4NcBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cJkI6ktd7dyov7VuN6hZIcGYNRaFiiwxyemQ+NUgZnU+NvMtQWBmgZ4xu0o3dLYdF
	 bZK/roO1Amp1ieqzD5854p7v6rBK2EL6wE8fDIpLk/MISqKkbd5Z40haFq6YTUVgd5
	 9pj840pMLZZc0TJDTIybfQiCV9d2CgOBlWrBG7DXiVbKaAKWMpel0PaHBJWL/+3zQa
	 OAdmsbDT9qJTYs/OdqitZw0gljYUTYHEyoaWuJsEe/k5gMTi3wCUw6ExQxqFourFBL
	 isSA6BQ4fhfg8E7C9beBI17eTH7qIGfvFc5rO75sfgvTz23B3N+0rt7THuuPCBbSBl
	 ryEsxFD3eTQkg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alper Ak <alperyasinak1@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/147] tpm: tpm_i2c_infineon: Fix locality leak on get_burstcount() failure
Date: Sat, 28 Feb 2026 13:15:23 -0500
Message-ID: <20260228181736.1605592-15-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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

