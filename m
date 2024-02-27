Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2731474C9;
	Tue, 27 Feb 2024 14:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044217; cv=none; b=HsERiVz0sx/coTQXdLa3aqlqmd5bsAV69G1Mf0DaNqGbZZlO5PHmOXlRXoKz+XhSIPXGKMA9rFENBtr6pAybhUcQIjzCbYaVhDAws06vnXpp7E4KGotkfueFFQJmGkxtl+cvRVzPPKdAOsocj+zwKoDYzUQIu5PpnRh9kiZl3cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044217; c=relaxed/simple;
	bh=feii9K7xDS6buJ29i9Gl1PPsBNioYYONyZRy396AR+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6MQsZwGAKjkg5dKOvLyij5LD0I3sV1EH4zFEqng1vLFse9j+Z5HpiLeXK6BfF/uKLnpfIY6tB0SoRS3ea1LW9+19bRBIrRieW4NdFX+Ft1KZscGiTalFENFga+EmrZTkBNG137EuLnKxwEpQ6dr4CMTIStkXa8yrrqryEErL88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uY4xiAOA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uY4xiAOA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D37DC433C7;
	Tue, 27 Feb 2024 14:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044217;
	bh=feii9K7xDS6buJ29i9Gl1PPsBNioYYONyZRy396AR+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uY4xiAOApZxBxFn5C9xjVz8y6IEKoOw3GsYTqp7gpsMKQUIotBtS1vcvgvPAGDVBS
	 zHrTpcPCkweoc0eAOylMdou4j+uQM3M4SwulqeDerN47UzGhbH+ZDLDPMR0wzpnbCJ
	 duC//WBPx+31rOzJQN4XuD+iD12BDhfQUI3dKb1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.10 077/122] KVM: arm64: vgic-its: Test for valid IRQ in MOVALL handler
Date: Tue, 27 Feb 2024 14:27:18 +0100
Message-ID: <20240227131601.225565731@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1374,6 +1374,8 @@ static int vgic_its_cmd_handle_movall(st
 
 	for (i = 0; i < irq_count; i++) {
 		irq = vgic_get_irq(kvm, NULL, intids[i]);
+		if (!irq)
+			continue;
 
 		update_affinity(irq, vcpu2);
 


