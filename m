Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BCA3212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:02:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30162C433D2;
	Tue,  7 Feb 2023 13:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774968;
	bh=aOrXWbZZS9UgzCifRBScWp/Ew1uVkBCfNly7tzT8iAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZYl6vXPproZt23jq3gQ1M4rMhJOiuSBwbKT61qt6wt7FodemNuV87NjRgaRQvNlaI
	 VyuESt2QVUVEPiGjQkQVdOkLbMeUltgI1xwxQbSSXXvymn84y/OzoVFUl6niDOuYDz
	 GkeOhOL4w8k1j0zX5G92R9UB/Q+RVXZo78I54Fq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <stefan.wahren@i2se.com>,
	Fabio Estevam <festevam@gmail.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/208] i2c: mxs: suppress probe-deferral error message
Date: Tue,  7 Feb 2023 13:55:48 +0100
Message-Id: <20230207125638.626871707@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stefan Wahren <stefan.wahren@i2se.com>

[ Upstream commit 78a4471fa1a76a8bef4919105de67660a89a1e9b ]

During boot of I2SE Duckbill the kernel log contains a
confusing error:

  Failed to request dma

This is caused by i2c-mxs tries to request a not yet available DMA
channel (-EPROBE_DEFER). So suppress this message by using
dev_err_probe().

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mxs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mxs.c b/drivers/i2c/busses/i2c-mxs.c
index 5af5cffc444e..d113bed79545 100644
--- a/drivers/i2c/busses/i2c-mxs.c
+++ b/drivers/i2c/busses/i2c-mxs.c
@@ -826,8 +826,8 @@ static int mxs_i2c_probe(struct platform_device *pdev)
 	/* Setup the DMA */
 	i2c->dmach = dma_request_chan(dev, "rx-tx");
 	if (IS_ERR(i2c->dmach)) {
-		dev_err(dev, "Failed to request dma\n");
-		return PTR_ERR(i2c->dmach);
+		return dev_err_probe(dev, PTR_ERR(i2c->dmach),
+				     "Failed to request dma\n");
 	}
 
 	platform_set_drvdata(pdev, i2c);
-- 
2.39.0



