Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18ABF340A6F;
	Sat, 30 May 2026 18:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164468; cv=none; b=c4XR/aL4v012O68bjA3j+1BTiGh/Gh3YBZb7llX+zE/8mrnQu9x3pylOnQ86HoSTXrMkzkP6EzwYpSLXKXVpXQQ3m4uTH1CkBacMuowX0VXUG6kuXJYy+qo1ayg+K7CwjsrjqJ1RicRFKRUopEURPpRH9SVLWM1SyTbR4C8nPuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164468; c=relaxed/simple;
	bh=eRRxJCi34kJq9ZcF6QH6h6yqLlidDquyXWSmbRv4Blk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UxY8tosQ412PjxUa0hFJD5aj775VmWeazp0UpOIfLGk3obXMKaoykNAPzGomBF1AaXuEu9Mbot2FWrJXh3w+eUidKA+WysGDKWpK1KR3nT8XDl6wM1f5Pre/ASr+q5Q1nr1w4pUdz3ilHK2IYW7PeMgBuWXelmQWNUeL13J+TDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D6eloUxE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6eloUxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416F71F00893;
	Sat, 30 May 2026 18:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164466;
	bh=F3wQ/i6KGYIW3zWf3zqGw/KGnAn3T7nyA5/+8gNgtFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D6eloUxE7lcv7TN455grqiDGouzB5kkzryO2W0v6QzdWyPDHGdchXJaFiesaDiuvp
	 6KFUDEeiXbCImLhWlVSvx4LwycBB9YeGDZgQaYRbMKn/er7LOYg04arDnNU3dvZNP0
	 CO52PsDKMxtPBmwv+yf9DBsEbOBVrhCBJs2QpAmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Vollrath <tactii@gmail.com>,
	Avigail Dahan <avigailx.dahan@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 564/776] e1000e: Unroll PTP in probe error handling
Date: Sat, 30 May 2026 18:04:38 +0200
Message-ID: <20260530160254.702369386@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Matt Vollrath <tactii@gmail.com>

[ Upstream commit aa3f7fe409350857c25d050482a2eef2cfd69b58 ]

If probe fails after registering the PTP clock and its delayed work,
these resources must be released.

This was not an issue until a 2016 fix moved the e1000e_ptp_init() call
before the jump to err_register.

Fixes: aa524b66c5ef ("e1000e: don't modify SYSTIM registers during SIOCSHWTSTAMP ioctl")
Signed-off-by: Matt Vollrath <tactii@gmail.com>
Tested-by: Avigail Dahan <avigailx.dahan@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260416-iwl-net-submission-2026-04-14-v2-12-686c33c9828d@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 3216089642648..2154d476f9da6 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7708,6 +7708,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_register:
 	if (!(adapter->flags & FLAG_HAS_AMT))
 		e1000e_release_hw_control(adapter);
+	e1000e_ptp_remove(adapter);
 err_eeprom:
 	if (hw->phy.ops.check_reset_block && !hw->phy.ops.check_reset_block(hw))
 		e1000_phy_hw_reset(&adapter->hw);
-- 
2.53.0



