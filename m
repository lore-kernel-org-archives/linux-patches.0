Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28AF64FDE56;
	Wed, 30 Sep 2026 16:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786834; cv=none; b=udLTb/wWVWz/sMpV15sDxc+m01k4VOtXEFET2ijrf+3xwcTK1da2/Nmmt7PIYSNnHtOBKfJ545HmtKGYzSikiJ6osE6Qa2BNmwHVYMFz5Z9FSASETnXrmmAAivDqybPQ6hvQxMRS4It6hxm7ZEwL9KIOT5ftCgLOf2Kgg0qiuHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786834; c=relaxed/simple;
	bh=LZuX0mBOvanu93tUO+Jf/BYGRoh8iU26+fExJkNJr/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZq/eVLFcOYF2fDbGpQlvpb5EQgUI8Tjlu1PRwRkpq+nZGm2ksie0CBbENOpbM8mOkfqJA69hm312hOUbsSzk7BX8yRGeZXGppVoUm1cc/ir61IBSpgCgmkPZoYR5QPpHltKT18h/mR1pe0wPSl7MBiblyzpluUmB6NyM18beJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gwo1gm8F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gwo1gm8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82DE51F000FF;
	Wed, 30 Sep 2026 16:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786833;
	bh=eH8AH2x2zDKjwsfdbJpKT9I1Yh92fM1DG9GMp8v2940=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gwo1gm8FWRMzspbRIijR+TBzPGa4J18SGlOIH5bn5maiqWmaEK9SmktMqQMhQ97If
	 NTk+h6vLBgQAWS3oU2Y58zoAbnMmSveAkyL4fY4FlJTXFGPkCO2HrJmRYfjvTyAU+w
	 APdRfkGHZzy2sKiRAm6SbcGK/B6m6vZPww+hEikQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 011/457] KVM: s390: Fix potential races in dat skey functions
Date: Wed, 30 Sep 2026 17:21:56 +0200
Message-ID: <20260930152346.275197306@linuxfoundation.org>
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

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit 27554b9505ddfc0aeab466aeb60929dfa17284c7 ]

When dat_cond_set_storage_key() finds a large page, it will
conditionally set the storage key in absolute memory using
large_crste_to_phys() to get the absolute address.

There is a race window between dat_entry_walk() and
large_crste_to_phys(): the large page could have been split
concurrently, and large_crste_to_phys() might be called with a crste
that does not designate a large page, leading to crashes.

Similar issues were also present in dat_set_storage_key().

dat_get_storage_key() and dat_reset_reference_bit() did instead check
for a potential concurrent splitting of the large page, but then
handled it incorrectly.

Fix by performing a READ_ONCE on the crste pointer, checking and using
the result, instead of dereferencing the pointer again. In case a race
is detacted, try dat_entry_walk() again.

Fixes: 8e03e8316eb2 ("KVM: s390: KVM page table management functions: storage keys")
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260828115439.145885-8-imbrenda@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/dat.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/arch/s390/kvm/dat.c b/arch/s390/kvm/dat.c
index 165c704fcf299..a21cb3975e992 100644
--- a/arch/s390/kvm/dat.c
+++ b/arch/s390/kvm/dat.c
@@ -620,17 +620,20 @@ int dat_get_storage_key(union asce asce, gfn_t gfn, union skey *skey)
 	union pte *ptep;
 	int rc;
 
+again:
 	skey->skey = 0;
 	rc = dat_entry_walk(NULL, gfn, asce, DAT_WALK_ANY, TABLE_TYPE_PAGE_TABLE, &crstep, &ptep);
 	if (rc)
 		return rc;
 
 	if (!ptep) {
-		union crste crste;
+		union crste crste = READ_ONCE(*crstep);
 
-		crste = READ_ONCE(*crstep);
-		if (!crste.h.fc || !crste.s.fc1.pr)
+		if (!crste_leaf(crste) && !crste.h.i)
+			goto again;
+		if (!crste.s.fc1.pr)
 			return 0;
+
 		skey->skey = page_get_storage_key(large_crste_to_phys(crste, gfn));
 		return 0;
 	}
@@ -661,13 +664,20 @@ int dat_set_storage_key(struct kvm_s390_mmu_cache *mc, union asce asce, gfn_t gf
 	union pte *ptep;
 	int rc;
 
+again:
 	rc = dat_entry_walk(mc, gfn, asce, DAT_WALK_LEAF_ALLOC, TABLE_TYPE_PAGE_TABLE,
 			    &crstep, &ptep);
 	if (rc)
 		return rc;
 
 	if (!ptep) {
-		page_set_storage_key(large_crste_to_phys(*crstep, gfn), skey.skey, !nq);
+		union crste crste = READ_ONCE(*crstep);
+
+		/* A large page has been split concurrently, try again */
+		if (!crste_leaf(crste))
+			goto again;
+
+		page_set_storage_key(large_crste_to_phys(crste, gfn), skey.skey, !nq);
 		return 0;
 	}
 
@@ -717,15 +727,22 @@ int dat_cond_set_storage_key(struct kvm_s390_mmu_cache *mmc, union asce asce, gf
 	union pte *ptep;
 	int rc;
 
+again:
 	rc = dat_entry_walk(mmc, gfn, asce, DAT_WALK_LEAF_ALLOC, TABLE_TYPE_PAGE_TABLE,
 			    &crstep, &ptep);
 	if (rc)
 		return rc;
 
 	if (!ptep) {
+		union crste crste = READ_ONCE(*crstep);
+
+		/* A large page has been split concurrently, try again */
+		if (!crste_leaf(crste))
+			goto again;
 		if (!oldkey)
 			oldkey = &prev;
-		return page_cond_set_storage_key(large_crste_to_phys(*crstep, gfn), skey, oldkey,
+
+		return page_cond_set_storage_key(large_crste_to_phys(crste, gfn), skey, oldkey,
 						 nq, mr, mc);
 	}
 
@@ -766,7 +783,7 @@ int dat_reset_reference_bit(union asce asce, gfn_t gfn, union skey *skey)
 	int rc;
 
 	skey->skey = 0;
-
+again:
 	rc = dat_entry_walk(NULL, gfn, asce, DAT_WALK_ANY, TABLE_TYPE_PAGE_TABLE, &crstep, &ptep);
 	if (rc)
 		return rc;
@@ -774,9 +791,12 @@ int dat_reset_reference_bit(union asce asce, gfn_t gfn, union skey *skey)
 	if (!ptep) {
 		union crste crste = READ_ONCE(*crstep);
 
-		if (!crste.h.fc || !crste.s.fc1.pr)
+		/* A large page has been split concurrently, try again */
+		if (!crste_leaf(crste) && !crste.h.i)
+			goto again;
+		if (!crste.s.fc1.pr)
 			return 0;
-		skey->skey = page_reset_referenced(large_crste_to_phys(*crstep, gfn)) << 1;
+		skey->skey = page_reset_referenced(large_crste_to_phys(crste, gfn)) << 1;
 		return 0;
 	}
 	old = pgste_get_lock(ptep);
-- 
2.53.0



