Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE8837C0E3;
	Tue, 12 May 2026 18:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609656; cv=none; b=HngzfjBDPMChpo/o0D6/vgwJR5GM6XnQCFYsecY3wxLML5u+iidqi7/aaHuQKKiG/oW4TGgVR4PIld72YqM3wpnG8+H/a8qFzq1tPiX07xOhSoyzl2lZQj0xLVzmXOZbwc4Fy6p/kJVIp8RkJq6Bz7ihxkO0dBRwjJaqC/O3aEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609656; c=relaxed/simple;
	bh=oG1vofbbggqxQZ3ycyeJ8VguIMTiyfyytjehiGa0hjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pLcQZmGGlTKNvRGaZns97/t6qzK6Vqu8WPmHOMEBrpe7QOqJ0gs3iA+KKcWB3BNHiy1PGUUqFJVH5nS2KjYafMALHPxPMs0+CyWEGE23G1XT4Fi1h/hzbdGoZQ8QY6bM/V0Laos4QAPIILOABFFWIVO5ZmGBGLKCYYQEUbNECLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yJn9rxY6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yJn9rxY6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146FBC2BCC7;
	Tue, 12 May 2026 18:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609656;
	bh=oG1vofbbggqxQZ3ycyeJ8VguIMTiyfyytjehiGa0hjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yJn9rxY68DlzNu+M31JPivG2H0a10hmB+P9MuL+aNSAbIEJcNoAEExlCBMuPJiBbb
	 pu4jz0s92dj/vQREP2QHe+BR+phZuw/iNBxWx5IKmpQHt26fCY2gWadC6x10xh8trc
	 W0n8ndG2yqxIfh1zw7Dz6toMKDmwJSAP/uFcbBQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 7.0 279/307] KVM: arm64: vgic: Fix IIDR revision field extracted from wrong value
Date: Tue, 12 May 2026 19:41:14 +0200
Message-ID: <20260512173946.016404336@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw@amazon.co.uk>

commit a0e6ae45af17e8b27958830595799c702ffbab8d upstream.

The uaccess write handlers for GICD_IIDR in both GICv2 and GICv3
extract the revision field from 'reg' (the current IIDR value read back
from the emulated distributor) instead of 'val' (the value userspace is
trying to write). This means userspace can never actually change the
implementation revision — the extracted value is always the current one.

Fix the FIELD_GET to use 'val' so that userspace can select a different
revision for migration compatibility.

Fixes: 49a1a2c70a7f ("KVM: arm64: vgic-v3: Advertise GICR_CTLR.{IR, CES} as a new GICD_IIDR revision")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Link: https://patch.msgid.link/20260407210949.2076251-2-dwmw2@infradead.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic-mmio-v2.c |    2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/kvm/vgic/vgic-mmio-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
@@ -91,7 +91,7 @@ static int vgic_mmio_uaccess_write_v2_mi
 		 * migration from old kernels to new kernels with legacy
 		 * userspace.
 		 */
-		reg = FIELD_GET(GICD_IIDR_REVISION_MASK, reg);
+		reg = FIELD_GET(GICD_IIDR_REVISION_MASK, val);
 		switch (reg) {
 		case KVM_VGIC_IMP_REV_2:
 		case KVM_VGIC_IMP_REV_3:
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -194,7 +194,7 @@ static int vgic_mmio_uaccess_write_v3_mi
 		if ((reg ^ val) & ~GICD_IIDR_REVISION_MASK)
 			return -EINVAL;
 
-		reg = FIELD_GET(GICD_IIDR_REVISION_MASK, reg);
+		reg = FIELD_GET(GICD_IIDR_REVISION_MASK, val);
 		switch (reg) {
 		case KVM_VGIC_IMP_REV_2:
 		case KVM_VGIC_IMP_REV_3:


