Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7361913B2B9;
	Tue, 27 Feb 2024 14:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042682; cv=none; b=qXCsFe6tT/IHfoBMVJhIA7Za5jB4+WMvzJN/XFw8C6urGevYFYlpEpSYF7R+klJ+kCRHupi0KGEveMKL7oJCav+XAodBHJDpLvu29M6f8nmVLSjIXv4NaiZzVzlRIYkS3PdRhqbbJN142/TlEZAhRfSXqE+NW0yzty+Es40DMfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042682; c=relaxed/simple;
	bh=8AE2hxXG+FVNNnoEuJ0gpYWeC0hCbF+t2Ibx2Rxq2DE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSo51Fu7WE0DBctrWUYK5B3j2W4kHa8fGiucbWvT5uWAiiyPP19ElBt6DJ1kBBemvY5IocBy82eE/Qhzqy0bCLWU7IeFzAV7PY2FwzEUbLWTl8W26kvd/dVjVQkQH6UrjIZtRZ16GzcplJ3SIg7EwlcnFKmCihI/XTuPb9ALMuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nYnsyh3s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nYnsyh3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31F7C433F1;
	Tue, 27 Feb 2024 14:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042682;
	bh=8AE2hxXG+FVNNnoEuJ0gpYWeC0hCbF+t2Ibx2Rxq2DE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nYnsyh3s4OV6HfD7VW6/kywyUP2W3rnklLbJjRXenZTTNuHNkbNjsbUWTCfUjPX6C
	 K/yd6O+hyhuKTvd/E3bkcfUIsebvJ9tBDFsxo2EdYV5vgw23hkCGV8X/+cUbxvIA9i
	 4JkS7UjELc/3+LN5jmj0gYPgvl28ahyqYjYHUL0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.15 082/245] KVM: arm64: vgic-its: Test for valid IRQ in MOVALL handler
Date: Tue, 27 Feb 2024 14:24:30 +0100
Message-ID: <20240227131617.901798585@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


