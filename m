Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090391863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FAEBC433D2;
	Wed, 28 Dec 2022 15:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239877;
	bh=ZjtrfsprdOkf+S+ZZbLRs8+7HS8dh63QMFm//u2RRaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hsA64Rd7D68mBVDGUuXzd+sS/cCTx0YzrgD1uqURkaRzHXgxiZOHqvaZV69mccPl+
	 zeV3+X9EAMlFrQbIdn30o+c0LWJJGEPE/Pr1pQLcBBUEXjgFLMkRNLNXsQHoqSiuQ2
	 obbMztTdHI7Z8ATZNXCG0BoUoPUp0hTr26zJosbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie James <eajames@linux.ibm.com>,
	Joel Stanley <joel@jms.id.au>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0089/1073] tpm: Add flag to use default cancellation policy
Date: Wed, 28 Dec 2022 15:27:57 +0100
Message-Id: <20221228144330.474907271@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit 7bfda9c73fa9710a842a7d6f89b024351c80c19c ]

The check for cancelled request depends on the VID of the chip, but
some chips share VID which shouldn't share their cancellation
behavior. This is the case for the Nuvoton NPCT75X, which should use
the default cancellation check, not the Winbond one.
To avoid changing the existing behavior, add a new flag to indicate
that the chip should use the default cancellation check and set it
for the I2C TPM2 TIS driver.

Fixes: bbc23a07b072 ("tpm: Add tpm_tis_i2c backend for tpm_tis_core")
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Tested-by: Joel Stanley <joel@jms.id.au>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_tis_core.c | 20 ++++++++++++--------
 drivers/char/tpm/tpm_tis_core.h |  1 +
 drivers/char/tpm/tpm_tis_i2c.c  |  1 +
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 757623bacfd5..3f98e587b3e8 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -682,15 +682,19 @@ static bool tpm_tis_req_canceled(struct tpm_chip *chip, u8 status)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 
-	switch (priv->manufacturer_id) {
-	case TPM_VID_WINBOND:
-		return ((status == TPM_STS_VALID) ||
-			(status == (TPM_STS_VALID | TPM_STS_COMMAND_READY)));
-	case TPM_VID_STM:
-		return (status == (TPM_STS_VALID | TPM_STS_COMMAND_READY));
-	default:
-		return (status == TPM_STS_COMMAND_READY);
+	if (!test_bit(TPM_TIS_DEFAULT_CANCELLATION, &priv->flags)) {
+		switch (priv->manufacturer_id) {
+		case TPM_VID_WINBOND:
+			return ((status == TPM_STS_VALID) ||
+				(status == (TPM_STS_VALID | TPM_STS_COMMAND_READY)));
+		case TPM_VID_STM:
+			return (status == (TPM_STS_VALID | TPM_STS_COMMAND_READY));
+		default:
+			break;
+		}
 	}
+
+	return status == TPM_STS_COMMAND_READY;
 }
 
 static irqreturn_t tis_int_handler(int dummy, void *dev_id)
diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
index 66a5a13cd1df..b68479e0de10 100644
--- a/drivers/char/tpm/tpm_tis_core.h
+++ b/drivers/char/tpm/tpm_tis_core.h
@@ -86,6 +86,7 @@ enum tis_defaults {
 enum tpm_tis_flags {
 	TPM_TIS_ITPM_WORKAROUND		= BIT(0),
 	TPM_TIS_INVALID_STATUS		= BIT(1),
+	TPM_TIS_DEFAULT_CANCELLATION	= BIT(2),
 };
 
 struct tpm_tis_data {
diff --git a/drivers/char/tpm/tpm_tis_i2c.c b/drivers/char/tpm/tpm_tis_i2c.c
index 29f0db41c0b7..e728a61659f8 100644
--- a/drivers/char/tpm/tpm_tis_i2c.c
+++ b/drivers/char/tpm/tpm_tis_i2c.c
@@ -329,6 +329,7 @@ static int tpm_tis_i2c_probe(struct i2c_client *dev,
 	if (!phy->io_buf)
 		return -ENOMEM;
 
+	set_bit(TPM_TIS_DEFAULT_CANCELLATION, &phy->priv.flags);
 	phy->i2c_client = dev;
 
 	/* must precede all communication with the tpm */
-- 
2.35.1



