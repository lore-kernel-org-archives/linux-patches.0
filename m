Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7813DD87D;
	Tue, 12 May 2026 17:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608137; cv=none; b=S8RzBAmhTlEejt9L71B0hl0aFV9E391I0+i3kUbmm+X8+en/KbiAdPvDkK7wfOnJllgWOHG6yNuUPAak4zW6/QIb333ibuYRb0195fCkDWcZQBv+RrCGnlxmsNIVCSPO7ROoPR3Lbx4eak71HIT96qGzQrM8OJ6WmKHmd9FubIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608137; c=relaxed/simple;
	bh=lKNnEz6/dK3QdqQC6JARPO3g/QdDHX80HRdCqtxXEOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QID6du8H81siHxbs3uSyLobkaGLEhzYOPvz45jA/poLHdCcq5TBO5E65P26J6QsMjvaxUH1mGlLM0qGP6jwUDmZpmWAJSgX4UfgdFZjfHqp1HoQJl/NPDXsX9wC9oTBN7FJHwZ/s/NeEh3keKhNVSvwFBrXMQmgd9ZWYQ7CmuYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WAsPQYEO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WAsPQYEO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81796C2BCF5;
	Tue, 12 May 2026 17:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608136;
	bh=lKNnEz6/dK3QdqQC6JARPO3g/QdDHX80HRdCqtxXEOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WAsPQYEO+1FaSLhckeBLX7/VelXY/cOSuSHW9F2GWPwLhuABdhPyudfKso2e5hBZP
	 01Ra73wG+G7KAUnNL2Uoc8q1OE/GazNptmhmSy7Paew0QX5a6TNO7o9WRjKACOeBza
	 N4py/n9vdsSFAqqj+3W7MotQ/++v6zwRKXF5o/0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.12 169/206] KVM: arm64: vgic: Fix IIDR revision field extracted from wrong value
Date: Tue, 12 May 2026 19:40:21 +0200
Message-ID: <20260512173936.441098459@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -167,7 +167,7 @@ static int vgic_mmio_uaccess_write_v3_mi
 		if ((reg ^ val) & ~GICD_IIDR_REVISION_MASK)
 			return -EINVAL;
 
-		reg = FIELD_GET(GICD_IIDR_REVISION_MASK, reg);
+		reg = FIELD_GET(GICD_IIDR_REVISION_MASK, val);
 		switch (reg) {
 		case KVM_VGIC_IMP_REV_2:
 		case KVM_VGIC_IMP_REV_3:


