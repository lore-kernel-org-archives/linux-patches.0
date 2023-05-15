Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590FDFC00
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:33:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57D7C433EF;
	Mon, 15 May 2023 17:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172024;
	bh=+VyxnjygScCFtL/AuPw+muvoofhShgdeygLG64otsKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Skn1wkn5ZWk7VJaTj39oi3GhdrlUTLzVqoTC2tOdTB/jzSwY1fIRp98SJtjpbpA6K
	 zbEzwetf7UJ6Q8phVt7fiXlq6T/2KXPUF9mwJ1BQvUpsFX78+WZnuzxyGkaUFGfjwz
	 kbNVacat47ZDsPUTPsWuGyg0Vd5yppmm7zMRVVZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Babu Moger <babu.moger@amd.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.10 020/381] hwmon: (k10temp) Check range scale when CUR_TEMP register is read-write
Date: Mon, 15 May 2023 18:24:31 +0200
Message-Id: <20230515161737.684321944@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
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
@@ -74,6 +74,7 @@ static DEFINE_MUTEX(nb_smu_ind_mutex);
 
 #define ZEN_CUR_TEMP_SHIFT			21
 #define ZEN_CUR_TEMP_RANGE_SEL_MASK		BIT(19)
+#define ZEN_CUR_TEMP_TJ_SEL_MASK		GENMASK(17, 16)
 
 #define ZEN_SVI_BASE				0x0005A000
 
@@ -173,7 +174,8 @@ static long get_raw_temp(struct k10temp_
 
 	data->read_tempreg(data->pdev, &regval);
 	temp = (regval >> ZEN_CUR_TEMP_SHIFT) * 125;
-	if (regval & data->temp_adjust_mask)
+	if ((regval & data->temp_adjust_mask) ||
+	    (regval & ZEN_CUR_TEMP_TJ_SEL_MASK) == ZEN_CUR_TEMP_TJ_SEL_MASK)
 		temp -= 49000;
 	return temp;
 }


