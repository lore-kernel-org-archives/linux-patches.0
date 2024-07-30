Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B571FBA;
	Tue, 30 Jul 2024 17:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359438; cv=none; b=Zwk6xhQGuT4t2MeRCVe5EKgCOBR0o8zFvScfM6i8OEWWb0c5k0i61Hnmq2CWhJzk4n6jefU9349FdGuAt8wuWDgVLDobpqoveW8uO/jRScQCegS5yfAlmbAE73lvLp6M7ZiGCxtyhztDJdI9/C1qVEDOEimAvFTxahrSYWfeAJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359438; c=relaxed/simple;
	bh=DHa5SJJD7XPHgtVurZoGS6qC1HY40mcaDej4bm0ZLgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJmukETXjO+PejXMOVQrH7TmkLhfTEDBogN8M+mUoeM5cBSXrnvWkqIxL2SbxRlSBpHI0qH68KMrismHwu2lBAikdLJ90YHon/QZqA90A+CbuaDtNAWu7oi4534ycj+MVr4w3OmeqlLgDCSp2nvhgNJk2KVobMIzHGKXV+yxcdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IpO3GZff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IpO3GZff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B523C32782;
	Tue, 30 Jul 2024 17:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359437;
	bh=DHa5SJJD7XPHgtVurZoGS6qC1HY40mcaDej4bm0ZLgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IpO3GZffDeMG9q6uLoN3IVfbUwYFM8QwW/vj6psyDC3Tx8sCjtrW6mOc8gusz9ewO
	 dLARp4MFwGneQscg983JmXaTYdbqfRg2u5NpUfmHjYmI+4Hq040RcfAixbatkJDIeQ
	 VoixlnDnpYHdLIECAGuyhaa6AYJ2b/0cA1XHKaSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joy Chakraborty <joychakr@google.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.6 482/568] rtc: isl1208: Fix return value of nvmem callbacks
Date: Tue, 30 Jul 2024 17:49:49 +0200
Message-ID: <20240730151658.866392774@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Joy Chakraborty <joychakr@google.com>

commit 70f1ae5f0e7f44edf842444044615da7b59838c1 upstream.

Read/write callbacks registered with nvmem core expect 0 to be returned
on success and a negative value to be returned on failure.

isl1208_nvmem_read()/isl1208_nvmem_write() currently return the number of
bytes read/written on success, fix to return 0 on success and negative on
failure.

Fixes: c3544f6f51ed ("rtc: isl1208: Add new style nvmem support to driver")
Cc: stable@vger.kernel.org
Signed-off-by: Joy Chakraborty <joychakr@google.com>
Link: https://lore.kernel.org/r/20240612080831.1227131-1-joychakr@google.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-isl1208.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/rtc/rtc-isl1208.c
+++ b/drivers/rtc/rtc-isl1208.c
@@ -775,14 +775,13 @@ static int isl1208_nvmem_read(void *priv
 {
 	struct isl1208_state *isl1208 = priv;
 	struct i2c_client *client = to_i2c_client(isl1208->rtc->dev.parent);
-	int ret;
 
 	/* nvmem sanitizes offset/count for us, but count==0 is possible */
 	if (!count)
 		return count;
-	ret = isl1208_i2c_read_regs(client, ISL1208_REG_USR1 + off, buf,
+
+	return isl1208_i2c_read_regs(client, ISL1208_REG_USR1 + off, buf,
 				    count);
-	return ret == 0 ? count : ret;
 }
 
 static int isl1208_nvmem_write(void *priv, unsigned int off, void *buf,
@@ -790,15 +789,13 @@ static int isl1208_nvmem_write(void *pri
 {
 	struct isl1208_state *isl1208 = priv;
 	struct i2c_client *client = to_i2c_client(isl1208->rtc->dev.parent);
-	int ret;
 
 	/* nvmem sanitizes off/count for us, but count==0 is possible */
 	if (!count)
 		return count;
-	ret = isl1208_i2c_set_regs(client, ISL1208_REG_USR1 + off, buf,
-				   count);
 
-	return ret == 0 ? count : ret;
+	return isl1208_i2c_set_regs(client, ISL1208_REG_USR1 + off, buf,
+				   count);
 }
 
 static const struct nvmem_config isl1208_nvmem_config = {


