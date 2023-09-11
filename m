Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6951170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:19:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E953C433C8;
	Mon, 11 Sep 2023 14:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441991;
	bh=g/a1BIhFjSgJoT3d+GK0mCCPNoPeszVw+e2BR0Hznh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DhpPq0cBknijGPG9rj3SyR6eUdxk+xoVS7mScodJbNcZfr+3mSDAWySxKwjWaqVuy
	 3V3JvedCMbuMMzkaMXDiEy1eERsTybZBML8+937iA5TOJuj7AhDr35bpA5f4c92ToN
	 qtOMA83Yaxz7Zlr/8Whm0HVxJijc7DG4x4N2PIps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Alexandre Mergnat <amergnat@baylibre.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 607/739] thermal/drivers/mediatek/lvts_thermal: Disable undesired interrupts
Date: Mon, 11 Sep 2023 15:46:46 +0200
Message-ID: <20230911134708.053445569@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 487bf099e85b724c824f5fafaf93c6749c4d2120 ]

Out of the many interrupts supported by the hardware, the only ones of
interest to the driver currently are:
* The temperature went over the high offset threshold, for any of the
  sensors
* The temperature went below the low offset threshold, for any of the
  sensors
* The temperature went over the stage3 threshold

These are the only thresholds configured by the driver through the
OFFSETH, OFFSETL, and PROTTC registers, respectively.

The current interrupt mask in LVTS_MONINT_CONF, enables many more
interrupts, including data ready on sensors for both filtered and
immediate mode. These are not only not handled by the driver, but they
are also triggered too often, causing unneeded overhead. Disable these
unnecessary interrupts.

The meaning of each bit can be seen in the comment describing
LVTS_MONINTST in the IRQ handler.

Fixes: f5f633b18234 ("thermal/drivers/mediatek: Add the Low Voltage Thermal Sensor driver")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Alexandre Mergnat <amergnat@baylibre.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20230706153823.201943-5-nfraprado@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/mediatek/lvts_thermal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/mediatek/lvts_thermal.c b/drivers/thermal/mediatek/lvts_thermal.c
index 25cdcec4a50c9..02e7af4619a2c 100644
--- a/drivers/thermal/mediatek/lvts_thermal.c
+++ b/drivers/thermal/mediatek/lvts_thermal.c
@@ -65,7 +65,7 @@
 #define LVTS_HW_FILTER				0x2
 #define LVTS_TSSEL_CONF				0x13121110
 #define LVTS_CALSCALE_CONF			0x300
-#define LVTS_MONINT_CONF			0x9FBF7BDE
+#define LVTS_MONINT_CONF			0x8300318C
 
 #define LVTS_INT_SENSOR0			0x0009001F
 #define LVTS_INT_SENSOR1			0x001203E0
-- 
2.40.1



