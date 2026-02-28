Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8802F36C9E9
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302298; cv=none; b=VDETa29NO/UBeFMzjBudVWbSk7G3RF0IKlkAxcfGopNcnwvS/4ifbm87beHaZ5y9HD2SUcn6WLIvtsHLL8xUlYFAOUrfO25EnuAvAcotZLe7U5GA2ej6fgr9EmwdeAHx5uYrW7Mlet8T3vQWR/k5tkARMVi5N3J+bVdP2nHIfNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302298; c=relaxed/simple;
	bh=kXZWofhJ2m56OFJgQLK8/ceHkmk24PWDIma89V4Qh2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qlcaqw7qOU0EtSUTWFFBKflPVKapC3q5XTqMb6lupggrNx8CKbxXjv3H0pxk7+glRKbExJ87RjTVOXrffYIOYqfhAP80llUDgKI/i2JA6CPrGhVuIiskmi43D6XuPz9Z+idEaOfYm1K5Vt+tSEXAw/cC6eVFNkWHq2PQe/4k2LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D62ut16o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D62ut16o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61DCC19423;
	Sat, 28 Feb 2026 18:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302298;
	bh=kXZWofhJ2m56OFJgQLK8/ceHkmk24PWDIma89V4Qh2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D62ut16o9Wui/RQSFKMbctJo/Qht1DzEx9fhqQoEP5eBDf4nTd5h5xvyL5J+UPMXy
	 kPUIAiyG0Q0zsmnndBAaFKlCfYy+Q32iiam4AFTCqyo3znmuCDkNtR+nrgKkvrr+8G
	 9i6dv0v9KYfbSoE8MXVnqC0vUfox/hsTx9GMZJ8WyZrALXeUArHqXh8yrx/XCTUczT
	 37MG9c9XMy/5+XkXkbitlIKzP7Ku5/j8EbohZsr5JkpKJqsR5VRav7OJvX9FSod00E
	 ErEIz+wuRGp+t5Mkel554Rk59MHp/UFrZqN8CYdCeoBcw1Q+L2w3PMQmXmL/dpR5a+
	 2msWoI5tn2+Xw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alper Ak <alperyasinak1@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/232] tpm: tpm_i2c_infineon: Fix locality leak on get_burstcount() failure
Date: Sat, 28 Feb 2026 13:07:45 -0500
Message-ID: <20260228181127.1592657-12-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index fd3c3661e6466..b1cfd2da5eb3e 100644
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

