Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E6A39FD7;
	Fri, 24 Nov 2023 18:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X4AbkK7V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C52FC433C9;
	Fri, 24 Nov 2023 18:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700848976;
	bh=bVOf6ykizHlY6kILmv25sHkMooZkYK5vkudQxpSOXyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X4AbkK7Ve7bxjYJxj/KMKJNODdHbzSjo2KwU2clCB/ab9fMhtXxSuju/g5gb4Arcd
	 kYDHWEUW/E90hQZVDUqs5WLNoOaa1F8BvjBOdlV3cwnc+dLMPa29DCcyPInFJ+YyH+
	 U8/tX0pbgCAgeUxbD8mWCItqosEsY3ys+AwABcm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jean Delvare <jdelvare@suse.de>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 4.14 49/57] i2c: i801: fix potential race in i801_block_transaction_byte_by_byte
Date: Fri, 24 Nov 2023 17:51:13 +0000
Message-ID: <20231124171932.125003539@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171930.281665051@linuxfoundation.org>
References: <20231124171930.281665051@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -707,15 +707,11 @@ static int i801_block_transaction_byte_b
 		return i801_check_post(priv, status);
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
 			goto exit;
@@ -738,9 +734,12 @@ static int i801_block_transaction_byte_b
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
 


