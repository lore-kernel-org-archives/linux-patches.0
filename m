Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCD515496
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB322C4339B;
	Mon,  8 May 2023 11:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545370;
	bh=zYcaq/u36HILowGlBwfk3R65GqLyhuH9xoB+SwrbdP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WWcdxjX3cdQz6a25UkvFjGOy+O6LjhiWyVdnd2DFAJHKUaVG41p8DlW+8qUQ31v8r
	 sufIU26ysQqW6KXac5Q7Z7aIVsdcbWVZbHOw2l8kcUbaJ+SXyF4Vl4gnb5uH099bds
	 VdVTozvgNGR3KPhFZXG3OvnSiYPWbafBDJKIZ4no=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Babu Moger <babu.moger@amd.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 018/371] hwmon: (k10temp) Check range scale when CUR_TEMP register is read-write
Date: Mon,  8 May 2023 11:43:39 +0200
Message-Id: <20230508094812.819860008@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Babu Moger <Babu.Moger@amd.com>

commit 0c072385348e3ac5229145644055d3e2afb5b3db upstream.

Spec says, when CUR_TEMP_TJ_SEL == 3 and CUR_TEMP_RANGE_SEL == 0,
it should use RangeUnadjusted is 0, which is (CurTmp*0.125 -49) C. The
CUR_TEMP register is read-write when CUR_TEMP_TJ_SEL == 3 (bit 17-16).

Add the check to detect it.

Sensors command's output before the patch.
$sensors
 k10temp-pci-00c3
 Adapter: PCI adapter
 Tctl:         +76.6°C <- Wrong value
 Tccd1:        +26.5°C
 Tccd2:        +27.5°C
 Tccd3:        +27.2°C
 Tccd4:        +27.5°C
 Tccd5:        +26.0°C
 Tccd6:        +26.2°C
 Tccd7:        +25.0°C
 Tccd8:        +26.5°C

Sensors command's output after the patch.
$sensors
 k10temp-pci-00c3
 Adapter: PCI adapter
 Tctl:         +28.8°C <- corrected value
 Tccd1:        +27.5°C
 Tccd2:        +28.5°C
 Tccd3:        +28.5°C
 Tccd4:        +28.5°C
 Tccd5:        +27.0°C
 Tccd6:        +27.5°C
 Tccd7:        +27.0°C
 Tccd8:        +27.5°C

Signed-off-by: Babu Moger <babu.moger@amd.com>
Fixes: 1b59788979ac ("hwmon: (k10temp) Add temperature offset for Ryzen 2700X")
Link: https://lore.kernel.org/r/20230413213958.847634-1-babu.moger@amd.com
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/k10temp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -75,6 +75,7 @@ static DEFINE_MUTEX(nb_smu_ind_mutex);
 
 #define ZEN_CUR_TEMP_SHIFT			21
 #define ZEN_CUR_TEMP_RANGE_SEL_MASK		BIT(19)
+#define ZEN_CUR_TEMP_TJ_SEL_MASK		GENMASK(17, 16)
 
 #define ZEN_SVI_BASE				0x0005A000
 
@@ -175,7 +176,8 @@ static long get_raw_temp(struct k10temp_
 
 	data->read_tempreg(data->pdev, &regval);
 	temp = (regval >> ZEN_CUR_TEMP_SHIFT) * 125;
-	if (regval & data->temp_adjust_mask)
+	if ((regval & data->temp_adjust_mask) ||
+	    (regval & ZEN_CUR_TEMP_TJ_SEL_MASK) == ZEN_CUR_TEMP_TJ_SEL_MASK)
 		temp -= 49000;
 	return temp;
 }


