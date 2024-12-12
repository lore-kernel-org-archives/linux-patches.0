Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFB410F2;
	Thu, 12 Dec 2024 15:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018941; cv=none; b=P/V53J0p0dBKRCQemgwgxD6UvWct8Lw/caf3x7LeZmCKTYKBTFHnLKdz+HhBGBdDm+K/d7ViZzCycKnlgW6tEmqDhBPm1LNuo1rlo1+KJjM1hwnPlKSKdNpBQnwana99E/JuHiOZbPjPPLpCZpB1ynTptgy+HIviV7DhKqNIrh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018941; c=relaxed/simple;
	bh=KrKPspVhblcaWDODlIzJPCxyn47IdXVPzLam/Z4jFx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7cvSTFjg+aMyB7UC7OOxGdCQhDQMKQnNTBv7hqCeXw0skqD5Rfcli40R4yyXP9dVsWPNj4O3wRL86MC3PXtVmCcU8bJHojnUSiomddaSSD4KRJ05Zt9LeIAirH7cpuu6JqhVBd1KLdbIWwXZtAx8iOF7NmEYyZXei+AuJ9sQsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d0vl0SFt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d0vl0SFt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E77FC4CECE;
	Thu, 12 Dec 2024 15:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018940;
	bh=KrKPspVhblcaWDODlIzJPCxyn47IdXVPzLam/Z4jFx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d0vl0SFtCtuFUWc1WMnDwVswdPFRp8CZGBzVawSiwyLt08ZDt1acunswWpLPqmvqv
	 dmoweMyM0yOeq3hNRikf3kYx5I+0SqNkkDjkEyHF6HOabDI1DdHpTKI+eOzSXOMZ6J
	 ssv7itgbZwbKTgQG9z13ZfR++PWBdkz96RSw/FLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orange Kao <orange@aiven.io>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/772] EDAC/igen6: Avoid segmentation fault on module unload
Date: Thu, 12 Dec 2024 15:50:21 +0100
Message-ID: <20241212144353.067938013@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Orange Kao <orange@aiven.io>

[ Upstream commit fefaae90398d38a1100ccd73b46ab55ff4610fba ]

The segmentation fault happens because:

During modprobe:
1. In igen6_probe(), igen6_pvt will be allocated with kzalloc()
2. In igen6_register_mci(), mci->pvt_info will point to
   &igen6_pvt->imc[mc]

During rmmod:
1. In mci_release() in edac_mc.c, it will kfree(mci->pvt_info)
2. In igen6_remove(), it will kfree(igen6_pvt);

Fix this issue by setting mci->pvt_info to NULL to avoid the double
kfree.

Fixes: 10590a9d4f23 ("EDAC/igen6: Add EDAC driver for Intel client SoCs using IBECC")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219360
Signed-off-by: Orange Kao <orange@aiven.io>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/r/20241104124237.124109-2-orange@aiven.io
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/igen6_edac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/edac/igen6_edac.c b/drivers/edac/igen6_edac.c
index 74c5aad1f6081..0ab8642c4e55a 100644
--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -1075,6 +1075,7 @@ static int igen6_register_mci(int mc, u64 mchbar, struct pci_dev *pdev)
 	imc->mci = mci;
 	return 0;
 fail3:
+	mci->pvt_info = NULL;
 	kfree(mci->ctl_name);
 fail2:
 	edac_mc_free(mci);
@@ -1099,6 +1100,7 @@ static void igen6_unregister_mcis(void)
 
 		edac_mc_del_mc(mci->pdev);
 		kfree(mci->ctl_name);
+		mci->pvt_info = NULL;
 		edac_mc_free(mci);
 		iounmap(imc->window);
 	}
-- 
2.43.0



