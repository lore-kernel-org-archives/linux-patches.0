Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F961D5ABA;
	Wed, 25 Feb 2026 01:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983192; cv=none; b=Zpetuvq7a+JmG5GO5TRDgo3RFWn7TRXOtSNJiLhUEKHEJ+wNFqSjlGT8RVZbChbAvQv3ulsXwVygMcq2hLeSINru6sDhCjR2o20qOOqUTFz/yoe0iGDeEN6Tdbpe2U9NI0To7sbxcjMUlcbVhXzWMlaI4o/lYkv5TeGBB4NJyKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983192; c=relaxed/simple;
	bh=kKFaplG6EytM6dS2iH/v6LmYZ/f9TZ1wAtW3Mwv7++k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nyqAiCmjv9stkfVHSK4+l/lBxM0yILdEX6uYvHHj9vFTiu8TNWrFm/2tWyWO+H5qklvHiiSrQx4gt+Ht7mV+rJ34JcpwgMwQckV7ZPoIFPlBF+afVrq4Q/kPlTjDKQq4vqlG123vqq1qGnbylDJgJxiUNoeX0qwq/QcErp2Vd1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=upT6TuIS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="upT6TuIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE3CC116D0;
	Wed, 25 Feb 2026 01:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983192;
	bh=kKFaplG6EytM6dS2iH/v6LmYZ/f9TZ1wAtW3Mwv7++k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=upT6TuISS7f9RdLPPkqZ2ey4zf7ZXZJqd1kZ3yNq45N8ZGKIoXcrUfcjmamxuUziD
	 3Croa0/HKP/vBqeUE0ku0HNmI7iDwWbXMKZQrhLm7s3rPdX5GkEvEInVJkxSigcTJD
	 yL7ZT/KbZdjfxD7il23eyfJLSMlitnC2pVi4Ni5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhang <zhangjian.3032@bytedance.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 340/781] net: mctp-i2c: fix duplicate reception of old data
Date: Tue, 24 Feb 2026 17:17:29 -0800
Message-ID: <20260225012408.031134620@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index f782d93f826ef..ecda1cc36391c 100644
--- a/drivers/net/mctp/mctp-i2c.c
+++ b/drivers/net/mctp/mctp-i2c.c
@@ -242,6 +242,9 @@ static int mctp_i2c_slave_cb(struct i2c_client *client,
 		return 0;
 
 	switch (event) {
+	case I2C_SLAVE_READ_REQUESTED:
+		midev->rx_pos = 0;
+		break;
 	case I2C_SLAVE_WRITE_RECEIVED:
 		if (midev->rx_pos < MCTP_I2C_BUFSZ) {
 			midev->rx_buffer[midev->rx_pos] = *val;
@@ -279,6 +282,9 @@ static int mctp_i2c_recv(struct mctp_i2c_dev *midev)
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



