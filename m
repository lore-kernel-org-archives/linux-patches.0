Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706822144C1;
	Wed,  7 May 2025 19:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645004; cv=none; b=L1iTLtS6bD1YSWTWdk1IcAS/P+cVmdPC8ZZjycrpgmPwm9oq+s+fuHNQoeY+yVhHZvYG5D2IIqatVYZWduiSevfdu71G5/aBcGQ0OANW2CLF2tKe7ktNzvL71ner+kr+rRKcUk0pBQ5G2PVfaPJvjrfstiejGblt2jh5AEekEf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645004; c=relaxed/simple;
	bh=xbfp8V0FwVth44WcS/wGElYUnNHdm3f1DMyhMh6rT3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b8BWHxSh+iuurRE0DkqYpDkb5t9ac1f+OR3+AkHXXOZVeHTk9n1i6TsdvhVgW9uYiYLK+zELdX7DjoeG6Muc9IB0xV5iZqnfjrvbPuaok6HXyRiZgIVgUWQUBjPd92TcOwbPeTqG9eoJcFcUycCAGjmH9U3O5FMjjlkWdNkgq9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrYVccfr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrYVccfr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC055C4CEE2;
	Wed,  7 May 2025 19:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645004;
	bh=xbfp8V0FwVth44WcS/wGElYUnNHdm3f1DMyhMh6rT3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrYVccfrqFnI4httN0GF2uETOOsYE8AAUh5tsRduKsTzVj8B0VXCfdZ7N3PzoFpiQ
	 iKHVkz6pCvl5IeH2bucm+KLLwjqR9+ZCDXDqPQphRVgN/N+oQPF8Vy86MnDwRFSVxB
	 NmObHarTlOcxmFwSXRIfO9MGyNLWw1jcjzpM6fZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/129] pds_core: delete VF dev on reset
Date: Wed,  7 May 2025 20:40:00 +0200
Message-ID: <20250507183816.118106972@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit 2dac60e062340c1e5c975ad6465192d11c40d47a ]

When the VF is hit with a reset, remove the aux device in
the prepare for reset and try to restore it after the reset.
The userland mechanics will need to recover and rebuild whatever
uses the device afterwards.

Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: dfd76010f8e8 ("pds_core: remove write-after-free of client_id")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/auxbus.c | 18 +++++++++++++++++-
 drivers/net/ethernet/amd/pds_core/main.c   | 16 ++++++++++++++++
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/pds_core/auxbus.c b/drivers/net/ethernet/amd/pds_core/auxbus.c
index fb7a5403e630d..b76a9b7e0aed6 100644
--- a/drivers/net/ethernet/amd/pds_core/auxbus.c
+++ b/drivers/net/ethernet/amd/pds_core/auxbus.c
@@ -177,6 +177,9 @@ int pdsc_auxbus_dev_del(struct pdsc *cf, struct pdsc *pf)
 	struct pds_auxiliary_dev *padev;
 	int err = 0;
 
+	if (!cf)
+		return -ENODEV;
+
 	mutex_lock(&pf->config_lock);
 
 	padev = pf->vfs[cf->vf_id].padev;
@@ -195,14 +198,27 @@ int pdsc_auxbus_dev_del(struct pdsc *cf, struct pdsc *pf)
 int pdsc_auxbus_dev_add(struct pdsc *cf, struct pdsc *pf)
 {
 	struct pds_auxiliary_dev *padev;
-	enum pds_core_vif_types vt;
 	char devname[PDS_DEVNAME_LEN];
+	enum pds_core_vif_types vt;
+	unsigned long mask;
 	u16 vt_support;
 	int client_id;
 	int err = 0;
 
+	if (!cf)
+		return -ENODEV;
+
 	mutex_lock(&pf->config_lock);
 
+	mask = BIT_ULL(PDSC_S_FW_DEAD) |
+	       BIT_ULL(PDSC_S_STOPPING_DRIVER);
+	if (cf->state & mask) {
+		dev_err(pf->dev, "%s: can't add dev, VF client in bad state %#lx\n",
+			__func__, cf->state);
+		err = -ENXIO;
+		goto out_unlock;
+	}
+
 	/* We only support vDPA so far, so it is the only one to
 	 * be verified that it is available in the Core device and
 	 * enabled in the devlink param.  In the future this might
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index eddbf0acdde77..346a69e95c880 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -475,6 +475,14 @@ static void pdsc_reset_prepare(struct pci_dev *pdev)
 	pdsc_stop_health_thread(pdsc);
 	pdsc_fw_down(pdsc);
 
+	if (pdev->is_virtfn) {
+		struct pdsc *pf;
+
+		pf = pdsc_get_pf_struct(pdsc->pdev);
+		if (!IS_ERR(pf))
+			pdsc_auxbus_dev_del(pdsc, pf);
+	}
+
 	pdsc_unmap_bars(pdsc);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
@@ -510,6 +518,14 @@ static void pdsc_reset_done(struct pci_dev *pdev)
 
 	pdsc_fw_up(pdsc);
 	pdsc_restart_health_thread(pdsc);
+
+	if (pdev->is_virtfn) {
+		struct pdsc *pf;
+
+		pf = pdsc_get_pf_struct(pdsc->pdev);
+		if (!IS_ERR(pf))
+			pdsc_auxbus_dev_add(pdsc, pf);
+	}
 }
 
 static const struct pci_error_handlers pdsc_err_handler = {
-- 
2.39.5



