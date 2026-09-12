Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5328C3A9DBA;
	Sat, 12 Sep 2026 20:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243476; cv=none; b=tUt1pwORyhXO5uNTVTQWmNyt43kBskYkhbKODxV5fzFoPiTfLwYoxg2Z/KASytJxzyyyqD2iH+P3KgJib4mYumTW0HJtLpWUTgYcMOiPvjq/zuYyrjgXKpBXeQnP/50Yh3l00FkK1XphyxB56rr4jW8JK2rpR+Cfv1htv4IxNyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243476; c=relaxed/simple;
	bh=JInZFswzSbrA39YrGXRF01ipOGUW7VOpesvelygtS7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FthVYUfztGLpKrj9NZaH+uRyoTmD9MdFQByIbVF/vh84YmWcbfV/VaaUez/P3D+LgOmvzhv3TzzL59KDdJx5AHz2O/Nic/CNuFhfv3GP0R24iXmJ2iLA3hXHNQiBgjm48OAZx5ti2ZJmhZOd+e7W6EpsFGvoeKROZIHQUTo+ge4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/+y5M1Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/+y5M1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57211F00893;
	Sat, 12 Sep 2026 20:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243473;
	bh=+BKANXFN1pBU4giVp4KH82xl+atEIQb9yT22u9xsqJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H/+y5M1YePjatN4HBv+Rp72RHiwgageQsacFRO9isMMZSKG7KdxJVi0ngTFLIataZ
	 f4Bo1fWoSJO4EnqXGi9Gg5NTOlLtVtGZzi2Y7hERepNvftcXELKjaJS4XZAJio6MvY
	 J9vJ9lbuFKAtBgWcxLIdQxxrAuruVYnSqywrXFTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 767/798] tpm: st33zp24: Return zero on status read failure
Date: Sat, 12 Sep 2026 09:06:35 +0200
Message-ID: <20260912065534.647234863@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 8b92687708f5ef980de01c2042dbd76d11f78547 ]

st33zp24_status() ignores the result of the transport read and returns
data even when no byte was received. The I2C transport, for example,
skips i2c_master_recv() when the register-select write is short or fails,
leaving data uninitialized. The resulting stack value can be interpreted
as TPM_STS flags and let status checks complete spuriously.

The status callback cannot propagate a transport error. Return zero
unless recv() reports exactly one byte. With no status bits set, callers
retry or take their existing timeout or error path instead of acting on
an invalid status value.

This issue was found by a static analysis checker and confirmed by manual
source review.

Fixes: 251a7b08213a ("TPM: STMicroelectronics ST33 I2C KERNEL 3.x")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Link: https://lore.kernel.org/r/20260813153032.3951878-1-ruoyuw560@gmail.com
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/st33zp24/st33zp24.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/st33zp24/st33zp24.c b/drivers/char/tpm/st33zp24/st33zp24.c
index 33ee4fe693796..f4f77548a6152 100644
--- a/drivers/char/tpm/st33zp24/st33zp24.c
+++ b/drivers/char/tpm/st33zp24/st33zp24.c
@@ -98,7 +98,9 @@ static u8 st33zp24_status(struct tpm_chip *chip)
 	struct st33zp24_dev *tpm_dev = dev_get_drvdata(&chip->dev);
 	u8 data;
 
-	tpm_dev->ops->recv(tpm_dev->phy_id, TPM_STS, &data, 1);
+	if (tpm_dev->ops->recv(tpm_dev->phy_id, TPM_STS, &data, 1) != 1)
+		return 0;
+
 	return data;
 } /* st33zp24_status() */
 
-- 
2.53.0



