Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F011A2586C4;
	Thu, 17 Apr 2025 18:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913129; cv=none; b=U15XMma02UeOhwQuTfffyj6AklM790AzTDdqqKhO1YB2OaGkdG/Kjp9P7W2iffi+GRkJqF3aDKXyiLfCU4tRZadJutoVCOdVapwOI0RMPbhq2V7GdtMVFqYKs8LigLXVr+viuBzOOSsipCwJBj5E1EezABPoJQXrg0O0Os+Zxxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913129; c=relaxed/simple;
	bh=odagQIebgCBsXAHSN4y0Yt9lqxNbpdIWIf555ZwuItI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKxx74w+46j7q+HFQE/PxgLORZu4DJtG8eJcpBHwv+3DEmHowa912HA643otLTrJxufEsvk1PN5aSMZ9QC+WslB7j9p/MCKQDtXQOBVA39K1w21qtOJzee6OaP8GmOkLH3M1kof8QV0s2TQJhZOR6tq3dUDUIUk3YLwkXZzRjfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KE8vnG5p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KE8vnG5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808DAC4CEE4;
	Thu, 17 Apr 2025 18:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913128;
	bh=odagQIebgCBsXAHSN4y0Yt9lqxNbpdIWIf555ZwuItI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KE8vnG5pXBbj/GOQInsApdyUmrFMwt1pQoZtbVLvYIDsBIcNVXU3T7C86Lx74eWPG
	 +XqVr2Q8qN0BwSotjlV2Z8htrRUYHAcxTX1OT6febbUoMD2g60dlRfat2lRC5333ey
	 A3xQKJrgmsSRxWUndUnuFPhvfPQYRKJEFA2Zrn68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Quentin Perret <qperret@google.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.14 237/449] KVM: arm64: Tear down vGIC on failed vCPU creation
Date: Thu, 17 Apr 2025 19:48:45 +0200
Message-ID: <20250417175127.536324006@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will@kernel.org>

commit 250f25367b58d8c65a1b060a2dda037eea09a672 upstream.

If kvm_arch_vcpu_create() fails to share the vCPU page with the
hypervisor, we propagate the error back to the ioctl but leave the
vGIC vCPU data initialised. Note only does this leak the corresponding
memory when the vCPU is destroyed but it can also lead to use-after-free
if the redistributor device handling tries to walk into the vCPU.

Add the missing cleanup to kvm_arch_vcpu_create(), ensuring that the
vGIC vCPU structures are destroyed on error.

Cc: <stable@vger.kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20250314133409.9123-1-will@kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/arm.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -466,7 +466,11 @@ int kvm_arch_vcpu_create(struct kvm_vcpu
 	if (err)
 		return err;
 
-	return kvm_share_hyp(vcpu, vcpu + 1);
+	err = kvm_share_hyp(vcpu, vcpu + 1);
+	if (err)
+		kvm_vgic_vcpu_destroy(vcpu);
+
+	return err;
 }
 
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)


