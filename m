Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8716F3D961;
	Mon,  1 Apr 2024 16:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988305; cv=none; b=FRM/AfM7IyPPeBRH/gEZ5t4rUZ30LXw6SaJZuZuR7kM2gkdbhWQOxfhIW1ftTeRT1lCT714AJkr4xxhGLZemOJU5I6uOIc3YBQHVBEV9PondOHBiinnoPZ9UcTZv8R2n5XojanCKzXgkLQq+AdWOmvMr+pRxEvkpIvH+IdzZF6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988305; c=relaxed/simple;
	bh=nuiSUb8MrTqCKnGQejucqsMNTC9pDmwiFNezOS8DcHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lljmDp3f7uFFix/OqaYKc1bv/D8pb/ZF8gPHrQuurcNW0M+AGDNp9ySHUigqpXeGnVq7dwnlsfcRwLQGodQ1exWiNKe0aweV8Qatc8MXTQ3XfaOSmZIj9svhxqRuLMKKYGSKovFjUOkJlInP3ocseVqymW5PQX4zoN+t5Xo4ONE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R1/6OgXE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R1/6OgXE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAF3C433C7;
	Mon,  1 Apr 2024 16:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988305;
	bh=nuiSUb8MrTqCKnGQejucqsMNTC9pDmwiFNezOS8DcHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R1/6OgXEJtSzQJv1q1wWUQkqYuKpMSq/JmJqigzjwNfvPFK8YZ6sCHeozSWFiEbae
	 H3zbyD1aABAc+nvILw9jRjHjLAz7/ycQu9gDq1Pa/A1y3wvbHE0lmaEKUMfb4hLbf0
	 K7HClX2va+ny77BHx5X+hhg80ntAXMpuiV3R4oV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 146/432] i915: make inject_virtual_interrupt() void
Date: Mon,  1 Apr 2024 17:42:13 +0200
Message-ID: <20240401152557.493180297@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 675daf435e9f ("vfio/platform: Create persistent IRQ handlers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gvt/interrupt.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/interrupt.c b/drivers/gpu/drm/i915/gvt/interrupt.c
index de3f5903d1a7a..b32ba5f2b240e 100644
--- a/drivers/gpu/drm/i915/gvt/interrupt.c
+++ b/drivers/gpu/drm/i915/gvt/interrupt.c
@@ -422,7 +422,7 @@ static void init_irq_map(struct intel_gvt_irq *irq)
 #define MSI_CAP_DATA(offset) (offset + 8)
 #define MSI_CAP_EN 0x1
 
-static int inject_virtual_interrupt(struct intel_vgpu *vgpu)
+static void inject_virtual_interrupt(struct intel_vgpu *vgpu)
 {
 	unsigned long offset = vgpu->gvt->device_info.msi_cap_offset;
 	u16 control, data;
@@ -434,10 +434,10 @@ static int inject_virtual_interrupt(struct intel_vgpu *vgpu)
 
 	/* Do not generate MSI if MSIEN is disabled */
 	if (!(control & MSI_CAP_EN))
-		return 0;
+		return;
 
 	if (WARN(control & GENMASK(15, 1), "only support one MSI format\n"))
-		return -EINVAL;
+		return;
 
 	trace_inject_msi(vgpu->id, addr, data);
 
@@ -451,10 +451,9 @@ static int inject_virtual_interrupt(struct intel_vgpu *vgpu)
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



