Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36AD3B9930;
	Tue, 21 Jul 2026 21:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670408; cv=none; b=QWJFLe8LL8a44xOTA6vQC2oirS4ZhNnwhAL6AYsGRm0z08v6gD7yd6sU5hdLHvH/DTET9iQYb2FB8A4AmeMcJ9fVccYx5KLiw6pkKWdY2tVDKk3lTggHjUmtzBihpM1Nc72uTsGxKDWG+cqZIBsYloN9QdsNF6G54XblnPG7Ntk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670408; c=relaxed/simple;
	bh=yqPOlr67qvX9ohEky5LYbAVOSowO6GY1KHGWeirnGfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PuwjPSXqtY5XYUeayeEhU4/5DeMmcfbhl9CgFXFxKpUeEz4eMsBB6BpeDrnwTVqLh3qDcdX8F0EQwf43+RbMfGDWrnSKQxHY4gFHdtNK6G29AvgjM/rsWlP0yaPJUFCmFh9nrGuw/oMiIQoHN927/oCJylAsVmhDCiMZwlPz5Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KeziK+ig; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KeziK+ig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4CDC1F000E9;
	Tue, 21 Jul 2026 21:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670407;
	bh=+dMjJRmXebUrAkaQihuMSqvMsdsg+bSoheG7PnqCF8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KeziK+ig10N5so5Ohyx/dDN9VXIQDIyNrORGyrAru0sppM5fUwYTcuG/QrV9AWL3I
	 OgR9tJFDnsm/QfY6FKlsTVuCSiRO0HfcJbAJKI7NYyJkwsb1RV1jwichVa7oG2L4xt
	 uRg8ds426iODQee9Mllh+3Ylm/dRnHovdeZQCFeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhishek Ojha <Abhishek.ojha@savoirfairelinux.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 0920/1067] regulator: ltc3676: Fix incorrect IRQSTAT bit offsets
Date: Tue, 21 Jul 2026 17:25:21 +0200
Message-ID: <20260721152445.114520901@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhishek Ojha <Abhishek.ojha@savoirfairelinux.com>

commit 50dce2e2f84b56d8b4b406d97a1543709e8a87f5 upstream.

The LTC3676_IRQSTAT_* bit definitions do not match the IRQSTAT
(Interrupt Request Status) register layout documented in Table 15
of the LTC3676/LTC3676-1 datasheet:

  bit 0 - Pushbutton Status Active
  bit 1 - Hard Reset Occurred
  bit 2 - PGOOD Timeout Occurred
  bit 3 - Undervoltage Warning
  bit 4 - Undervoltage Standby (Fault) Occurred
  bit 5 - Overtemperature Warning
  bit 6 - Overtemperature Standby (Fault) Occurred
  bit 7 - Reserved

The driver instead defines these starting at bit 3, one bit higher
than the datasheet specifies, which causes ltc3676_regulator_isr()
to check the wrong status bits and misreport (or miss) PGOOD
timeout, undervoltage and thermal warning/fault conditions.

Fix the bit offsets to match the datasheet.

Fixes: 37b918a034fe ("regulator: Add LTC3676 support")
Cc: stable@vger.kernel.org
Signed-off-by: Abhishek Ojha <Abhishek.ojha@savoirfairelinux.com>
Link: https://patch.msgid.link/20260715170408.295552-1-Abhishek.ojha@savoirfairelinux.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/ltc3676.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/regulator/ltc3676.c
+++ b/drivers/regulator/ltc3676.c
@@ -45,11 +45,11 @@
 #define LTC3676_DVBxA_REF_SELECT	BIT(5)
 #define LTC3676_DVBxB_PGOOD_MASK	BIT(5)
 
-#define LTC3676_IRQSTAT_PGOOD_TIMEOUT	BIT(3)
-#define LTC3676_IRQSTAT_UNDERVOLT_WARN	BIT(4)
-#define LTC3676_IRQSTAT_UNDERVOLT_FAULT	BIT(5)
-#define LTC3676_IRQSTAT_THERMAL_WARN	BIT(6)
-#define LTC3676_IRQSTAT_THERMAL_FAULT	BIT(7)
+#define LTC3676_IRQSTAT_PGOOD_TIMEOUT	BIT(2)
+#define LTC3676_IRQSTAT_UNDERVOLT_WARN	BIT(3)
+#define LTC3676_IRQSTAT_UNDERVOLT_FAULT	BIT(4)
+#define LTC3676_IRQSTAT_THERMAL_WARN	BIT(5)
+#define LTC3676_IRQSTAT_THERMAL_FAULT	BIT(6)
 
 enum ltc3676_reg {
 	LTC3676_SW1,


