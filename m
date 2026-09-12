Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2613612F6;
	Sat, 12 Sep 2026 07:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198979; cv=none; b=grUcLBqGsnA2rLtZO4vfd94Z8y25HCp474U3mrHdmougdRCatjd/PPT+eYi7Mg+M3ucsdee90DdjSoh5AYoM7gfXGTSQHmTYsZf+JU/J3mh+IidL7W844gjAltg6sNY38mBjPcskFSKJZYlLyjuPTjwKvYihJQXs1auCAcItHYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198979; c=relaxed/simple;
	bh=DZlEnAh9y9UZ9zE1DVf0eelj7pNcw9/jbkcDXvUiT78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hNCCWcqKG7Ms/0PgirUmQ8LASEq1FL45zUkSwmKHgWX0Ljl4AJm0hW8kRncaVk1oalbN0fNpjvONPa2D71l09PGzpedrWyJmtjI9g0rHkOw73vxmTjdvyUIng16PLqj+yFM9/pdYl/8327q+klUfuioQyKKliT5wzhk5xcEcSFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uU4X1a7v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uU4X1a7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D53A1F000FF;
	Sat, 12 Sep 2026 07:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198978;
	bh=ZP794hzewRr8e49r9pHdx5M0vHSPV2ZD98DSvPkhhtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uU4X1a7vVITCqBoFloRBiE1ur/ZDmtDJ3TZqNXcXdCEUhpbbVDwUP2oEEAPCuxMhS
	 QMsIAyVu32HWBxF8GZbwXyQu8rsbr0v2Agxgovz2JeQzrUZVYGuF6jvWZtvNXDsmq1
	 Tx4RnN/h28kaZ9BlXEsTPVIUjzzADPpxl1gNHvc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander A. Klimov" <grandmaster@al2klimov.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0490/1815] tlclk: if sscanf() fails, fall back to 0, not random value
Date: Sat, 12 Sep 2026 08:37:20 +0200
Message-ID: <20260912065700.393809795@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander A. Klimov <grandmaster@al2klimov.de>

[ Upstream commit 75f9481e0479c3faadf4d88baffe84b3d23d5763 ]

If sscanf(IN, FMT, &OUT) fails, OUT may be unchanged.
So if OUT was never initialized, it may be still uninitialized memory.
To prevent such, initialize OUT=0 first.

