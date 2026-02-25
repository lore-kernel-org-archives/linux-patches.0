Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EAF2505B2;
	Wed, 25 Feb 2026 01:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982883; cv=none; b=aRBbr8VGRybYprV+VO6NK1uNTQHN1I6PQ4eZDy0Jif2dzlabdzljmGJn3dgIRMFqykNg7JGUEaZRHrrygD2djwWdaeNNIt6jsCg2VurPRn/vhH13XVEx+XC3YQWylZHg6eCh48A08XUtxLM3LMA0ZG+XwwPOnpWVWTyyk3hHzMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982883; c=relaxed/simple;
	bh=I3f2uULr5bRJpvnjMrnz+dN11SsUnprHlAHoR2MAkkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVlwN7lqeF2LfIe84AqWpmzxxbaYdBxLACea543oVxsQyjJO3jqSjPZd/kaOY8KwLLDfhfzGgKteeufJV6TOqhgPRgITc3QErgQbEBp3AQdyVRLwzVDQkYR2QZHRrrPYnk+6Lv9y2AVLU7Ap3C5TWzHP8X4gwd1EbG3hdcHC+BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nSyICQwz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nSyICQwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8B1C116D0;
	Wed, 25 Feb 2026 01:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982883;
	bh=I3f2uULr5bRJpvnjMrnz+dN11SsUnprHlAHoR2MAkkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nSyICQwzY4w2+qqF11eES/kYaPtRz4AelSD1D5OtYrGTqeIfxvC7NOxtY0cAcNgdg
	 miE4J3aINA32WbIzAA3P658WFu9pUtBAzx9WzNiLBLkTN4VeKb44bHucS16ewwJ+W1
	 5eP4n8Hc+KuPc/j9bZvt2Lylrdp5Gai7MTs+sack=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alper Ak <alperyasinak1@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 024/781] tpm: tpm_i2c_infineon: Fix locality leak on get_burstcount() failure
Date: Tue, 24 Feb 2026 17:12:13 -0800
Message-ID: <20260225012400.294415475@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index bdf1f329a6794..8b7d32de0b2ef 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -544,8 +544,10 @@ static int tpm_tis_i2c_send(struct tpm_chip *chip, u8 *buf, size_t bufsiz,
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



