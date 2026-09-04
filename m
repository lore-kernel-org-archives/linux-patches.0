Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A6723BD1B;
	Fri,  4 Sep 2026 05:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498988; cv=none; b=EjqIpSco5+LeIg53gCvLfyMbkr5RE2gGoBhzG5Fe9QPjHLk5VaoruyyzZLw6PlztlPcP+GFLaQ3UG/sjXUyGlsf/T5tjTyeVF4gimsXmNqXMmJy9R7yFWTadBPD7glASb62SEa3A/IREVK+TuFfIJK/gA3IVvqWrnWJ13puvMK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498988; c=relaxed/simple;
	bh=If3oMLq71ujtD1vP/hESoZ7LixiHZHnq+Yg9uyysrKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4T7hQrPSvDlqoCAg2N9ZADSTTtcCBX9eZsHNVr/IikvYG7ZmSeO9VB3EQ8QuF6qSdryw9AdVHwka/MtvGtsuTr4PecUEZg0eIbMIW5SV3w0ZZGROPSwtrBhKgO7XiEVbhZh9LtFUoVinj5ndoQP0NEYj6czABPgQofXXdTFH1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gzgHdWqK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gzgHdWqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E90AD1F00A3D;
	Fri,  4 Sep 2026 05:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498987;
	bh=6HfYYtdSmpFZOhOCCpwLbfhOGNuVAYq1d3F8wwTMQt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gzgHdWqKeYxXrUh8ijXs2+wrf0lR4jXpEa/z5N2FxWk7lFjbQ3vZ9zqqJEV7Iczp+
	 blkN9aBnpw7G2kSVGBs27pJeVkLtnapPvBeUgSM+YbVWCEAtpmJT7o7fbse9R1Qjpf
	 03b/+RhwHqPSjq2FvvC828bzsKV9elORke/CLtIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Even Xu <even.xu@intel.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.2 256/713] HID: intel-thc-hid: intel-quickspi: validate report size before copy
Date: Fri,  4 Sep 2026 06:53:44 +0200
Message-ID: <20260904045809.577216225@linuxfoundation.org>
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
@@ -555,7 +555,14 @@ static int quickspi_alloc_report_buf(str
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


