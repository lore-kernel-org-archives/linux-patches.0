Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A17A216E14;
	Thu, 12 Dec 2024 16:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021921; cv=none; b=IuX6Sz4m/WUMmU0drbDmLqGWjrQkWpPJJdzL/EpGbRTTqmixKlZb1aHCDwo5sMQ3B+77ejs62pAPOJpAd6lEKTFHxYYW3IZfvo66Z/+hS8+6VxOdP/CC60sRox3EXnyUHIfy+fS4c0d+R76sEPDnJxroap+6bm3UQdM5DO9P3sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021921; c=relaxed/simple;
	bh=88XXtHU8jCzuBEtR2JDWVIsIfqmHNef9EQDY/qRAKu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z23gbnJsFJFt1cXDemz9otibTp4Z0tjEQ4KtJWnebxIaMQSQjWQRgRKgqPGyfIYD7m+TgP4oipqCIDB8q5pHB7ZTjtqyoddjP+oMUJmwKhWzHAyWjCqQffEVOK83SEf4PASTQ5YS86d5VQDhl5UmbUykuwLA7VNTyvy94GHRp3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sf27YGla; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sf27YGla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D3CC4CECE;
	Thu, 12 Dec 2024 16:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021921;
	bh=88XXtHU8jCzuBEtR2JDWVIsIfqmHNef9EQDY/qRAKu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sf27YGlaXLNtjXQMHIyiPZUj9fzB/IeZNSIjDkG5gVJkXElyBbph+iLk87FRlPwGL
	 Ujk1SR7F9u6sF1umfeYrZlOkVvlW8/WgYOcN7hAdDgyrHo2eGeBuVxhAETuxMpR6fh
	 lEkCcAywmhChZW6wixWf0LB0Hql7qx36kfvQN9BU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orange Kao <orange@aiven.io>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/565] EDAC/igen6: Avoid segmentation fault on module unload
Date: Thu, 12 Dec 2024 15:54:54 +0100
Message-ID: <20241212144315.400866519@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



