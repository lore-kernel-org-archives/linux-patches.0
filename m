Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C35350D54;
	Tue, 26 Aug 2025 14:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219144; cv=none; b=dj+LX6MUviiIDALB84x55HtMiVdP1QDsbAobD1k3YSNrDn5RXGj43xVPFbJSWiEaHhuWIXb3jwkGTkVkUHb0MLd4CNSEV0k/5FYTCq25mOvxpIxfSGnVRL7kNWpohN9gQ+aHYF3eeg37SZwi0CI0tPqD6vGjmUEWigIHdo8cBHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219144; c=relaxed/simple;
	bh=VzJsjKsz/h/Fc6pGivXYVWLEsmtg1/xkhFlMQigwn6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuTvPHbMUjXY7I0dKl73ykKS92Eu4w5fmFIJE8MD6055OECAgOc6RZM0Iermi0GAwpJqrU+taRb4N3npMA3oc+w0wfCX/0c4tz2dRMrzr6yos0YI4IdlFifMZTJxbOO2fqhreTLhjBconr1cOjcKtUT9TSK2CPRcKuSMY4nYDhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJnka9Iu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJnka9Iu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B71C4CEF1;
	Tue, 26 Aug 2025 14:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219143;
	bh=VzJsjKsz/h/Fc6pGivXYVWLEsmtg1/xkhFlMQigwn6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iJnka9IuBVu8qAGKN3zAGXyYdEfiUDJwUm3WWTELv8pfiCOqVXwivb1PDE+DlUAzj
	 GrR9kk5bpf0lfZjCrcIBKgITxZbXkb3uFLYXIJbDd8gEENMeWTqJ5w7cNJd5V7dSVM
	 hpu/EkajZFY1/voa3X/NI25qq/hbz6nmt8aexx7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Guo <alexguo1023@gmail.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 252/403] media: dvb-frontends: w7090p: fix null-ptr-deref in w7090p_tuner_write_serpar and w7090p_tuner_read_serpar
Date: Tue, 26 Aug 2025 13:09:38 +0200
Message-ID: <20250826110913.784466478@linuxfoundation.org>
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

[ Upstream commit ed0234c8458b3149f15e496b48a1c9874dd24a1b ]

In w7090p_tuner_write_serpar, msg is controlled by user. When msg[0].buf is null and msg[0].len is zero, former checks on msg[0].buf would be passed. If accessing msg[0].buf[2] without sanity check, null pointer deref would happen. We add
check on msg[0].len to prevent crash.

Similar commit: commit 0ed554fd769a ("media: dvb-usb: az6027: fix null-ptr-deref in az6027_i2c_xfer()")

Signed-off-by: Alex Guo <alexguo1023@gmail.com>
Link: https://lore.kernel.org/r/20250616013353.738790-1-alexguo1023@gmail.com
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/dib7000p.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
index d31ce5c7104d..41dcbabdc193 100644
--- a/drivers/media/dvb-frontends/dib7000p.c
+++ b/drivers/media/dvb-frontends/dib7000p.c
@@ -2198,6 +2198,8 @@ static int w7090p_tuner_write_serpar(struct i2c_adapter *i2c_adap, struct i2c_ms
 	struct dib7000p_state *state = i2c_get_adapdata(i2c_adap);
 	u8 n_overflow = 1;
 	u16 i = 1000;
+	if (msg[0].len < 3)
+		return -EOPNOTSUPP;
 	u16 serpar_num = msg[0].buf[0];
 
 	while (n_overflow == 1 && i) {
@@ -2217,6 +2219,8 @@ static int w7090p_tuner_read_serpar(struct i2c_adapter *i2c_adap, struct i2c_msg
 	struct dib7000p_state *state = i2c_get_adapdata(i2c_adap);
 	u8 n_overflow = 1, n_empty = 1;
 	u16 i = 1000;
+	if (msg[0].len < 1 || msg[1].len < 2)
+		return -EOPNOTSUPP;
 	u16 serpar_num = msg[0].buf[0];
 	u16 read_word;
 
-- 
2.39.5



