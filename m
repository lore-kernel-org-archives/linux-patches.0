Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5E332AAD6;
	Thu, 28 May 2026 20:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000452; cv=none; b=YkdjXZnr5Wpu0WZ9Hpjmc+MZUx7dprc6q4KNFpnQ03xb85uF2dVwiLSUZImbCcJ3XOacCQvAxohqDspZPzrbUhZK+Jb8XYSeMEG9M14Gy3C8FEsPZPHQShk9qIAIDHSVPCpOTRlNNgIwgfn3vYmUqVNYVT9kd/7pSGonjg0Y9w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000452; c=relaxed/simple;
	bh=fKGpts3bGJbx7BEYB4oWmI2xfIj0RjsRwzfmWSSJuO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CBFSeHMeoX42gqsmkCLJ1hpYE0fFglySg8LWLY8P4WbVH0adhI/HxcTx76qbp83MKBuFKTdg68xXsb/bQ/yvdGgIsEM+y2IyxpgLh0brnXDEQKXiEJM37cROUcApEGwioBPcMdd9WK0pDCUH793tf9ZtSDv19sW7A/HOqeVI5Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fdw7bLwA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fdw7bLwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241F91F000E9;
	Thu, 28 May 2026 20:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000451;
	bh=jdW7OET1IRwrWAJqWRBZYX5qNY819bjFIw8x2s2kbIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fdw7bLwAZZAxG1DbQXMuf0PHTmOXjmAfOQuOqCiQIeDa0JO+A1Xb9MZ3fMoQmXXyl
	 JWQIWdz5hxz4+S78/qSN18+tywwjWBktkHtj8ZSro3HueXZ/G0seY7O+9MYZWSNZW5
	 g6zki9C2Ver2JjTrTHsYIVeqXl2z3N3F/9MPw8lI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Yakovlev <vovchkir@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/272] spi: spi-dw-dma: fix print error log when wait finish transaction
Date: Thu, 28 May 2026 21:46:27 +0200
Message-ID: <20260528194629.755526410@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f4c209e5f52ba..4104e1bc2d5bd 100644
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



