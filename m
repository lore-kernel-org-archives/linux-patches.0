Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5428F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:03:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD03C433C7;
	Sun, 16 Jul 2023 20:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537815;
	bh=LTxDahle6YaZGXZLSQV5iDddTtg5pM13vCY2Tynhp2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ymQW8MLRqmD/489n9NDlrbTyI1K3kT54vSIFir/jsSpC1g4/GcjSiQnmvGfIfXv4D
	 k2vmE7mTeBa1Hl5uFYY49BbPASytlPjNscxlo6za2KIA16iHME5eg/CNt2poQ91rLG
	 dnoMoEf8Uq8OxGlNIRnsETVeTwMejB6NIttG+Oi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca@z3ntu.xyz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 230/800] Input: drv260x - sleep between polling GO bit
Date: Sun, 16 Jul 2023 21:41:23 +0200
Message-ID: <20230716194954.432462321@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luca Weiss <luca@z3ntu.xyz>

[ Upstream commit efef661dfa6bf8cbafe4cd6a97433fcef0118967 ]

When doing the initial startup there's no need to poll without any
delay and spam the I2C bus.

Let's sleep 15ms between each attempt, which is the same time as used
in the vendor driver.

Fixes: 7132fe4f5687 ("Input: drv260x - add TI drv260x haptics driver")
Signed-off-by: Luca Weiss <luca@z3ntu.xyz>
Link: https://lore.kernel.org/r/20230430-drv260x-improvements-v1-2-1fb28b4cc698@z3ntu.xyz
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/drv260x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/misc/drv260x.c b/drivers/input/misc/drv260x.c
index 8a9ebfc04a2d9..85371fa1a03ed 100644
--- a/drivers/input/misc/drv260x.c
+++ b/drivers/input/misc/drv260x.c
@@ -435,6 +435,7 @@ static int drv260x_init(struct drv260x_data *haptics)
 	}
 
 	do {
+		usleep_range(15000, 15500);
 		error = regmap_read(haptics->regmap, DRV260X_GO, &cal_buf);
 		if (error) {
 			dev_err(&haptics->client->dev,
-- 
2.39.2



