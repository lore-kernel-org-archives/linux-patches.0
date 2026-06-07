Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB7E2D3A69;
	Sun,  7 Jun 2026 10:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828541; cv=none; b=tvfzPzkWtYdiLbLg7NLPHX69ekKSxuZ0sIFN5LpNyHjxlP2tkHarxvg6IKDlC/IIoqjlW9qsibqGNmZqOaXw/cOrAs+u768F99COG8OLsqwXHVYxHOLkt0RvVA9D/2UQe8aIXRbL9zNqu9nvBMQ/rtI+inZYMcq/AYEMJCu1Wbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828541; c=relaxed/simple;
	bh=g4fsEwOp08cUIrM3DqzTe8fb+VYf5O8WH6eALWvOVAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVNqvDrDUkepWseDItchvjkbWJRCRKIw4bud7XYHOoK2CKAEheBZdWH5ADjnB0jdeCheC+ES52ep8wTQZbxNFkspvuncX/KhL0FXKlCNXJLY0cqxsIxyvgjtzYySI6ySYp9NizvyNRZKtcC8jf6QeZ/d0mDiZ9MEmQAY+67GrU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FQjt/B5G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FQjt/B5G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2F71F00893;
	Sun,  7 Jun 2026 10:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828540;
	bh=AkDVIPJ5NuJdq/bV3yE1KzU+gsI0PfPmDC78782xj0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FQjt/B5G250tg+CwYo903DeEHepcTJC3udnhDTtClRNuT4m/mqaqgRMWWDqMUkzvR
	 DdSI94fftUlEHzBwpr6j8fbCecTvZfrccfYOd5Pnf6UW51WiSkRAWMOTiELie7sLKk
	 ReQLLXto769C45JqPWQRatS9CBO59APr+merk1ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Gyeyoung Baek <gye976@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 171/315] iio: chemical: mhz19b: reject oversized serial replies
Date: Sun,  7 Jun 2026 11:59:18 +0200
Message-ID: <20260607095733.870093514@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit 673478bc29cf72010faaf293c1c8c667393335a0 upstream.

mhz19b_receive_buf() appends each serdev chunk into the fixed
MHZ19B_CMD_SIZE receive buffer and advances buf_idx by len without
checking that the chunk fits in the remaining space. A large callback
can therefore overflow st->buf before the command path validates the
reply.

Reset the reply state before each command and reject oversized serial
replies before copying them into the fixed buffer. When an oversized
reply is detected, wake the waiter and report -EMSGSIZE instead of
overwriting st->buf.

Fixes: 4572a70b3681 ("iio: chemical: Add support for Winsen MHZ19B CO2 sensor")
Cc: stable@vger.kernel.org
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Acked-by: Gyeyoung Baek <gye976@gmail.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/mhz19b.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/iio/chemical/mhz19b.c
+++ b/drivers/iio/chemical/mhz19b.c
@@ -52,6 +52,8 @@ struct mhz19b_state {
 	struct completion buf_ready;
 
 	u8 buf_idx;
+	bool buf_overflow;
+
 	/*
 	 * Serdev receive buffer.
 	 * When data is received from the MH-Z19B,
@@ -106,6 +108,10 @@ static int mhz19b_serdev_cmd(struct iio_
 	cmd_buf[8] = mhz19b_get_checksum(cmd_buf);
 
 	/* Write buf to uart ctrl synchronously */
+	st->buf_idx = 0;
+	st->buf_overflow = false;
+	reinit_completion(&st->buf_ready);
+
 	ret = serdev_device_write(serdev, cmd_buf, MHZ19B_CMD_SIZE, 0);
 	if (ret < 0)
 		return ret;
@@ -121,6 +127,9 @@ static int mhz19b_serdev_cmd(struct iio_
 		if (!ret)
 			return -ETIMEDOUT;
 
+		if (st->buf_overflow)
+			return -EMSGSIZE;
+
 		if (st->buf[8] != mhz19b_get_checksum(st->buf)) {
 			dev_err(dev, "checksum err");
 			return -EINVAL;
@@ -240,6 +249,14 @@ static size_t mhz19b_receive_buf(struct
 {
 	struct iio_dev *indio_dev = dev_get_drvdata(&serdev->dev);
 	struct mhz19b_state *st = iio_priv(indio_dev);
+	size_t remaining = MHZ19B_CMD_SIZE - st->buf_idx;
+
+	if (len > remaining) {
+		st->buf_idx = 0;
+		st->buf_overflow = true;
+		complete(&st->buf_ready);
+		return len;
+	}
 
 	memcpy(st->buf + st->buf_idx, data, len);
 	st->buf_idx += len;


