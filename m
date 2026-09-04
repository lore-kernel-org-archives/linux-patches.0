Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C30E3A7F4C;
	Fri,  4 Sep 2026 05:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498991; cv=none; b=sL+8YDJENgbbLNEq7LBf0ilNvjAgZLiFOCALgysIvvJpHrCif3TR8XDNjNqaWjSlhAN0KxsEdBTVmTntZwfljxpi/lL318/1acRhpVHo9+asz8Zxv7bCi+Gm7/Q8cWjQB9/SG/JinJKPv7OzhN5b673CyQ85nqyticsOKkgOjXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498991; c=relaxed/simple;
	bh=ejnmvp1wCAx2sj1XThXU+03QKlVtPEjhoSUdH2n3isk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Midc2vLnzuKg4mhwvXLP4/sCP49CdQ6mFsOYLk1jlh3JQPNjdaE8/8LiYwF/TTunDrpVpMNnnNKENSo3QxRXTT3srlt5RmXHBrTk10Z55pdrlbjGYdnfeSxV+pxg2QVVAkWZtUpyUBj0gaAVw1VKiXyyJsvUvBPhkK6qjjMe1qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZ7QGF8x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZ7QGF8x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64221F00A3D;
	Fri,  4 Sep 2026 05:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498990;
	bh=uKUpgvxxub+pXYW65IJfs6i7KupL/9IQdzG45aEGYcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lZ7QGF8x1vgI8zFeDXa1a+8eyukyc27DUyQFYGGTTF7NpEsGZ/ViPnDBDYufm5/dt
	 IeBnh3e9IiBXUQDLCCsvI8lE2Cs3Q3Dr2+x6hneryEL0CNSM9O6Q8cC75At/crw/DG
	 jSLkGUuqCWumoNotZdtCOEswINHBQleoxZKvul5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI <sashiko-bot@kernel.org>,
	HyeongJun An <sammiee5311@gmail.com>,
	Even Xu <even.xu@intel.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.2 257/713] HID: intel-thc-hid: intel-quickspi: bound GET_REPORT response to the caller buffer
Date: Fri,  4 Sep 2026 06:53:45 +0200
Message-ID: <20260904045809.599383198@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

commit 035ec4a71cb8020a927c123bbe75c2f88d614986 upstream.

quickspi_hid_raw_request() receives the caller's buffer length in len, but
quickspi_get_report() never sees it and copies the whole device-supplied
response into buf regardless:

    memcpy(buf, qsdev->report_buf, qsdev->report_len);

qsdev->report_len comes from the input report the touch controller returns,
while buf is sized to whatever the caller asked hidraw for through
HIDIOCGFEATURE or HIDIOCGINPUT.  A response larger than that overflows buf
with device-controlled content.

The intel-quicki2c sibling already passes the caller length down to
quicki2c_get_report() and validates the response against it before the
copy.  Do the same here.

Fixes: 4138f21115ae ("HID: intel-thc-hid: intel-quickspi: Complete THC QuickSPI driver")
Suggested-by: Sashiko AI <sashiko-bot@kernel.org>
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Even Xu <even.xu@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/intel-thc-hid/intel-quickspi/quickspi-hid.c      |    2 -
 drivers/hid/intel-thc-hid/intel-quickspi/quickspi-protocol.c |   16 ++++++++---
 drivers/hid/intel-thc-hid/intel-quickspi/quickspi-protocol.h |    2 -
 3 files changed, 15 insertions(+), 5 deletions(-)

--- a/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-hid.c
+++ b/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-hid.c
@@ -61,7 +61,7 @@ static int quickspi_hid_raw_request(stru
 
 	switch (reqtype) {
 	case HID_REQ_GET_REPORT:
-		ret = quickspi_get_report(qsdev, rtype, reportnum, buf);
+		ret = quickspi_get_report(qsdev, rtype, reportnum, buf, len);
 		break;
 	case HID_REQ_SET_REPORT:
 		ret = quickspi_set_report(qsdev, rtype, reportnum, buf, len);
--- a/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-protocol.c
+++ b/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-protocol.c
@@ -345,10 +345,12 @@ int reset_tic(struct quickspi_device *qs
 }
 
 int quickspi_get_report(struct quickspi_device *qsdev,
-			u8 report_type, unsigned int report_id, void *buf)
+			u8 report_type, unsigned int report_id, void *buf,
+			u32 buf_len)
 {
 	int rep_type;
 	int ret;
+	u32 report_len;
 
 	if (report_type == HID_INPUT_REPORT) {
 		rep_type = GET_INPUT_REPORT;
@@ -375,9 +377,17 @@ int quickspi_get_report(struct quickspi_
 	}
 	qsdev->get_report_cmpl = false;
 
-	memcpy(buf, qsdev->report_buf, qsdev->report_len);
+	/* quickspi_handle_input_data() updates this from IRQ context. */
+	report_len = READ_ONCE(qsdev->report_len);
+	if (report_len > buf_len) {
+		dev_err_once(qsdev->dev, "Get report response too big, %u vs %u\n",
+			     report_len, buf_len);
+		return -EINVAL;
+	}
+
+	memcpy(buf, qsdev->report_buf, report_len);
 
-	return qsdev->report_len;
+	return report_len;
 }
 
 int quickspi_set_report(struct quickspi_device *qsdev,
--- a/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-protocol.h
+++ b/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-protocol.h
@@ -12,7 +12,7 @@ struct quickspi_device;
 
 void quickspi_handle_input_data(struct quickspi_device *qsdev, u32 buf_len);
 int quickspi_get_report(struct quickspi_device *qsdev, u8 report_type,
-			unsigned int report_id, void *buf);
+			unsigned int report_id, void *buf, u32 buf_len);
 int quickspi_set_report(struct quickspi_device *qsdev, u8 report_type,
 			unsigned int report_id, void *buf, u32 buf_len);
 int quickspi_get_report_descriptor(struct quickspi_device *qsdev);


