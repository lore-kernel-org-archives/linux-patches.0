Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFE738E8AD;
	Fri,  7 Aug 2026 15:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116661; cv=none; b=p6aUKK561m0ZVD5JlT2J9GukbZtVjmS9gK/5d9XXosZYCt0dhmKjPKp1SWrohopT+Pl/UbKf3goR5pktfdOd7PDZ+5MVTvhbtzWHPkvGgt12KcCmeYPoyCUeAIR5Xc1KRDn1vTeq5Jm5gs+0+6Op+/XOBJcll9SizvrsTN91qNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116661; c=relaxed/simple;
	bh=wO6E0BIPlk+wAzQZ4Tc1x2YFz2VJUnmVrtGLc0/q2lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OGVU67aUak+1KdJmrAK3bmFHoimKOLCmcvqyD7lBhqwoMYv7cHXTxqOJaW/VeKJO6PiCyPKiAJIZDji98Gmt0XmTA/qT1qtOHEumXFmtmWPO5lVKomRpNBiJY3mnj2dQ7iE+8Hp8OU/WCnQOtrRZesu9unwmjQ3+oKj3jAb65G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wtHWcPG7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtHWcPG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEA41F000E9;
	Fri,  7 Aug 2026 15:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116660;
	bh=AV4e2ZKFk3b34/5xUECBE0Z0i612zhaUO0a9pz4RDfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wtHWcPG7hSLDVQNwBjNfT+UVkL8rZKgcFHOXyAtyxpi3PmC/+rF1HKrt0bdAwBBM7
	 Wvn8AUlwRtkqKLeEEdlBn2hOC/36lvJcOazs4wcW/4b+qvZOr4m7T+5aD2jF05p3zv
	 T8fKGs72gPpzkbyciWK0j42ndziWPxtIf0gtx4K4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 046/438] KVM: arm64: vgic: Mitigate potential LPI registration failure
Date: Fri,  7 Aug 2026 16:34:02 +0200
Message-ID: <20260807143428.978645156@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos López <clopez@suse.de>

[ Upstream commit 21f12496fdd357ad4e1fcdd07dc80ab7378f7d24 ]

Mitigate a potential failure when inserting a new LPI into the VGIC LPI
xarray.

When vgic_add_lpi() is preparing to register a new LPI, it pre-allocates
an xarray entry using xa_reserve_irq(), so that it can later perform the
insertion under the xarray lock without allocating.

However, since xa_reserve_irq() is called before acquiring such lock,
there is a potential race where xa_reserve_irq() observes a populated
entry, thus not performing the allocation, and another CPU removes that
entry before the xarray lock is grabbed to perform the insertion.

  CPU0 (Adding new LPI)                      CPU1 (Releasing LPI)
  =====================                      ===================
  vgic_add_lpi()
      /* Entry populated, does not allocate */
      xa_reserve_irq(.., intid, ..)
                                            vgic_release_deleted_lpis()
                                                xa_lock_irqsave()
                                                vgic_release_lpi_locked()
                          xarray node freed --> __xa_erase(.., intid)
                                                xa_unlock_irqrestore()
      xa_lock_irqsave()
      xa_load(.., intid) == NULL
      vgic_try_get_irq_ref(NULL) == false
      __xa_store(.., intid, irq, 0) <-- xarray node was freed, gfp=0
                                        cannot allocate, returns -ENOMEM

This can happen e.g. if the guest issues a DISCARD while the LPI is
still referenced from a vCPU's active-pending list (ap_list), and the
same INTID is re-mapped via MAPTI.

Mitigate this by passing GFP_NOWAIT to __xa_store(), so that the
allocation can happen under the lock in the rare case that this
condition is hit. Add __GFP_ACCOUNT as well to match xa_reserve_irq()'s
flags.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 1d6f83f60f79 ("KVM: arm64: vgic: Store LPIs in an xarray")
Signed-off-by: Carlos López <clopez@suse.de>
Link: https://patch.msgid.link/20260715105137.3973823-5-clopez@suse.de
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-its.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index e9ef7686a9524..c15f1867adc20 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -121,7 +121,8 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 		 * from the deferred release path, pending cleanup by
 		 * vgic_release_deleted_lpis(). Evict and free it if present.
 		 */
-		oldirq = __xa_store(&dist->lpi_xa, intid, irq, 0);
+		oldirq = __xa_store(&dist->lpi_xa, intid, irq,
+				    GFP_NOWAIT | __GFP_ACCOUNT);
 		ret = xa_err(oldirq);
 		if (ret) {
 			xa_unlock_irqrestore(&dist->lpi_xa, flags);
-- 
2.53.0



