Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404DF35083D;
	Tue, 26 Aug 2025 14:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217884; cv=none; b=XQKD5x0HBlEe3YOu2CUsd1ek0GWn6I8up9YGdSy78ZAI2qfGpDylkVKAA9IkNe9eaXjAD/hxWAIHnU1L13GkOs3M8bONmLuwYQ06kZjTuCnPYVYq5o1MulSPLh5LJYnppUrWvrrGFL6W+OU9+qSsBf+BbZEPi4nWr05CujiGSD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217884; c=relaxed/simple;
	bh=GL/YoysjY5FA1SsdhPRh/oSzLjErCpKBdPjWIZOGSTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MOPfFCoeQXBKEDktTcf1yHVbnKT/iXtr8ZDLEzL8m/x+RW43dfcwQ5EK6entCn8KobpHBk6YCpCIY2CotAkYJgMxSrGkv8dW7w+zi/F6qhCtLAYgsdps22zFaOddPkpAv67EzoFpchoWuFnTFSPnLnKN6aYkyCgnlhMXCAOy8cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JNQRPsZn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JNQRPsZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3EF9C4CEF1;
	Tue, 26 Aug 2025 14:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217884;
	bh=GL/YoysjY5FA1SsdhPRh/oSzLjErCpKBdPjWIZOGSTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JNQRPsZnXJhpR9InEO+98ctRzSAt5YXtSNg7kcbg3pwC0d2Al9vwQoKYBPv6gqKxU
	 5XjKBPOHZytbjcBOCKhIe+CYdtvx0DS9tnDuUe49KKtlzkWJHrPMqQUeWowFbYwlS1
	 mw5y6U36+KDZdmpYc3Xrh8/Ik+QLBrkN0ByS6yjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Guo <alexguo1023@gmail.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 312/523] media: dvb-frontends: dib7090p: fix null-ptr-deref in dib7090p_rw_on_apb()
Date: Tue, 26 Aug 2025 13:08:42 +0200
Message-ID: <20250826110932.158502996@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Guo <alexguo1023@gmail.com>

[ Upstream commit ce5cac69b2edac3e3246fee03e8f4c2a1075238b ]

In dib7090p_rw_on_apb, msg is controlled by user. When msg[0].buf is null and
msg[0].len is zero, former checks on msg[0].buf would be passed. If accessing
msg[0].buf[2] without sanity check, null pointer deref would happen. We add
check on msg[0].len to prevent crash. Similar issue occurs when access
msg[1].buf[0] and msg[1].buf[1].

Similar commit: commit 0ed554fd769a ("media: dvb-usb: az6027: fix null-ptr-deref in az6027_i2c_xfer()")

Signed-off-by: Alex Guo <alexguo1023@gmail.com>
Link: https://lore.kernel.org/r/20250616013231.730221-1-alexguo1023@gmail.com
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/dib7000p.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
index 8c426baf76ee..a4d060fb1bab 100644
--- a/drivers/media/dvb-frontends/dib7000p.c
+++ b/drivers/media/dvb-frontends/dib7000p.c
@@ -2261,8 +2261,12 @@ static int dib7090p_rw_on_apb(struct i2c_adapter *i2c_adap,
 	u16 word;
 
 	if (num == 1) {		/* write */
+		if (msg[0].len < 3)
+			return -EOPNOTSUPP;
 		dib7000p_write_word(state, apb_address, ((msg[0].buf[1] << 8) | (msg[0].buf[2])));
 	} else {
+		if (msg[1].len < 2)
+			return -EOPNOTSUPP;
 		word = dib7000p_read_word(state, apb_address);
 		msg[1].buf[0] = (word >> 8) & 0xff;
 		msg[1].buf[1] = (word) & 0xff;
-- 
2.39.5



