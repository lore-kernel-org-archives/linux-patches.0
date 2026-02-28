Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A04F36C9E6
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302299; cv=none; b=HsCJau60T6OkkzXeB6zf092CGbqlTZ74crHcpilYUhaEiseUUiIVlaE2IOm40GnsDU2BtniY4HaRdQwoOKIAJ+vkOyqHw9oNTlp5PkdF4smF7NtVZe0EoO1023IV2PbxDNQAyDR6i+zPZfx9eR6bE/lL1vt8vdMGTpJYymFtVFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302299; c=relaxed/simple;
	bh=cC5G4q/8nVRkSOd6+oYBecbvnRi46ZAI0PqoNgGo3Z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ch+V1HuWa6yfMqRZ9MsL4GPF9t9nFaZ2hQBmPFdHoM0wPTzUB8zmcYkD/S0XsEUQST2H/6O8lbQCWWm6J2GWn8N2WZOf3XwVVBiVWnHZwjMOk12u+CiqPdNlFw3Px2XeKcKzR29KhhPlcGob7KDVId3TTHJBYZPyjNeEIKIx5gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RHrQNxw8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RHrQNxw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A845CC116D0;
	Sat, 28 Feb 2026 18:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302299;
	bh=cC5G4q/8nVRkSOd6+oYBecbvnRi46ZAI0PqoNgGo3Z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RHrQNxw8hFINlhU8idVT5zuoVF45e7Ym/+ZCd4gg/m7ILrLso7gh612Ew/WBLf4v9
	 F6TcLDEhoMRpPuOe/nEO3iK8KorIdGXJedzu/EVc/T8sKehE/fXJHK0dczI58pU2Kr
	 YoBq7iEudElwxN1tM88j52/Nc4/peR8EZgTLNlL8prP6J5jwHwHnlO0glH89rmfktj
	 T0DfEmCBINvI9GegYqF7HzeT/uZ6LPVNQN9BlLe9DTcqHowAEXmmujuwMY1+DR1hcb
	 Um3FvtN7swY18mNLgatI+w0IOWOyXOLmcGi2DTTVjkx0KpyYBYjLX/I+j6XQz8Wbeg
	 sSg5yYEYyqPMw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alper Ak <alperyasinak1@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/232] tpm: st33zp24: Fix missing cleanup on get_burstcount() error
Date: Sat, 28 Feb 2026 13:07:46 -0500
Message-ID: <20260228181127.1592657-13-sashal@kernel.org>
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
index 15b393e92c8ec..71cc97f394b51 100644
--- a/drivers/char/tpm/st33zp24/st33zp24.c
+++ b/drivers/char/tpm/st33zp24/st33zp24.c
@@ -327,8 +327,10 @@ static int st33zp24_send(struct tpm_chip *chip, unsigned char *buf,
 
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

