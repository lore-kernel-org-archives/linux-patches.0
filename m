Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458BB1F941
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:18:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB02EC433C8;
	Fri, 21 Jul 2023 16:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956322;
	bh=+RsjphFFg7pVLQ9ePTZLAZWQN410QFyG4FwkD9G1pKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XooHun++CCsgGUlPhGtsq9YVEWSdiU54WzsmIuKeD8ULoyQuKUxrVEHSsxsM8/b1j
	 jIWfskeiUPK0jy1TA96CkEuiIMRH4XFmSRenOoLTN3ugn0kGiWFlZLhxdV9Lp+b7R3
	 Pct4JB9OSB3pNc6tjPzkLzDba6snC6bagfeS0x7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Haener <michael.haener@siemens.com>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>
Subject: [PATCH 6.4 128/292] tpm: tis_i2c: Limit write bursts to I2C_SMBUS_BLOCK_MAX (32) bytes
Date: Fri, 21 Jul 2023 18:03:57 +0200
Message-ID: <20230721160534.324545866@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

commit 83e7e5d89f04d1c417492940f7922bc8416a8cc4 upstream.

Underlying I2C bus drivers not always support longer transfers and
imx-lpi2c for instance doesn't. The fix is symmetric to previous patch
which fixed the read direction.

Cc: stable@vger.kernel.org # v5.20+
Fixes: bbc23a07b072 ("tpm: Add tpm_tis_i2c backend for tpm_tis_core")
Tested-by: Michael Haener <michael.haener@siemens.com>
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_tis_i2c.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

--- a/drivers/char/tpm/tpm_tis_i2c.c
+++ b/drivers/char/tpm/tpm_tis_i2c.c
@@ -230,19 +230,27 @@ static int tpm_tis_i2c_write_bytes(struc
 	struct i2c_msg msg = { .addr = phy->i2c_client->addr };
 	u8 reg = tpm_tis_i2c_address_to_register(addr);
 	int ret;
+	u16 wrote = 0;
 
 	if (len > TPM_BUFSIZE - 1)
 		return -EIO;
 
-	/* write register and data in one go */
 	phy->io_buf[0] = reg;
-	memcpy(phy->io_buf + sizeof(reg), value, len);
-
-	msg.len = sizeof(reg) + len;
 	msg.buf = phy->io_buf;
-	ret = tpm_tis_i2c_retry_transfer_until_ack(data, &msg);
-	if (ret < 0)
-		return ret;
+	while (wrote < len) {
+		/* write register and data in one go */
+		msg.len = sizeof(reg) + len - wrote;
+		if (msg.len > I2C_SMBUS_BLOCK_MAX)
+			msg.len = I2C_SMBUS_BLOCK_MAX;
+
+		memcpy(phy->io_buf + sizeof(reg), value + wrote,
+		       msg.len - sizeof(reg));
+
+		ret = tpm_tis_i2c_retry_transfer_until_ack(data, &msg);
+		if (ret < 0)
+			return ret;
+		wrote += msg.len - sizeof(reg);
+	}
 
 	return 0;
 }


