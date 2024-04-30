Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C198801;
	Tue, 30 Apr 2024 11:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476008; cv=none; b=jgU5/kfjkedGfPrRh+ZzaQAu44U23hwvkxFFLarqWU0qD3Ngljg7Id2hXvSNKOZM+5xFuyZ8RHjT+S0vFCd9ttPjpI5qeHpm1+b8v9wEs2IWsvoHNKsfnIaKJPzOfH/pg/LiPxnl31CzNk2xHgfkbDSv/ePqo2HFd0H9L3VTnHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476008; c=relaxed/simple;
	bh=GdLeS1Ssq7m2y6Yyl5v7Q3k/wa9oXVpQ3HEfM1Qkr9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXirf5RjMFWQYJTOc8VTZdDxbHVE5bxdQX7864hvU6Y+1nNwGecjVh7Qv4Yibzg8aiaQGwm6tMKThsCtM6KMvaMxeJ16ADKRQTeS46YkXL/j8andnzgtARY4eqtO3AOhsTsBY+h87f8LBylpSkKMIaxPHemO/JrND6VGXf7P8bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IUuPJV2x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IUuPJV2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5F7C2BBFC;
	Tue, 30 Apr 2024 11:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476008;
	bh=GdLeS1Ssq7m2y6Yyl5v7Q3k/wa9oXVpQ3HEfM1Qkr9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IUuPJV2xJF7TvxjUJobfS/J3Hn7z/96YXiVrLlazk23yz6rqmrPexX/lbYXeR71v6
	 MhYgeZLrecIf1/3U9KcXxV/9D1ljsBkKoT/jhxYvWj9wOB1rJjSIIykKF1BLOco/44
	 Oc5AGFfKBemQxjY9C23SuhZzqOMrb53POby5u5OI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Jiri Kosina <jkosina@suse.com>,
	Eva Kurchatova <nyandarknessgirl@gmail.com>
Subject: [PATCH 5.15 77/80] HID: i2c-hid: remove I2C_HID_READ_PENDING flag to prevent lock-up
Date: Tue, 30 Apr 2024 12:40:49 +0200
Message-ID: <20240430103045.685119702@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -51,7 +51,6 @@
 /* flags */
 #define I2C_HID_STARTED		0
 #define I2C_HID_RESET_PENDING	1
-#define I2C_HID_READ_PENDING	2
 
 #define I2C_HID_PWR_ON		0x00
 #define I2C_HID_PWR_SLEEP	0x01
@@ -251,7 +250,6 @@ static int __i2c_hid_command(struct i2c_
 		msg[1].len = data_len;
 		msg[1].buf = buf_recv;
 		msg_num = 2;
-		set_bit(I2C_HID_READ_PENDING, &ihid->flags);
 	}
 
 	if (wait)
@@ -259,9 +257,6 @@ static int __i2c_hid_command(struct i2c_
 
 	ret = i2c_transfer(client->adapter, msg, msg_num);
 
-	if (data_len > 0)
-		clear_bit(I2C_HID_READ_PENDING, &ihid->flags);
-
 	if (ret != msg_num)
 		return ret < 0 ? ret : -EIO;
 
@@ -533,9 +528,6 @@ static irqreturn_t i2c_hid_irq(int irq,
 {
 	struct i2c_hid *ihid = dev_id;
 
-	if (test_bit(I2C_HID_READ_PENDING, &ihid->flags))
-		return IRQ_HANDLED;
-
 	i2c_hid_get_input(ihid);
 
 	return IRQ_HANDLED;


