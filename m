Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8F835A95D;
	Fri,  9 Jan 2026 12:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960610; cv=none; b=EAxvf/hzYgCgxAliRLoGDZt9oj8dRcYrVwwl8tbh6sFf+hlKs2YZ3xjN1+M/GVPXh8hIb+wZTlgN4A2ejxG6z7Q8CzSQD62hmTacouJy7Xo5e3/9KuzrSj5g0pp6JA4nv2Zyl/6014MuTRWosvkiJB8ItdoqTEMdXi8IpFdNp/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960610; c=relaxed/simple;
	bh=J5m45Smu2LN0dHk6v7wsWW68hoH6cA4M+kY5NnCIX6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qw2Cbi3sr0daEfh7od2ss+SxgN4VsERNLyav7uWiTXePvnt75WAQIwyxCP5xWW5CIIWr8/trhczhyf8e8tQa6ZpcISt0OvBVHvVCwSwDXLDQGaumIN8klaP2/mPWnkpt8HwjNhZmnBhL6jFDitv4bub1zWhPGE0sXpzMQh0DZ0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qHNA1a2X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qHNA1a2X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C75C4CEF1;
	Fri,  9 Jan 2026 12:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960609;
	bh=J5m45Smu2LN0dHk6v7wsWW68hoH6cA4M+kY5NnCIX6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qHNA1a2XRnTtyoRoEdNSbBSQCmDvPZptUXMnLb0theYS4d9MjHcfHgBIubloBObF1
	 lWBnyWqxCWMH/2Ww20Dw8qfsS9+RwcxH0nshTFANCSC9lu+wBuZ0FIJJBt2dFqEFpo
	 LMYrxkgCFsEeVujRL+lWKDfgpefA2wSvy1wXVhOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 432/737] media: dvb-usb: dtv5100: fix out-of-bounds in dtv5100_i2c_msg()
Date: Fri,  9 Jan 2026 12:39:31 +0100
Message-ID: <20260109112150.245409960@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeongjun Park <aha310510@gmail.com>

commit b91e6aafe8d356086cc621bc03e35ba2299e4788 upstream.

rlen value is a user-controlled value, but dtv5100_i2c_msg() does not
check the size of the rlen value. Therefore, if it is set to a value
larger than sizeof(st->data), an out-of-bounds vuln occurs for st->data.

Therefore, we need to add proper range checking to prevent this vuln.

Fixes: 60688d5e6e6e ("V4L/DVB (8735): dtv5100: replace dummy frontend by zl10353")
Cc: stable@vger.kernel.org
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/dvb-usb/dtv5100.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/media/usb/dvb-usb/dtv5100.c
+++ b/drivers/media/usb/dvb-usb/dtv5100.c
@@ -55,6 +55,11 @@ static int dtv5100_i2c_msg(struct dvb_us
 	}
 	index = (addr << 8) + wbuf[0];
 
+	if (rlen > sizeof(st->data)) {
+		warn("rlen = %x is too big!\n", rlen);
+		return -EINVAL;
+	}
+
 	memcpy(st->data, rbuf, rlen);
 	msleep(1); /* avoid I2C errors */
 	return usb_control_msg(d->udev, pipe, request,


