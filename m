Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6FE13AA2F;
	Tue, 27 Feb 2024 13:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042066; cv=none; b=PBVcJpIzujnewviS/dCUsZfhQ8ME+MNAuVw7Pue+QYQxIK1rQam+oLrj5k/O2glfrdfH+V4OKnxH7mbupIhc8k9p+o0PwW7BjGXOutJi4HvdGsMr0z6zZhyqJkTaroU5b64rL8gDnpez3UXkmLN+Dtt0xbfFXMv2H2M32fXmf5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042066; c=relaxed/simple;
	bh=lomdsMYTUBhTAR1gTXPWwjtIjz2+6+INv9KVHaBDT48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l9fVo9QlUGhjoiE7SpfGynnLU7GvG7pt/KKYwGkELTi+CewhWiTS5Uy0tbVh+8cqmPNXS39o/i7JCNHwFNCpkj/sLVU9bYF0Nf551xqsdkWBJ4TUy3PEwhtcW28p07YuFsb25Ha7kySeFe1bUlN8iOhRpUwQ83Jjvdhp2HkW7UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S3xcQdAN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S3xcQdAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89023C433F1;
	Tue, 27 Feb 2024 13:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042065;
	bh=lomdsMYTUBhTAR1gTXPWwjtIjz2+6+INv9KVHaBDT48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S3xcQdANVMihgH7nFdPGWHxrEMEQfXEqZ3R64ExoG2v5JipKQ+3YfODCqBW49YkXZ
	 NgwMxYxlkgQbZcEtZ4k0eCnavJJoVTbHS9+gbJ/cpBUY+ALzE3RK2+kPwpMXliza/Y
	 Rtm+Jku4BL+/nHlk+EyLlOhQ8wy82v9/4QsYXs/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.6 167/299] KVM: arm64: vgic-its: Test for valid IRQ in MOVALL handler
Date: Tue, 27 Feb 2024 14:24:38 +0100
Message-ID: <20240227131631.221285443@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Upton <oliver.upton@linux.dev>

commit 85a71ee9a0700f6c18862ef3b0011ed9dad99aca upstream.

It is possible that an LPI mapped in a different ITS gets unmapped while
handling the MOVALL command. If that is the case, there is no state that
can be migrated to the destination. Silently ignore it and continue
migrating other LPIs.

Cc: stable@vger.kernel.org
Fixes: ff9c114394aa ("KVM: arm/arm64: GICv4: Handle MOVALL applied to a vPE")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20240221092732.4126848-3-oliver.upton@linux.dev
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic-its.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1427,6 +1427,8 @@ static int vgic_its_cmd_handle_movall(st
 
 	for (i = 0; i < irq_count; i++) {
 		irq = vgic_get_irq(kvm, NULL, intids[i]);
+		if (!irq)
+			continue;
 
 		update_affinity(irq, vcpu2);
 


