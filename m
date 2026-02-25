Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20D4262FC0;
	Wed, 25 Feb 2026 01:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983722; cv=none; b=PDbTWukrWmvbP1hxIWD7fzm1gn6P/xrT1t2lImoDbCGt+HY9F5teF4OTv25aIe8bcPQfosUlL3/a1BtuWWtgpudciLqD/c42y96o+ytxwnbsLNH4JnVj6SLuk9e49Z2T2jXl8GsLtj1cNw/uD02nDekJcaxLKWhFwvMsYeoeg4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983722; c=relaxed/simple;
	bh=uiBLuxeAGZ+qVEXf0evUowLYoPohCjpeX6PMYWJzQu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ah+uom48BcOIgvMH2zY2VkAGwiGJADlQ/MVgGCvKiFCCP5YoJho8WUuqu0k2Ami+rOzqrld5Zq0XiZrDFe/GrwAxgqkUiQbRHalvrO6xQ9J4Z6QmKzhkBTsfSjIDPNWlZxgEMC+963jMfERy9OoxVfQtxo+D2az/y6N/wTBgDUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=euzyHPxq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="euzyHPxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB50BC116D0;
	Wed, 25 Feb 2026 01:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983721;
	bh=uiBLuxeAGZ+qVEXf0evUowLYoPohCjpeX6PMYWJzQu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=euzyHPxqKa0e+ijsXh7VN2tSwxyEELzyNipW6jmB3hi7M/7+ehf2hqv6K8y/VUReq
	 3no3wFOorlt4LuxWFhKFGYGmL4tyUliqUrFg2yNn5iqHnpqdvVnLg7yAjyHhDO5f8Y
	 jJOC27LGG1Q8dCeGxPHQOlJ+R2WuSoa5RtZXaDkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alper Ak <alperyasinak1@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 019/641] tpm: st33zp24: Fix missing cleanup on get_burstcount() error
Date: Tue, 24 Feb 2026 17:15:45 -0800
Message-ID: <20260225012349.436622059@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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



