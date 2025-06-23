Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BDE3FB1B;
	Mon, 23 Jun 2025 22:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716294; cv=none; b=dNQ8IAye1Lqez7rDDW2noLrwesg07h9ol3MrrhygspdWbL0XzIrQZ9eM0gToS9HyiTLlSeufqymd9cwDxUK4EEVikE5Yx2qwdHayRf2cnTOilLQmspGbHI2B3uyBailzgyouJvm1nWpAGv0GxULJKL8JZubf7kYZVQNJ8UUux3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716294; c=relaxed/simple;
	bh=ioFG+NfGpGSMNl88S/VkEkRX5wAdlUsV76C3KowqE9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plgbuxgy7BwgMSe9/qn7x/J/SDcRSOMnmw17eL23MXazcDRUPG0TkggcVrzcERWKIBKMQ71gxvZ40G65bUBtNSUBJjxlE9PZ4YsvcsXXrSrcyr/TZ9kFTAL7MvMOVVqPiGp20scTmCe07bEYeh5kGm/7jKKDbL+pCB8rUyThEwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B7l4ji/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B7l4ji/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02161C4CEEA;
	Mon, 23 Jun 2025 22:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716294;
	bh=ioFG+NfGpGSMNl88S/VkEkRX5wAdlUsV76C3KowqE9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B7l4ji/Uu78eoxhKy68ym00qpee5Eilm47T3zGKtjSATOd+HgOmkhhi+jQyEHjONU
	 kP1RELdKmqvUi53yjSOeJGukkvPpfY2GDgSIlds470UtvkqY4ygZ76Fv9poCRXbbVj
	 xIXolE1/3Pc6SPEsmU29asnqv5+anjP/U4FGemhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Gil Fine <gil.fine@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 254/290] e1000e: set fixed clock frequency indication for Nahum 11 and Nahum 13
Date: Mon, 23 Jun 2025 15:08:35 +0200
Message-ID: <20250623130634.565741466@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 721c098f2bb1b..7e4fea0e186b6 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -3540,9 +3540,6 @@ s32 e1000e_get_base_timinca(struct e1000_adapter *adapter, u32 *timinca)
 	case e1000_pch_cnp:
 	case e1000_pch_tgp:
 	case e1000_pch_adp:
-	case e1000_pch_mtp:
-	case e1000_pch_lnp:
-	case e1000_pch_ptp:
 	case e1000_pch_nvp:
 		if (er32(TSYNCRXCTL) & E1000_TSYNCRXCTL_SYSCFI) {
 			/* Stable 24MHz frequency */
@@ -3558,6 +3555,17 @@ s32 e1000e_get_base_timinca(struct e1000_adapter *adapter, u32 *timinca)
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
index bbcfd529399b0..d039dea48ca32 100644
--- a/drivers/net/ethernet/intel/e1000e/ptp.c
+++ b/drivers/net/ethernet/intel/e1000e/ptp.c
@@ -294,15 +294,17 @@ void e1000e_ptp_init(struct e1000_adapter *adapter)
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



