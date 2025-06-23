Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77E521FF2B;
	Mon, 23 Jun 2025 22:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716174; cv=none; b=OfLQZIGeFlvIr433/YT0z1XUdwp5M+AXEA3MOnQSdxkfmnd/s1Bni8IHJLuqtIv7o7oEHmu8Qd/0dpQo9Zc9+abTpmj6qH54CQYfO/+5ClQhvnm1ylZtfPzdZgc39ztRZQTa0PuQ36MvC4HKmlpDdr2ZWDx0jHijB1VdWr87cVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716174; c=relaxed/simple;
	bh=+NBxTrCiWIIKjoAa/O0e/wEBp8BdVT5C89z5Xci66tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDv1eQSZQoM/0NR0z9iY3CI/yztgCvVNCxbf9Kn6xAqcoaMbajcxx0O2oAwbk/srtaclVnCWfv75KcHMDjrJUqR1HnViwx0bqKdbiIHSJ+hr0J8jnX9Cc877r3ueEg+mlm3ImbtSheLvYE3dMEl8rkBPLPbtbShXLpFjqQ3EFQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kSFxA80K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kSFxA80K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA729C4CEEA;
	Mon, 23 Jun 2025 22:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716174;
	bh=+NBxTrCiWIIKjoAa/O0e/wEBp8BdVT5C89z5Xci66tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kSFxA80Khbf/DnxUPEfqkeF7Vv+fwrbMS+jEVq6FJKUfjlZnf9r/Mo3QR1yJD67Fa
	 mWYbep8UuD6um32CySo9pBpgoTc5plWxzRrhZthOvVhC9mOAFXM/YyHrHYSCzjl4kS
	 DTjhvdwjC/8r8YDvcXgaQSU3YB2lExDb0XJ+bkLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Gil Fine <gil.fine@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 527/592] e1000e: set fixed clock frequency indication for Nahum 11 and Nahum 13
Date: Mon, 23 Jun 2025 15:08:05 +0200
Message-ID: <20250623130712.970345365@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Lifshits <vitaly.lifshits@intel.com>

[ Upstream commit 688a0d61b2d7427189c4eb036ce485d8fc957cbb ]

On some systems with Nahum 11 and Nahum 13 the value of the XTAL clock in
the software STRAP is incorrect. This causes the PTP timer to run at the
wrong rate and can lead to synchronization issues.

The STRAP value is configured by the system firmware, and a firmware
update is not always possible. Since the XTAL clock on these systems
always runs at 38.4MHz, the driver may ignore the STRAP and just set
the correct value.

Fixes: cc23f4f0b6b9 ("e1000e: Add support for Meteor Lake")
Signed-off-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Tested-by: Mor Bar-Gabay <morx.bar.gabay@intel.com>
Reviewed-by: Gil Fine <gil.fine@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 14 +++++++++++---
 drivers/net/ethernet/intel/e1000e/ptp.c    |  8 +++++---
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 8ebcb6a7d608a..a0045aa9550b5 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -3534,9 +3534,6 @@ s32 e1000e_get_base_timinca(struct e1000_adapter *adapter, u32 *timinca)
 	case e1000_pch_cnp:
 	case e1000_pch_tgp:
 	case e1000_pch_adp:
-	case e1000_pch_mtp:
-	case e1000_pch_lnp:
-	case e1000_pch_ptp:
 	case e1000_pch_nvp:
 		if (er32(TSYNCRXCTL) & E1000_TSYNCRXCTL_SYSCFI) {
 			/* Stable 24MHz frequency */
@@ -3552,6 +3549,17 @@ s32 e1000e_get_base_timinca(struct e1000_adapter *adapter, u32 *timinca)
 			adapter->cc.shift = shift;
 		}
 		break;
+	case e1000_pch_mtp:
+	case e1000_pch_lnp:
+	case e1000_pch_ptp:
+		/* System firmware can misreport this value, so set it to a
+		 * stable 38400KHz frequency.
+		 */
+		incperiod = INCPERIOD_38400KHZ;
+		incvalue = INCVALUE_38400KHZ;
+		shift = INCVALUE_SHIFT_38400KHZ;
+		adapter->cc.shift = shift;
+		break;
 	case e1000_82574:
 	case e1000_82583:
 		/* Stable 25MHz frequency */
diff --git a/drivers/net/ethernet/intel/e1000e/ptp.c b/drivers/net/ethernet/intel/e1000e/ptp.c
index 89d57dd911dc8..ea3c3eb2ef202 100644
--- a/drivers/net/ethernet/intel/e1000e/ptp.c
+++ b/drivers/net/ethernet/intel/e1000e/ptp.c
@@ -295,15 +295,17 @@ void e1000e_ptp_init(struct e1000_adapter *adapter)
 	case e1000_pch_cnp:
 	case e1000_pch_tgp:
 	case e1000_pch_adp:
-	case e1000_pch_mtp:
-	case e1000_pch_lnp:
-	case e1000_pch_ptp:
 	case e1000_pch_nvp:
 		if (er32(TSYNCRXCTL) & E1000_TSYNCRXCTL_SYSCFI)
 			adapter->ptp_clock_info.max_adj = MAX_PPB_24MHZ;
 		else
 			adapter->ptp_clock_info.max_adj = MAX_PPB_38400KHZ;
 		break;
+	case e1000_pch_mtp:
+	case e1000_pch_lnp:
+	case e1000_pch_ptp:
+		adapter->ptp_clock_info.max_adj = MAX_PPB_38400KHZ;
+		break;
 	case e1000_82574:
 	case e1000_82583:
 		adapter->ptp_clock_info.max_adj = MAX_PPB_25MHZ;
-- 
2.39.5



