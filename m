Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F2D1F8F13;
	Fri,  6 Dec 2024 14:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496744; cv=none; b=hCHoK7uC4b+6Syrx4Uw9F7MR+DyW6kBQSvKRq9ZJu4D/Mc6caVwrMakGEwoGnf/mXYR8UpvFXOpMxSk9GqF8erjAs6EoYEMIF/JTp768iidQuDjlI5X0HfWCLPNnS4xLdTxLwwsqz2oHf5wg9mEGTmmYWzzXosRpZiIbbTItLqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496744; c=relaxed/simple;
	bh=eKjMb1VV0xLvjhHzaHLG0hIKpD0cLAWbmMCTJaimPTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QyjdtD0TFLNxD7lTCs83zCjP2vTDAMhe3OZUK3hvnb1Fij515zWrOHOuyGYu2iElnUQWzDqbNwU9IhhTrTV45GQ2fTbmr/RzG3GxkrPRoSppHCf+A/P63eHHtzP3+WX3HrVe1zNgoAciL4tiGjFybNKtVOojAgn4EtUB09EUg9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KL5YVLji; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KL5YVLji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1961DC4CED1;
	Fri,  6 Dec 2024 14:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496744;
	bh=eKjMb1VV0xLvjhHzaHLG0hIKpD0cLAWbmMCTJaimPTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KL5YVLjiRxvzc5PE5oRqvvgmQJCw+292DXqWcyHTEZq09wXSJ2KsnwdOTjDwntOI3
	 jIySwJi661VAJ0y7TcwhH49468OLYj1gzS8LZJhcVcp67G9yotkO2zY92iFQNeJYKR
	 2X1rfx4t0AfqzZ58h/rjocSYO6j4kRjRb4A0Q70s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orange Kao <orange@aiven.io>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/676] EDAC/igen6: Avoid segmentation fault on module unload
Date: Fri,  6 Dec 2024 15:28:30 +0100
Message-ID: <20241206143656.913194081@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
index a0edb61a5a01a..0b408299699a8 100644
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



