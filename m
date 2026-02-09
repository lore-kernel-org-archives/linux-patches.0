Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7321137B3F2;
	Mon,  9 Feb 2026 14:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647358; cv=none; b=pV55329Ct1J7u4bEC4FE8NVg2kdz8n1ALhjF+EK6/m3P8shYWVHKHFK0Q6Ra+JDFOLPtX8RfVcfvNmeI4ywwL2RIcamIdqtkpw6N6kuOy/nzxaVF90dMK9yhHiIaroMHNAM60P/mV2kXY6P2Igp23wUELeRsKLhwvpXWWZdX1pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647358; c=relaxed/simple;
	bh=SYovAvvgYinzaZ3y0kXZDYc7VSBQ20M4LT0x02+cKMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQZW2Vu3LqzUQSuJvphZ+ToXby9WgWAn/VjJag4lGNCMA7JtXa7q4E4vmiF61vfHrzVbtKSViwl4f0lQmr/NPlKE3MI67lHtogvqnWoM2rUd17h15yzzK0H0Q0aKRL0/Cf7jUkqQ07r4lda+trYkvQ6wVYJxEqFfwBhIoLsLtxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RcBaNlg+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RcBaNlg+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0EEC19423;
	Mon,  9 Feb 2026 14:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647358;
	bh=SYovAvvgYinzaZ3y0kXZDYc7VSBQ20M4LT0x02+cKMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RcBaNlg+RwIFSTOQziM7Xps1o7kVNJnX65MNDXIvdlXWypQmBz7AyT8Hpt34gpeUM
	 1Ewr2lJZ35qWNFcF6krKF98iDoRuea+AfLpd2TWssjsyiTGgVXiYHqJPIKscro8M/F
	 clayiRb2KcwA3g9bR+AeFAi42KssuOe3ZDSzTCDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kwok Kin Ming <kenkinming2002@gmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 076/175] HID: i2c-hid: fix potential buffer overflow in i2c_hid_get_report()
Date: Mon,  9 Feb 2026 15:22:29 +0100
Message-ID: <20260209142323.181554029@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

From: Kwok Kin Ming <kenkinming2002@gmail.com>

[ Upstream commit 2497ff38c530b1af0df5130ca9f5ab22c5e92f29 ]

`i2c_hid_xfer` is used to read `recv_len + sizeof(__le16)` bytes of data
into `ihid->rawbuf`.

The former can come from the userspace in the hidraw driver and is only
bounded by HID_MAX_BUFFER_SIZE(16384) by default (unless we also set
`max_buffer_size` field of `struct hid_ll_driver` which we do not).

The latter has size determined at runtime by the maximum size of
different report types you could receive on any particular device and
can be a much smaller value.

Fix this by truncating `recv_len` to `ihid->bufsize - sizeof(__le16)`.

The impact is low since access to hidraw devices requires root.

Signed-off-by: Kwok Kin Ming <kenkinming2002@gmail.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/i2c-hid/i2c-hid-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 63f46a2e57882..5a183af3d5c6a 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -286,6 +286,7 @@ static int i2c_hid_get_report(struct i2c_hid *ihid,
 	 * In addition to report data device will supply data length
 	 * in the first 2 bytes of the response, so adjust .
 	 */
+	recv_len = min(recv_len, ihid->bufsize - sizeof(__le16));
 	error = i2c_hid_xfer(ihid, ihid->cmdbuf, length,
 			     ihid->rawbuf, recv_len + sizeof(__le16));
 	if (error) {
-- 
2.51.0



