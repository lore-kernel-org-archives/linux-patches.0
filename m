Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24790FC06;
	Mon, 11 Dec 2023 18:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yjaGcCyn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7ECC433C7;
	Mon, 11 Dec 2023 18:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319906;
	bh=BlvVO5cHSXQGBAQcGG+DGrO6On0lkAgMXUb+GIC2oGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yjaGcCynHVTxk5D8oYWknPvuDfKBF59FN2ayVHgxepWeX5JWASHCVt404vQ0/F0+u
	 Rsr+5/rk1Jijvtf0gzt99FibM5UDTTGByaMnqrW0z38IM+c+wnHpzn+HMTUVCn+kK3
	 RuHPHI25TyEbG/EcNWD41E4T5vEt7ja5XwXWPbOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Khalil Blaiech <kblaiech@nvidia.com>,
	David Thompson <davthompson@nvidia.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 24/97] mlxbf-bootctl: correctly identify secure boot with development keys
Date: Mon, 11 Dec 2023 19:21:27 +0100
Message-ID: <20231211182020.801508007@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182019.802717483@linuxfoundation.org>
References: <20231211182019.802717483@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Thompson <davthompson@nvidia.com>

[ Upstream commit d4eef75279f5e9d594f5785502038c763ce42268 ]

The secure boot state of the BlueField SoC is represented by two bits:
                0 = production state
                1 = secure boot enabled
                2 = non-secure (secure boot disabled)
                3 = RMA state
There is also a single bit to indicate whether production keys or
development keys are being used when secure boot is enabled.
This single bit (specified by MLXBF_BOOTCTL_SB_DEV_MASK) only has
meaning if secure boot state equals 1 (secure boot enabled).

The secure boot states are as follows:
- “GA secured” is when secure boot is enabled with official production keys.
- “Secured (development)” is when secure boot is enabled with development keys.

Without this fix “GA Secured” is displayed on development cards which is
misleading. This patch updates the logic in "lifecycle_state_show()" to
handle the case where the SoC is configured for secure boot and is using
development keys.

Fixes: 79e29cb8fbc5c ("platform/mellanox: Add bootctl driver for Mellanox BlueField Soc")
Reviewed-by: Khalil Blaiech <kblaiech@nvidia.com>
Signed-off-by: David Thompson <davthompson@nvidia.com>
Link: https://lore.kernel.org/r/20231130183515.17214-1-davthompson@nvidia.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxbf-bootctl.c | 39 +++++++++++++++--------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/platform/mellanox/mlxbf-bootctl.c b/drivers/platform/mellanox/mlxbf-bootctl.c
index 5d21c6adf1ab6..9911d4f854696 100644
--- a/drivers/platform/mellanox/mlxbf-bootctl.c
+++ b/drivers/platform/mellanox/mlxbf-bootctl.c
@@ -17,6 +17,7 @@
 
 #define MLXBF_BOOTCTL_SB_SECURE_MASK		0x03
 #define MLXBF_BOOTCTL_SB_TEST_MASK		0x0c
+#define MLXBF_BOOTCTL_SB_DEV_MASK		BIT(4)
 
 #define MLXBF_SB_KEY_NUM			4
 
@@ -37,11 +38,18 @@ static struct mlxbf_bootctl_name boot_names[] = {
 	{ MLXBF_BOOTCTL_NONE, "none" },
 };
 
+enum {
+	MLXBF_BOOTCTL_SB_LIFECYCLE_PRODUCTION = 0,
+	MLXBF_BOOTCTL_SB_LIFECYCLE_GA_SECURE = 1,
+	MLXBF_BOOTCTL_SB_LIFECYCLE_GA_NON_SECURE = 2,
+	MLXBF_BOOTCTL_SB_LIFECYCLE_RMA = 3
+};
+
 static const char * const mlxbf_bootctl_lifecycle_states[] = {
-	[0] = "Production",
-	[1] = "GA Secured",
-	[2] = "GA Non-Secured",
-	[3] = "RMA",
+	[MLXBF_BOOTCTL_SB_LIFECYCLE_PRODUCTION] = "Production",
+	[MLXBF_BOOTCTL_SB_LIFECYCLE_GA_SECURE] = "GA Secured",
+	[MLXBF_BOOTCTL_SB_LIFECYCLE_GA_NON_SECURE] = "GA Non-Secured",
+	[MLXBF_BOOTCTL_SB_LIFECYCLE_RMA] = "RMA",
 };
 
 /* ARM SMC call which is atomic and no need for lock. */
@@ -165,25 +173,30 @@ static ssize_t second_reset_action_store(struct device *dev,
 static ssize_t lifecycle_state_show(struct device *dev,
 				    struct device_attribute *attr, char *buf)
 {
+	int status_bits;
+	int use_dev_key;
+	int test_state;
 	int lc_state;
 
-	lc_state = mlxbf_bootctl_smc(MLXBF_BOOTCTL_GET_TBB_FUSE_STATUS,
-				     MLXBF_BOOTCTL_FUSE_STATUS_LIFECYCLE);
-	if (lc_state < 0)
-		return lc_state;
+	status_bits = mlxbf_bootctl_smc(MLXBF_BOOTCTL_GET_TBB_FUSE_STATUS,
+					MLXBF_BOOTCTL_FUSE_STATUS_LIFECYCLE);
+	if (status_bits < 0)
+		return status_bits;
 
-	lc_state &=
-		MLXBF_BOOTCTL_SB_TEST_MASK | MLXBF_BOOTCTL_SB_SECURE_MASK;
+	use_dev_key = status_bits & MLXBF_BOOTCTL_SB_DEV_MASK;
+	test_state = status_bits & MLXBF_BOOTCTL_SB_TEST_MASK;
+	lc_state = status_bits & MLXBF_BOOTCTL_SB_SECURE_MASK;
 
 	/*
 	 * If the test bits are set, we specify that the current state may be
 	 * due to using the test bits.
 	 */
-	if (lc_state & MLXBF_BOOTCTL_SB_TEST_MASK) {
-		lc_state &= MLXBF_BOOTCTL_SB_SECURE_MASK;
-
+	if (test_state) {
 		return sprintf(buf, "%s(test)\n",
 			       mlxbf_bootctl_lifecycle_states[lc_state]);
+	} else if (use_dev_key &&
+		   (lc_state == MLXBF_BOOTCTL_SB_LIFECYCLE_GA_SECURE)) {
+		return sprintf(buf, "Secured (development)\n");
 	}
 
 	return sprintf(buf, "%s\n", mlxbf_bootctl_lifecycle_states[lc_state]);
-- 
2.42.0



