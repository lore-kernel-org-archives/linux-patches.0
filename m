Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7083876BA;
	Sat, 17 Oct 2026 16:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253401; cv=none; b=JWKn9ZwaUr1y/iLVcrQC6CIh2vvIJ+6zRiSRf9ugmT19gJXnlD9afP600NXtnmGq4LenRKoMxTV2IVS7vpXh2NIN+Z7mRyKVaydNEOTM2V9H5iH2/T7EyKwPdO2bGE7SFzJLeMemqanK0NmM1rVrXLL8cyj0GYJd1YiAbKd8W0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253401; c=relaxed/simple;
	bh=vBzYFRTHtahA8lBlkJCh7BDy3gOd6BA0ZRe9pnPHHAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=guh9btBwztS4yIUD7CtbvkVy67rBvo6X5Wb1bRxgiY0h7piNMwfZ4xXukvSM/RcuyXmbwO3kx8/2RkMw/IuI6b6odNNcsSjmnb6wsvxbengE8uQ2FavrPiyu7fdme/9meyPfafVM/KB87xKU4wpZagDpZJpLzfaIgVtjK7FlvAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OchQZCWD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OchQZCWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B4C1F000C4;
	Sat, 17 Oct 2026 16:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253400;
	bh=pHdVIeSf2IHANFy2rhIg7svMS2YjCZGLVxOMoMcUfQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OchQZCWDNy26MW18+vRDAYfGH1dn+xH1dU9BF8Ts/HqAU/1RRO/VqSjw7rCE5x8vL
	 NvzsSb3roDI01iO6j8+9dnxU8iUe7JOpEXlnMs5aIb5WXE3mP8LkdJKyVf5z+QbvgN
	 Vv1C/sUiIbea+LmaC4DdHBztw8PfHqejPl/pV/nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 104/869] wifi: iwlwifi: Fix error code in iwl_op_mode_dvm_start()
Date: Sat, 17 Oct 2026 17:49:05 +0200
Message-ID: <20261017160039.701985509@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit cf80c02a9fdb6c5bc8508beb6a0f6a1294fc32f6 ]

Preserve the error code if iwl_setup_deferred_work() fails.  The current
code returns ERR_PTR(0) (which is NULL) on this path.  I believe the
missing error code potentially leads to a use after free involving
debugfs.

Fixes: 90a0d9f33996 ("iwlwifi: Add missing check for alloc_ordered_workqueue")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/a7a1cd2c-ce01-461a-9afd-dbe535f8df01@sabinyo.mountain
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/dvm/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/main.c b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
index bc065c7089f71..a4f6e5a8f3a9d 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -1468,7 +1468,8 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	/********************
 	 * 6. Setup services
 	 ********************/
-	if (iwl_setup_deferred_work(priv))
+	err = iwl_setup_deferred_work(priv);
+	if (err)
 		goto out_uninit_drv;
 
 	iwl_setup_rx_handlers(priv);
-- 
2.53.0



