Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD802772A;
	Thu, 15 Aug 2024 14:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732414; cv=none; b=o2BeWr8XfIc7SzANNLD+lXT/tD6IyhGMjLeU+JjzDz3z/ctiDLzrZ2O+Iz6ZLh4TzFXDqCEO9+ydAyhLoq+Gdx0iV+cDNde2FIjxIKKHXIdK+JRpRg4PeM8iDBIu6a5722og7SRxFFESNUre2sY+CTOCnPpi9mUcwPpRkQOwgqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732414; c=relaxed/simple;
	bh=QBrPjtVlujIr4YzoyfKXfLtGpnYLatQYJ/zIlMlX3KM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBP7B0QcAPrT5Orj6/WRB7ufMKnykWjUOfC2WBuPEXSTT4g9yA0OXXigFbtrwsxloILQkvMYBhm09ZFmphQW2kb+X753Qm/5eYSCS8OhYc4k1UL5jv8Wi1+zqXiHeO0HKjM+/jKNzd+/QBEKeaZVI96uaN0hJHVEIeNVzSgusFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCII4zWz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCII4zWz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF11C32786;
	Thu, 15 Aug 2024 14:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732414;
	bh=QBrPjtVlujIr4YzoyfKXfLtGpnYLatQYJ/zIlMlX3KM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCII4zWzrfTxVwh6/X6dTP22fu+BPZE+huPJqvbxh9nBxwp70qA0vA4jDGbqdkm+o
	 ZVBHJVPHb5LYTcfnCS8sOwmSed+k5fynm8J2CSQFiZrirHoCm+vwRNAILIP0gyQZOB
	 19oIt3TmlIsBKU1K88bTJMUHK9B5lDAJ6vY6Kv7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joy Chakraborty <joychakr@google.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.10 172/352] rtc: isl1208: Fix return value of nvmem callbacks
Date: Thu, 15 Aug 2024 15:23:58 +0200
Message-ID: <20240815131925.922989908@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -743,14 +743,13 @@ static int isl1208_nvmem_read(void *priv
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
@@ -758,15 +757,13 @@ static int isl1208_nvmem_write(void *pri
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


