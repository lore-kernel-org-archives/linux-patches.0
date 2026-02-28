Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC79375AAA
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301627; cv=none; b=hQdgrsHXZ+Oke+5JbpabyXUxgO8cancgAr1VQ7euq4tlbiEcXp1R4O1UBjK6WrHAZ6FqXfoHGUdUiApGIqmuYcq1+8OuEWjsI2uY4kNF4JoNtBlesxDQlo/htyh8s+Ya+TX802307tDdq/UljZY36t5qbF9NwGFI265Ic2h43Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301627; c=relaxed/simple;
	bh=tMRhH3b4Qv16+wIX0wq6CYBKRItvqPMaTdl2WXtNBZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gv0BQO0CBw7a7u2qS0DMO6pRm/XamC/yqKx/5ZYvHK6pvRdLTrvauBkeMDjcRJdDpj+e7EnPLrKL6SggtO4QC7ItldW+lZWNxy7x/QLzinUe3A7g5SrWhhoZTtXDp9X50VuiaMgI1fR+q75En5FG8nVZcgKptkRot5PXvti7als=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gDvojDwz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gDvojDwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628A6C19424;
	Sat, 28 Feb 2026 18:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301626;
	bh=tMRhH3b4Qv16+wIX0wq6CYBKRItvqPMaTdl2WXtNBZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gDvojDwzp0Q5PujR/sbraVV6++lnyKjrXDLkYSkvUDpmRa3QrEZe+RXQ/0FXPL+uu
	 x1Qt8Gl8D1uoVUJDL1Mf5SUaHK8m41If6PqdAU8iOIeAFYEX02yL8NqvjZ8QYMPyrg
	 iMJTIz9e3fwWf8IcbZik3otY4Z8wCUH1AQnw9av0yFyXRXqmvTIPnsIQlj7/ZomBYU
	 mNvsowczi46KWSB2N+EDJrxsTGM4sjcyefpEQrWgoKLsVB7h/gA1LWIjn48O4Peh+n
	 NfrQUQLRok6I5BzVfuXgunFWd7LtxgZxDgijSiyDvJu5K3XCmIYejiOtQPHWt/5dU3
	 L0nXArf+ZhdKg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alper Ak <alperyasinak1@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/385] tpm: st33zp24: Fix missing cleanup on get_burstcount() error
Date: Sat, 28 Feb 2026 12:54:00 -0500
Message-ID: <20260228180011.1568201-18-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index c0771980bc2ff..06caf53a42ee5 100644
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

