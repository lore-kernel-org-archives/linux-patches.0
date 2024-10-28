Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3741615B10D;
	Mon, 28 Oct 2024 06:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097824; cv=none; b=L6/uol4p/rC5eZSez33WoeAW2suNdy+52/qviyC2278BYjAxHgIcn/t8nTHbVQIlr1lZnAxi9nMyGNcuJGZD24CetSIQ0cTGheLkEl4a7RejE/wOishredYnc3VQ7n98E3cbeDxafttu9ZBKfsMvdLCm475xJ4f+mNddXY8Gr4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097824; c=relaxed/simple;
	bh=N1ITCPry7ETEQiqUWd1ZXfBqtIvCIN/xQwoHz9WMJXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XH+Vcy1G+laGTIQHmklGN3uyWco5o8ddsQ1wzlBLdp43xSeeEjJ+gQtkXFyzbzzi1t/dOnslKvnGmz+KMKhPB/CAnqybRhi2fT9+ReL6RDS8ysd8Dz9VoT+hc1HRYwyVj6kFSnOn0WjmABjoF6un0e6KoU7mbVf7MgnjcRkJOnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZG/IWK9G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZG/IWK9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC95EC4CEC3;
	Mon, 28 Oct 2024 06:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097824;
	bh=N1ITCPry7ETEQiqUWd1ZXfBqtIvCIN/xQwoHz9WMJXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZG/IWK9G3GjwHEyIwGgVP78kTBJaVq7BL2PVW6H/5zrm3ti7Hb0TQVr/zoqthA8Ho
	 25GESHhHWoalO3y8BSB+1FcRIkIPuL55zKF951u5myt/vgQGhTKBFsjwJmMO6eJCyk
	 rRUHaDxNNI7KWesykr62ItMNIiaa0zyUu4So2bOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Yang <me@shenghaoyang.info>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 163/208] net: dsa: mv88e6xxx: support 4000ps cycle counter period
Date: Mon, 28 Oct 2024 07:25:43 +0100
Message-ID: <20241028062310.643281527@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shenghao Yang <me@shenghaoyang.info>

[ Upstream commit 3e65ede526cf4f95636dbc835598d100c7668ab3 ]

The MV88E6393X family of devices can run its cycle counter off
an internal 250MHz clock instead of an external 125MHz one.

Add support for this cycle counter period by adding another set
of coefficients and lowering the periodic cycle counter read interval
to compensate for faster overflows at the increased frequency.

Otherwise, the PHC runs at 2x real time in userspace and cannot be
synchronized.

Fixes: de776d0d316f ("net: dsa: mv88e6xxx: add support for mv88e6393x family")
Signed-off-by: Shenghao Yang <me@shenghaoyang.info>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/ptp.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/ptp.c b/drivers/net/dsa/mv88e6xxx/ptp.c
index a62b4ce7ff61d..5980bb4ce43e0 100644
--- a/drivers/net/dsa/mv88e6xxx/ptp.c
+++ b/drivers/net/dsa/mv88e6xxx/ptp.c
@@ -40,7 +40,7 @@ static const struct mv88e6xxx_cc_coeffs mv88e6xxx_cc_10ns_coeffs = {
 	.cc_mult_dem = 3125ULL,
 };
 
-/* Other families:
+/* Other families except MV88E6393X in internal clock mode:
  * Raw timestamps are in units of 8-ns clock periods.
  *
  * clkadj = scaled_ppm * 8*2^28 / (10^6 * 2^16)
@@ -55,6 +55,21 @@ static const struct mv88e6xxx_cc_coeffs mv88e6xxx_cc_8ns_coeffs = {
 	.cc_mult_dem = 15625ULL
 };
 
+/* Family MV88E6393X using internal clock:
+ * Raw timestamps are in units of 4-ns clock periods.
+ *
+ * clkadj = scaled_ppm * 4*2^28 / (10^6 * 2^16)
+ * simplifies to
+ * clkadj = scaled_ppm * 2^8 / 5^6
+ */
+#define MV88E6XXX_CC_4NS_SHIFT 28
+static const struct mv88e6xxx_cc_coeffs mv88e6xxx_cc_4ns_coeffs = {
+	.cc_shift = MV88E6XXX_CC_4NS_SHIFT,
+	.cc_mult = 4 << MV88E6XXX_CC_4NS_SHIFT,
+	.cc_mult_num = 1 << 8,
+	.cc_mult_dem = 15625ULL
+};
+
 #define TAI_EVENT_WORK_INTERVAL msecs_to_jiffies(100)
 
 #define cc_to_chip(cc) container_of(cc, struct mv88e6xxx_chip, tstamp_cc)
@@ -110,6 +125,8 @@ mv88e6xxx_cc_coeff_get(struct mv88e6xxx_chip *chip)
 	}
 
 	switch (period_ps) {
+	case 4000:
+		return &mv88e6xxx_cc_4ns_coeffs;
 	case 8000:
 		return &mv88e6xxx_cc_8ns_coeffs;
 	case 10000:
@@ -479,10 +496,10 @@ static u64 mv88e6xxx_ptp_clock_read(const struct cyclecounter *cc)
 	return 0;
 }
 
-/* With a 125MHz input clock, the 32-bit timestamp counter overflows in ~34.3
+/* With a 250MHz input clock, the 32-bit timestamp counter overflows in ~17.2
  * seconds; this task forces periodic reads so that we don't miss any.
  */
-#define MV88E6XXX_TAI_OVERFLOW_PERIOD (HZ * 16)
+#define MV88E6XXX_TAI_OVERFLOW_PERIOD (HZ * 8)
 static void mv88e6xxx_ptp_overflow_check(struct work_struct *work)
 {
 	struct delayed_work *dw = to_delayed_work(work);
-- 
2.43.0



