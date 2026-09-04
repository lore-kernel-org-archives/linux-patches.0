Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1CB3B19BC;
	Fri,  4 Sep 2026 05:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500071; cv=none; b=qdhEnD8NBjIZI1cPKWLPubIaXGyJKpvIYVJbi5gUWc8pVB+ZAaIAwuEec5zV4+DdntXtWV3MGwg8O9jEbPembNZa80XRuWfw4reX/rc17I5qKSxBx0ObCTjrxgJpRUhoqLzQxYAm7ZCyOaKoygBlm0PIChb5cU0NfDXD4GqXmoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500071; c=relaxed/simple;
	bh=v71zrKhXzW7mVdA7ciRbf8KkrC4eynRZASpOdbQ62nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LTiP1fVI5k4vlwCHq+QOGZXkv9XgK6kSLBNXlmMFu3UqEI5isIQBCwrlF9RVm4mYnN8z3EJ8Ir0T9/SdIiYu8RUwQM+TGt3TVJGFR3jIB2HLtNGDS1WdD9Bjy4iuWrGJtcqNJbjYQxrR5Tf4LOW9XXQ0WGx5CPRinHWaDUS2OL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O+NUOH6F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O+NUOH6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A291F00A3D;
	Fri,  4 Sep 2026 05:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500069;
	bh=aH9+WwycUo/52sZdpuwqezEfNBOgOFFDDR8/SC8Ig7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O+NUOH6Fi9x2BlqW0JBL8VLL5EVRH1MP3b0+NMVtSefMazi4VR7B31fkJgEnKkDCK
	 stOFBPROb9kEMWz4Pc+lIYpquIbkSzc+iS2r56fg6kG4CYCuaPb3rLA+472IHbXO1U
	 6lq6aj0djgp0EnjBFafMRGqe+F6rflvKWvSI7sjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 7.2 633/713] mfd: qnap-mcu: keep the reply buffer alive past a command timeout
Date: Fri,  4 Sep 2026 07:00:01 +0200
Message-ID: <20260904045818.019005259@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Ahmet Memis <ali@iusegentoo.com>

commit 47504742cea7878ebd1bf1491bbed923df6b90b1 upstream.

qnap_mcu_exec() publishes an on-stack buffer to the receive path:

	unsigned char rx[QNAP_MCU_RX_BUFFER_SIZE];
	...
	reply->data = rx;
	reply->length = length;

and qnap_mcu_receive_buf() writes into it from the serdev receive path,
which runs out of flush_to_ldisc() and is not serialized against
qnap_mcu_exec() at all. bus_lock cannot cover it, because qnap_mcu_exec()
holds that mutex across wait_for_completion_timeout().

On a timeout qnap_mcu_exec() returns with reply->data still pointing at
its own frame. A reply that arrives late, or an unsolicited message from
the MCU, is then written into a stack frame that has been left, corrupting
whatever runs next on that stack. The same applies when qnap_mcu_write()
fails, since that path returns without touching the reply state either.

Move the receive buffer into struct qnap_mcu. It is 37 bytes and the
structure is devm_kzalloc()ed, so it lives as long as the driver, and a
late write lands in memory that is still valid and is reinitialized by the
next command. bus_lock keeps commands from sharing it.

This deliberately does not clear reply->data or reply->length on the
timeout path. Doing so races with qnap_mcu_receive_buf(), which reads both
after its

	if (!reply->length)
		return size;

check: clearing reply->data gives a NULL dereference, and clearing
reply->length alone removes the reply->received == reply->length exit
condition, so the copy loop runs until the uart chunk is consumed and
overruns the buffer. Leaving both set keeps the write bounded by
reply->length, which qnap_mcu_exec() has already checked against
sizeof(mcu->rx).

Fixes: 998f70d1806b ("mfd: Add base driver for qnap-mcu devices")
Cc: stable@vger.kernel.org
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
Link: https://lore.kernel.org/all/20260802132012.537B81F000E9@smtp.kernel.org/
Link: https://patch.msgid.link/20260802135307.31380-1-ali@iusegentoo.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/qnap-mcu.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/mfd/qnap-mcu.c
+++ b/drivers/mfd/qnap-mcu.c
@@ -56,6 +56,7 @@ struct qnap_mcu_reply {
  * @reply:	Reply data structure
  * @variant:	Device variant specific information
  * @version:	MCU firmware version
+ * @rx:		Receive buffer the reply is assembled in
  */
 struct qnap_mcu {
 	struct serdev_device *serdev;
@@ -63,6 +64,7 @@ struct qnap_mcu {
 	struct qnap_mcu_reply reply;
 	const struct qnap_mcu_variant *variant;
 	u8 version[QNAP_MCU_VERSION_LEN];
+	u8 rx[QNAP_MCU_RX_BUFFER_SIZE];
 };
 
 /*
@@ -214,19 +216,18 @@ int qnap_mcu_exec(struct qnap_mcu *mcu,
 		  const u8 *cmd_data, size_t cmd_data_size,
 		  u8 *reply_data, size_t reply_data_size)
 {
-	unsigned char rx[QNAP_MCU_RX_BUFFER_SIZE];
 	size_t length = reply_data_size + QNAP_MCU_CHECKSUM_SIZE;
 	struct qnap_mcu_reply *reply = &mcu->reply;
 	int ret = 0;
 
-	if (length > sizeof(rx)) {
+	if (length > sizeof(mcu->rx)) {
 		dev_err(&mcu->serdev->dev, "expected data too big for receive buffer");
 		return -EINVAL;
 	}
 
 	guard(mutex)(&mcu->bus_lock);
 
-	reply->data = rx;
+	reply->data = mcu->rx;
 	reply->length = length;
 	reply->received = 0;
 	reinit_completion(&reply->done);
@@ -242,15 +243,15 @@ int qnap_mcu_exec(struct qnap_mcu *mcu,
 		return -ETIMEDOUT;
 	}
 
-	if (!qnap_mcu_verify_checksum(rx, reply->received)) {
+	if (!qnap_mcu_verify_checksum(mcu->rx, reply->received)) {
 		dev_err(&mcu->serdev->dev, "Invalid Checksum received from controller\n");
 		return -EPROTO;
 	}
 
-	if (qnap_mcu_reply_is_any_error(mcu, rx, reply->received))
+	if (qnap_mcu_reply_is_any_error(mcu, mcu->rx, reply->received))
 		return -EPROTO;
 
-	memcpy(reply_data, rx, reply_data_size);
+	memcpy(reply_data, mcu->rx, reply_data_size);
 
 	return 0;
 }


