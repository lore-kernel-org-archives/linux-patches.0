Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B6E257854;
	Thu, 28 May 2026 20:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999362; cv=none; b=vEMvduAiMNQoyyF/mA/MJYJRGy9cr4ugNSYj+VD+ufuKwGuQ5m5xGa+IjXxPpyzc5PoVgluKTO0wIbv1IItApEDiyJAoJBt0hspi7U58c+UMB8S+TQSpBfJ26mPJPUdhcVI2lCnYH5SpjMuR9aUW6lxM57z49DnDb+YmhN7ZiFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999362; c=relaxed/simple;
	bh=sUSZkI1+b9YAf/a3f1Hvc8kq6zESTtGR/J/2BICjrJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMdq5icXOulslwgJ9TcWZp9MkkILSqd/oqxRdrNNF76maGDoKC+GfUv4mkQTMS9kYqHqfJPZXwDl+v82bTkYPY7rJHFsFutsQu7ognNWCHcMPiRwBfdfFsSCSLJAAB9e22DOTsjE8uAZxqmGjbU50m/j8clv7LUv/uIcYQRTbGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qFFpXs1Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qFFpXs1Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5D41F000E9;
	Thu, 28 May 2026 20:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999360;
	bh=fDRz7a/u+WI3/vb9qQEpZ/5GvzEcLUHaYd8FGi77/WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qFFpXs1QKcQv0cwDbwxLi7KpdIWNFMfow1wUW2FS35gAy3j9YcB3jb8BsRp7o8AU8
	 Tv1FMFam2adpB6aoh/BNw0j0sso9oHJP5Jmq19xlcxmTcmnJto4fTcolD7hTeF8LK8
	 cJULZ/p74vBwbQB8SI3FnPW9K1CNxNcnzh98ZAsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Yakovlev <vovchkir@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 009/377] spi: spi-dw-dma: fix print error log when wait finish transaction
Date: Thu, 28 May 2026 21:44:07 +0200
Message-ID: <20260528194638.658547376@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Yakovlev <vovchkir@gmail.com>

[ Upstream commit 3b46d61890632c8f8b117147b6923bff4b42ccb7 ]

If an error occurs, the device may not have a current message. In this
case, the system will crash.

In this case, it's better to use dev from the struct ctlr (struct spi_controller*).

Signed-off-by: Vladimir Yakovlev <vovchkir@gmail.com>
Link: https://patch.msgid.link/20260302222017.992228-2-vovchkir@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-dw-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-dw-dma.c b/drivers/spi/spi-dw-dma.c
index b5bed02b7e500..31063f9270924 100644
--- a/drivers/spi/spi-dw-dma.c
+++ b/drivers/spi/spi-dw-dma.c
@@ -271,7 +271,7 @@ static int dw_spi_dma_wait(struct dw_spi *dws, unsigned int len, u32 speed)
 					 msecs_to_jiffies(ms));
 
 	if (ms == 0) {
-		dev_err(&dws->host->cur_msg->spi->dev,
+		dev_err(&dws->host->dev,
 			"DMA transaction timed out\n");
 		return -ETIMEDOUT;
 	}
-- 
2.53.0



