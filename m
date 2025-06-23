Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769D17080E;
	Mon, 23 Jun 2025 22:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716500; cv=none; b=CSN9vPXY0kXgMG2qJnUjCMsh2x0TTKHXPIIVZTcVquYOWpsN4JMkIpf87/XfSdwWbTwM08P1ACbf1Ig/CWTVTCjWiLCPdMC6NKHn2uD8au+3BXvYtq0VdoXgQlFfZgBzFXK1pJs3xVGmpqw2/RQ7l1aQDCrzfb6A2L8VCN+uvy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716500; c=relaxed/simple;
	bh=vn71yLkYt256x5+9dncPhHS0Sach/z0PyUCcAk9Q5Ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AIeYc8MxOCKpCpi99/cLweYERc38HMOQ7UWKWBX3+o/90Xjddq3xW854p/OOJL/0lgs4FqgtTQvuGCbPSd+guwU2nUbn0wHqtdeaypCxPBBhAaMGm47r54KYRKrvENiPch2k+Lb4hqtIRxSgD0D3DT5RmnypKDfVu26eCsGhJ9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bEQt+TCv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bEQt+TCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA3AC4CEEA;
	Mon, 23 Jun 2025 22:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716500;
	bh=vn71yLkYt256x5+9dncPhHS0Sach/z0PyUCcAk9Q5Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bEQt+TCv12G0/C2eNdU9MV083YfXggMKazF+m6dc1ay3pyL77rRIIV8hfBHgKyT5P
	 m+nlDWxYaqrmZERMIhfLzKN7VP1QB1OGJqC/E4/4RPeFBuSABS46I2brIOTUCdR83d
	 Kyri5ofSIhiGdlANZhKut0rly5eg9BHUQdRDdFAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.15 556/592] KVM: arm64: VHE: Synchronize restore of host debug registers
Date: Mon, 23 Jun 2025 15:08:34 +0200
Message-ID: <20250623130713.668998481@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

commit cade3d57e456e69f67aa9894bf89dc8678796bb7 upstream.

When KVM runs in non-protected VHE mode, there's no context
synchronization event between __debug_switch_to_host() restoring the
host debug registers and __kvm_vcpu_run() unmasking debug exceptions.
Due to this, it's theoretically possible for the host to take an
unexpected debug exception due to the stale guest configuration.

This cannot happen in NVHE/HVHE mode as debug exceptions are masked in
the hyp code, and the exception return to the host will provide the
necessary context synchronization before debug exceptions can be taken.

For now, avoid the problem by adding an ISB after VHE hyp code restores
the host debug registers.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250617133718.4014181-2-mark.rutland@arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
@@ -167,6 +167,9 @@ static inline void __debug_switch_to_hos
 
 	__debug_save_state(guest_dbg, guest_ctxt);
 	__debug_restore_state(host_dbg, host_ctxt);
+
+	if (has_vhe())
+		isb();
 }
 
 #endif /* __ARM64_KVM_HYP_DEBUG_SR_H__ */


