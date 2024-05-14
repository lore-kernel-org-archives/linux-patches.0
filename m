Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C109129A66;
	Tue, 14 May 2024 10:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683785; cv=none; b=IipnFuQ0ZqwhBE5CxePOnlNuEScZL2ydNUDkba/3smkkYK4KFl+C4dBLHX3L/LQec2V/VPW1geqQJxDHoiHutgqCYqTaJob915KWSGenLuTeBKjFPLy7eVpwhuiNrrKGM2OusZdh4UIX3youPAvaA/0a7qkjUNAOUBF/8r/BYeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683785; c=relaxed/simple;
	bh=CwInm5geF4LAm3wm7C4RlcYE+gn/EYB2fjxvGoLWLfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZeRdL137dPRPsO+xjGHYammP8MGFL3qk9135ldLBkGjzETjqOxEDqvCecrGqA+QfLJBCzlsJDXjXKymQtdZg8fAYgBj3PzMg3QGttF5AXB0ggC6kidxfIRL3vVf2+/nG5//KZrJafka0qDzQLz/88XvtEajGChTkzwYqZ4RT7uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qT/XjZq7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qT/XjZq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D698C2BD10;
	Tue, 14 May 2024 10:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683785;
	bh=CwInm5geF4LAm3wm7C4RlcYE+gn/EYB2fjxvGoLWLfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qT/XjZq7B6AcEJaW3ieqjuU9GR/WNkEEvjnx2lDtnnm3OlBjyY8XBwGea7oBe2VpB
	 7PA6dHJ1wnVVvPMWJv+6nI23WRYoUy5bfXUYqmXG47mwW4vySYJUMXQdrN6nQXYe3R
	 70lPBofL/d7BvdSziXv7Uc7gUEoUFgQtIiw+65GU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramona Gradinariu <ramona.bolboaca13@gmail.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.8 273/336] iio:imu: adis16475: Fix sync mode setting
Date: Tue, 14 May 2024 12:17:57 +0200
Message-ID: <20240514101048.928377618@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ramona Gradinariu <ramona.bolboaca13@gmail.com>

commit 74a72baf204fd509bbe8b53eec35e39869d94341 upstream.

Fix sync mode setting by applying the necessary shift bits.

Fixes: fff7352bf7a3 ("iio: imu: Add support for adis16475")
Signed-off-by: Ramona Gradinariu <ramona.bolboaca13@gmail.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20240405045309.816328-2-ramona.bolboaca13@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/adis16475.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iio/imu/adis16475.c
+++ b/drivers/iio/imu/adis16475.c
@@ -1289,6 +1289,7 @@ static int adis16475_config_sync_mode(st
 	struct device *dev = &st->adis.spi->dev;
 	const struct adis16475_sync *sync;
 	u32 sync_mode;
+	u16 val;
 
 	/* default to internal clk */
 	st->clk_freq = st->info->int_clk * 1000;
@@ -1350,8 +1351,9 @@ static int adis16475_config_sync_mode(st
 	 * I'm keeping this for simplicity and avoiding extra variables
 	 * in chip_info.
 	 */
+	val = ADIS16475_SYNC_MODE(sync->sync_mode);
 	ret = __adis_update_bits(&st->adis, ADIS16475_REG_MSG_CTRL,
-				 ADIS16475_SYNC_MODE_MASK, sync->sync_mode);
+				 ADIS16475_SYNC_MODE_MASK, val);
 	if (ret)
 		return ret;
 


