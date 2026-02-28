Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBBCC2737F2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302365; cv=none; b=MNfwdGRietroUHxYrlsJDNKuKpMoa+5nrC6uCuTIUvyW+941G3Fuj7mp14m2XPRBpqw7pkT4fCG8w6w/xnpZdEalMspFgxYx7oOZlJlwzH/sqjJkWn5AycrzaWjxcINO/35ivFrkKQ5vkRDT+O4Y3r3g5qzqAXEv6qeig1DJ8qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302365; c=relaxed/simple;
	bh=l5ufw9uRrleflWpzEHkermHmkWL/Jusnnc3uAIBZotA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fsDwRVTv9Rv7RTHLBkbiJB50zECU7CVP1OlwnOLe+Duf6DssbaVCAk4iqbDBy0e7Bm0adkrOE/DPKNPRvxELdtPyFTRMOiZXOI208rrczh8mcoysm7xGauyfbA1OlOXnJHsN1BJbMDgjBV9NpoIhf8Ho+V+hEXx8VR/IJLxpBqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JyGW4sTZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JyGW4sTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49475C19425;
	Sat, 28 Feb 2026 18:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302365;
	bh=l5ufw9uRrleflWpzEHkermHmkWL/Jusnnc3uAIBZotA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JyGW4sTZV7Ajk3UhkM9rzZ901mtI8onqZQLPNkJ9QfxMbGnXlMRT+tgkhj2LWJ6yt
	 gQP+hwirrDpeZGE+B6xf1P2Ju16G49jLT+BVq8P8pJm+oQ0rAP4so8ZWQGZWnL1cT0
	 HiEU4pgzfk9EkQbb8tyQcAsWyEcZQqQX1m5PBNZ21Y26+Z1MGqGEUgwPle0UnILca3
	 b/CVMdUEcydVzR+MZcEH8BkksyiIQNQng/c3V8EUjBGalsncqU9+TXfAPPiYmlkFw/
	 lSU+4HQ+/X2VEmJxx7WNOicX1iBkrN1h3TKs0q+R0QmI00c+pyzXOujoUAlms9MKJA
	 fKOAu/WcOGXaA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jian Zhang <zhangjian.3032@bytedance.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/232] net: mctp-i2c: fix duplicate reception of old data
Date: Sat, 28 Feb 2026 13:09:06 -0500
Message-ID: <20260228181127.1592657-93-sashal@kernel.org>
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

From: Jian Zhang <zhangjian.3032@bytedance.com>

[ Upstream commit ae4744e173fadd092c43eda4ca92dcb74645225a ]

The MCTP I2C slave callback did not handle I2C_SLAVE_READ_REQUESTED
events. As a result, i2c read event will trigger repeated reception of
old data, reset rx_pos when a read request is received.

Signed-off-by: Jian Zhang <zhangjian.3032@bytedance.com>
Link: https://patch.msgid.link/20260108101829.1140448-1-zhangjian.3032@bytedance.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 2a14e91b6d76 ("mctp i2c: initialise event handler read bytes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-i2c.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/mctp/mctp-i2c.c b/drivers/net/mctp/mctp-i2c.c
index 17619d011689f..1d0c516842793 100644
--- a/drivers/net/mctp/mctp-i2c.c
+++ b/drivers/net/mctp/mctp-i2c.c
@@ -243,6 +243,9 @@ static int mctp_i2c_slave_cb(struct i2c_client *client,
 		return 0;
 
 	switch (event) {
+	case I2C_SLAVE_READ_REQUESTED:
+		midev->rx_pos = 0;
+		break;
 	case I2C_SLAVE_WRITE_RECEIVED:
 		if (midev->rx_pos < MCTP_I2C_BUFSZ) {
 			midev->rx_buffer[midev->rx_pos] = *val;
@@ -280,6 +283,9 @@ static int mctp_i2c_recv(struct mctp_i2c_dev *midev)
 	size_t recvlen;
 	int status;
 
+	if (midev->rx_pos == 0)
+		return 0;
+
 	/* + 1 for the PEC */
 	if (midev->rx_pos < MCTP_I2C_MINLEN + 1) {
 		ndev->stats.rx_length_errors++;
-- 
2.51.0

