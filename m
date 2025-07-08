Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B542A1BA;
	Tue,  8 Jul 2025 16:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992403; cv=none; b=G7HOXAFosDVz047hAZUv+DkbtqrOFnNlLTNMD9pr8OmGKqSzG6fLfoo/AVi5/qdXm47WaxPOirNbMMdjp3jzVLgmhWgsUPOH5dBHkLWX+8gZ1Csir+CXwgQzgIIT8v0BzYtaFQZWKS72zvtpkfmdxoQq9dSUyOP5wCTjh2Kidos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992403; c=relaxed/simple;
	bh=/2Dk+/YMZx3EoyjDwJnzU2yB1CxofDGT72Fj0UxvkJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QHJ9FkE3zTXTT7Dyyoec1vv6L0qJpI3aEhef4yRNufklIDP/MSGluvMHip83W6SKAJOzfP46I+3MpHNfOxp7rRCjHflMfVyojOf9VGvkuIsdBPQ0jNk6eNN776BLktpV9ZvonLAepKyV2nGSmYajkGNuNwO/7dLYrxt94tduUac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TDlvh55S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TDlvh55S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB30CC4CEF0;
	Tue,  8 Jul 2025 16:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992403;
	bh=/2Dk+/YMZx3EoyjDwJnzU2yB1CxofDGT72Fj0UxvkJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TDlvh55SDsERTTSaMeZ3ZEH4hjuJ+YWdb7MBh6w6CQZnLwarTiy2erVV84Clc2eQ2
	 7zEdlx9hpfsUho64ydcFOs/c2SyoE8Ci6IfofUJP/OaCcc3xZOKfdcPIGFwX7Jqj5H
	 +qdOAnpmmhfR/soxOHd0fouY2Lnr1dhNInUKkjdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Pasternak <vadimp@nvidia.com>,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/132] platform/mellanox: mlxreg-lc: Fix logic error in power state check
Date: Tue,  8 Jul 2025 18:22:41 +0200
Message-ID: <20250708162232.124306513@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 644bec18e705ca41d444053407419a21832fcb2f ]

Fixes a logic issue in mlxreg_lc_completion_notify() where the
intention was to check if MLXREG_LC_POWERED flag is not set before
powering on the device.

The original code used "state & ~MLXREG_LC_POWERED" to check for the
absence of the POWERED bit. However this condition evaluates to true
even when other bits are set, leading to potentially incorrect
behavior.

Corrected the logic to explicitly check for the absence of
MLXREG_LC_POWERED using !(state & MLXREG_LC_POWERED).

Fixes: 62f9529b8d5c ("platform/mellanox: mlxreg-lc: Add initial support for Nvidia line card devices")
Suggested-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://lore.kernel.org/r/20250630105812.601014-1-alok.a.tiwari@oracle.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxreg-lc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/mellanox/mlxreg-lc.c b/drivers/platform/mellanox/mlxreg-lc.c
index 8d833836a6d32..74e9d78ff01ef 100644
--- a/drivers/platform/mellanox/mlxreg-lc.c
+++ b/drivers/platform/mellanox/mlxreg-lc.c
@@ -688,7 +688,7 @@ static int mlxreg_lc_completion_notify(void *handle, struct i2c_adapter *parent,
 	if (regval & mlxreg_lc->data->mask) {
 		mlxreg_lc->state |= MLXREG_LC_SYNCED;
 		mlxreg_lc_state_update_locked(mlxreg_lc, MLXREG_LC_SYNCED, 1);
-		if (mlxreg_lc->state & ~MLXREG_LC_POWERED) {
+		if (!(mlxreg_lc->state & MLXREG_LC_POWERED)) {
 			err = mlxreg_lc_power_on_off(mlxreg_lc, 1);
 			if (err)
 				goto mlxreg_lc_regmap_power_on_off_fail;
-- 
2.39.5