Fixes: 648bf4fb21f5 ("[PATCH] tlclk driver update")
Fixes: 1a80ba882730 ("[PATCH] Telecom Clock Driver for MPCBL0010 ATCA computer blade")
Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
Link: https://patch.msgid.link/20260526061321.6123-4-grandmaster@al2klimov.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tlclk.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/char/tlclk.c b/drivers/char/tlclk.c
index dd45fe5eb6f27..255f69123af5f 100644
--- a/drivers/char/tlclk.c
+++ b/drivers/char/tlclk.c
@@ -328,7 +328,7 @@ static DEVICE_ATTR(alarms, S_IRUGO, show_alarms, NULL);
 static ssize_t store_received_ref_clk3a(struct device *d,
 		 struct device_attribute *attr, const char *buf, size_t count)
 {
-	unsigned long tmp;
+	unsigned long tmp = 0;
 	unsigned char val;
 	unsigned long flags;
 
@@ -350,7 +350,7 @@ static DEVICE_ATTR(received_ref_clk3a, (S_IWUSR|S_IWGRP), NULL,
 static ssize_t store_received_ref_clk3b(struct device *d,
 		 struct device_attribute *attr, const char *buf, size_t count)
 {
-	unsigned long tmp;
+	unsigned long tmp = 0;
 	unsigned char val;
 	unsigned long flags;
 
@@ -372,7 +372,7 @@ static DEVICE_ATTR(received_ref_clk3b, (S_IWUSR|S_IWGRP), NULL,
 static ssize_t store_enable_clk3b_output(struct device *d,
 		 struct device_attribute *attr, const char *buf, size_t count)
 {
-	unsigned long tmp;
+	unsigned long tmp = 0;
 	unsigned char val;
 	unsigned long flags;
 
@@ -394,7 +394,7 @@ static ssize_t store_enable_clk3a_output(struct device *d,
 		 struct device_attribute *attr, const char *buf, size_t count)
 {
 	unsigned long flags;
-	unsigned long tmp;
+	unsigned long tmp = 0;
 	unsigned char val;
 
 	sscanf(buf, "%lX", &tmp);
@@ -415,7 +415,7 @@ static ssize_t store_enable_clkb1_output(struct device *d,
 		 struct device_attribute *attr, const char *buf, size_t count)
 {
 	unsigned long flags;
-	unsigned long tmp;
+	unsigned long tmp = 0;
 	unsigned char val;
 
 	sscanf(buf, "%lX", &tmp);
@@ -437,7 +437,7 @@ static ssize_t store_enable_clka1_output(struct device *d,
 		 struct device_attribute *attr, const char *buf, size_t count)
 {
 	unsigned long flags;
-	unsigned long tmp;
+	unsigned long tmp = 0;
 	unsigned char val;
 
 	sscanf(buf, "%lX", &tmp);
@@ -458,7 +458,7 @@ static ssize_t store_enable_clkb0_output(struct device *d,
 		 struct device_attribute *attr, const char *buf, size_t count)
 {
 	unsigned long flags;
-	unsigned long tmp;
+	unsigned long tmp = 0;
 	unsigned char val;
 
 	sscanf(buf, "%lX", &tmp);
@@ -479,7 +479,7 @@ static ssize_t store_enable_clka0_output(struct device *d,
 		 struct device_attribute *attr, const char *buf, size_t count)
 {
 	unsigned long flags;
-	unsigned long tmp;
+	unsigned long tmp = 0;
 	unsigned char val;
 
 	sscanf(buf, "%lX", &tmp);
@@ -500,7 +500,7 @@ static ssize_t store_select_amcb2_transmit_clock(struct device *d,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	unsigned long flags;
-	unsigned long tmp;
+	unsigned long tmp = 0;
 	unsigned char val;
 
 	sscanf(buf, "%lX", &tmp);
@@ -541,7 +541,7 @@ static DEVICE_ATTR(select_amcb2_transmit_clock, (S_IWUSR|S_IWGRP), NULL,
 static ssize_t store_select_amcb1_transmit_clock(struct device *d,
 		 struct device_attribute *attr, const char *buf, size_t count)
 {
-	unsigned long tmp;
+	unsigned long tmp = 0;
 	unsigned char val;
 	unsigned long flags;
 
@@ -583,7 +583,7 @@ static DEVICE_ATTR(select_amcb1_transmit_clock, (S_IWUSR|S_IWGRP), NULL,
 static ssize_t store_select_redundant_clock(struct device *d,
 		 struct device_attribute *attr, const char *buf, size_t count)
 {
-	unsigned long tmp;
+	unsigned long tmp = 0;
 	unsigned char val;
 	unsigned long flags;
 
@@ -604,7 +604,7 @@ static DEVICE_ATTR(select_redundant_clock, (S_IWUSR|S_IWGRP), NULL,
 static ssize_t store_select_ref_frequency(struct device *d,
 		 struct device_attribute *attr, const char *buf, size_t count)
 {
-	unsigned long tmp;
+	unsigned long tmp = 0;
 	unsigned char val;
 	unsigned long flags;
 
@@ -625,7 +625,7 @@ static DEVICE_ATTR(select_ref_frequency, (S_IWUSR|S_IWGRP), NULL,
 static ssize_t store_filter_select(struct device *d,
 		 struct device_attribute *attr, const char *buf, size_t count)
 {
-	unsigned long tmp;
+	unsigned long tmp = 0;
 	unsigned char val;
 	unsigned long flags;
 
@@ -645,7 +645,7 @@ static DEVICE_ATTR(filter_select, (S_IWUSR|S_IWGRP), NULL, store_filter_select);
 static ssize_t store_hardware_switching_mode(struct device *d,
 		 struct device_attribute *attr, const char *buf, size_t count)
 {
-	unsigned long tmp;
+	unsigned long tmp = 0;
 	unsigned char val;
 	unsigned long flags;
 
@@ -666,7 +666,7 @@ static DEVICE_ATTR(hardware_switching_mode, (S_IWUSR|S_IWGRP), NULL,
 static ssize_t store_hardware_switching(struct device *d,
 		 struct device_attribute *attr, const char *buf, size_t count)
 {
-	unsigned long tmp;
+	unsigned long tmp = 0;
 	unsigned char val;
 	unsigned long flags;
 
@@ -687,7 +687,7 @@ static DEVICE_ATTR(hardware_switching, (S_IWUSR|S_IWGRP), NULL,
 static ssize_t store_refalign (struct device *d,
 		 struct device_attribute *attr, const char *buf, size_t count)
 {
-	unsigned long tmp;
+	unsigned long tmp = 0;
 	unsigned long flags;
 
 	sscanf(buf, "%lX", &tmp);
@@ -706,7 +706,7 @@ static DEVICE_ATTR(refalign, (S_IWUSR|S_IWGRP), NULL, store_refalign);
 static ssize_t store_mode_select (struct device *d,
 		 struct device_attribute *attr, const char *buf, size_t count)
 {
-	unsigned long tmp;
+	unsigned long tmp = 0;
 	unsigned char val;
 	unsigned long flags;
 
@@ -726,7 +726,7 @@ static DEVICE_ATTR(mode_select, (S_IWUSR|S_IWGRP), NULL, store_mode_select);
 static ssize_t store_reset (struct device *d,
 		 struct device_attribute *attr, const char *buf, size_t count)
 {
-	unsigned long tmp;
+	unsigned long tmp = 0;
 	unsigned char val;
 	unsigned long flags;
 
-- 
2.53.0



