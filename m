Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119BB18DF83;
	Mon, 28 Oct 2024 06:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098406; cv=none; b=QmH3bNdnvNeJOR7ohT1wDAlyjJsiJhZb9ha3CR3Za6XFrb4MAoCkYfWMaL+zZpIbxMHh1MjDHzOzsfQaQLqD7b5yioWbfeyFhYLWVXWoV6TYXgPg3C8IRFYzdqt6pW6zL/ok61+4aLbpphji5yCzqcuQsyI27tVJAKcpTrXvnEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098406; c=relaxed/simple;
	bh=G9iPOGLyjSNxqzPk368QsFPYAGHtOLMbOf9EyNYCaH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5rVu2vMrfcHQf6bdNg5pXDEnRnmDReOns+/0WGYr/59xpudvx2vGTb7EoP/qDb2bplu0idE+gknhR0wo2YUR4E6yDPvqKd7kqe+1/Q8sH6QV39vuDiL1qqB2ODSYchI1iGYcpsR6S1wzGeM0AIfFAGmiwS69iU4r+QO3ct/DHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AeRVB5w5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AeRVB5w5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58A4C4CEC3;
	Mon, 28 Oct 2024 06:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098405;
	bh=G9iPOGLyjSNxqzPk368QsFPYAGHtOLMbOf9EyNYCaH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AeRVB5w5/0N40ZV/PV18KPNY8NRP4J0Jb94mi/oqVgfOcp9U0FAa58SPFAOYj7uSr
	 h0x33b7JOKnvPjZNP/rL1NbElPDUeDEkRYcRo6vOYLvv3OeVw3+TPdSIuO4tAaVCIY
	 hJ6OZ55QhdobxXmhnZWuee2l7kr9Jsqy+ZLKkAhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Yang <me@shenghaoyang.info>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 177/261] net: dsa: mv88e6xxx: group cycle counter coefficients
Date: Mon, 28 Oct 2024 07:25:19 +0100
Message-ID: <20241028062316.442073293@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shenghao Yang <me@shenghaoyang.info>

[ Upstream commit 67af86afff74c914944374a103c04e4d9868dd15 ]

Instead of having them as individual fields in ptp_ops, wrap the
coefficients in a separate struct so they can be referenced together.

Fixes: de776d0d316f ("net: dsa: mv88e6xxx: add support for mv88e6393x family")
Signed-off-by: Shenghao Yang <me@shenghaoyang.info>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.h |  6 ++--
 drivers/net/dsa/mv88e6xxx/ptp.c  | 59 ++++++++++++++++----------------
 2 files changed, 32 insertions(+), 33 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index c34caf9815c5c..1d003a9deafa7 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -206,6 +206,7 @@ struct mv88e6xxx_gpio_ops;
 struct mv88e6xxx_avb_ops;
 struct mv88e6xxx_ptp_ops;
 struct mv88e6xxx_pcs_ops;
