Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601122C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:11:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9547C433D2;
	Tue,  7 Feb 2023 13:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775472;
	bh=Tql21/U+HBWrQXbGKOoeuk87rFXHzfmJddhkYWlpJFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uKaiFoJ/FijHpaQqvjVJBiAVsOhpgnEJA9FrrSouYvaluuqUksiKc4WO4znGgsstR
	 3sbhSAU4VFZGiR6WmTDKZHayy9Ty/DdJrYrR31rF/5t9ohSYHWKSUuApC/LjjyQB7D
	 rJcHcoXDh4HtlkqkLop/UAMUQXeIzfLduMomYXJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <stefan.wahren@i2se.com>,
	Fabio Estevam <festevam@gmail.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/120] i2c: mxs: suppress probe-deferral error message
Date: Tue,  7 Feb 2023 13:57:03 +0100
Message-Id: <20230207125620.989702253@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
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
index 68f67d084c63..b353732f593b 100644
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



