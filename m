Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A22633B6CC;
	Tue, 12 May 2026 18:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608838; cv=none; b=mPGQMHTnUM70TaZRVhsPhTGwhcxAx5EJXlxY2reFHzfdxbP+4I11ReRVurAhFdqddoZT9Z9mLfjn1QtWsQ5GShcx4isWXCfN5JF+cWaxQhxtifJ2Cj0a9gFQVglKostMeMMt/xM4qvMOp8MQa8FiesTQA1cWoXRJU9ht7p0G5sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608838; c=relaxed/simple;
	bh=rQg/b53NwfpBPyLSFK1pSE0TfZJg3cIIydEEqsh+bNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gxogxvbQ6NYPFH4K63Rchl9DpxdmvfflcU5ZbLJhuJTUsqcanlQZO0WbWktPC9wJ0WHeyYVviLHYT64o2kI0ABUAgyvAuWwNHq5eWDVVEzrucWuuKK8k3ZZgHZKajsKc1/rO+zotfRTzCrZsARNHJxKPJqqagiERO6Q7jBW1S1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XDbewy3v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XDbewy3v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C17C2BCB0;
	Tue, 12 May 2026 18:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608838;
	bh=rQg/b53NwfpBPyLSFK1pSE0TfZJg3cIIydEEqsh+bNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XDbewy3v2gcNpAY8ZiUZ/nkje3dr6RfisgWjcP01ZO4xMfN8PcdEZ6ZmkgxPv0FM2
	 JWGpIC1oQk9JlEh2d5nwo7U4I5WLgH0lZh8nKNaSfGgVMj7129HbtrsPgW1we7LNfJ
	 egZVxQX59Ebzh0VRcq4YUw3TFWmgWqsiawI7qE50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.18 234/270] KVM: arm64: vgic: Fix IIDR revision field extracted from wrong value
Date: Tue, 12 May 2026 19:40:35 +0200
Message-ID: <20260512173943.370431498@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


