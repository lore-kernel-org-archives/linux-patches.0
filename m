Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1D13033C4;
	Wed, 28 Jan 2026 15:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615597; cv=none; b=AOoPvIueVSnSZrUsf6CZlzeNeByE45+elY3Z7cNXpS0cpBTZDFIuWqZdG8urLXXuuuDVaWKE704kErYKSkPT1jbPTZ6YRV3qrTX58kMg+z3peP9Pw3lcRbY5BuHDqUAGXSxGNaqDbzv/kEbdyjkprD+xou/BSb7awB8+a/ilPb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615597; c=relaxed/simple;
	bh=NuVUMhzwOazzLJIrQomvGYzzUN9fE/ixREc6b5R3jhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YugRIXtvjmtW/vIAw+ud9O076v3DAFbqSQQ8yMVntJx80ZL4BSmiKEhjmAYy+mNSn6ZWQ4Ui1Y8zUNNBzEEvHPWZ3uBwoTOxb0HLSGp5Iit8Lf74F+8gO5gmKESJGOQG8gCegpa+vph8x3ImI0wnfpX44B+qGMNJaRJExI+B8TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RaPTbEWu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RaPTbEWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4E0C4CEF1;
	Wed, 28 Jan 2026 15:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615597;
	bh=NuVUMhzwOazzLJIrQomvGYzzUN9fE/ixREc6b5R3jhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RaPTbEWuM9QfHLGU+bnz1+88nb4xdOez9r/rCGZLywo7lLm84WIG6EAq1ML9uZfdx
	 OE/SxkzYBltIMJBFEGAlvwIfYJQ0lrw3l/fi7GtMJlF2UWAj89kY2WJAw5WjXRxyJT
	 b66uGt2qojJuH8bp9iv6ZDuE8Qn+f1CZETR7LNLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	feng <alec.jiang@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 056/227] Input: i8042 - add quirk for ASUS Zenbook UX425QA_UM425QA
Date: Wed, 28 Jan 2026 16:21:41 +0100
Message-ID: <20260128145346.357295772@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: feng <alec.jiang@gmail.com>

commit 2934325f56150ad8dab8ab92cbe2997242831396 upstream.

The ASUS Zenbook UX425QA_UM425QA fails to initialize the keyboard after
a cold boot.

A quirk already exists for "ZenBook UX425", but some Zenbooks report
"Zenbook" with a lowercase 'b'. Since DMI matching is case-sensitive,
the existing quirk is not applied to these "extra special" Zenbooks.

Testing confirms that this model needs the same quirks as the ZenBook
UX425 variants.

Signed-off-by: feng <alec.jiang@gmail.com>
Link: https://patch.msgid.link/20260122013957.11184-1-alec.jiang@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -116,6 +116,17 @@ static const struct dmi_system_id i8042_
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_NEVER)
 	},
 	{
+		/*
+		 * ASUS Zenbook UX425QA_UM425QA
+		 * Some Zenbooks report "Zenbook" with a lowercase b.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Zenbook UX425QA_UM425QA"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_PROBE_DEFER | SERIO_QUIRK_RESET_NEVER)
+	},
+	{
 		/* ASUS ZenBook UX425UA/QA */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),


