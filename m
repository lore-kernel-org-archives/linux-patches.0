Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D5C342538
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301777; cv=none; b=e30iu/dDzmlC9iqrwBNWcnl8s7Dp0sujrHgTqOTL6+vnvCGDCnqasgzdwK80PBm+ZvHV9JOJxxkzqaxCMrVM1J0Bk5mvBbKQE3+KaqOqcAcr2x41ylU4jS/MHP9YEicUJkbviyMOws507ipLar/3syYQjatygBbFh9O1KgtCH2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301777; c=relaxed/simple;
	bh=75/D9RC2Pxqws5VQEIQCJ3+ZJuDRD81/pLpKoby4ov0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r0cFjMK2dSjruTQjHb/UiwAOUOedRk81fTBY0kjOvYVoyGOenR+7mbLzMiolor7FHp/Zkwfhd6qUnYC0ah/ZC5Y4uaHXqSCnOy49NQLYYV3jJAgyAIX7dK6ItnTyj/U0iKYKnWtkxO3aoxQljmM5ftVPYQeE+l+ScZhhP1dO3Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fGVBHHiw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fGVBHHiw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F52C116D0;
	Sat, 28 Feb 2026 18:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301777;
	bh=75/D9RC2Pxqws5VQEIQCJ3+ZJuDRD81/pLpKoby4ov0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fGVBHHiw5ucykGIJTCgttc7qSHDMjHhOOC9fY/j/fAjREfNVPYAZtejuyPsgFCOeO
	 P+u+XAuw+7t7kBVXXCZ06Qo5QAMaKViEZip08PT3EVcKMUbEsa/bZOybWTyoD96N3D
	 OX/MTw8vRBs9x8QMTlHcFsfgNLuIaFhSbQFSQLx5Muh2aWa6WEbfDsrFSko+ZtfY2c
	 VKn+B8Kw7gaumovO+ICf8QQgtsSc5uk+A3vlhaMBHcbreQeEUlGY5GNwnXIG0ffb/z
	 Ai3ntC1Oobn12jnuidVbNs8zuoIXaiX6j3wHAEYKaneO9cJzpoz2t1B0wjF+8yZQdi
	 xRW8K6GZ41WJg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jian Zhang <zhangjian.3032@bytedance.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 186/385] net: mctp-i2c: fix duplicate reception of old data
Date: Sat, 28 Feb 2026 12:56:48 -0500
Message-ID: <20260228180011.1568201-186-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 503a9174321c6..8a30d0559d60d 100644
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

