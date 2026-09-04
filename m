Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35DB405C3F;
	Fri,  4 Sep 2026 05:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498610; cv=none; b=XBb5APWlGYXZb9v7lll4IDle+BQ55wsULC3nI/Rwm/ZuMD4yAdszZ48GtE33fKFGUhnjpCT1UXtYslSl8nPBkK2xBwsJn793Ky9ViCLpR2LXYfUtkT+PBa/ws9pKgDB4W5AZIKLIlOAKoAzgjiCySAhC4KGf0j1WwBfLnnWIKqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498610; c=relaxed/simple;
	bh=Kj+HjDcARhxQK977mRyCstZFYRF6qRDXy8ROrX1Hl7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3S/rbnBwHcnQfxTdVFiz5OLlOQA0FrIUZIO80XoqWj2/7veFrZBE4XWWMfgvozKNwqN/kP10VDWVeqpFCSMgr/hxYywnGcg3A+EPzsUgkD2iANV7d6PyzwKF0Carg/OQqI2llitor6nuU8pa1lneK3l//17NR/B3RbERlowIXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U/N2xlnq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U/N2xlnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C26B1F00A3D;
	Fri,  4 Sep 2026 05:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498609;
	bh=hl0zgcM81r0O1gaV9M0zrevXa+xgCTEhO7ETKOjOQSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U/N2xlnqDp1AKpnpYV1qfm1/4Sq87dW7GN4uEi5lQ/4l3ZJEs6fZsbi9JpfF8cIGX
	 E3uo6Q3yQ5vkPM7Rd0EhNoFlYk+v0XUOsaNOIjHDOhaEI35PekeYNDW/ndej84Kwx5
	 H4deaUH6T/Sbg94tMychd3bFhROCrYEwXkAxUPi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 7.2 122/713] KVM: arm64: GICv2: Dont WARN on out-of-range GICV_DIR INTID
Date: Fri,  4 Sep 2026 06:51:30 +0200
Message-ID: <20260904045806.570317128@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

commit c6d9c8ac6521d3049ec90ac58bebd23ed03ac496 upstream.

vgic_v2_deactivate() passes the INTID a guest wrote to GICV_DIR straight
to vgic_get_vcpu_irq(), and treats a failed lookup as a "can't happen"
condition with WARN_ON_ONCE().

The guest can make it happen at will, though: for any INTID outside of
the implemented SGI, PPI and SPI ranges the lookup returns NULL, since
GICv2 has no LPIs. A guest running with EOImode==1 writing such an INTID
to GICV_DIR triggers the WARN, and panics hosts running with
panic_on_warn.

Drop the WARN and ignore failed lookups.

Fixes: 255de897e7fb ("KVM: arm64: GICv2: Handle deactivation via GICV_DIR traps")
Cc: stable@vger.kernel.org
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260726174803.5880-1-kmehltretter@gmail.com
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic-v2.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -170,8 +170,9 @@ void vgic_v2_deactivate(struct kvm_vcpu
 	/* Make sure we're in the same context as LR handling */
 	local_irq_save(flags);
 
+	/* Guest-supplied INTID: out of range yields no irq, so ignore it */
 	irq = vgic_get_vcpu_irq(vcpu, val);
-	if (WARN_ON_ONCE(!irq))
+	if (!irq)
 		goto out;
 
 	/* See the corresponding v3 code for the rationale */


