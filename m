Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D6D4D2EFE;
	Wed, 30 Sep 2026 17:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787891; cv=none; b=nmk9+6por4HdcalJv6Ujng3MUrO+xhNnwiGAU2Grz65i8wmnaTopo3mNBfeJiKOWIqRTps1+lBNJopPBdq/7clTNTsWHxd4Z6StJju2lU+IGcwE+GRq5OCw9H6HUmQrjoz6Jb70W/bao0sUoWR6HspZBN2ldjJxoth5wPDxTBfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787891; c=relaxed/simple;
	bh=SxV66zosnPeWDfdGjrhZe0GQSrCtM6KZo3lBXFeGmtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6tVkrik3IwEV9Bx3jW1hI+DdiXVGDl6mJpYyPWEkuzOVH9yBvESX/IQP64VYBV3oQLHxukOTe9piyV3WS1aGgotkCTVsqVD7IAPOETOTDcda9/t41XVvyAju9neAFho8mN9f4F4c8YAHvKxFFE9swyfwKWOx+ii6833Viv0NII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GYbYSfqX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GYbYSfqX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2773B1F000FF;
	Wed, 30 Sep 2026 17:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787890;
	bh=jI4IcAcXcSm9oZAf7HZwkF534DU4ILbPAtpBC5Q5eLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GYbYSfqXdObwo9AOoCcCVlmPFwCUjvQn1P2JPDKxvJ6bnz7KIYkB8AguuiVQSAJ+0
	 jOySXh66GWLm7KudrSR+5ermPTjfQOaTAf5VxKObTtO+yLYHsll7rzQQ+IVbc2ivp7
	 nknGxLHt78aCfAyYkAXWiiQbqJyZURoOUjXPF9tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 7.2 388/457] KVM: arm64: Fix AArch32 DBGBXVR<n> handling
Date: Wed, 30 Sep 2026 17:28:13 +0200
Message-ID: <20260930152354.369564098@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

commit 6b1bca1b1ab77f60a62087337bfe6e2f0efb9e6d upstream.

The consolidation of the breakpoint and watchpoint register accessors
switched DBGBXVR<n> from trap_bvr() to trap_dbg_wb_reg(). The latter
selects backing storage with demux_wb_reg(), which only handles Op2 values
4 through 7. Since DBGBXVR<n> uses Op2 1, an AArch32 guest access hits
KVM_BUG_ON() and marks the VM dead.

DBGBXVR<n> aliases DBGBVR<n>_EL1[63:32], and its AA32(HI) descriptor
already selects the upper half. Map Op2 1 to dbg_bvr[] alongside Op2 4,
restoring the pre-regression behavior.

Fixes: 3ce9f3357e9e ("KVM: arm64: Fold DBGxVR/DBGxCR accessors into common set")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://patch.msgid.link/20260810005616.13227-1-kmehltretter@gmail.com
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/sys_regs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -889,6 +889,7 @@ static u64 *demux_wb_reg(struct kvm_vcpu
 	struct kvm_guest_debug_arch *dbg = &vcpu->arch.vcpu_debug_state;
 
 	switch (rd->Op2) {
+	case 0b001:
 	case 0b100:
 		return &dbg->dbg_bvr[rd->CRm];
 	case 0b101:


