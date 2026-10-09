Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECDC3431F5;
	Fri,  9 Oct 2026 14:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556080; cv=none; b=s3jA3n/T+Xz9hoGBX8du5fgswgpERKcm6OR65TyvLK9z2Lox+UF8AC3k33G4Z7sge/3y+dGo5O/9QON5gjpBR7JKmuGiEPOjxVfnk7o9TigB/Ljx5ZXWAez4XmsuyGR/jAt28xg5qpgWU0aUwtx6/g4dGeJYvREZb5es06Xyqpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556080; c=relaxed/simple;
	bh=vtrsybf1oyoZKZthb4bkpsd4eJHeyr9L6DjOA5E/Fl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UpoG2MBAU6L5ISFhXPS5M6kPbOV/+qBn//a2xh5E82ZqUR7mehPaiHQ3k9vArgfM3t1pv5laB8G84NovgZRnLxDLDlGq2ptRJGKLMO4DJS2BjIlGJtZ//jKinc8QEJMshT4DCWc5+ly2ezQScRHdZIenFabeIHEYwJmoGqpr3as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLCz2bet; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLCz2bet"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CAD31F000FF;
	Fri,  9 Oct 2026 14:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556079;
	bh=n0HECNfIgAGA6s26iZLJDgE5ZeOXUIN2tEfP9KrKH94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uLCz2betEmwL4VFU0S57hS3iiSCCvXmjIWaY3AChMakVgriDv70Kadxv3iRXcps1l
	 z2UaNWrgcqH/XoyULR8hJuJurEK8sF1v8FXD8v4kVO5hTH6RF7djH2Kfx/dIACNo8d
	 9dDV8kNWys89U5TC8CFNn3MDjJvaUFdSv3eOCEsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcin Bernatowicz <marcin.bernatowicz@linux.intel.com>,
	=?UTF-8?q?Micha=C5=82=20Wajdeczko?= <michal.wajdeczko@intel.com>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 117/428] drm/xe/pf: Keep VF LMEM BAR size low if no VFs enabled
Date: Fri,  9 Oct 2026 16:07:34 +0200
Message-ID: <20261009140948.767091826@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcin Bernatowicz <marcin.bernatowicz@linux.intel.com>

[ Upstream commit 72207463f7a4a6818a88f4ef57802b42da534301 ]

When VFs are enabled on dGFX the driver resizes the PF VF_LMEM_BAR to
fit the requested layout. After VFs are disabled the PF VF BAR
size is left as-is. On platforms with tight MMIO apertures a
subsequent unplug/rescan followed by another enable may fail with:

  "VF BAR …: can't assign; no space"

because the PCI core reserves address space based on the (now large) VF
template, often multiplied by totalvfs.

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/5937
Fixes: 94eae6ee4c2d ("drm/xe/pf: Set VF LMEM BAR size")
Signed-off-by: Marcin Bernatowicz <marcin.bernatowicz@linux.intel.com>
Cc: Michał Wajdeczko <michal.wajdeczko@intel.com>
Cc: Michał Winiarski <michal.winiarski@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patch.msgid.link/20260918110130.700332-1-marcin.bernatowicz@linux.intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 0646547a67d25c407f5a4ac71b4eefe8b941202b)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pci_sriov.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_pci_sriov.c b/drivers/gpu/drm/xe/xe_pci_sriov.c
index c023a2a1fc171..31abcee552115 100644
--- a/drivers/gpu/drm/xe/xe_pci_sriov.c
+++ b/drivers/gpu/drm/xe/xe_pci_sriov.c
@@ -177,6 +177,7 @@ static int pf_enable_vfs(struct xe_device *xe, int num_vfs)
 	return num_vfs;
 
 failed:
+	pf_resize_vf_vram_bar(xe, xe->sriov.pf.device_total_vfs);
 	xe_sriov_pf_unprovision_vfs(xe, num_vfs);
 	xe_pm_runtime_put(xe);
 	pf_finish_vfs_enabling(xe);
@@ -204,6 +205,8 @@ static int pf_disable_vfs(struct xe_device *xe)
 
 	pci_disable_sriov(pdev);
 
+	pf_resize_vf_vram_bar(xe, xe->sriov.pf.device_total_vfs);
+
 	xe_sriov_pf_reprovision_default(xe);
 
 	pf_reset_vfs(xe, num_vfs);
-- 
2.53.0



