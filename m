Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF7F1885BE;
	Mon, 28 Oct 2024 06:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098410; cv=none; b=lIcKXSooLMCld5gVrdXNJrzuuTuFiKulxQVd+oXt3jzFz4Io9O3hmMZ+bGNoJOCcI3Es2Mu2avynF7h5q/YW190MNZiCjcVOOhPu04PRH3eWDyMC8Vn4wlvD7bgetoYfVHDLJzM+0R7xsOoQyPK11fY9bbT/pGKiwlmWipXVJH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098410; c=relaxed/simple;
	bh=jrqEiT4vJg3HEZzYxwJl3OArWjnk94i+aqfdJkQh7bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIqYJGNX1k2u30pd2DI8VpvQ1TkEn8RrUaawAegHIhN2Jo/cK+ASGnejNXh1Mg3uaXvazV1kIL+FdjqubLRv7QA8dZSiqAFIgckUHOWSAfjYXnbpWlgNhRW5jrXQ9RNsCrtzbaiGWQy65w24vsSR+aD7NfNI+lhXqausR6Ej0L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y1Gu/+6J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y1Gu/+6J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C175C4CEC3;
	Mon, 28 Oct 2024 06:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098410;
	bh=jrqEiT4vJg3HEZzYxwJl3OArWjnk94i+aqfdJkQh7bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y1Gu/+6JTNqCrLrFAbGKtJwazyjniagNuvRTO9RA4dHE+bCLeMUxPLANWDEI9LKAB
	 KHWX3PBpnSOTV2OhvpwYhYRBFGmCM/Lbatt/zw5qn5Z8mo++GvmxjXuYa/9B0IcWIC
	 DBgalkvxkKjNVJmxoxQ5LqOYRUfWQf7LhwSReBN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Yang <me@shenghaoyang.info>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 179/261] net: dsa: mv88e6xxx: support 4000ps cycle counter period
Date: Mon, 28 Oct 2024 07:25:21 +0100
Message-ID: <20241028062316.492501565@linuxfoundation.org>
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
index a409b8661fadd..aed4a4b07f34b 100644
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
@@ -483,10 +500,10 @@ static u64 mv88e6xxx_ptp_clock_read(const struct cyclecounter *cc)
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



