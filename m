Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F3212DDA1;
	Tue, 11 Nov 2025 00:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822292; cv=none; b=ZuCRlBziTz2wChXBOgz30p08FST9rep7Kbfn0XAlm1jx2cG48NZz+monZAWsaMEAFpvBVHWbkcO2sJKL3ZPcbTKGMMHTxI4B61R8SPL1nZOLGzDj6y+P2cphx+3gaDFVDhQblrJ8kAyHtpEnSl5Vx8NvDg7eHIlrJxs6MLNAWuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822292; c=relaxed/simple;
	bh=3NwIJ4x0qJ4xMyM4SO79rVTTthq4p3FcAr2CabHbwRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VLKOLpZvt5MVJ5aTIu5ENSHuHi6j2kFoRaH29G6cPN7obIs1P7nKo9Yq4Bkg1Dm+Ms2zDVP+I0/FQt6osZ2JRc/S6g8eHT5z9PxsVvbVxQapvhlhlC30dbPvo+qX0T46yPlUop1eXJHiiXR8tqzQY8cs0syOUApOtY44TA7FmXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i6g+q4uj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i6g+q4uj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6DDC4CEF5;
	Tue, 11 Nov 2025 00:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822292;
	bh=3NwIJ4x0qJ4xMyM4SO79rVTTthq4p3FcAr2CabHbwRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i6g+q4ujdaZqxdN/apYTcO8oiK8cjL/SR75LCsJiYvVx7ts/CuOi+ojRSAZ+WSbBZ
	 pzq1m9ohThYK1kYdjCMV000K0A1C148wVWcIRzsqJ25pmUOegfLbwXr/5ExsRTcU1K
	 Wv8EGxhQD7wHisn1WkFhPsorwQRTJ1v6QRILlIQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Cree <ecree.xilinx@gmail.com>,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 074/849] sfc: fix potential memory leak in efx_mae_process_mport()
Date: Tue, 11 Nov 2025 09:34:04 +0900
Message-ID: <20251111004538.212445283@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 46a499aaf8c27476fd05e800f3e947bfd71aa724 ]

In efx_mae_enumerate_mports(), memory allocated for mae_mport_desc is
passed as a argument to efx_mae_process_mport(), but when the error path
in efx_mae_process_mport() gets executed, the memory allocated for desc
gets leaked.

Fix that by freeing the memory allocation before returning error.

Fixes: a6a15aca4207 ("sfc: enumerate mports in ef100")
Acked-by: Edward Cree <ecree.xilinx@gmail.com>
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Link: https://patch.msgid.link/20251023141844.25847-1-nihaal@cse.iitm.ac.in
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/mae.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 6fd0c1e9a7d54..7cfd9000f79de 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -1090,6 +1090,9 @@ void efx_mae_remove_mport(void *desc, void *arg)
 	kfree(mport);
 }
 
+/*
+ * Takes ownership of @desc, even if it returns an error
+ */
 static int efx_mae_process_mport(struct efx_nic *efx,
 				 struct mae_mport_desc *desc)
 {
@@ -1100,6 +1103,7 @@ static int efx_mae_process_mport(struct efx_nic *efx,
 	if (!IS_ERR_OR_NULL(mport)) {
 		netif_err(efx, drv, efx->net_dev,
 			  "mport with id %u does exist!!!\n", desc->mport_id);
+		kfree(desc);
 		return -EEXIST;
 	}
 
-- 
2.51.0



