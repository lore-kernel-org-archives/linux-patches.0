Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704B635C694;
	Tue, 21 Jul 2026 22:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672672; cv=none; b=TMoAlQTAMHpFNLgSeZFAMckjr54cfLOr4DAvWGdqWfUWm/uOMFmGbHahQo5OEbuVQI+abGRQujo78Hke6+B/FGb2nEh7js5XOdWGyCTwSak3qG6krb7xKSDlpq3Es1SQ5Z79hOC/hw8Mi2O0jeNLXjaEHpFLmtow5ObBvvmmPLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672672; c=relaxed/simple;
	bh=ZRZzhyrxmlRTyDAoIb+PQqfjNmkCnM2UY3ebNJmdv8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuE7+13PysTEzrpZjG2q/LgKzYOLnXVQYgEAw2yO2bo5eDAsdZdpmL9ejG2tTJfLee83kibytLIwRkTixrt9/kryk5XJf+qymadOBnRKX1KxXQv1XVBhxIoIHHUhdlO49EA0Crx6JarsD11Iw6tE75+z1tOs5WP1lYWJPmo8d14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DNjsxxU3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DNjsxxU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FB31F000E9;
	Tue, 21 Jul 2026 22:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672671;
	bh=0ZRn07z0fAHrYNIuR+t7k0A1kmGSRY3hwC6nM48ppAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DNjsxxU3TxnMNpAUAjW9lQ5xkjb4D5P8E36oHI6FlfPRaL0E663e0IpeddvVf8nB9
	 Xo4TIwfG0qOk2AZS3LXanD2+jA+PNPsZltr8C+7KjXfb8aWyL+B2sc9scMcFTSd9t6
	 u4rYlKkPoStJ9O/gFPHpB2u5l8S/isre3TGxNYxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhishek Ojha <Abhishek.ojha@savoirfairelinux.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 712/843] regulator: ltc3676: Fix incorrect IRQSTAT bit offsets
Date: Tue, 21 Jul 2026 17:25:47 +0200
Message-ID: <20260721152422.066403072@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


