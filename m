Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2537A32A3C9;
	Sun,  7 Jun 2026 10:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828587; cv=none; b=p10wShRWi05qzkex1P/BOWrRRZa6PzmoBKMlSOZyXfO/+VxwCZ5rqcisHPZ9FB8W1DVV5E3Z6OxZToGNnITSEKqGuJpjt1/kfbmdacbK26+C0ZMlWBE5mIhxe0rrensXM8OwMLreavyzBVfM/nub+E3IRdD6o6H5Dkgp8ZoJXOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828587; c=relaxed/simple;
	bh=85/puwfzhwyxZ0jMgGEDpcoLRCmAFPtDLx2jIuzI4qQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gd4C1o2plZQ83JbN9EmS73+t4payFzvfzFPTmuToNOvTmlagUEwbTbock+h+dYnv0Dfae8Z8AnMkGpvzUkqVWw7LPtK2pGcsDnoZDGgZT+yON1244UDOyiEiEuefxVzJ63ZNcYCf6MoB1mJCI1TeP6Ibx8H4yY0N3sqYYg99u8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kNaeah6n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kNaeah6n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0681D1F00893;
	Sun,  7 Jun 2026 10:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828586;
	bh=xIxnEEqer6lCmfc/RdlEvRGCjCthy8DWt29MGgQyazI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kNaeah6n303yaDw/TLo4tfolKp2KExhpOAsnv1Ky0ow0A7c3oS9C/1xobsh2sqXam
	 ewepfSsw70Y52hl3Ex+6jIZ1qHylMYuZRC7HVxfjdWvYiwsV3I5d9NTSe6shZKkTGF
	 9R6uiF8YWr/WHz/RcQjnntHQHMgcLj6SAFsNZwco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Gyeyoung Baek <gye976@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 7.0 195/332] iio: chemical: mhz19b: reject oversized serial replies
Date: Sun,  7 Jun 2026 11:59:24 +0200
Message-ID: <20260607095735.221369933@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


