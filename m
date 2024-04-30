Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B27112D209;
	Tue, 30 Apr 2024 11:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475547; cv=none; b=Z7oyb5Ry9+Xkvr3cmHMB18Yr7v4ea72Nk3rEKbfvdb7TWzCnl77+ETjR6qLgvI9868DPWU54+4enaLTJHvdlgnX9yGAObxY06Aqtq2J3Yra2C4QPvr03q2O2GgQ2UqFC4qQQyZqhG2UrlbiCcdbKIcZKZ/w6/lwBgmQgYMsT9yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475547; c=relaxed/simple;
	bh=b+CyqGRCbQJhLjuRTM13DHCWsiAvxIgPJZC9u33RGAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EiEqf22Tcyx5yb28OtA1ClZD07ay3dnLIhQ8O8VyEp42jzOVDVlrapNUFPepwjjdGC+vl5yV6WlqE5eC5xwSCDU1KIHxyofNRu2T/A3ztOt6HyG0ctKI9srkyiaPsO3Z5pzQLe6K2yuyyP+tJsjNnMNj+lY6jPpJ2kIctleQETI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qhTnxpPa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qhTnxpPa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04CEAC2BBFC;
	Tue, 30 Apr 2024 11:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475547;
	bh=b+CyqGRCbQJhLjuRTM13DHCWsiAvxIgPJZC9u33RGAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qhTnxpPan1CSV2hvZ0lP+ok96BSgkG2FXhU58DDaSWkJIXHrnf6oiesioSEJv1KFQ
	 2a+CcgJjGc1XTIKgUeSvl79WUw5Lt9hzokvO58VYxaWSKsqfXUqUAYX+xBfWEcd8CE
	 9npjJkin1EnR2evhOx3dpQghrK5Tyk4mok9/drdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Jiri Kosina <jkosina@suse.com>,
	Eva Kurchatova <nyandarknessgirl@gmail.com>
Subject: [PATCH 6.6 130/186] HID: i2c-hid: remove I2C_HID_READ_PENDING flag to prevent lock-up
Date: Tue, 30 Apr 2024 12:39:42 +0200
Message-ID: <20240430103101.804993786@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/i2c-hid/i2c-hid-core.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -64,7 +64,6 @@
 /* flags */
 #define I2C_HID_STARTED		0
 #define I2C_HID_RESET_PENDING	1
-#define I2C_HID_READ_PENDING	2
 
 #define I2C_HID_PWR_ON		0x00
 #define I2C_HID_PWR_SLEEP	0x01
@@ -190,15 +189,10 @@ static int i2c_hid_xfer(struct i2c_hid *
 		msgs[n].len = recv_len;
 		msgs[n].buf = recv_buf;
 		n++;
-
-		set_bit(I2C_HID_READ_PENDING, &ihid->flags);
 	}
 
 	ret = i2c_transfer(client->adapter, msgs, n);
 
-	if (recv_len)
-		clear_bit(I2C_HID_READ_PENDING, &ihid->flags);
-
 	if (ret != n)
 		return ret < 0 ? ret : -EIO;
 
@@ -566,9 +560,6 @@ static irqreturn_t i2c_hid_irq(int irq,
 {
 	struct i2c_hid *ihid = dev_id;
 
-	if (test_bit(I2C_HID_READ_PENDING, &ihid->flags))
-		return IRQ_HANDLED;
-
 	i2c_hid_get_input(ihid);
 
 	return IRQ_HANDLED;


