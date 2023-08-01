Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F67D1F953
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019B2C433C8;
	Tue,  1 Aug 2023 09:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882065;
	bh=AuWUAmOASL8Jchzm0qVMs1OSfJBQU1mG/SlU2lAB3Is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WQq2yWgMb6mJK9rdlGxb9rAm3k40L1dGrlnP0NNSdjzgvW/5TnG1F8L22u/V7DXqV
	 WMYh4uzjA+kD2xY2VLQf6hgh0kIHQK6FZ9XtScQEHomlDxSaPoWCl3pW3h/3cZAj3q
	 ZG3M+EFVwJnGWm8i2OQCzYmwuA/efyo2kmMKdu+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baskaran Kannan <Baski.Kannan@amd.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 129/155] hwmon: (k10temp) Enable AMD3255 Proc to show negative temperature
Date: Tue,  1 Aug 2023 11:20:41 +0200
Message-ID: <20230801091914.789941828@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Baskaran Kannan <Baski.Kannan@amd.com>

commit e146503ac68418859fb063a3a0cd9ec93bc52238 upstream.

Industrial processor i3255 supports temperatures -40 deg celcius
to 105 deg Celcius. The current implementation of k10temp_read_temp
rounds off any negative temperatures to '0'. To fix this,
the following changes have been made.

A flag 'disp_negative' is added to struct k10temp_data to support
AMD i3255 processors. Flag 'disp_negative' is set if 3255 processor
is found during k10temp_probe.  Flag 'disp_negative' is used to
determine whether to round off negative temperatures to '0' in
k10temp_read_temp.

Signed-off-by: Baskaran Kannan <Baski.Kannan@amd.com>
Link: https://lore.kernel.org/r/20230727162159.1056136-1-Baski.Kannan@amd.com
Fixes: aef17ca12719 ("hwmon: (k10temp) Only apply temperature offset if result is positive")
Cc: stable@vger.kernel.org
[groeck: Fixed multi-line comment]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/k10temp.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -97,6 +97,13 @@ static DEFINE_MUTEX(nb_smu_ind_mutex);
 #define F19H_M01H_CFACTOR_ICORE			1000000	/* 1A / LSB	*/
 #define F19H_M01H_CFACTOR_ISOC			310000	/* 0.31A / LSB	*/
 
+/*
+ * AMD's Industrial processor 3255 supports temperature from -40 deg to 105 deg Celsius.
+ * Use the model name to identify 3255 CPUs and set a flag to display negative temperature.
+ * Do not round off to zero for negative Tctl or Tdie values if the flag is set
+ */
+#define AMD_I3255_STR				"3255"
+
 struct k10temp_data {
 	struct pci_dev *pdev;
 	void (*read_htcreg)(struct pci_dev *pdev, u32 *regval);
@@ -106,6 +113,7 @@ struct k10temp_data {
 	u32 show_temp;
 	bool is_zen;
 	u32 ccd_offset;
+	bool disp_negative;
 };
 
 #define TCTL_BIT	0
@@ -220,12 +228,12 @@ static int k10temp_read_temp(struct devi
 		switch (channel) {
 		case 0:		/* Tctl */
 			*val = get_raw_temp(data);
-			if (*val < 0)
+			if (*val < 0 && !data->disp_negative)
 				*val = 0;
 			break;
 		case 1:		/* Tdie */
 			*val = get_raw_temp(data) - data->temp_offset;
-			if (*val < 0)
+			if (*val < 0 && !data->disp_negative)
 				*val = 0;
 			break;
 		case 2 ... 9:		/* Tccd{1-8} */
@@ -417,6 +425,11 @@ static int k10temp_probe(struct pci_dev
 	data->pdev = pdev;
 	data->show_temp |= BIT(TCTL_BIT);	/* Always show Tctl */
 
+	if (boot_cpu_data.x86 == 0x17 &&
+	    strstr(boot_cpu_data.x86_model_id, AMD_I3255_STR)) {
+		data->disp_negative = true;
+	}
+
 	if (boot_cpu_data.x86 == 0x15 &&
 	    ((boot_cpu_data.x86_model & 0xf0) == 0x60 ||
 	     (boot_cpu_data.x86_model & 0xf0) == 0x70)) {


