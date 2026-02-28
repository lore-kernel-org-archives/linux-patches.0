Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0DED36C9D8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302366; cv=none; b=eWXBVNsaPCUm6ZV4rMKJmy8CgdLoH7GHvKDZY/CHQuCEtUe/EHGh2n+h0SGDj+wxV+WUaWCVbuQ1HrPc0zZR+//VboUbQOOPsPFrBUvMrpUlGfFgoaKyJXhMxZ88PxEQvjLM867pkE3QlN0P5WG+0V1t91fOow2fldJ+Tu6Us9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302366; c=relaxed/simple;
	bh=QWaiw5pYyeRYgIgu6IPOmBmCDxkx/CVcIhSk5pvFEx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qno9Jn+jnl60in1EGmCZ5WsTpIeO5Qhv0vRPNzyFG244PxtiFAP4d2RoZl78myhPJS9VaPXIbWdSJ6DsvrQsCxS5VwJHmaYh0NAVnLwLYcGzrvK8qentIVd2kE44udpTlWcwYzCMEo5TeEB38rT7VTfg+697UT/cweOf69Z6+Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=evL5niQi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="evL5niQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DFFAC116D0;
	Sat, 28 Feb 2026 18:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302366;
	bh=QWaiw5pYyeRYgIgu6IPOmBmCDxkx/CVcIhSk5pvFEx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=evL5niQi164SQrJakhs20jd2V7tYX8UGDkOaHgvJ96VctctBryiSvYTU/LVD+l0b3
	 oLmvYiLPKz4UF8IPCENMtxcTF9Hrp1CUgGft+pGE1xXPPMXdUpnap2Hys9RtVsP3cP
	 gQTYLhypEYMPu80tVt8rolhMa12UTdMTCI4udHpDjh1+B0rC+O2GQFO8mZnnRrj1GH
	 DYSQ2NHAI375e9KE9e3woR1GJ9Dh25JsbN5gW58JzfLvfe+lG30p5lmH1oKsuUvSS3
	 CZxFmE/TsHpKwBds35f9R6fAmkFv0nSH9fQgZmeKWUIAi71mq5kpic3kB5iZcABmtT
	 I2MXqRp+bGCjw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Matt Johnston <matt@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/232] mctp i2c: initialise event handler read bytes
Date: Sat, 28 Feb 2026 13:09:07 -0500
Message-ID: <20260228181127.1592657-94-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Matt Johnston <matt@codeconstruct.com.au>

[ Upstream commit 2a14e91b6d76639dac70ea170f4384c1ee3cb48d ]

Set a 0xff value for i2c reads of an mctp-i2c device. Otherwise reads
will return "val" from the i2c bus driver. For i2c-aspeed and
i2c-npcm7xx that is a stack uninitialised u8.

Tested with "i2ctransfer -y 1 r10@0x34" where 0x34 is a mctp-i2c
instance, now it returns all 0xff.

Fixes: f5b8abf9fc3d ("mctp i2c: MCTP I2C binding driver")
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Link: https://patch.msgid.link/20260113-mctp-read-fix-v1-1-70c4b59c741c@codeconstruct.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-i2c.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/mctp/mctp-i2c.c b/drivers/net/mctp/mctp-i2c.c
index 1d0c516842793..f77389c7006f8 100644
--- a/drivers/net/mctp/mctp-i2c.c
+++ b/drivers/net/mctp/mctp-i2c.c
@@ -244,7 +244,10 @@ static int mctp_i2c_slave_cb(struct i2c_client *client,
 
 	switch (event) {
 	case I2C_SLAVE_READ_REQUESTED:
+	case I2C_SLAVE_READ_PROCESSED:
+		/* MCTP I2C transport only uses writes */
 		midev->rx_pos = 0;
+		*val = 0xff;
 		break;
 	case I2C_SLAVE_WRITE_RECEIVED:
 		if (midev->rx_pos < MCTP_I2C_BUFSZ) {
-- 
2.51.0

