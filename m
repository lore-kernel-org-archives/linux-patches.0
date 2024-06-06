Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411541BE862;
	Thu,  6 Jun 2024 14:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683546; cv=none; b=WZEq+jCBYxQHoFLgafxb3SK59rVaUAknDciAkLYrsk/LMXaWHjil9KUyhnQBMUxfuzbLRSK5/PnSOUxnHdEbRaItYpGRnmUeNghhDcWyw5J8F+xUphnbZ+rjUd9icPvSTdTvvU/ot2TVup0izeZGIaxUf4hw5damyCZtdntgqyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683546; c=relaxed/simple;
	bh=U2dTqW78BBUwRKBXi8N9FZituDOtefBzfUqwXKpzLog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOMWMVTw+76LNJxtC2O4EEjcAsqdezr7KII1aRsgs4p2lek4cr/FLjUYH1CDW1IR+AlPMd9cVszuFDjk5N2InBSpljsaEuOldXNJUuENFS4+wAjD3jHVYhM2uCuYPsLn08aak3C9JiRvITgw9Juvm39bZVPIAjf/64NFdYvPrWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VsUYmBRL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VsUYmBRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6FDC2BD10;
	Thu,  6 Jun 2024 14:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683546;
	bh=U2dTqW78BBUwRKBXi8N9FZituDOtefBzfUqwXKpzLog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VsUYmBRLfy6xkniA2OqZXF0b3p2BzngDZBAztqpm4pRyGHB/TcE1lb6KyxEm045FZ
	 IQ6a2mFj9juZZIzGU6OMXE0idVt/R/A/cTbLa7ZqtJzbmHjHUioVCxzqdzdwNP8CrI
	 OY3u4lGWK7Ct/gFRBwOubZvXGhRkx3pD46TqxOzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 458/744] i915: make inject_virtual_interrupt() void
Date: Thu,  6 Jun 2024 16:02:10 +0200
Message-ID: <20240606131747.155571564@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 85884871921000b9bca2184077b1159771e50047 ]

The single caller of inject_virtual_interrupt() ignores the return value
anyway. This allows us to simplify eventfd_signal() in follow-up
patches.

Link: https://lore.kernel.org/r/20231122-vfs-eventfd-signal-v2-1-bd549b14ce0c@kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 82b951e6fbd3 ("vfio/pci: fix potential memory leak in vfio_intx_enable()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gvt/interrupt.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/interrupt.c b/drivers/gpu/drm/i915/gvt/interrupt.c
index 68eca023bbc68..80301472ac988 100644
--- a/drivers/gpu/drm/i915/gvt/interrupt.c
+++ b/drivers/gpu/drm/i915/gvt/interrupt.c
@@ -405,7 +405,7 @@ static void init_irq_map(struct intel_gvt_irq *irq)
 #define MSI_CAP_DATA(offset) (offset + 8)
 #define MSI_CAP_EN 0x1
 
-static int inject_virtual_interrupt(struct intel_vgpu *vgpu)
+static void inject_virtual_interrupt(struct intel_vgpu *vgpu)
 {
 	unsigned long offset = vgpu->gvt->device_info.msi_cap_offset;
 	u16 control, data;
@@ -417,10 +417,10 @@ static int inject_virtual_interrupt(struct intel_vgpu *vgpu)
 
 	/* Do not generate MSI if MSIEN is disabled */
 	if (!(control & MSI_CAP_EN))
-		return 0;
+		return;
 
 	if (WARN(control & GENMASK(15, 1), "only support one MSI format\n"))
-		return -EINVAL;
+		return;
 
 	trace_inject_msi(vgpu->id, addr, data);
 
@@ -434,10 +434,9 @@ static int inject_virtual_interrupt(struct intel_vgpu *vgpu)
 	 * returned and don't inject interrupt into guest.
 	 */
 	if (!test_bit(INTEL_VGPU_STATUS_ATTACHED, vgpu->status))
-		return -ESRCH;
-	if (vgpu->msi_trigger && eventfd_signal(vgpu->msi_trigger, 1) != 1)
-		return -EFAULT;
-	return 0;
+		return;
+	if (vgpu->msi_trigger)
+		eventfd_signal(vgpu->msi_trigger, 1);
 }
 
 static void propagate_event(struct intel_gvt_irq *irq,
-- 
2.43.0



