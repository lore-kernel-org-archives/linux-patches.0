Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0E34369A;
	Wed, 25 Feb 2026 01:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982884; cv=none; b=WU4nvJZH0s8omd978oROQjOKWnvwdP/HDjxSuwymmnAPpcaPQo6pvFYmp6URA5lYyBcBe0CulazZzrecky77DaMyFDTmZYmaIfTrKMOQAPmyCbX/W/Fkbkb91cXZL54++4eZlQlbGnou2SDHg/zxJAzQ35HPnyzPEKsuxMYBotM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982884; c=relaxed/simple;
	bh=g/59EbJiUsxE/Ofcn4h13T1IJWt/SFiWqJDrLm86bY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUrOx+XZRA3DXP8pL2NxFoKakkxeFoPGbbPHwJaVnCv52bJKxlqB3VaNisn5O66BIuJbodt/S+9ce9T6pZigmOOqoqrTJ8saC48yoUMK09GLEwXUEvVzXw3s7EWax4JDWMeF31wkuXilSF0LkM/Tdfyg1HE7caW5Xban6Lb5IRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWiJx4Mp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWiJx4Mp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D3CC116D0;
	Wed, 25 Feb 2026 01:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982884;
	bh=g/59EbJiUsxE/Ofcn4h13T1IJWt/SFiWqJDrLm86bY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dWiJx4Mp+yCG8iVOhjcUhZnQIotlXWrGPJ2nfhQWRd+zz11PZMpfUuSNwibK4FEeb
	 F85MFJXAit/SSePF9fmB+J0BBTG1S/Mjt/tXWf9YFp0lzXgSuhtgh0v8YyWbtkkhj6
	 gqGA384Z8iSd5/dN7eKptA6hQJBRhEPak4GpgnYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alper Ak <alperyasinak1@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 025/781] tpm: st33zp24: Fix missing cleanup on get_burstcount() error
Date: Tue, 24 Feb 2026 17:12:14 -0800
Message-ID: <20260225012400.318194772@linuxfoundation.org>
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

[ Upstream commit 3e91b44c93ad2871f89fc2a98c5e4fe6ca5db3d9 ]

get_burstcount() can return -EBUSY on timeout. When this happens,
st33zp24_send() returns directly without releasing the locality
acquired earlier.

Use goto out_err to ensure proper cleanup when get_burstcount() fails.

Fixes: bf38b8710892 ("tpm/tpm_i2c_stm_st33: Split tpm_i2c_tpm_st33 in 2 layers (core + phy)")
Signed-off-by: Alper Ak <alperyasinak1@gmail.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/st33zp24/st33zp24.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/st33zp24/st33zp24.c b/drivers/char/tpm/st33zp24/st33zp24.c
index 2ed7815e4899b..e2b7451ea7ccd 100644
--- a/drivers/char/tpm/st33zp24/st33zp24.c
+++ b/drivers/char/tpm/st33zp24/st33zp24.c
@@ -328,8 +328,10 @@ static int st33zp24_send(struct tpm_chip *chip, unsigned char *buf,
 
 	for (i = 0; i < len - 1;) {
 		burstcnt = get_burstcount(chip);
-		if (burstcnt < 0)
-			return burstcnt;
+		if (burstcnt < 0) {
+			ret = burstcnt;
+			goto out_err;
+		}
 		size = min_t(int, len - i - 1, burstcnt);
 		ret = tpm_dev->ops->send(tpm_dev->phy_id, TPM_DATA_FIFO,
 					 buf + i, size);
-- 
2.51.0



