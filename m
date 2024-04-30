Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E9C12C47A;
	Tue, 30 Apr 2024 11:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476320; cv=none; b=pOefDtP0rjTWcgN/q223K+Xfdnd7wqMTKVIHkLV0Ckj6ZE7XkmNbCpNrNLMuMZmLNVvUQw794oj19hqYJkGUL5j01Ih7cOOU9EuqyVb0luTc32Yt9dHhucFpTc9Bsj2wkfG47b8WD6EW2ySydP9ewCb/7Z3WCqYcQvmy1kKVFcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476320; c=relaxed/simple;
	bh=wjXcGFRfwx0Ux20yJwQ/dxBlRDlu/5faC26cCd7dvg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSQzW4mVSjwWjhWLL+SrF4OqEYo0KBTydQNQGy7/ZQDbFK6X8R0Y4TZMz3xuVkdKVaVMYLkhwgF19jkCPU5kBF7mbLVrBhKdJqJDugzUlLU4vL+3humWrYFF7p3ky/lbUVtV26LzM5LTxHd3Wf79qM0NSnqzHbXF0rvGLPijww0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q/q88Ezq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q/q88Ezq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091ADC2BBFC;
	Tue, 30 Apr 2024 11:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476320;
	bh=wjXcGFRfwx0Ux20yJwQ/dxBlRDlu/5faC26cCd7dvg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q/q88EzqESyfRxAcsND6th16G/AJLKogwoIiWNN/7CEElXcUc0kIFBATy1Nzfh1S5
	 s+cM31Kxvqh8P1tuTx6z8Ahg1lqPy3ijxeR8sPrPzqmHpqVIhIr+oYB6XmOefseM17
	 U/jq+F8vYLQkrPdtC+w5a/L+vLSTXq5Bf4sJZCM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Jiri Kosina <jkosina@suse.com>,
	Eva Kurchatova <nyandarknessgirl@gmail.com>
Subject: [PATCH 5.4 103/107] HID: i2c-hid: remove I2C_HID_READ_PENDING flag to prevent lock-up
Date: Tue, 30 Apr 2024 12:41:03 +0200
Message-ID: <20240430103047.697478326@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -56,7 +56,6 @@
 /* flags */
 #define I2C_HID_STARTED		0
 #define I2C_HID_RESET_PENDING	1
-#define I2C_HID_READ_PENDING	2
 
 #define I2C_HID_PWR_ON		0x00
 #define I2C_HID_PWR_SLEEP	0x01
@@ -258,7 +257,6 @@ static int __i2c_hid_command(struct i2c_
 		msg[1].len = data_len;
 		msg[1].buf = buf_recv;
 		msg_num = 2;
-		set_bit(I2C_HID_READ_PENDING, &ihid->flags);
 	}
 
 	if (wait)
@@ -266,9 +264,6 @@ static int __i2c_hid_command(struct i2c_
 
 	ret = i2c_transfer(client->adapter, msg, msg_num);
 
-	if (data_len > 0)
-		clear_bit(I2C_HID_READ_PENDING, &ihid->flags);
-
 	if (ret != msg_num)
 		return ret < 0 ? ret : -EIO;
 
@@ -540,9 +535,6 @@ static irqreturn_t i2c_hid_irq(int irq,
 {
 	struct i2c_hid *ihid = dev_id;
 
-	if (test_bit(I2C_HID_READ_PENDING, &ihid->flags))
-		return IRQ_HANDLED;
-
 	i2c_hid_get_input(ihid);
 
 	return IRQ_HANDLED;


