Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88248368957;
	Fri,  4 Sep 2026 05:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500797; cv=none; b=t3FfUjSB4Sy9Uzb148IT3QPtCjI5KW2o0FEWvyPv83ysL38dsQ9VMwT5YeT9pqGYNxnhJmR48ic/QyFUFH1Xo0im2dEgARqwS/4AIzQvvzVvNxCVVh7neCrR70facS1C8zqMfIi/0bpcgnWhq0zXyJGNQ3X9ZfrCnUcXMStTTmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500797; c=relaxed/simple;
	bh=ndl3WwGarCbPdfuvnqmh9xxXEIOnMlDLKVhK3RZkRdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQcrRxsc1IkOkLlX16BPZzKT4aXFmWQW4itfimz9dTpIAyn5DBn2rhqM1rQu+JUkKjzEUUSdpSwrTVFdFbYxqsZqqbAMXvOr/Htb+TXriyV3y1wyFImNf1iQZ9gxkouQLJocnAzydnXhJ0VFXq5q9b4haSRT9Erz/ea5qr3VFAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=int2Gf/9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="int2Gf/9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D99AE1F00A3D;
	Fri,  4 Sep 2026 05:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500796;
	bh=RnzdcffZDmfMiM7zVckJRbOYAZkpLDOTNuwqimiG6d0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=int2Gf/9tI6JaGDcbPcoysDkj4anyKtSDdffPMeAUBtNIO2YAXJ6gmNYxw5flzfGL
	 Hi039vdgOtjdvNhiCvfRFfT3tKI1hEWMElFB6MMdVviCMW/rFALw4h88gZfq80yFZ1
	 1KkMzflyKnA9B5L1xb8Fm4IOY/4gHvORH2IqqBNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Even Xu <even.xu@intel.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 183/552] HID: intel-thc-hid: intel-quickspi: validate report size before copy
Date: Fri,  4 Sep 2026 06:55:40 +0200
Message-ID: <20260904045753.167336503@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

commit a59cf84441f9a17323c89452cec2bf16724c48a9 upstream.

write_cmd_to_txdma() builds an output report in qsdev->report_buf, a heap
buffer allocated in quickspi_alloc_report_buf() to the device-descriptor
derived max_report_len (a few hundred bytes for a touch controller).  It
copies the caller-supplied report into that buffer:

    memcpy(write_buf->content, report_buf, report_buf_len);

The HID core caps a report at HID_MAX_BUFFER_SIZE (16384) by default, and
quickspi_hid_ll_driver does not set max_buffer_size, so the length reaches
the driver unbounded.  A hidraw SET_REPORT/SET_FEATURE ioctl carrying a
report larger than max_report_len therefore overflows report_buf with
attacker-controlled length and content.

Record the report_buf allocation size and reject reports that do not fit
before copying, matching the equivalent guard in the intel-quicki2c
sibling (quicki2c_init_write_buf()) and the hid-goodix-spi fix.

write_cmd_to_txdma() writes the output report header ahead of the content
in the same buffer, so size the allocation to cover the header as well.
That keeps the added bound from rejecting a maximum-sized report.

Fixes: 9d8d51735a3a ("HID: intel-thc-hid: intel-quickspi: Add HIDSPI protocol implementation")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Even Xu <even.xu@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c      |    9 ++++++++-
 drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h      |    1 +
 drivers/hid/intel-thc-hid/intel-quickspi/quickspi-protocol.c |    3 +++
 3 files changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c
+++ b/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c
@@ -556,7 +556,14 @@ static int quickspi_alloc_report_buf(str
 	max_report_len = max(le16_to_cpu(qsdev->dev_desc.max_output_len),
 			     le16_to_cpu(qsdev->dev_desc.max_input_len));
 
-	qsdev->report_buf = devm_kzalloc(qsdev->dev, max_report_len, GFP_KERNEL);
+	/*
+	 * write_cmd_to_txdma() writes the output report header ahead of the
+	 * content in this buffer, so it has to hold both.
+	 */
+	qsdev->report_buf_size = HIDSPI_OUTPUT_REPORT_SIZE(max_report_len);
+
+	qsdev->report_buf = devm_kzalloc(qsdev->dev, qsdev->report_buf_size,
+					 GFP_KERNEL);
 	if (!qsdev->report_buf)
 		return -ENOMEM;
 
--- a/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h
+++ b/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h
@@ -157,6 +157,7 @@ struct quickspi_device {
 	u8 *report_descriptor;
 	u8 *input_buf;
 	u8 *report_buf;
+	u32 report_buf_size;
 	u32 report_len;
 
 	wait_queue_head_t reset_ack_wq;
--- a/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-protocol.c
+++ b/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-protocol.c
@@ -30,6 +30,9 @@ static int write_cmd_to_txdma(struct qui
 
 	write_buf = (struct output_report *)qsdev->report_buf;
 
+	if (HIDSPI_OUTPUT_REPORT_SIZE(report_buf_len) > qsdev->report_buf_size)
+		return -EINVAL;
+
 	write_buf->output_hdr.report_type = report_type;
 	write_buf->output_hdr.content_len = cpu_to_le16(report_buf_len);
 	write_buf->output_hdr.content_id = report_id;


