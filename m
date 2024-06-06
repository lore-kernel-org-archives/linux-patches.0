Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B121197523;
	Thu,  6 Jun 2024 14:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683135; cv=none; b=S7qUvlFXRXLoEsL1LkDLYfcXPvuCNu5nuWZFEHbBs0nzQcEASBqmDKORL5C39njOl5CbEYhyvVgaaLr6507/t+18CNdvoHK6Rr3jYl2ydO+1AgoAfj1qBfhsAbJJCMK4S+hFIvDbM/ftu7ZGvt8RvV0ygYMeTq4D/8a2FpyTLwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683135; c=relaxed/simple;
	bh=zDv0U5bTcooXgN3/Qj5Az/UM8PEsQ9MwlM3fkIkIh6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cuygUOaCmt3toWZggdNG30io+JGBOkEe7JKX3+GfoSjsnDEe14RTNj4NNByNQ2JYiPeKKCl+4idlT/99lc/mJWtUgH4THlbaM1WnmU5VtV3nLqmLTaFycpk5stojZP45/0Wsb4cayp/aMUN/Al+7rJdJQd2V5tMpuzWBHjPBRQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SeOKVDS2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SeOKVDS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72D7C2BD10;
	Thu,  6 Jun 2024 14:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683134;
	bh=zDv0U5bTcooXgN3/Qj5Az/UM8PEsQ9MwlM3fkIkIh6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SeOKVDS2/NYLsL86LipW8fyfwi7wrv8RLon3kKPzLr4v8sOxy4fb/IzRQsI0Nbsth
	 72sPd7vuVdMzT6OzbtZH8XeVWpqNSHa5VrFZPfac0d7WSnf8JJnbkUsVY+q9EwXIFr
	 ifGCKQElgTW1vmx7uQE0V2mzOGpCHmghJTHp81A0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/744] drm/amd/pm: Restore config space after reset
Date: Thu,  6 Jun 2024 15:55:14 +0200
Message-ID: <20240606131733.802641258@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 30d1cda8ce31ab49051ff7159280c542a738b23d ]

During mode-2 reset, pci config space registers are affected at device
side. However, certain platforms have switches which assign virtual BAR
addresses and returns the same even after device is reset. This
affects pci_restore_state() as it doesn't issue another config write, if
the value read is same as the saved value.

Add a workaround to write saved config space values from driver side.
Presently, these switches are in platforms with SMU v13.0.6 SOCs, hence
restrict the workaround only to those.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c  | 25 +++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
index 6a28f8d5bff7d..be4b7b64f8785 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
@@ -2039,6 +2039,17 @@ static ssize_t smu_v13_0_6_get_gpu_metrics(struct smu_context *smu, void **table
 	return sizeof(struct gpu_metrics_v1_3);
 }
 
+static void smu_v13_0_6_restore_pci_config(struct smu_context *smu)
+{
+	struct amdgpu_device *adev = smu->adev;
+	int i;
+
+	for (i = 0; i < 16; i++)
+		pci_write_config_dword(adev->pdev, i * 4,
+				       adev->pdev->saved_config_space[i]);
+	pci_restore_msi_state(adev->pdev);
+}
+
 static int smu_v13_0_6_mode2_reset(struct smu_context *smu)
 {
 	int ret = 0, index;
@@ -2060,6 +2071,20 @@ static int smu_v13_0_6_mode2_reset(struct smu_context *smu)
 	/* Restore the config space saved during init */
 	amdgpu_device_load_pci_state(adev->pdev);
 
+	/* Certain platforms have switches which assign virtual BAR values to
+	 * devices. OS uses the virtual BAR values and device behind the switch
+	 * is assgined another BAR value. When device's config space registers
+	 * are queried, switch returns the virtual BAR values. When mode-2 reset
+	 * is performed, switch is unaware of it, and will continue to return
+	 * the same virtual values to the OS.This affects
+	 * pci_restore_config_space() API as it doesn't write the value saved if
+	 * the current value read from config space is the same as what is
+	 * saved. As a workaround, make sure the config space is restored
+	 * always.
+	 */
+	if (!(adev->flags & AMD_IS_APU))
+		smu_v13_0_6_restore_pci_config(smu);
+
 	dev_dbg(smu->adev->dev, "wait for reset ack\n");
 	do {
 		ret = smu_cmn_wait_for_response(smu);
-- 
2.43.0



