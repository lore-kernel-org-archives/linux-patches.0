Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557CD101F2;
	Tue, 26 Aug 2025 13:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213304; cv=none; b=id3KLWwXh57w8FRP2T+RIazm5EAsFu9gVDUfcitOCANNYMu2g2hYr8GgkGMRV3EZuKgbL2dab+zbTQlRxBvEpiRMDOjjqHlmsvaLrDVF8NpLLDvV63vGb2ry5OqpLTWRqOvfT5sBKGYRfRxvT32njU32Djycy8KruzSk3v3GMfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213304; c=relaxed/simple;
	bh=bGoRBNvDdeTzo/YdZ9OzUTrWiVyKMW7XEyo6xiEiLhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=URXQqr7eKi8OvQdS7Coefv6yO7PiGDxS0tevhkHg9doyhjzbxrYhPaPvdlMMUXfRcnkUjxk9wrNUMTmrKFvkrS+PjoxGBX3gA4zIhLYF1Y3/7r6vFX4o8NJPzvW/RQzshx4PWYlwERRYvSsBYXEheHA67CvrWU4sPJBTv2q8CWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5csstKL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5csstKL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4333C4CEF1;
	Tue, 26 Aug 2025 13:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213304;
	bh=bGoRBNvDdeTzo/YdZ9OzUTrWiVyKMW7XEyo6xiEiLhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P5csstKLO0dFDsvjGuG23F4D7BjzNfc5OJVNeZrhkUhv7iSHv+KmYSqWT7l7cVOSW
	 WtDW8uukzlu83r/wRBvLRYsZg5C6GEhTUw10Vwb3fgIp1UhCf7KlkySD3X8oturUxb
	 xxNkCMm4bcFU6abbAgmbQwJY8SUnAMeRQkT9Iavg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Guo <alexguo1023@gmail.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 255/587] media: dvb-frontends: dib7090p: fix null-ptr-deref in dib7090p_rw_on_apb()
Date: Tue, 26 Aug 2025 13:06:44 +0200
Message-ID: <20250826110959.418510653@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 444fe1c4bf2d..f94660dd9df0 100644
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



