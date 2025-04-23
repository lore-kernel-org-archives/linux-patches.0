Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9EB28CF6C;
	Wed, 23 Apr 2025 15:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421044; cv=none; b=r9MDQVs9gbkiFJu4ARwXB7TQ45QIfYOi2mKWHWLp4vQ2OkBVbDzdc3+nUHqgLm5XqrDO5+fNgoFpVyD5ybQouArhoSAC01WDylkFf+rdPkB9Txaw/A7yKHmOV1znm8jAuZqSqwJRzVoHxYDL8p6bXB/llnTlIUfqYUNfvlE2tCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421044; c=relaxed/simple;
	bh=P15eP17d98fbJ7o2DmPT+Mkxx6u5uPLbSsb3j+p2sE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4zQBcE59sJexFah3dmphLZzKQV6fp0F+EJ1RiKPP5R6w1PXEE9+2/mKX9YOXRAndOh3O1B/8zUrAi3p6T6SfIrP+56xv8/LUTOc03JdYR8DM8mZqB/ET9Yx9Me1qlvX9Yj3oJ/hn4soT0Tz1gzrcPPwRJt2O5sb2wWgwgW3bmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ha6LeBsM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ha6LeBsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE22C4CEE2;
	Wed, 23 Apr 2025 15:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421044;
	bh=P15eP17d98fbJ7o2DmPT+Mkxx6u5uPLbSsb3j+p2sE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ha6LeBsMlk4YikJmtskq2pL1OYWve1qChJldpktV8MKxrZxd0fEvUUMbqBj2mGWO0
	 zuorMvoe0YMVoTTjzMfJBWC3HvOkMyM7xmJBMhyt4TGmomHUDq2P+Whl3rPZ937dBy
	 9q0W4HlehcNjotfXsyAUk6fM/P6LkK7/HvJ5RQzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Quentin Perret <qperret@google.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 088/291] KVM: arm64: Tear down vGIC on failed vCPU creation
Date: Wed, 23 Apr 2025 16:41:17 +0200
Message-ID: <20250423142627.957196114@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -371,7 +371,11 @@ int kvm_arch_vcpu_create(struct kvm_vcpu
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


