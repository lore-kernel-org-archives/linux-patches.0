Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840AD23E6D9;
	Thu, 12 Dec 2024 16:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020744; cv=none; b=qWP8fibfxngopplXfAWBvsWXlC70m5QFbvQD2I0qJ+ZgdANob6xli0vXeJiYDN2fRyaIu5c8/E8sYEn3OVAkbpnNZtsjdIGRNi7WvuIwSPXZtrVANqYBR8Un095o2juQ2+H5SyXCuJ/N3Rd9IPVxjELFIAWsRsL9kE03sfc2xsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020744; c=relaxed/simple;
	bh=FE2oINCrKowK+mVVehe77y5ObRGOzEj1qshDa1J0ypU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+cvT1UHKsjwXc5QA7pi/QT62ZEhlK5fay48j+dqP5051rIHWPLLxjfI1D0iM2C0LQcEVijRHM+AXxIQYwgqWF3YxxfsB1WtXF4uRdC22GKuo/EoOISDrvBIlDTIGmVBu20yqIWOn5M6B6u5EOCS/EkgyZNEekTtesLzhMqxpKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IUT68/vh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IUT68/vh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79A9C4CECE;
	Thu, 12 Dec 2024 16:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020744;
	bh=FE2oINCrKowK+mVVehe77y5ObRGOzEj1qshDa1J0ypU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IUT68/vhTGn93gjvARGuK+OF+LoiaJ+qqBSz8pGPvRF56anm2yrhLWNaxQAIPICFD
	 QkzMhwwxiwDXXrdzky1EKUHn46fpxWkRS/MzngMewJFqsj592MhX2L/jp9aTH4gUiv
	 sUJm3iOGClZguvDh0c+2eAXYYyXi3GssAb1Gj50E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 547/772] KVM: arm64: Change kvm_handle_mmio_return() return polarity
Date: Thu, 12 Dec 2024 15:58:12 +0100
Message-ID: <20241212144412.569983511@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fuad Tabba <tabba@google.com>

[ Upstream commit cc81b6dfc3bc82c3a2600eefbd3823bdb2190197 ]

Most exit handlers return <= 0 to indicate that the host needs to
handle the exit. Make kvm_handle_mmio_return() consistent with
the exit handlers in handle_exit(). This makes the code easier to
reason about, and makes it easier to add other handlers in future
patches.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
Acked-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20240423150538.2103045-15-tabba@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Stable-dep-of: e735a5da6442 ("KVM: arm64: Don't retire aborted MMIO instruction")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/arm.c  | 2 +-
 arch/arm64/kvm/mmio.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index cf7e10587fb09..3a05f364b4b6d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -876,7 +876,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	if (run->exit_reason == KVM_EXIT_MMIO) {
 		ret = kvm_handle_mmio_return(vcpu);
-		if (ret)
+		if (ret <= 0)
 			return ret;
 	}
 
diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index 3dd38a151d2a6..886ef30e12196 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -86,7 +86,7 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
 
 	/* Detect an already handled MMIO return */
 	if (unlikely(!vcpu->mmio_needed))
-		return 0;
+		return 1;
 
 	vcpu->mmio_needed = 0;
 
@@ -117,7 +117,7 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
 	 */
 	kvm_incr_pc(vcpu);
 
-	return 0;
+	return 1;
 }
 
 int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
-- 
2.43.0



