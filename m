Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD68E13EFE9;
	Tue, 27 Feb 2024 14:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043712; cv=none; b=cbyvmcM8soUxZyzE7B1tWfQZ9bn76t0ycoxuMWyv9JJ/w+7c4ZXurRtToR/FQpr4h56l6wV53ZhWTnxXNmHzUQrha0a1XWVYahLtzDQcA5DqPvJLybkMvfd/J4VENbNWbYhHNc7yvGyOO4nsmISyyUJxFqwxO/ySXUCKD2cqdtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043712; c=relaxed/simple;
	bh=Ey8P+Bi/0KibeulrDBVHR26f0kpailZOzHieq71zBos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XS0J6wKLIS1j53x3WhVV07xRKV4c1TJWDJP0MU+qO+CQd8DDI1wB+6Dm2cDnSoWfT1Ej/YWWzRss/aTm2gi7Pd8wn1UKuZDSy09Xz87x0zVs1j+C+qzn9rCww8pDOkgnJyS/zmBxsfdnBxCV7uNqChwD/DhH8re+qi8s4GR0hxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j7lfhnlZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j7lfhnlZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6D2C433F1;
	Tue, 27 Feb 2024 14:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043712;
	bh=Ey8P+Bi/0KibeulrDBVHR26f0kpailZOzHieq71zBos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j7lfhnlZWGS1V8YMB0i7eQwgqQFkT2QoHYXToQ7WgVhWv3ZKhhJVjcCOvWH7r3s3u
	 BSu1SwH2zIFLgH0I2JTAPQwajWLvcAmBz5zT9sEiUaPZ2EcudAzN8wvF9pMPsjdmwt
	 3q3u0UnJNrwp7BX0fMxOugIndsP5EFqi4iH393aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.4 02/84] KVM: arm64: vgic-its: Test for valid IRQ in MOVALL handler
Date: Tue, 27 Feb 2024 14:26:29 +0100
Message-ID: <20240227131552.946973582@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 virt/kvm/arm/vgic/vgic-its.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1376,6 +1376,8 @@ static int vgic_its_cmd_handle_movall(st
 
 	for (i = 0; i < irq_count; i++) {
 		irq = vgic_get_irq(kvm, NULL, intids[i]);
+		if (!irq)
+			continue;
 
 		update_affinity(irq, vcpu2);
 


