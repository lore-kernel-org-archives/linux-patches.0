Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DFC20371A;
	Tue,  3 Dec 2024 15:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240221; cv=none; b=nQRTfwzxEzoyuBZfR/qWp/kGu/WTR4Hv0jyAv70SQA8qgjx0X0viKkp5cD8hsC58SWX2jOvLeFKr3pCML4fm+CUhvAofNkAthCDSRCj4D7Mjtrcp5qg1zBviM1fX8qL+e9m5b8Hjyd4uFofPsDVBFm0UJW74RTS0pDGRK2SpeQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240221; c=relaxed/simple;
	bh=ixUUu37UsiSeRSa1am3QUKiIj0Cn1z6PZDtZ9bZeDyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZtwtLfyeKHRF5h6Iy535Dji2ErP7Gpoz2ntwz/jWHsQgqhZEfjgPisg1dpBQAy7rDac35QEqNACQ409zPHQ2y1rM4GRJRyziyyvVF1nL949TnEZFhLjFGlgoASSCohQI47DmetUj+Rz1cnIWzgswK86irQRK6Ewc/DA1zt/Rsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZ3aea61; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZ3aea61"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69AC5C4CED6;
	Tue,  3 Dec 2024 15:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240220;
	bh=ixUUu37UsiSeRSa1am3QUKiIj0Cn1z6PZDtZ9bZeDyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BZ3aea61mGHhWaBx2PwmnnauNcBpxgHC7FxjObJzxU2WBQrbCB0UeC5BXU2G+h5Xy
	 IBMb4PKtKgvfZrBmVISZxPoyBNZrlOlwz6gVf7aRFoQIrj79hjz7fMgAlcRln3JqXj
	 /Ozwtpbtm3cz4teurjr8330CZJqpTerHk5IMI4QQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orange Kao <orange@aiven.io>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 063/826] EDAC/igen6: Avoid segmentation fault on module unload
Date: Tue,  3 Dec 2024 15:36:30 +0100
Message-ID: <20241203144745.931956136@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 189a2fc29e74f..07dacf8c10be3 100644
--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -1245,6 +1245,7 @@ static int igen6_register_mci(int mc, u64 mchbar, struct pci_dev *pdev)
 	imc->mci = mci;
 	return 0;
 fail3:
+	mci->pvt_info = NULL;
 	kfree(mci->ctl_name);
 fail2:
 	edac_mc_free(mci);
@@ -1269,6 +1270,7 @@ static void igen6_unregister_mcis(void)
 
 		edac_mc_del_mc(mci->pdev);
 		kfree(mci->ctl_name);
+		mci->pvt_info = NULL;
 		edac_mc_free(mci);
 		iounmap(imc->window);
 	}
-- 
2.43.0



