Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F11D1B3934;
	Thu, 17 Apr 2025 18:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915683; cv=none; b=Uc9o87hw87RFI+ZmE8NA7Sw2ahdsw+LyeH+2ReZPu9Y8ccfxv+er3i4aBpqygJ1RP4C+9aa1DZnkEQa8gyY/zYorm5B4eMd0CGYMQrLbmvPBuyiqPSGuYnGPqWCorkjaQd3S5b5ecdRid9T83m+B/HWiMiTaF1PvhZK1kqCEUAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915683; c=relaxed/simple;
	bh=W4lZtm81hdSC4GZu7qzryIs28w+K4bKD4QjdpmFehfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdpBRqqPJtqtHMfF80OKCkDhcWP8q1YuF8wlqWqnKFBNXrJG+a57bWhVv8tklvV7RKvrtiwO72dLnffNa89S0oj5x5Us+IfNkskTGw34OgNVK2Gf1a3FWWeh5DgvxuI8WXI3XimXaIQ4/Mg6s3LbQAtxrxDjcLYXPXavTGwQNgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LXtUmkcy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LXtUmkcy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ECC8C4CEE4;
	Thu, 17 Apr 2025 18:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915683;
	bh=W4lZtm81hdSC4GZu7qzryIs28w+K4bKD4QjdpmFehfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LXtUmkcy2f+Cddd2HeWKLXvwrOQAdScPOpAdSkypvnJwSwBiNdK8sbortxNB1eOw3
	 VJ9GlXeHE1Jo4yFDW4ARQlwhNtbxAL1E+s9cysjEillBYpKOMR6Y6C+oO2OlJX9cpA
	 Rokz2xBEDvftCW7yt4+LrtX47FBfAmWsKsX03p+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Quentin Perret <qperret@google.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.12 206/393] KVM: arm64: Tear down vGIC on failed vCPU creation
Date: Thu, 17 Apr 2025 19:50:15 +0200
Message-ID: <20250417175115.868502784@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -493,7 +493,11 @@ int kvm_arch_vcpu_create(struct kvm_vcpu
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


