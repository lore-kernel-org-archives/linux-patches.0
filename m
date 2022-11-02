Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C0D7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:45:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61918C433D6;
	Wed,  2 Nov 2022 02:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357105;
	bh=hQc/fvqxmDb/0/Vl/oExmBpp8Yf47T1fFx0Bc340Itw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cqdbiaLQGs346BkpmAcVmO3+e+yIR5qkyxRuny/dESneuK/lhKzLmTjpehopiRqUS
	 9jB0L2wpziKZSg3z6EvHi5sLtpM2QzbTmtYXK2hBTsKZ3Lw0YLW/CoyYMgw72Z95wG
	 J9kRg5PcJBPyMnQHt9xw0+COUJCYmC5jUpO9Ag3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 113/240] media: ov8865: Fix an error handling path in ov8865_probe()
Date: Wed,  2 Nov 2022 03:31:28 +0100
Message-Id: <20221102022113.943830614@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 080e0b7404850406628674b07286f16cc389a892 ]

The commit in Fixes also introduced some new error handling which should
goto the existing error handling path.
Otherwise some resources leak.

Fixes: 73dcffeb2ff9 ("media: i2c: Support 19.2MHz input clock in ov8865")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov8865.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ov8865.c b/drivers/media/i2c/ov8865.c
index b8f4f0d3e33d..15d0f79231dd 100644
--- a/drivers/media/i2c/ov8865.c
+++ b/drivers/media/i2c/ov8865.c
@@ -3034,11 +3034,13 @@ static int ov8865_probe(struct i2c_client *client)
 				       &rate);
 	if (!ret && sensor->extclk) {
 		ret = clk_set_rate(sensor->extclk, rate);
-		if (ret)
-			return dev_err_probe(dev, ret,
-					     "failed to set clock rate\n");
+		if (ret) {
+			dev_err_probe(dev, ret, "failed to set clock rate\n");
+			goto error_endpoint;
+		}
 	} else if (ret && !sensor->extclk) {
-		return dev_err_probe(dev, ret, "invalid clock config\n");
+		dev_err_probe(dev, ret, "invalid clock config\n");
+		goto error_endpoint;
 	}
 
 	sensor->extclk_rate = rate ? rate : clk_get_rate(sensor->extclk);
-- 
2.35.1



