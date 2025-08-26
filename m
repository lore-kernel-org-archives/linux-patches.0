Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137A23376BE;
	Tue, 26 Aug 2025 13:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215943; cv=none; b=kVrHVsQ6az+6ZpTxKn0+6ND/04E79ZvAeT88cQp7rvcloOUTl4Aht+bTnkfICKjpn+VcGjx8ebQMow3WaC4UXJpN3hXlmXVk7YZS9++mJ4/gd68u9mBwL8jpRWpCXBVHu6Kn5fIBHaY/tZddH+QhqjRfKDUPpSHYSxZpsKHde40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215943; c=relaxed/simple;
	bh=fEvf4nNwyvJ37h4EvHOZ+fDGJGDR/nR2Lfg2oZshr5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iS6vaJRn4QVgTPWnljcFV2XrhtEIllpQ2qayyyuOy1vUL4LQvV7WK8Tq0gkT+GjaIVaF3prdB3T2c+4/ROe5eJt+FZL3OUTwvI8ki6lCnGFK9oPR3eL/r82+Cxvj8xr+3/xTgP02DZIuW6D6KQVMZBPL3XRnlBVnqy8lo1TXED8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R6Rnj6hN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R6Rnj6hN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E3BC4CEF1;
	Tue, 26 Aug 2025 13:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215942;
	bh=fEvf4nNwyvJ37h4EvHOZ+fDGJGDR/nR2Lfg2oZshr5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R6Rnj6hNFLH8tHNj7nbRTACD+Ukc/mVXf3VXYWicb8D4IKPP8nsI/nysEVKOmQ0Vg
	 r+NT2lo/6LDWJlvgSAY8Se7U9kdYmXYfsM0RS8SribvTiogUBDPLJTgFroBmnfaNDs
	 k9hTs/s8ILvBCMZgrMppKK7g8TKMgntTf56+aYVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 223/644] powerpc/eeh: Rely on dev->link_active_reporting
Date: Tue, 26 Aug 2025 13:05:14 +0200
Message-ID: <20250826110951.948979535@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej W. Rozycki <macro@orcam.me.uk>

[ Upstream commit 1541a21305ceb10fcf3f7cbb23f3e1a00bbf1789 ]

Use dev->link_active_reporting to determine whether Data Link Layer Link
Active Reporting is available rather than re-retrieving the capability.

Link: https://lore.kernel.org/r/alpine.DEB.2.21.2305310124100.59226@angie.orcam.me.uk
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/eeh_pe.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/eeh_pe.c b/arch/powerpc/kernel/eeh_pe.c
index a856d9ba42d2..3f55e372f259 100644
--- a/arch/powerpc/kernel/eeh_pe.c
+++ b/arch/powerpc/kernel/eeh_pe.c
@@ -670,9 +670,8 @@ static void eeh_bridge_check_link(struct eeh_dev *edev)
 	eeh_ops->write_config(edev, cap + PCI_EXP_LNKCTL, 2, val);
 
 	/* Check link */
-	eeh_ops->read_config(edev, cap + PCI_EXP_LNKCAP, 4, &val);
-	if (!(val & PCI_EXP_LNKCAP_DLLLARC)) {
-		eeh_edev_dbg(edev, "No link reporting capability (0x%08x) \n", val);
+	if (!edev->pdev->link_active_reporting) {
+		eeh_edev_dbg(edev, "No link reporting capability\n");
 		msleep(1000);
 		return;
 	}
-- 
2.39.5



