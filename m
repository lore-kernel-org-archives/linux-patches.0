Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF141155C81;
	Mon, 27 May 2024 19:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837646; cv=none; b=Rbmf7OeY+h3TLTbfd6E00+DEHvNDNLffa6hYjNV0bHUbtzbRezpT5W4/YWsLCMBA7UpvvNGqdcF58562VZc2q9Pk4y+wshbSxp1oSW/bE8WZi1qB4mIDPrwnLc/wSfGT91RHE1+jB7c/uqpwm4Bxr64v8cA36Zln75LJ/4zcPxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837646; c=relaxed/simple;
	bh=0kmKtUvfDo6X7DYb97q/bApYE4OE0gwR2l7W54k7aEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tl1YoZqpvNhzWOaKFNDYg03qhAX+w7KB1GYtj9Hp6H8WjTOYUfaCXO6eQO4JKYjBtZNWHs6JcjZTaZUegSRQYhrR1WJ+8xFqrl7QYGEIHnDX5spoPw8ykoNFbyTdeTo6plvmbU+h8tJGONnzma34G/6MMwacTZUAAe/nOC5Wy3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xzELW15t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xzELW15t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D6EC2BBFC;
	Mon, 27 May 2024 19:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837645;
	bh=0kmKtUvfDo6X7DYb97q/bApYE4OE0gwR2l7W54k7aEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xzELW15tK+jrzzlTG150HvrOLauPXS3dDXkIFE3uPHBguBjpaTI5zBdzVnuQQrMwO
	 72tzONBDrd0cigDw1lclUFxVIWKtvCJyeLkiGvYrzBaXLseYcxOe7Wms5Zo/aYDJeA
	 AA50EFLY6Eu9rqH1k+jMK7DyzAsJnPUQjw69yWd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 049/493] drm/amd/pm: Restore config space after reset
Date: Mon, 27 May 2024 20:50:51 +0200
Message-ID: <20240527185630.704876740@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 78491b04df108..ddb11eb8c3f53 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
@@ -2205,6 +2205,17 @@ static ssize_t smu_v13_0_6_get_gpu_metrics(struct smu_context *smu, void **table
 	return sizeof(*gpu_metrics);
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
@@ -2226,6 +2237,20 @@ static int smu_v13_0_6_mode2_reset(struct smu_context *smu)
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



