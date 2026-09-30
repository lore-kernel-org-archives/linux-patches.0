Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193D851DDF3;
	Wed, 30 Sep 2026 18:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792935; cv=none; b=sV4HxghRqwa1yql27frbHes/wiJg6T2Xkbod00BmNKZ3cassn8qKuU+Ls6ZwNI2hz40N+KPJmv0hzsalTaGGdnlQ3gQocO+3oL2ndojhNkw85ULooBoCssg/j++/m2knPpHjT5N6Io7kv1/qHL3ZUN1Qmtv8MHXG9M0jbvlO480=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792935; c=relaxed/simple;
	bh=patjh0NAwU3eWUHXDQB5P5QvCirxH+YxI+7dLPApxyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwkQHXniqUOX0iNqfX5epqSb/RMyWAPJEGPPkcEUBpcWjDKcTrfPOeE46kILReiQEGtlOe3hk9hDQn7+AXfa03FTsUoRj5YYh6OzVzG5aPK3UrEcDvR5htNlbN/y4WAHgN4HCGhWWF6j84xuOHa6lt+iIck0e4jEU5uD8F5whxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TPn6s4yA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TPn6s4yA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2061F00898;
	Wed, 30 Sep 2026 18:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792933;
	bh=wqH65eC8o0+tbyuc7SzwMDyx2FKyE8sQ6mAfSBg3EMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TPn6s4yA7eKOpGiYxAurYiQxPWq/E1beob7ibHKWfpqeJhDfwZ4wD/fL/ZRtHnOVO
	 ge8KAWrmpKs4eT+p6+wgM8N5sPChXWPOUXfMvU5TBWBOGS0RGhjspcIpn/QnY3Y7eu
	 PLhG4GJ9KUDuSmm7eS5YoBJesOPL+k4fVlM6Vq+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 032/395] KVM: arm64: vgic-its: Free the caches when GITS_BASER changes
Date: Wed, 30 Sep 2026 17:24:54 +0200
Message-ID: <20260930152341.318705968@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit 8cd92f77ae4f5371a7d581f8324c24919670b304 ]

A guest that disables the ITS and re-points or shrinks GITS_BASER<n>
with VALID still set keeps the devices and collections it mapped
against the old table, as KVM frees them only when VALID is cleared.
The contents of the table are IMPLEMENTATION DEFINED, so a write that
gives GITS_BASER<n> a different address or size may lose whatever the
old value described. Free the list whenever the stored value changes,
and drop the translation cache with it.

The cache is not empty just because the ITS is disabled: its->enabled
is written under the cmd_lock, while vgic_its_resolve_lpi() tests it
under the its_lock, so an injection can still cache an entry after the
ITS was disabled. Hence the invalidation inside the its_lock section.

Test for a change rather than a write: its_restore_enable() rewrites
GITS_BASER<n> from its probe-time cache on resume, and KVM reports
GITS_TYPER.HCC as 0, so nothing re-maps the boot CPU's collection
afterwards.

Fixes: 36d6961c2b481 ("KVM: arm/arm64: vgic-its: Free caches when GITS_BASER Valid bit is cleared")
Suggested-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/all/87ecg9owwa.wl-maz@kernel.org/
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://patch.msgid.link/20260821064445.615838-2-fuad.tabba@linux.dev
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-its.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index cdaf2af5e765d..9b5f8d308fac0 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1648,7 +1648,7 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
 				      unsigned long val)
 {
 	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
-	u64 entry_size, table_type;
+	u64 old, entry_size, table_type;
 	u64 reg, *regptr, clearbits = 0;
 
 	/* When GITS_CTLR.Enable is 1, we ignore write accesses. */
@@ -1671,7 +1671,9 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
 		return;
 	}
 
-	reg = update_64bit_reg(*regptr, addr & 7, len, val);
+	old = *regptr;
+
+	reg = update_64bit_reg(old, addr & 7, len, val);
 	reg &= ~GITS_BASER_RO_MASK;
 	reg &= ~clearbits;
 
@@ -1681,7 +1683,8 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
 
 	*regptr = reg;
 
-	if (!(reg & GITS_BASER_VALID)) {
+	/* The ITS driver rewrites an unchanged GITS_BASER<n> on resume. */
+	if (reg != old) {
 		/* Take the its_lock to prevent a race with a save/restore */
 		mutex_lock(&its->its_lock);
 		switch (table_type) {
@@ -1692,6 +1695,8 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
 			vgic_its_free_collection_list(kvm, its);
 			break;
 		}
+		/* A concurrent injection may have cached a translation. */
+		vgic_its_invalidate_cache(its);
 		mutex_unlock(&its->its_lock);
 	}
 }
-- 
2.53.0



