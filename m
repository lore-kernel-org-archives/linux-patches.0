Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C750512BF3E;
	Tue, 30 Apr 2024 10:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473889; cv=none; b=oXuevF/9DRmHs8gh0OWHLvJlTiW+g2ISAfaYzIvxgy5FYbj8AIJl+mUKu7CTo/n2K6/u0/ntO+OAvDjgXwhjutOgzGvOYPPaKrUjrIqZlvGSgF3g31EUqpW55JJQ2DC/a4IZsUNfeXFhvb1MZpg4A+3Wp/Y+HKB2emquDoJQBh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473889; c=relaxed/simple;
	bh=CnbwM04Z1eBImR6CVRJaUOUR+H5uKlK3KHL8Z8U32/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7kfkFwq5I3ViRy2OpmXtHjJSzc5bWujzdhxHX2W9cdqNGJEzvMzArdQmlrvJHUqNNyDF/ENi0lNV2oqiwqkwI39hKEu3dik/K4gZurApOBpWx0uiBE6KO2jNvzKlvQA5Dh4sG1JR+Kk3aCZWyW3j3YAtN6CZMh8r6MLUNYYJYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXXw8fIp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXXw8fIp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4C9C2BBFC;
	Tue, 30 Apr 2024 10:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473889;
	bh=CnbwM04Z1eBImR6CVRJaUOUR+H5uKlK3KHL8Z8U32/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xXXw8fIpDDDzagT7HDbAD/RuM4KKVE/F9PgijkXJZcgMQYsq2vxj8OD35fC6Q+KxX
	 +NQ58ysPz+6E7XgTiyGtxuEhTFhUv0un0wSqVjGWgTMW7EmPCapoI+p5vrB/7KExxP
	 8QxZ2rann2OHqwJfjRxcCKtPEjG8zhNVmRWKfdhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Jiri Kosina <jkosina@suse.com>,
	Eva Kurchatova <nyandarknessgirl@gmail.com>
Subject: [PATCH 4.19 73/77] HID: i2c-hid: remove I2C_HID_READ_PENDING flag to prevent lock-up
Date: Tue, 30 Apr 2024 12:39:52 +0200
Message-ID: <20240430103043.294857512@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

commit 9c0f59e47a90c54d0153f8ddc0f80d7a36207d0e upstream.

The flag I2C_HID_READ_PENDING is used to serialize I2C operations.
However, this is not necessary, because I2C core already has its own
locking for that.

More importantly, this flag can cause a lock-up: if the flag is set in
i2c_hid_xfer() and an interrupt happens, the interrupt handler
(i2c_hid_irq) will check this flag and return immediately without doing
anything, then the interrupt handler will be invoked again in an
infinite loop.

Since interrupt handler is an RT task, it takes over the CPU and the
flag-clearing task never gets scheduled, thus we have a lock-up.

Delete this unnecessary flag.

Reported-and-tested-by: Eva Kurchatova <nyandarknessgirl@gmail.com>
Closes: https://lore.kernel.org/r/CA+eeCSPUDpUg76ZO8dszSbAGn+UHjcyv8F1J-CUPVARAzEtW9w@mail.gmail.com
Fixes: 4a200c3b9a40 ("HID: i2c-hid: introduce HID over i2c specification implementation")
Cc: <stable@vger.kernel.org>
Signed-off-by: Nam Cao <namcao@linutronix.de>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
[apply to v4.19 -> v5.15]
Signed-off-by: Nam Cao <namcao@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/i2c-hid/i2c-hid-core.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -58,7 +58,6 @@
 /* flags */
 #define I2C_HID_STARTED		0
 #define I2C_HID_RESET_PENDING	1
-#define I2C_HID_READ_PENDING	2
 
 #define I2C_HID_PWR_ON		0x00
 #define I2C_HID_PWR_SLEEP	0x01
@@ -259,7 +258,6 @@ static int __i2c_hid_command(struct i2c_
 		msg[1].len = data_len;
 		msg[1].buf = buf_recv;
 		msg_num = 2;
-		set_bit(I2C_HID_READ_PENDING, &ihid->flags);
 	}
 
 	if (wait)
@@ -267,9 +265,6 @@ static int __i2c_hid_command(struct i2c_
 
 	ret = i2c_transfer(client->adapter, msg, msg_num);
 
-	if (data_len > 0)
-		clear_bit(I2C_HID_READ_PENDING, &ihid->flags);
-
 	if (ret != msg_num)
 		return ret < 0 ? ret : -EIO;
 
@@ -550,9 +545,6 @@ static irqreturn_t i2c_hid_irq(int irq,
 {
 	struct i2c_hid *ihid = dev_id;
 
-	if (test_bit(I2C_HID_READ_PENDING, &ihid->flags))
-		return IRQ_HANDLED;
-
 	i2c_hid_get_input(ihid);
 
 	return IRQ_HANDLED;


