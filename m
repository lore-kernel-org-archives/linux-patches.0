Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA07C1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:18:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D79C433EF;
	Mon, 20 Mar 2023 15:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325523;
	bh=bRb6TR5KYwtr9MR7+KocAOUsZL7ovGjeYKku9GQ4Ra4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=msI87XZXeZWpaWieWYx4NOY5c49/9OCyoloMqyvdm0bKkSy+7ClXTwIMgq2OEIxV0
	 fG5y+QTfKRQlj1KVOvpUzxadX24ONceP8TgENf0T75ICkWYr2gb15htFnLGAJjMh7X
	 +oqltOmBa5WW4TCZYPhObbXlcOgBkX6A0y6Hw5v4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony OBrien <tony.obrien@alliedtelesis.co.nz>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/198] hwmon: (adt7475) Fix masking of hysteresis registers
Date: Mon, 20 Mar 2023 15:53:52 +0100
Message-Id: <20230320145511.496995149@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tony O'Brien <tony.obrien@alliedtelesis.co.nz>

[ Upstream commit 48e8186870d9d0902e712d601ccb7098cb220688 ]

The wrong bits are masked in the hysteresis register; indices 0 and 2
should zero bits [7:4] and preserve bits [3:0], and index 1 should zero
bits [3:0] and preserve bits [7:4].

Fixes: 1c301fc5394f ("hwmon: Add a driver for the ADT7475 hardware monitoring chip")
Signed-off-by: Tony O'Brien <tony.obrien@alliedtelesis.co.nz>
Link: https://lore.kernel.org/r/20230222005228.158661-3-tony.obrien@alliedtelesis.co.nz
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/adt7475.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/adt7475.c b/drivers/hwmon/adt7475.c
index 77222c35a38ec..6e4c92b500b8e 100644
--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -488,10 +488,10 @@ static ssize_t temp_store(struct device *dev, struct device_attribute *attr,
 		val = (temp - val) / 1000;
 
 		if (sattr->index != 1) {
-			data->temp[HYSTERSIS][sattr->index] &= 0xF0;
+			data->temp[HYSTERSIS][sattr->index] &= 0x0F;
 			data->temp[HYSTERSIS][sattr->index] |= (val & 0xF) << 4;
 		} else {
-			data->temp[HYSTERSIS][sattr->index] &= 0x0F;
+			data->temp[HYSTERSIS][sattr->index] &= 0xF0;
 			data->temp[HYSTERSIS][sattr->index] |= (val & 0xF);
 		}
 
-- 
2.39.2



