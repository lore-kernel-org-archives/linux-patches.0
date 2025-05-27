Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276D33C01;
	Tue, 27 May 2025 17:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367256; cv=none; b=pnfgj9FK1uQmkPdKQQDgRZm/fDq8oLTJNeXafqv8T55IqfEV9AlEvH85KDaExsyri1j3Ish9rAUTV7YGXtrHzB7OYtzHwtX3oSCYYUt9Vv+yZk+TTh97QOw/QCjuvP10V4+IaltPnbHUP3eRt7wkO63B5C+KZTFutthUZKDkx3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367256; c=relaxed/simple;
	bh=B9tnl6BcFThKLU+V2uxpZMZQSX5pFwCgyxW4otPtp/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lptCEbZSdsAUPNCOy59i7hYnbrLN84MFrZr9bEBUUSWgLqH+l/KCpN88P4t1oOFdg0lp05FEv49CkaJuzZMDoAk+dJ7KK2DrFeu/c/a7Ut6gmss4dKrp7zT/Ol0XH7rOrd97ac8eQX/axbT52ePcwTsBZIar7l2HJyTk/Hhg78g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opPLW5Rm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opPLW5Rm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92576C4CEE9;
	Tue, 27 May 2025 17:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367256;
	bh=B9tnl6BcFThKLU+V2uxpZMZQSX5pFwCgyxW4otPtp/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=opPLW5RmMoml3DnfhrZ+jVbvZUX7Tnx6rZ1sVu/SejqjI9FAkX9JhWrZNu+o98V62
	 K/zf9gZu8Cg1CCFEC/S2CHq39836JhnIihLQ9zznwbjZiC3VIGi6Ax/QGqdtfbeEPd
	 zrH+pGdusoISJJMqOu5i7xvcAJ4ZXRfFcnUsKV8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satyanarayana K V P <satyanarayana.k.v.p@intel.com>,
	=?UTF-8?q?Micha=C5=82=20Wajdeczko?= <michal.wajdeczko@intel.com>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
	=?UTF-8?q?Piotr=20Pi=C3=B3rkowski?= <piotr.piorkowski@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 329/783] drm/xe/pf: Create a link between PF and VF devices
Date: Tue, 27 May 2025 18:22:06 +0200
Message-ID: <20250527162526.457173777@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Satyanarayana K V P <satyanarayana.k.v.p@intel.com>

[ Upstream commit 8c0aff7d92e2be25717669eb65a81a89740a24f2 ]

When both PF and VF devices are enabled on the host, they
resume simultaneously during system resume.

However, the PF must finish provisioning the VF before any
VFs can successfully resume.

Establish a parent-child device link between the PF and VF
devices to ensure the correct order of resumption.

V4 -> V5:
- Added missing break in the error condition.
V3 -> V4:
- Made xe_pci_pf_get_vf_dev() as a static function and updated
  input parameter types.
- Updated xe_sriov_warn() to xe_sriov_abort() when VF device
  cannot be found.
V2 -> V3:
- Added function documentation for xe_pci_pf_get_vf_dev().
- Added assertion if not called from PF.
V1 -> V2:
- Added a helper function to get VF pci_dev.
- Updated xe_sriov_notice() to xe_sriov_warn() if vf pci_dev
  is not found.

Signed-off-by: Satyanarayana K V P <satyanarayana.k.v.p@intel.com>
Cc: Michał Wajdeczko <michal.wajdeczko@intel.com>
Cc: Michał Winiarski <michal.winiarski@intel.com>
Cc: Piotr Piórkowski <piotr.piorkowski@intel.com>
Reviewed-by: Piotr Piorkowski <piotr.piorkowski@intel.com>
Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250224102807.11065-2-satyanarayana.k.v.p@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pci_sriov.c | 51 +++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_pci_sriov.c b/drivers/gpu/drm/xe/xe_pci_sriov.c
index aaceee748287e..09ee8a06fe2ed 100644
--- a/drivers/gpu/drm/xe/xe_pci_sriov.c
+++ b/drivers/gpu/drm/xe/xe_pci_sriov.c
@@ -62,6 +62,55 @@ static void pf_reset_vfs(struct xe_device *xe, unsigned int num_vfs)
 			xe_gt_sriov_pf_control_trigger_flr(gt, n);
 }
 
+static struct pci_dev *xe_pci_pf_get_vf_dev(struct xe_device *xe, unsigned int vf_id)
+{
+	struct pci_dev *pdev = to_pci_dev(xe->drm.dev);
+
+	xe_assert(xe, IS_SRIOV_PF(xe));
+
+	/* caller must use pci_dev_put() */
+	return pci_get_domain_bus_and_slot(pci_domain_nr(pdev->bus),
+			pdev->bus->number,
+			pci_iov_virtfn_devfn(pdev, vf_id));
+}
+
+static void pf_link_vfs(struct xe_device *xe, int num_vfs)
+{
+	struct pci_dev *pdev_pf = to_pci_dev(xe->drm.dev);
+	struct device_link *link;
+	struct pci_dev *pdev_vf;
+	unsigned int n;
+
+	/*
+	 * When both PF and VF devices are enabled on the host, during system
+	 * resume they are resuming in parallel.
+	 *
+	 * But PF has to complete the provision of VF first to allow any VFs to
+	 * successfully resume.
+	 *
+	 * Create a parent-child device link between PF and VF devices that will
+	 * enforce correct resume order.
+	 */
+	for (n = 1; n <= num_vfs; n++) {
+		pdev_vf = xe_pci_pf_get_vf_dev(xe, n - 1);
+
+		/* unlikely, something weird is happening, abort */
+		if (!pdev_vf) {
+			xe_sriov_err(xe, "Cannot find VF%u device, aborting link%s creation!\n",
+				     n, str_plural(num_vfs));
+			break;
+		}
+
+		link = device_link_add(&pdev_vf->dev, &pdev_pf->dev,
+				       DL_FLAG_AUTOREMOVE_CONSUMER);
+		/* unlikely and harmless, continue with other VFs */
+		if (!link)
+			xe_sriov_notice(xe, "Failed linking VF%u\n", n);
+
+		pci_dev_put(pdev_vf);
+	}
+}
+
 static int pf_enable_vfs(struct xe_device *xe, int num_vfs)
 {
 	struct pci_dev *pdev = to_pci_dev(xe->drm.dev);
@@ -92,6 +141,8 @@ static int pf_enable_vfs(struct xe_device *xe, int num_vfs)
 	if (err < 0)
 		goto failed;
 
+	pf_link_vfs(xe, num_vfs);
+
 	xe_sriov_info(xe, "Enabled %u of %u VF%s\n",
 		      num_vfs, total_vfs, str_plural(total_vfs));
 	return num_vfs;
-- 
2.39.5



