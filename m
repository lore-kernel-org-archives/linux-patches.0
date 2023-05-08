Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172D1168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90716C433EF;
	Mon,  8 May 2023 11:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544259;
	bh=7eCSt9TAkm14rHbuv7NNeQ7hMy0h70s6meaHdg7R9cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EZZyJpjYbiOIcYMVhWCTfgOtNhiScg4ILH0TNnGA9g78fQiAz3GuQXqj1jZvQKyvj
	 ofC4QETlBV1of4sF2Vn8ioylkRhOvfGgywVEqA+jxdZPlmrahVdDe80Y6ggcVwLjE4
	 oUFUjkwRFstnvUlQrd8kcspLfoKa680y7b93n/h4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 321/694] media: ov5670: Fix probe on ACPI
Date: Mon,  8 May 2023 11:42:36 +0200
Message-Id: <20230508094442.749618522@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 73b41dc51fbeffa4a216b20193274cfe92b5d95b ]

devm_clk_get() will return either an error or NULL, which the driver
handles, continuing to use the clock of reading the value of the
clock-frequency property.

However, the value of ov5670->xvclk is left as-is and the other clock
framework functions aren't capable of handling error values.

Use devm_clk_get_optional() to obtain NULL instead of -ENOENT.

Fixes: 8004c91e2095 ("media: i2c: ov5670: Use common clock framework")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5670.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5670.c b/drivers/media/i2c/ov5670.c
index f79d908f4531b..c5e783a06f06c 100644
--- a/drivers/media/i2c/ov5670.c
+++ b/drivers/media/i2c/ov5670.c
@@ -2660,7 +2660,7 @@ static int ov5670_probe(struct i2c_client *client)
 		goto error_print;
 	}
 
-	ov5670->xvclk = devm_clk_get(&client->dev, NULL);
+	ov5670->xvclk = devm_clk_get_optional(&client->dev, NULL);
 	if (!IS_ERR_OR_NULL(ov5670->xvclk))
 		input_clk = clk_get_rate(ov5670->xvclk);
 	else if (PTR_ERR(ov5670->xvclk) == -ENOENT)
-- 
2.39.2



