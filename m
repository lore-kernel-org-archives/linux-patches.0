Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E2A34197;
	Fri, 24 Nov 2023 18:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PwmfuJ8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955D3C433C8;
	Fri, 24 Nov 2023 18:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850112;
	bh=As9bqPqQjLnsVBbEoIaCY0Zcyq2hP9Hj7kyw48Avf6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PwmfuJ8Vjsk0trJSBFRSvYfh4YRApcofT7QauoQxc+7tFbUS1z2+EpDN5xMi40Dfy
	 8toeUwZ/VKYfQ2PpwUMbOR6vFh5X40z0pBe3e4QbchXp183OEYw7yneQN5z51wsMCa
	 BwITw1aMbV+ojZwtMvnaTEZxf7QwwDfy59b0jpBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jean Delvare <jdelvare@suse.de>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 6.6 449/530] i2c: i801: fix potential race in i801_block_transaction_byte_by_byte
Date: Fri, 24 Nov 2023 17:50:15 +0000
Message-ID: <20231124172041.761284019@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Heiner Kallweit <hkallweit1@gmail.com>

commit f78ca48a8ba9cdec96e8839351e49eec3233b177 upstream.

Currently we set SMBHSTCNT_LAST_BYTE only after the host has started
receiving the last byte. If we get e.g. preempted before setting
SMBHSTCNT_LAST_BYTE, the host may be finished with receiving the byte
before SMBHSTCNT_LAST_BYTE is set.
Therefore change the code to set SMBHSTCNT_LAST_BYTE before writing
SMBHSTSTS_BYTE_DONE for the byte before the last byte. Now the code
is also consistent with what we do in i801_isr_byte_done().

Reported-by: Jean Delvare <jdelvare@suse.com>
Closes: https://lore.kernel.org/linux-i2c/20230828152747.09444625@endymion.delvare/
Cc: stable@vger.kernel.org
Acked-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-i801.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -681,15 +681,11 @@ static int i801_block_transaction_byte_b
 		return result ? priv->status : -ETIMEDOUT;
 	}
 
-	for (i = 1; i <= len; i++) {
-		if (i == len && read_write == I2C_SMBUS_READ)
-			smbcmd |= SMBHSTCNT_LAST_BYTE;
-		outb_p(smbcmd, SMBHSTCNT(priv));
-
-		if (i == 1)
-			outb_p(inb(SMBHSTCNT(priv)) | SMBHSTCNT_START,
-			       SMBHSTCNT(priv));
+	if (len == 1 && read_write == I2C_SMBUS_READ)
+		smbcmd |= SMBHSTCNT_LAST_BYTE;
+	outb_p(smbcmd | SMBHSTCNT_START, SMBHSTCNT(priv));
 
+	for (i = 1; i <= len; i++) {
 		status = i801_wait_byte_done(priv);
 		if (status)
 			return status;
@@ -712,9 +708,12 @@ static int i801_block_transaction_byte_b
 			data->block[0] = len;
 		}
 
-		/* Retrieve/store value in SMBBLKDAT */
-		if (read_write == I2C_SMBUS_READ)
+		if (read_write == I2C_SMBUS_READ) {
 			data->block[i] = inb_p(SMBBLKDAT(priv));
+			if (i == len - 1)
+				outb_p(smbcmd | SMBHSTCNT_LAST_BYTE, SMBHSTCNT(priv));
+		}
+
 		if (read_write == I2C_SMBUS_WRITE && i+1 <= len)
 			outb_p(data->block[i+1], SMBBLKDAT(priv));
 


