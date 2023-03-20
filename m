Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4202D1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:12:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CDCC4339C;
	Mon, 20 Mar 2023 15:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325150;
	bh=1dmy8v+6t/Q81mRh9oGB2LK5JOqFchzXvLhucNgLVas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AEZBPYZmO7tbTbPxB0ML95wySbUOEEy1ctTV6zbXD549wd/BDZ2bBlxTRGtezjcM8
	 O6fjghAmxn37DHu27XYPU2M5hyNtzmqr6c0NzOA+lN9TAQz4klB3eqUHly3Dih9Mpe
	 DQvybnXKi6dXAYQj4K0UgcSjMjIuE9SCZMvCWAcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony OBrien <tony.obrien@alliedtelesis.co.nz>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/115] hwmon: (adt7475) Fix masking of hysteresis registers
Date: Mon, 20 Mar 2023 15:54:26 +0100
Message-Id: <20230320145451.691211271@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
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
index c7f19a1ca0a59..6b84822e7d93b 100644
--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -486,10 +486,10 @@ static ssize_t temp_store(struct device *dev, struct device_attribute *attr,
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



