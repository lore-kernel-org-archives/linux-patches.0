Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF3635504A;
	Tue,  6 Jan 2026 17:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720358; cv=none; b=LTiBAvQ3pKCujpP4hVkkFacStBasV/I1saEf0wKoxXXLNdJeRIEr8gy6mrQFmTmWv9lORRA2iOKJFioQv+sfXXweWZIuaOjOpduipEmcvMMROoAFYBWoR6vG0Y84tG+LvEInFhuTgsW4N5vzj6Ek3CxMD/nwWLx4zGjzK9sFIx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720358; c=relaxed/simple;
	bh=/yZ6FMvBGZLGk2wqL6nQY1T6uzUsmuzNb24Fsyo2lmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4JqZAE1tqPRhEEFIRmpKFbUaFpRmqzKAkrx5elV7wGd7GMVnwy3h7Wc0HZD2lDE0VEyEm/ujbIDv57A+ZuFx3ZJ/oYyTJ3FpzTRiI/iS4Irq7je4fiwlf3UinIxTdGR81I5tNWZ8Hygybv2lAfBzzO5RvYmLCh5M04PrjcoQcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Umh3rxUt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Umh3rxUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F472C116C6;
	Tue,  6 Jan 2026 17:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720358;
	bh=/yZ6FMvBGZLGk2wqL6nQY1T6uzUsmuzNb24Fsyo2lmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Umh3rxUtIditeJgGnCWKtYE8BfibgHo8pbf3yF9j33Awo+ZwoTUu3g/ooUH0yy0oS
	 JHl9b4zgsCFlphVZ4cMLKPucK8h4lZM2hAbvk7ZkPO2xckICwZR86Tc9keXDbxjwHb
	 3hHqmwoizTC1/sU+Acu+VMsx8UsptLTB63E/qIlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 179/567] media: dvb-usb: dtv5100: fix out-of-bounds in dtv5100_i2c_msg()
Date: Tue,  6 Jan 2026 17:59:21 +0100
Message-ID: <20260106170457.951421581@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


