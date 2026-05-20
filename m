Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02826348C55;
	Wed, 20 May 2026 18:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301195; cv=none; b=OgBlUGg311EAakAKCpveUqHiMkFDRr4aDspAD2FylmNQpxycIQIy+qYCKifMvL4+vhsqp4ghy1bQizV74lpGobAGdWQy+kagEF4zyn5OWT+7O2WDStxhkewB3VVf+TOfvcqfsh5L1gpkNPwMVRNloRjAkd9Xl4Hbo++2giJId28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301195; c=relaxed/simple;
	bh=7QwN/e/dFteMV0XjoKn9XZB6JFZQ5ER+dAXXIO3YHPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+xRwnpn29sZB4CT0V4FHhp508dN48bGDhtuSO4OBrkjyOYoAf17H/HrbWkeam5fYZhkg0AfRbf5ic4MAhyAibZo7DVqLp6mOtSsabztEVUZ6fot6+yxy3OIijGS6Lw4xR10VHvfN7vGIJyp/2fAzyM33V2Rcyo2BsxGgHnxosU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nTdb2/WM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nTdb2/WM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C891F000E9;
	Wed, 20 May 2026 18:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301193;
	bh=PGHm+zKm0fpdjFDUL/FxKLtHkYFs+qxYorKbm1QP0cU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nTdb2/WMOk8YjdbJcNQRN7ILJmeW6fwMrNj7EYhIbroBX44G762gKuwkjA+nQHYYo
	 P1eZGRB6kUcXd0N3yswxMGYQIAtr5SbPkhuL7BOlJ8Lg5eIOQWxGlhMqda6Vu8Cnzu
	 CbBEvDIJsXn2blkjlawGn60R1d1kwpBHA9fIoB/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Vollrath <tactii@gmail.com>,
	Avigail Dahan <avigailx.dahan@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 461/666] e1000e: Unroll PTP in probe error handling
Date: Wed, 20 May 2026 18:21:12 +0200
Message-ID: <20260520162121.262234630@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4d9dcb0001d21..3f0dd19ba399c 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7700,6 +7700,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_register:
 	if (!(adapter->flags & FLAG_HAS_AMT))
 		e1000e_release_hw_control(adapter);
+	e1000e_ptp_remove(adapter);
 err_eeprom:
 	if (hw->phy.ops.check_reset_block && !hw->phy.ops.check_reset_block(hw))
 		e1000_phy_hw_reset(&adapter->hw);
-- 
2.53.0



