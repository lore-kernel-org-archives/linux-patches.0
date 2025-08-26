Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E190306D3F;
	Tue, 26 Aug 2025 14:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219115; cv=none; b=AUYdQLi7aJ4SW2/PvXem30XYtZxlcRKz0doUS3B+N+Xo4pMT1NqfjooLjMgYDy6LRLrtt2AvFVQBtSHI5MJf51Z+CGblBK4K/f9lioMmAl2AIwA5vnkPLfVnq2ueej3VGTW/Yfy+giVacxgLNMiEKpYTHBb2JOCzd1nK9WSujaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219115; c=relaxed/simple;
	bh=o91LiZDMEpclgAP1lNjkoNWgokebjK8Vb33V9ehpooY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULbgk+fpbujFyK+hYPUgZo2jD/EsJuwjTVtQtThMMA4ltccymp7HAivERLerbWR/pJApxRFdnGOTsmN1+nm0X2Y7o5lMop5bDMstFMMNuN1nI/A8ol34HwscJekeehV5zg5CnAcdaBxfLSbJs7xOET6Dto66ULnnfyPTk/H60CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QnaC9/uC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QnaC9/uC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3BFBC4CEF1;
	Tue, 26 Aug 2025 14:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219115;
	bh=o91LiZDMEpclgAP1lNjkoNWgokebjK8Vb33V9ehpooY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QnaC9/uCQjaxCqouNwBtbB6QYs05y/EZdVPv5b5BnQx56bNPGiRSZqsSQXakZ+O/J
	 T2S3nm4wurzcqvojEV85AxbzVZwGHaaPn3eEIeEvNIyBKVjC8PJOMIWzBt6Qg1etcC
	 6L05sMsfY3yFs8kH4PJ5PKuaFBhfShJgWju9vjQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Guo <alexguo1023@gmail.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 251/403] media: dvb-frontends: dib7090p: fix null-ptr-deref in dib7090p_rw_on_apb()
Date: Tue, 26 Aug 2025 13:09:37 +0200
Message-ID: <20250826110913.754912844@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index fd08a851a452..d31ce5c7104d 100644
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



