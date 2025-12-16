Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3E8328638;
	Tue, 16 Dec 2025 12:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887132; cv=none; b=lQDBuzsjGcX8+V0SzlMqjCN2XnaaNlZ8J3Igclofc2mFVlqjtP+3qridHmUL7lLdpGEb328nfNlzJi6ahdIG3aRcmZflrpoptywt4Rn8+dzY+kgzZdwRNmrt08i1m3jrYDWxiM48sKRzbE9BoI0MmmpjMKxdsW15xq7QdAF3Ii0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887132; c=relaxed/simple;
	bh=UggNJ5xMNJDC3KwbBMEEBfHfUAf5E2ywQQfV77bSo6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzFBL5C4PSj2PeIGHB2Zxw/q/0iT2qaUmhR8KNTGWxa8QOisis0AsNDAOnCsu5/8lg+TSRB8bBZ2yJo1UMfdZiz7wJ3bjxtl/ZSAD8Bp3/Dh/twMIGhC2nAx+tl6X42g8FP4y89n8Tk0wvgi8/IM87oIQtFYKZ5gtIVneitBpQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJsIEUah; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJsIEUah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF540C4CEF1;
	Tue, 16 Dec 2025 12:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887132;
	bh=UggNJ5xMNJDC3KwbBMEEBfHfUAf5E2ywQQfV77bSo6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OJsIEUahniGJCzT6dsuFfXyR86Uo9Myxd9GeLrqy2foOUFvNPjmrJcQCvAbVxh7T/
	 ANtYoHriUkiBgXbhL8UQM7+CXU4LHxCqiYbecT8a0CoW6nm0VLgq1XqnyV8m2nJJzz
	 KLac38pcckpm/IxExgPTTt+I+qPBIidjSjgbHazM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.18 103/614] ice: extract ice_init_dev() from ice_init()
Date: Tue, 16 Dec 2025 12:07:50 +0100
Message-ID: <20251216111405.061283795@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Przemek Kitszel <przemyslaw.kitszel@intel.com>

[ Upstream commit c2fb9398f73d41cb2b5da74ff505578525ee3fd8 ]

Extract ice_init_dev() from ice_init(), to allow service task and IRQ
scheme teardown to be put after clearing SW constructs in the subsequent
commit.

Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 1390b8b3d2be ("ice: remove duplicate call to ice_deinit_hw() on error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 6b3d941f419b3..a12dcc733e041 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5023,14 +5023,10 @@ static int ice_init(struct ice_pf *pf)
 	struct device *dev = ice_pf_to_dev(pf);
 	int err;
 
-	err = ice_init_dev(pf);
-	if (err)
-		return err;
-
 	err = ice_init_pf(pf);
 	if (err) {
 		dev_err(dev, "ice_init_pf failed: %d\n", err);
-		goto unroll_dev_init;
+		return err;
 	}
 
 	if (pf->hw.mac_type == ICE_MAC_E830) {
@@ -5080,8 +5076,6 @@ static int ice_init(struct ice_pf *pf)
 	ice_dealloc_vsis(pf);
 unroll_pf_init:
 	ice_deinit_pf(pf);
-unroll_dev_init:
-	ice_deinit_dev(pf);
 	return err;
 }
 
@@ -5093,7 +5087,6 @@ static void ice_deinit(struct ice_pf *pf)
 	ice_deinit_pf_sw(pf);
 	ice_dealloc_vsis(pf);
 	ice_deinit_pf(pf);
-	ice_deinit_dev(pf);
 }
 
 /**
@@ -5323,10 +5316,14 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	}
 	pf->adapter = adapter;
 
-	err = ice_init(pf);
+	err = ice_init_dev(pf);
 	if (err)
 		goto unroll_adapter;
 
+	err = ice_init(pf);
+	if (err)
+		goto unroll_dev_init;
+
 	devl_lock(priv_to_devlink(pf));
 	err = ice_load(pf);
 	if (err)
@@ -5344,6 +5341,8 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 unroll_init:
 	devl_unlock(priv_to_devlink(pf));
 	ice_deinit(pf);
+unroll_dev_init:
+	ice_deinit_dev(pf);
 unroll_adapter:
 	ice_adapter_put(pdev);
 unroll_hw_init:
@@ -5457,6 +5456,7 @@ static void ice_remove(struct pci_dev *pdev)
 	devl_unlock(priv_to_devlink(pf));
 
 	ice_deinit(pf);
+	ice_deinit_dev(pf);
 	ice_vsi_release_all(pf);
 
 	ice_setup_mc_magic_wake(pf);
-- 
2.51.0



