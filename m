Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD28191F93;
	Sat, 12 Sep 2026 14:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224050; cv=none; b=lDXutCaamVW6gz95OFvgc4eoSgoF87YEsrluGzYdhXtuwQRtlbsGPcvUoVrsDJ5W0t9oU7YP+O29Coib6G2YqK6ii45S+hwgmXtmXevKt3u2uY+rIDYsVHm+LuSFn6OpHemm1ZNLErAbaJ2nwQsTsK3lR8WmD3rHtGkggj0ErXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224050; c=relaxed/simple;
	bh=ZnCjhXrT91FGP0NrDXnC3QZXWXL8CudjhqxErppSXYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fVRMjuYINPchTqP9g2qNZwxezKPzH7YmdW3tP1CmPGXYMcPRnRZ6t7wceuaw2nR8pCk7O5AKQoNmLi2bYVAx+cS1eCEwqd2X3Z8zMeKttvXuJH0s3dmcFawBh6zTSJujz+uB4kRQL3LGEBAbhBF/AQpOPvt8gj4eVMs6sbBVlec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GEDC22fL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GEDC22fL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70EF1F000FF;
	Sat, 12 Sep 2026 14:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224049;
	bh=Ra2SNG3XIePziOnW/vAIG49oIxJ6j537Mj+onlzmtrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GEDC22fLZhlv7BYUb4jvPMrGt7nFukcJf5vBdz9zFggQbelSjvPpU/CpiaVnZcXQ0
	 QqUKktaPh0p9FnYeBipIDJexYpG8CTKwUpPAC36deowlImn+mpV/lcqebiX08200SJ
	 n2C8qSKAk+h0fzlxWMxBDg6+zccRV7Z6ObTOrnOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0915/1424] RDMA/mlx5: Fix stack out-of-bounds read in cc_params debugfs
Date: Sat, 12 Sep 2026 08:55:47 +0200
Message-ID: <20260912065627.816790543@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 03826bc1fa6c90405bf05831f2b501a8368dcd27 ]

get_param() reads a congestion parameter as a u32 but formats it with the
signed "%d" into an 11-byte stack buffer. A value with bit 31 set, such as
0x80000000, renders as "-2147483648\n" whose full length is 12. snprintf()
stores only 11 bytes yet returns 12, so simple_read_from_buffer() treats 12
bytes as valid and reads one byte past lbuf[].

Size the buffer for the widest unsigned decimal, format with "%u" to match
the u32, and use scnprintf() so the length passed to
simple_read_from_buffer() reflects the bytes actually stored.

Fixes: 4a2da0b8c0782 ("IB/mlx5: Add debug control parameters for congestion control")
Link: https://patch.msgid.link/20260726-get-param-leaks-kernel-stack-memory-v1-1-d61a4d39662d@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/cong.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cong.c b/drivers/infiniband/hw/mlx5/cong.c
index a78a067e3ce7f..88ac5fd1038ed 100644
--- a/drivers/infiniband/hw/mlx5/cong.c
+++ b/drivers/infiniband/hw/mlx5/cong.c
@@ -399,15 +399,13 @@ static ssize_t get_param(struct file *filp, char __user *buf, size_t count,
 	int offset = param->offset;
 	u32 var = 0;
 	int ret;
-	char lbuf[11];
+	char lbuf[12];
 
 	ret = mlx5_ib_get_cc_params(param->dev, param->port_num, offset, &var);
 	if (ret)
 		return ret;
 
-	ret = snprintf(lbuf, sizeof(lbuf), "%d\n", var);
-	if (ret < 0)
-		return ret;
+	ret = scnprintf(lbuf, sizeof(lbuf), "%u\n", var);
 
 	return simple_read_from_buffer(buf, count, pos, lbuf, ret);
 }
-- 
2.53.0



