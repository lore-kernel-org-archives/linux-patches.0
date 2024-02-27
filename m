Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4E813EFED;
	Tue, 27 Feb 2024 13:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041011; cv=none; b=VtvkGeA4J/HwLA5hGoTa6gr7Xyxh6YZmJglTrSiVARWvd1IU0n/YE8eV3eXA3U0CPymS/5dp1tpOMO9xByPzfnZgH2vioBT7kGZqtmydvD8j7De8wsxIIWcpLfbAMegMoU+I6YMMDGzQByPiuYv0S4tE1G93EalKAcN5olj0o/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041011; c=relaxed/simple;
	bh=l3NrOUo8gKws86L4qcXUyM4GHXbNi1LFe//kssKfj70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pu0kOQG3ze+tdNLepispcLcL6Z1L9BKIrxHEoEYf7itrkYoAxGadv267SyvO554VScsqRadIzoEqYkAwDAE9VRy15gC7e8/33feg0NdanwZDy2eqYxCV9pXpgV9sCdsIXkzIr5bJkaG48HvzB8wnv6/U68T/wiiNJylCrz5iHjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kVGHUs1l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kVGHUs1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A9BC433F1;
	Tue, 27 Feb 2024 13:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041010;
	bh=l3NrOUo8gKws86L4qcXUyM4GHXbNi1LFe//kssKfj70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kVGHUs1lXVKMs2rO1xNffDXFBx0nSMpVDl42NAvMuc8aHq9tcGGnPzJ17os0pL3Es
	 qgIxhFG2lf8RXn3W46BUeHI5mOSJh5xKdcNVsG5HaGsRvNgtjQJxmlAtNiUYRtEGR5
	 qiqd+iICvkxPS6TiWXeR+4jjjWssWPPZbYOskZVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.7 188/334] KVM: arm64: vgic-its: Test for valid IRQ in MOVALL handler
Date: Tue, 27 Feb 2024 14:20:46 +0100
Message-ID: <20240227131636.750697106@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1432,6 +1432,8 @@ static int vgic_its_cmd_handle_movall(st
 
 	for (i = 0; i < irq_count; i++) {
 		irq = vgic_get_irq(kvm, NULL, intids[i]);
+		if (!irq)
+			continue;
 
 		update_affinity(irq, vcpu2);
 


