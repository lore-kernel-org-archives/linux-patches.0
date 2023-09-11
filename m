Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B7611C87
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:29:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7077CC433CD;
	Mon, 11 Sep 2023 15:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694446161;
	bh=6QPScqfbrZknyI+l+SMWZ8iiqodo9WQiPqbflI2lMaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hHvcWjp1zS4tc+QCVWwqWaymAFRygahugIXg5WIFQWNrwT4thTN73mj1pvFI5nkUP
	 g1cTyK4RFJUYoVWGkrDEnUCGC1JnZR3geq/c0nysOTZSPA58nr2PoFop8+gaFUIyU5
	 kpAm2qnrqYPNFfIvZuOvYhDMlzPHhvRocifjlAkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 577/600] s390/dasd: fix string length handling
Date: Mon, 11 Sep 2023 15:50:10 +0200
Message-ID: <20230911134650.649627826@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

commit f7cf22424665043787a96a66a048ff6b2cfd473c upstream.

Building dasd_eckd.o with latest clang reveals this bug:

    CC      drivers/s390/block/dasd_eckd.o
      drivers/s390/block/dasd_eckd.c:1082:3: warning: 'snprintf' will always be truncated;
      specified size is 1, but format string expands to at least 11 [-Wfortify-source]
       1082 |                 snprintf(print_uid, sizeof(*print_uid),
            |                 ^
      drivers/s390/block/dasd_eckd.c:1087:3: warning: 'snprintf' will always be truncated;
      specified size is 1, but format string expands to at least 10 [-Wfortify-source]
       1087 |                 snprintf(print_uid, sizeof(*print_uid),
            |                 ^

Fix this by moving and using the existing UID_STRLEN for the arrays
that are being written to. Also rename UID_STRLEN to DASD_UID_STRLEN
to clarify its scope.

Fixes: 23596961b437 ("s390/dasd: split up dasd_eckd_read_conf")
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com> # build
Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://github.com/ClangBuiltLinux/linux/issues/1923
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/r/20230828153142.2843753-2-hca@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dasd_devmap.c |    6 +-----
 drivers/s390/block/dasd_eckd.c   |   10 +++++-----
 drivers/s390/block/dasd_int.h    |    4 ++++
 3 files changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/s390/block/dasd_devmap.c
+++ b/drivers/s390/block/dasd_devmap.c
@@ -1377,16 +1377,12 @@ static ssize_t dasd_vendor_show(struct d
 
 static DEVICE_ATTR(vendor, 0444, dasd_vendor_show, NULL);
 
-#define UID_STRLEN ( /* vendor */ 3 + 1 + /* serial    */ 14 + 1 +\
-		     /* SSID   */ 4 + 1 + /* unit addr */ 2 + 1 +\
-		     /* vduit */ 32 + 1)
-
 static ssize_t
 dasd_uid_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
+	char uid_string[DASD_UID_STRLEN];
 	struct dasd_device *device;
 	struct dasd_uid uid;
-	char uid_string[UID_STRLEN];
 	char ua_string[3];
 
 	device = dasd_device_from_cdev(to_ccwdev(dev));
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -1079,12 +1079,12 @@ static void dasd_eckd_get_uid_string(str
 
 	create_uid(conf, &uid);
 	if (strlen(uid.vduit) > 0)
-		snprintf(print_uid, sizeof(*print_uid),
+		snprintf(print_uid, DASD_UID_STRLEN,
 			 "%s.%s.%04x.%02x.%s",
 			 uid.vendor, uid.serial, uid.ssid,
 			 uid.real_unit_addr, uid.vduit);
 	else
-		snprintf(print_uid, sizeof(*print_uid),
+		snprintf(print_uid, DASD_UID_STRLEN,
 			 "%s.%s.%04x.%02x",
 			 uid.vendor, uid.serial, uid.ssid,
 			 uid.real_unit_addr);
@@ -1093,8 +1093,8 @@ static void dasd_eckd_get_uid_string(str
 static int dasd_eckd_check_cabling(struct dasd_device *device,
 				   void *conf_data, __u8 lpm)
 {
+	char print_path_uid[DASD_UID_STRLEN], print_device_uid[DASD_UID_STRLEN];
 	struct dasd_eckd_private *private = device->private;
-	char print_path_uid[60], print_device_uid[60];
 	struct dasd_conf path_conf;
 
 	path_conf.data = conf_data;
@@ -1293,9 +1293,9 @@ static void dasd_eckd_path_available_act
 	__u8 path_rcd_buf[DASD_ECKD_RCD_DATA_SIZE];
 	__u8 lpm, opm, npm, ppm, epm, hpfpm, cablepm;
 	struct dasd_conf_data *conf_data;
+	char print_uid[DASD_UID_STRLEN];
 	struct dasd_conf path_conf;
 	unsigned long flags;
-	char print_uid[60];
 	int rc, pos;
 
 	opm = 0;
@@ -5856,8 +5856,8 @@ static void dasd_eckd_dump_sense(struct
 static int dasd_eckd_reload_device(struct dasd_device *device)
 {
 	struct dasd_eckd_private *private = device->private;
+	char print_uid[DASD_UID_STRLEN];
 	int rc, old_base;
-	char print_uid[60];
 	struct dasd_uid uid;
 	unsigned long flags;
 
--- a/drivers/s390/block/dasd_int.h
+++ b/drivers/s390/block/dasd_int.h
@@ -259,6 +259,10 @@ struct dasd_uid {
 	char vduit[33];
 };
 
+#define DASD_UID_STRLEN ( /* vendor */ 3 + 1 + /* serial    */ 14 + 1 +	\
+			  /* SSID   */ 4 + 1 + /* unit addr */ 2 + 1 +	\
+			  /* vduit */ 32 + 1)
+
 /*
  * PPRC Status data
  */


