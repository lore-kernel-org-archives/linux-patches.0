Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86702868AF;
	Tue, 12 Aug 2025 17:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021086; cv=none; b=SEkIX2xmXV7xk7st3ClMKKneCIzW+qfIjIrUPr8dXvCfga6ryvEBSfvRVf0xs+NN+T/+XVBjcAfXBB7AUFxI4Kpn2/qMXqVszpqGMP1GBSRgEO4jQyiK5msnDz55yVAC3RBnyuxL+wi5Vu/bxJvMUa+80gk1H3aEzQV0vvpfmHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021086; c=relaxed/simple;
	bh=rLPmHNh3vlPqo3iKX1fASVz1Qy/WltCZYPxwFn/k/k4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLg2c+Kynf8hV+nihjnHVDHTyWYaM4UGscuYFIsZ6EqX0yfcVFt0KJbP2RhiADoxWddZLj1MixEeE1drZgyWuv9V4f3GqHjpllPWtjjRXQPwu1j5Qgm4z5GrWIzmNDmumyRuPr0LnW0uehirn/UKX0yteHUrkR6SXs8kJGtQP6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G72kcjZR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G72kcjZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32075C4CEF0;
	Tue, 12 Aug 2025 17:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021086;
	bh=rLPmHNh3vlPqo3iKX1fASVz1Qy/WltCZYPxwFn/k/k4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G72kcjZRETmKkWc+5YCkiAgZyUGtHlZQK722trwv5I0NN/3a/TGw9SRrECDvk14CY
	 lPz4N0LfUupuAIFlhWOLPZZkxUfjRDeGmdHKQMEDDRdvGwC8Ga07GwFTPD8A/NGaK8
	 JX7dYlE4v9mth8Re1GCLYpcZj05uTI9jcHDLFmhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 209/253] powerpc/eeh: Rely on dev->link_active_reporting
Date: Tue, 12 Aug 2025 19:29:57 +0200
Message-ID: <20250812172957.717862465@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej W. Rozycki <macro@orcam.me.uk>

[ Upstream commit 1541a21305ceb10fcf3f7cbb23f3e1a00bbf1789 ]

Use dev->link_active_reporting to determine whether Data Link Layer Link
Active Reporting is available rather than re-retrieving the capability.

Link: https://lore.kernel.org/r/alpine.DEB.2.21.2305310124100.59226@angie.orcam.me.uk
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Stable-dep-of: 1010b4c012b0 ("powerpc/eeh: Make EEH driver device hotplug safe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/eeh_pe.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/eeh_pe.c b/arch/powerpc/kernel/eeh_pe.c
index e4624d789629..7d1b50599dd6 100644
--- a/arch/powerpc/kernel/eeh_pe.c
+++ b/arch/powerpc/kernel/eeh_pe.c
@@ -671,9 +671,8 @@ static void eeh_bridge_check_link(struct eeh_dev *edev)
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



