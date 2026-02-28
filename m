Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BCA33D6F7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301626; cv=none; b=hfzHY/lswmogI3SoHb+ZaTsYou0bqj3u2Zt8pqxcMgwULSkMdO5hKEsSS8uHhWa42H7rXEq38wg1SNXGJnf48Aax3srv3rpIFGaopRpdMxweR1iZWBpNOL5RNiSncgOF/GNFQIIC/dL5MvcAbUIjxFdu6Vd8K0AM4534HRfaWkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301626; c=relaxed/simple;
	bh=x7T7gXRXk2Mez3XQb4rfhR48AD15xz/gzIWXv6zalg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTZoHE3+XIxpuZaQrH+oF+t9CKq7T8PTikQkEmdSTWYh9TyLO9GZoVE71FJtFSylx49Mp2drjSli0I6vxmqAgZy1SZTDmbkiZbC7oSkC34vu21zxFgEozdZ9Ajl1k0LdBzrpje8uO2nXgWQunRfIJT8Dg8kGCzFAYqQBrBdKcL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SdiTti3N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SdiTti3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0210C116D0;
	Sat, 28 Feb 2026 18:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301626;
	bh=x7T7gXRXk2Mez3XQb4rfhR48AD15xz/gzIWXv6zalg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SdiTti3NI63CK4M2jP5Inc9EB+v5YHU2SkfZQ4PE5aX5UhuGEsKZxl9sayYc3pr7a
	 l64H+RD6P/MHuX7PZmNXI/WXnkkWsDOhWfIbgqVAwhgajLNQV5k03LlLWsxvJK7Sz9
	 puopA5G1ZRIJsUlOFoy/phvvYUB0ZaEx70JU+fUVBhXKqPXtvyaG7hgWYcyuC0ZkK4
	 B8h8vYiXSATSQjev77/eZohFtYexr76L9Znmv35ygzpbDdoaelhr5NFf0G9TttylN9
	 pClZOtlBfQI2UNyn5uloYMu3utIh8POpngVSPfMP4nPaEKefVwv6nqXw4Di+fwQ/ca
	 IeRELNuVW1DVQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alper Ak <alperyasinak1@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/385] tpm: tpm_i2c_infineon: Fix locality leak on get_burstcount() failure
Date: Sat, 28 Feb 2026 12:53:59 -0500
Message-ID: <20260228180011.1568201-17-sashal@kernel.org>
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
index 81d8a78dc6552..3675faa4a00c7 100644
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

