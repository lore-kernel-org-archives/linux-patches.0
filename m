Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947C937F756;
	Thu, 20 Aug 2026 15:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238795; cv=none; b=buH+oXI5B1Dd4UFg5bap18nMEoFV0bM55MKFu42gM2EY5DHx1Vlto25NRDo9E0jVQAkRXej3+BZZz2b2xBRN4l6zozV1Kgz21s/QbRN+jFNr0m5wrglvaSpe9+4hQNc7/0IQQPXzHo4tI08bgzTJ/N178PpEFGBL3Y/eBbIXico=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238795; c=relaxed/simple;
	bh=gn86UBy/QITJm66Rurj8e+d+HPthF9lMeRMzLyqdCZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4tmQa1fUYcqLGAFn9VjyaoyBqTA/+Zh9/kGUfrxasIJo1577doTyoXs0NyLwcqBO19Fci7dYys/lVlhxWQJArAW8/AIP0RUz/vRr7hjGK6TVt9+OqxqjLKEjVh8iljKoUnVkcBplNHGFwCeSRLZ7wG6Yncl31pcFq5xUBucNkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hjr6yx+v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hjr6yx+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A111F000E9;
	Thu, 20 Aug 2026 15:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238793;
	bh=LX0LNavKWUhODN9Z0fQU12+GaIL63GED1s0papjHvp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hjr6yx+vbqVdppSKe0uHMcrlIz+Xt797LTul289wHoNaTBzNccJ/6CLqGOqhp3ls6
	 F/F7dq3TFy3UlZOC8YPvFsRnW/BTKcI5bnC2GidG4PEuPPTtZaib77eZ5hKdv9tFso
	 BxZaXI2KxV4SdTdAe7Qh2j1R2Sy3g8HUWAwE9mFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 044/217] Input: synaptics-rmi4 - bound the F54 report size to the allocated buffer
Date: Thu, 20 Aug 2026 16:53:32 +0200
Message-ID: <20260820145238.949453599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 49c5adc2b7d6e43c5cf033e1c86fdb9c16ababb1 upstream.

rmi_f54_work() reads a diagnostics report from the device into
f54->report_data, sizing the transfer with rmi_f54_get_report_size():

	report_size = rmi_f54_get_report_size(f54);
	...
	for (i = 0; i < report_size; i += F54_REPORT_DATA_SIZE) {
		int size = min(F54_REPORT_DATA_SIZE, report_size - i);
		...
		rmi_read_block(.., f54->report_data + i, size);
	}

report_data is allocated once at probe from F54's own electrode counts
(array3_size(f54->num_tx_electrodes, f54->num_rx_electrodes, sizeof(u16))),
but rmi_f54_get_report_size() computes the size from
drv_data->num_*_electrodes when those are set, i.e. from the F55
function's electrode counts. Both counts come straight from device
queries (F54 and F55 each report up to 255 electrodes) and nothing
constrains the F55 counts to the F54 ones.

A malicious or malfunctioning RMI4 device that reports larger F55
electrode counts than its F54 counts makes report_size exceed the
allocation, so the read loop writes past report_data (and the V4L2
dequeue memcpy() then reads past it). On conforming hardware the F55
configured electrodes are a subset of the F54 physical electrodes, so
report_size never exceeds the buffer and well-behaved devices are
unaffected.

Record the allocation size and reject a report that does not fit,
mirroring the existing zero-size check.

Fixes: c762cc68b6a1 ("Input: synaptics-rmi4 - propagate correct number of rx and tx electrodes to F54")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Assisted-by: Antigravity:gemini-3.5-flash
Link: https://patch.msgid.link/20260626051802.4033172-3-dmitry.torokhov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/rmi4/rmi_f54.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/input/rmi4/rmi_f54.c
+++ b/drivers/input/rmi4/rmi_f54.c
@@ -104,6 +104,7 @@ struct f54_data {
 
 	enum rmi_f54_report_type report_type;
 	u8 *report_data;
+	size_t max_report_size;
 	int report_size;
 
 	bool is_busy;
@@ -548,6 +549,13 @@ static void rmi_f54_work(struct work_str
 		goto out;     /* retry won't help */
 	}
 
+	if (report_size > f54->max_report_size) {
+		dev_err(&fn->dev, "Report size %d exceeds buffer size %zu\n",
+			report_size, f54->max_report_size);
+		error = -EINVAL;
+		goto out;
+	}
+
 	/*
 	 * Need to check if command has completed.
 	 * If not try again later.
@@ -678,8 +686,8 @@ static int rmi_f54_probe(struct rmi_func
 
 	rx = f54->num_rx_electrodes;
 	tx = f54->num_tx_electrodes;
-	f54->report_data = devm_kzalloc(&fn->dev,
-					array3_size(tx, rx, sizeof(u16)),
+	f54->max_report_size = array3_size(tx, rx, sizeof(u16));
+	f54->report_data = devm_kzalloc(&fn->dev, f54->max_report_size,
 					GFP_KERNEL);
 	if (f54->report_data == NULL)
 		return -ENOMEM;


