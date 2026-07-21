Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0483ACA5D;
	Tue, 21 Jul 2026 17:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654040; cv=none; b=oi5YgFmAcvuGdoWA4MSze2wsSYv68PWy0FdxHl5hqCQ7UKk4iqwipRn+AWeMgvx9Ol/lOLay8PrzvDIWjpKzM23UMooSOZ6tuZRCKHeK0g3qiwTAv0ZVrUZqHBBPOuLituyzwcGTvo+ANvrQVTdLZiIa4IRezgsE8Dxwla5xlbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654040; c=relaxed/simple;
	bh=p/hYyBET3fg2nSkcgRRDtw4GOQRperAGU1fG7JwOs6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5xpVG9+Ice271pqdRuyKL5WYEvvwz0H+2RIApuFjg/3/Jb0hcFWe0MzM3M/pNlfQL3dZml5grGHm7GlUFGsE20mee7kH7XGFs/bCAV8XU7Z5FCu4tj1IRLjr4e4h0NeuUxjtAi/K7WwxaZDsKDGc9SPSZmIoXuLl903armolcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D7jti4AS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D7jti4AS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88CD11F000E9;
	Tue, 21 Jul 2026 17:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654039;
	bh=aUU0xP6Gq4S7qWea/HeAZerIvlsyk1gEIQGSHkgzVsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D7jti4ASKFjxGG2E78FZI0NUMIJNv25cCujBVi17Jb9fbfkqEDQSsyQoCQhU8uI2h
	 YiTDf57TINDq+IOe/YNqXXKhA81sbtqfQEUfiJ/gDMzqd62ZpU0Op3ctLOQyX4d8ci
	 a15WvwJ15229hMOobYtRZPJhyrFzK+wRVEHS8oAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 7.1 1553/2077] KVM: s390: vsie: Add missing radix_tree_preload() in _gaccess_shadow_fault()
Date: Tue, 21 Jul 2026 17:20:26 +0200
Message-ID: <20260721152629.404706017@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

commit 668e70cc545e2659f3c4adad20a0883533042473 upstream.

Add missing radix_tree_preload() in _gaccess_shadow_fault() to
guarantee forward progress. The core of _gaccess_shadow_fault() has
been split into ___gaccess_shadow_fault() in order to simplify locking.

Fixes: e38c884df921 ("KVM: s390: Switch to new gmap")
CC: stable@vger.kernel.org # 7.1
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260611104850.110313-5-imbrenda@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/gaccess.c | 59 +++++++++++++++++++++++++----------------
 1 file changed, 36 insertions(+), 23 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 20e28b183c1a..0584fc91606f 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -1582,35 +1582,48 @@ static int _gaccess_do_shadow(struct kvm_s390_mmu_cache *mc, struct gmap *sg,
 	return _do_shadow_crste(sg, saddr, host, table, entries + LEVEL_MEM, w->p);
 }
 
-static inline int _gaccess_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg, gpa_t saddr,
-					unsigned long seq, struct pgtwalk *walk)
+static inline int ___gaccess_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg, gpa_t saddr,
+					  unsigned long seq, struct pgtwalk *walk)
 {
 	struct gmap *parent;
 	int rc;
 
+	if (kvm_s390_array_needs_retry_safe(vcpu->kvm, seq, walk->raw_entries))
+		return -EAGAIN;
+	parent = READ_ONCE(sg->parent);
+	if (!parent)
+		return -EAGAIN;
+	scoped_guard(spinlock, &parent->children_lock) {
+		if (READ_ONCE(sg->parent) != parent)
+			return -EAGAIN;
+		sg->invalidated = false;
+		rc = _gaccess_do_shadow(vcpu->arch.mc, sg, saddr, walk);
+	}
+	if (!rc)
+		kvm_s390_release_faultin_array(vcpu->kvm, walk->raw_entries, false);
+	return rc;
+}
+
+static inline int _gaccess_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg, gpa_t saddr,
+					unsigned long seq, struct pgtwalk *walk)
+{
+	int rc;
+
 	if (kvm_s390_array_needs_retry_unsafe(vcpu->kvm, seq, walk->raw_entries))
 		return -EAGAIN;
-again:
-	rc = kvm_s390_mmu_cache_topup(vcpu->arch.mc);
-	if (rc)
-		return rc;
-	scoped_guard(read_lock, &vcpu->kvm->mmu_lock) {
-		if (kvm_s390_array_needs_retry_safe(vcpu->kvm, seq, walk->raw_entries))
-			return -EAGAIN;
-		parent = READ_ONCE(sg->parent);
-		if (!parent)
-			return -EAGAIN;
-		scoped_guard(spinlock, &parent->children_lock) {
-			if (READ_ONCE(sg->parent) != parent)
-				return -EAGAIN;
-			sg->invalidated = false;
-			rc = _gaccess_do_shadow(vcpu->arch.mc, sg, saddr, walk);
-		}
-		if (rc == -ENOMEM)
-			goto again;
-		if (!rc)
-			kvm_s390_release_faultin_array(vcpu->kvm, walk->raw_entries, false);
-	}
+
+	do {
+		rc = kvm_s390_mmu_cache_topup(vcpu->arch.mc);
+		if (rc)
+			return rc;
+		rc = radix_tree_preload(GFP_KERNEL);
+		if (rc)
+			return rc;
+		scoped_guard(read_lock, &vcpu->kvm->mmu_lock)
+			rc = ___gaccess_shadow_fault(vcpu, sg, saddr, seq, walk);
+		radix_tree_preload_end();
+	} while (rc == -ENOMEM);
+
 	return rc;
 }
 
-- 
2.55.0