+struct mv88e6xxx_cc_coeffs;
 
 struct mv88e6xxx_irq {
 	u16 masked;
@@ -731,10 +732,7 @@ struct mv88e6xxx_ptp_ops {
 	int arr1_sts_reg;
 	int dep_sts_reg;
 	u32 rx_filters;
-	u32 cc_shift;
-	u32 cc_mult;
-	u32 cc_mult_num;
-	u32 cc_mult_dem;
+	const struct mv88e6xxx_cc_coeffs *cc_coeffs;
 };
 
 struct mv88e6xxx_pcs_ops {
diff --git a/drivers/net/dsa/mv88e6xxx/ptp.c b/drivers/net/dsa/mv88e6xxx/ptp.c
index 56391e09b3257..641af44e00af9 100644
--- a/drivers/net/dsa/mv88e6xxx/ptp.c
+++ b/drivers/net/dsa/mv88e6xxx/ptp.c
@@ -18,6 +18,13 @@
 
 #define MV88E6XXX_MAX_ADJ_PPB	1000000
 
+struct mv88e6xxx_cc_coeffs {
+	u32 cc_shift;
+	u32 cc_mult;
+	u32 cc_mult_num;
+	u32 cc_mult_dem;
+};
+
 /* Family MV88E6250:
  * Raw timestamps are in units of 10-ns clock periods.
  *
@@ -25,10 +32,13 @@
  * simplifies to
  * clkadj = scaled_ppm * 2^7 / 5^5
  */
-#define MV88E6250_CC_SHIFT	28
-#define MV88E6250_CC_MULT	(10 << MV88E6250_CC_SHIFT)
-#define MV88E6250_CC_MULT_NUM	(1 << 7)
-#define MV88E6250_CC_MULT_DEM	3125ULL
+#define MV88E6250_CC_SHIFT 28
+static const struct mv88e6xxx_cc_coeffs mv88e6250_cc_coeffs = {
+	.cc_shift = MV88E6250_CC_SHIFT,
+	.cc_mult = 10 << MV88E6250_CC_SHIFT,
+	.cc_mult_num = 1 << 7,
+	.cc_mult_dem = 3125ULL,
+};
 
 /* Other families:
  * Raw timestamps are in units of 8-ns clock periods.
@@ -37,10 +47,13 @@
  * simplifies to
  * clkadj = scaled_ppm * 2^9 / 5^6
  */
-#define MV88E6XXX_CC_SHIFT	28
-#define MV88E6XXX_CC_MULT	(8 << MV88E6XXX_CC_SHIFT)
-#define MV88E6XXX_CC_MULT_NUM	(1 << 9)
-#define MV88E6XXX_CC_MULT_DEM	15625ULL
+#define MV88E6XXX_CC_SHIFT 28
+static const struct mv88e6xxx_cc_coeffs mv88e6xxx_cc_coeffs = {
+	.cc_shift = MV88E6XXX_CC_SHIFT,
+	.cc_mult = 8 << MV88E6XXX_CC_SHIFT,
+	.cc_mult_num = 1 << 9,
+	.cc_mult_dem = 15625ULL
+};
 
 #define TAI_EVENT_WORK_INTERVAL msecs_to_jiffies(100)
 
@@ -214,10 +227,10 @@ static int mv88e6xxx_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 		scaled_ppm = -scaled_ppm;
 	}
 
-	mult = ptp_ops->cc_mult;
-	adj = ptp_ops->cc_mult_num;
+	mult = ptp_ops->cc_coeffs->cc_mult;
+	adj = ptp_ops->cc_coeffs->cc_mult_num;
 	adj *= scaled_ppm;
-	diff = div_u64(adj, ptp_ops->cc_mult_dem);
+	diff = div_u64(adj, ptp_ops->cc_coeffs->cc_mult_dem);
 
 	mv88e6xxx_reg_lock(chip);
 
@@ -364,10 +377,7 @@ const struct mv88e6xxx_ptp_ops mv88e6165_ptp_ops = {
 		(1 << HWTSTAMP_FILTER_PTP_V2_EVENT) |
 		(1 << HWTSTAMP_FILTER_PTP_V2_SYNC) |
 		(1 << HWTSTAMP_FILTER_PTP_V2_DELAY_REQ),
-	.cc_shift = MV88E6XXX_CC_SHIFT,
-	.cc_mult = MV88E6XXX_CC_MULT,
-	.cc_mult_num = MV88E6XXX_CC_MULT_NUM,
-	.cc_mult_dem = MV88E6XXX_CC_MULT_DEM,
+	.cc_coeffs = &mv88e6xxx_cc_coeffs
 };
 
 const struct mv88e6xxx_ptp_ops mv88e6250_ptp_ops = {
@@ -391,10 +401,7 @@ const struct mv88e6xxx_ptp_ops mv88e6250_ptp_ops = {
 		(1 << HWTSTAMP_FILTER_PTP_V2_EVENT) |
 		(1 << HWTSTAMP_FILTER_PTP_V2_SYNC) |
 		(1 << HWTSTAMP_FILTER_PTP_V2_DELAY_REQ),
-	.cc_shift = MV88E6250_CC_SHIFT,
-	.cc_mult = MV88E6250_CC_MULT,
-	.cc_mult_num = MV88E6250_CC_MULT_NUM,
-	.cc_mult_dem = MV88E6250_CC_MULT_DEM,
+	.cc_coeffs = &mv88e6250_cc_coeffs,
 };
 
 const struct mv88e6xxx_ptp_ops mv88e6352_ptp_ops = {
@@ -418,10 +425,7 @@ const struct mv88e6xxx_ptp_ops mv88e6352_ptp_ops = {
 		(1 << HWTSTAMP_FILTER_PTP_V2_EVENT) |
 		(1 << HWTSTAMP_FILTER_PTP_V2_SYNC) |
 		(1 << HWTSTAMP_FILTER_PTP_V2_DELAY_REQ),
-	.cc_shift = MV88E6XXX_CC_SHIFT,
-	.cc_mult = MV88E6XXX_CC_MULT,
-	.cc_mult_num = MV88E6XXX_CC_MULT_NUM,
-	.cc_mult_dem = MV88E6XXX_CC_MULT_DEM,
+	.cc_coeffs = &mv88e6xxx_cc_coeffs,
 };
 
 const struct mv88e6xxx_ptp_ops mv88e6390_ptp_ops = {
@@ -446,10 +450,7 @@ const struct mv88e6xxx_ptp_ops mv88e6390_ptp_ops = {
 		(1 << HWTSTAMP_FILTER_PTP_V2_EVENT) |
 		(1 << HWTSTAMP_FILTER_PTP_V2_SYNC) |
 		(1 << HWTSTAMP_FILTER_PTP_V2_DELAY_REQ),
-	.cc_shift = MV88E6XXX_CC_SHIFT,
-	.cc_mult = MV88E6XXX_CC_MULT,
-	.cc_mult_num = MV88E6XXX_CC_MULT_NUM,
-	.cc_mult_dem = MV88E6XXX_CC_MULT_DEM,
+	.cc_coeffs = &mv88e6xxx_cc_coeffs,
 };
 
 static u64 mv88e6xxx_ptp_clock_read(const struct cyclecounter *cc)
@@ -487,8 +488,8 @@ int mv88e6xxx_ptp_setup(struct mv88e6xxx_chip *chip)
 	memset(&chip->tstamp_cc, 0, sizeof(chip->tstamp_cc));
 	chip->tstamp_cc.read	= mv88e6xxx_ptp_clock_read;
 	chip->tstamp_cc.mask	= CYCLECOUNTER_MASK(32);
-	chip->tstamp_cc.mult	= ptp_ops->cc_mult;
-	chip->tstamp_cc.shift	= ptp_ops->cc_shift;
+	chip->tstamp_cc.mult	= ptp_ops->cc_coeffs->cc_mult;
+	chip->tstamp_cc.shift	= ptp_ops->cc_coeffs->cc_shift;
 
 	timecounter_init(&chip->tstamp_tc, &chip->tstamp_cc,
 			 ktime_to_ns(ktime_get_real()));
-- 
2.43.0



