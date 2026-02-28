Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB93638D001
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302121; cv=none; b=YlEtexh7Mb+48IlY/BvI7ukeeDwOU/YF4Dcx+M1/XWEZVgUA7IL/PGLxWnxg/vxYnq8l0mOJ9wtaaynkICK46oQWtqZ8UkuLDUvbBEGo7eu0KTfNpU5wuMybNX/kVm1Wce+eB1hZjx+MkZZAObTmpVt0ZQ9OYo4r08trarosfEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302121; c=relaxed/simple;
	bh=veA/BN2UznO+ByqXeK6TxEavSXSjZ5IgqBlQIfyvK/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7PCMY+drU2IvEH861/bjqBO7k9Cmy8DkftGAW1W0uz4Jvf99Oyt4ZZGz3M/f1Nk6OTHdeDVFpvzScMydbnCRRbeOD7LiWqjzDTJjRGk/r+1oBaSozByobFV4AopitQxQiSJuUwRvBfWfd2x8y99vq9BL7s07DQ001rkqbz0h6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FQRZn1lR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FQRZn1lR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38481C19423;
	Sat, 28 Feb 2026 18:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302121;
	bh=veA/BN2UznO+ByqXeK6TxEavSXSjZ5IgqBlQIfyvK/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FQRZn1lR0nV6oOwCPFQRVNVNX2jMz3YjO+hM++5nxKmvTplk0H8uUZSevJyZUPJ2c
	 Nf+zxy/ksI3C35X755bAO/CvylHKpYQ72kfAGcR0gQetLFhR/s2JA82u8DaB3CaCsp
	 hgXb3LFEM9c6yN7tzh38nqm+T7wVdKHbnO7Dqf5Gs9rLmx8gRsy6B2uJkzdZgMNYyk
	 +N3Chtk7olKCfUTf6GMmskDotPC6wECTtKuesUkKCo/p78Nf0hEMYA2po6BJytnfSi
	 ffYJmOJiZG1kB9D0aPZdrqHNUDbuK6NLqxSN67h7MZXsG1idvbwJiBgUSb/YRHhBrW
	 D1Top1yS36/+A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jian Zhang <zhangjian.3032@bytedance.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 112/283] net: mctp-i2c: fix duplicate reception of old data
Date: Sat, 28 Feb 2026 13:04:14 -0500
Message-ID: <20260228180709.1583486-112-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index fbe8483a07b58..079fb7ca97b62 100644
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

