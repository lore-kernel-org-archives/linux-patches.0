Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53663290A1;
	Mon, 13 Apr 2026 16:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099488; cv=none; b=g0pvG83qu39d7Kt4gp8Z1CAQp7xfHAPowxjschojZR4GacIsJendZ7YWNJ/KwYoSg2zzcn+XzvAIf9rguUp3PeucXErzX4X3AqPpTjf9enGoWghnq1/rlkMAS1Q2lNV0f0/CipOdOzA0nVTAdmHCpiBAnIiB5DIiwwTaep8cltI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099488; c=relaxed/simple;
	bh=gu8evSFoR1VoRKFUOW4UEbwj4ZvGSUCsKk6SGC73HzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LbXhl2xkuCvfGFCDHSBWTv40guz8surgaClsT/A8gCRr8JG24ciWmYRz8MxB5asDC4SAAUpbfsd+AjfDaoipkii1FbvLqSXYJ/ml1HPAPwy2TePvQQRsh1qzp6PQrlecxdcarN+ccQCtrDSwI5aLafLLofzgJVa+gB/TRKx2tn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xnmppFFI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xnmppFFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C28DC2BCAF;
	Mon, 13 Apr 2026 16:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099488;
	bh=gu8evSFoR1VoRKFUOW4UEbwj4ZvGSUCsKk6SGC73HzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xnmppFFIuyz0wsVr5row8St+80dRz42zCFWnL44qLFBnsZbMB7HxW7eEH19318Efy
	 CpirLRABqdWa43mmd+YcAtRpHI88WYoEkB+noS+kZKkRno5US4RbSFu+62ed8ZAfZr
	 PxHy/13L1uoW76naJ7vFs/gsmIDZk0hyOyTv9a9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Guo <alexguo1023@gmail.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 360/491] media: dvb-frontends: w7090p: fix null-ptr-deref in w7090p_tuner_write_serpar and w7090p_tuner_read_serpar
Date: Mon, 13 Apr 2026 18:00:05 +0200
Message-ID: <20260413155832.513860406@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/media/dvb-frontends/dib7000p.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
index a4d060fb1babd..18b48a3984291 100644
--- a/drivers/media/dvb-frontends/dib7000p.c
+++ b/drivers/media/dvb-frontends/dib7000p.c
@@ -2198,7 +2198,11 @@ static int w7090p_tuner_write_serpar(struct i2c_adapter *i2c_adap, struct i2c_ms
 	struct dib7000p_state *state = i2c_get_adapdata(i2c_adap);
 	u8 n_overflow = 1;
 	u16 i = 1000;
-	u16 serpar_num = msg[0].buf[0];
+	u16 serpar_num;
+
+	if (msg[0].len < 3)
+		return -EOPNOTSUPP;
+	serpar_num = msg[0].buf[0];
 
 	while (n_overflow == 1 && i) {
 		n_overflow = (dib7000p_read_word(state, 1984) >> 1) & 0x1;
@@ -2217,9 +2221,13 @@ static int w7090p_tuner_read_serpar(struct i2c_adapter *i2c_adap, struct i2c_msg
 	struct dib7000p_state *state = i2c_get_adapdata(i2c_adap);
 	u8 n_overflow = 1, n_empty = 1;
 	u16 i = 1000;
-	u16 serpar_num = msg[0].buf[0];
+	u16 serpar_num;
 	u16 read_word;
 
+	if (msg[0].len < 1 || msg[1].len < 2)
+		return -EOPNOTSUPP;
+	serpar_num = msg[0].buf[0];
+
 	while (n_overflow == 1 && i) {
 		n_overflow = (dib7000p_read_word(state, 1984) >> 1) & 0x1;
 		i--;
-- 
2.53.0



