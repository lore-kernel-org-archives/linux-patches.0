Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1852DC321;
	Sat, 12 Sep 2026 15:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226483; cv=none; b=rOkTTkuUdIHZFdHhr23AvE9j87PhIixQZxMF/Yl+YvJbwNS8g5j1RhuWkOPVSIfXfNdWmpIlJoymkqY1xnMdjdhjhQGZFRw5AzCTw8xpsGcXP3zZCFaRw2WeuMIUkYE1YkCGQ4aBE3dfz4ekwdI0xWUEX5ksdJk2ePsyJyEZskc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226483; c=relaxed/simple;
	bh=yOQeIGE6OUJUwvwwdWpGRVQ9i7coyXtq/hwJz1vbwoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxvLCZ/C93ItNy7aWl3zWDARPvPGN5ItMzO89I9VU0OcRhKeMhVfguVO23KLMQAjQHYBSM+RJLfF2q5ObjQICg+NfHK0Z2Q8w+zUsvKdwsOo0S6iCQrWbjXX5wC7u634tzroFg9qcumwOz+/6/ijoQOY74gY11USikswqbu6i0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AOgoNgM1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AOgoNgM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E2D1F000FF;
	Sat, 12 Sep 2026 15:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226482;
	bh=Ol/uHOa3CaGQqcP9Yvrn0wwVEL8a5akmFUvv2drHq/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AOgoNgM13hgfk1sqFD6kEC2zPTbSORhpz4QyIZmgy1Rt151HiB7yrZYL9Lti8f9Za
	 2DK5BHZxXpFGOjQ8rjrTx13G9aUibx8685POEDOphH69pdPKo5VOV39p101wUAUllC
	 IEjujGPy+FAxwxn+3rsJzRtnXIgGNI+t+JJtQ6tM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1368/1424] tpm: st33zp24: Return zero on status read failure
Date: Sat, 12 Sep 2026 09:03:20 +0200
Message-ID: <20260912065637.899308895@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f78c61f4163d5..e810a7fa9db10 100644
--- a/drivers/char/tpm/st33zp24/st33zp24.c
+++ b/drivers/char/tpm/st33zp24/st33zp24.c
@@ -93,7 +93,9 @@ static u8 st33zp24_status(struct tpm_chip *chip)
 	struct st33zp24_dev *tpm_dev = dev_get_drvdata(&chip->dev);
 	u8 data;
 
-	tpm_dev->ops->recv(tpm_dev->phy_id, TPM_STS, &data, 1);
+	if (tpm_dev->ops->recv(tpm_dev->phy_id, TPM_STS, &data, 1) != 1)
+		return 0;
+
 	return data;
 }
 
-- 
2.53.0



