Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289A51D7995;
	Tue, 16 Jun 2026 15:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622472; cv=none; b=fulHdI3BuBkGXfn0hcP5YiR+Yo6MRizFrnKP4yEQyZYrIOgNb8ZXm/wil/ASS/X2YuUf82JstKwUR/FtXzGscUtYldbZ0eGwDB2RRnclqLDyEz1BV/C26+13LJWuHUvxwYhLcYquTQgJTG+Ed4Jd2OrZJR/TMkP5itQ32u9Ohpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622472; c=relaxed/simple;
	bh=CjvNZSgtIRLqY9YXF9ksAx0hLkEjp1Bu58FKDkZbg8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eb5C9xRsmMdO1R+/DxRcxTxw55wzkf4hlwC/B9ddVcyT4Mb1qMG4QfnhaSECUjl/0L/BZ8rGnRABWlI6J/OwQjKoMhM4XmH10G4eGQESHBzf5Wf7B8/PnPtOlaZzEwxmnXjvJuPzcrLnEXY5cuqvdTrjzk/YJm7Qm2+s3NjcwuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZS7ZLrji; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZS7ZLrji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B5B1F000E9;
	Tue, 16 Jun 2026 15:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622471;
	bh=m6hyAp89qplNZWTKbVpoo3a1SELJINCR1Cu0tr9ub2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZS7ZLrjioq9YXvQU8NEyKb9YcbxLczc3KnMX2sfCcClIahsVRedlO9N5kk1KYatnm
	 LPsMugNYvzkGOK9TPnDOcyOWKiCWrzHlnSzgxgF4J7O8uErdgBQnlZytIvb62Bo4HY
	 hKhak8Az6WC4TL1/TQJCCkoE+eVrPMeKxhRLzj2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.18 006/325] KVM: arm64: Take the SRCU lock for page table walks in fault injection and AT emulation
Date: Tue, 16 Jun 2026 20:26:42 +0530
Message-ID: <20260616145058.139350030@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Hyunwoo Kim <imv4bel@gmail.com>

commit f2ca45b50d4216c9cc7ffabf50d9ad1932209251 upstream.

walk_s1() and kvm_walk_nested_s2() expect to be called while holding
kvm->srcu to guard against memslot changes. While this is generally
the case, __kvm_at_s12() and __kvm_find_s1_desc_level() call into the
respective walkers without taking kvm->srcu.

Fix by acquiring kvm->srcu prior to the table walk in both instances.

Cc: stable@vger.kernel.org
Fixes: 50f77dc87f13 ("KVM: arm64: Populate level on S1PTW SEA injection")
Fixes: be04cebf3e78 ("KVM: arm64: nv: Add emulation of AT S12E{0,1}{R,W}")
Suggested-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Reviewed-by: Oliver Upton <oupton@kernel.org>
Link: https://patch.msgid.link/aiAZfdeyanIvP8SD@v4bel
Signed-off-by: Marc Zyngier <maz@kernel.org>
[ Hyunwoo Kim: __kvm_at_s12() still returns void in 6.18.y, so the
  surrounding context differs from upstream (return; instead of
  return ret;); the added scoped_guard() is unchanged. ]
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/at.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1528,7 +1528,8 @@ void __kvm_at_s12(struct kvm_vcpu *vcpu,
 	/* Do the stage-2 translation */
 	ipa = (par & GENMASK_ULL(47, 12)) | (vaddr & GENMASK_ULL(11, 0));
 	out.esr = 0;
-	ret = kvm_walk_nested_s2(vcpu, ipa, &out);
+	scoped_guard(srcu, &vcpu->kvm->srcu)
+		ret = kvm_walk_nested_s2(vcpu, ipa, &out);
 	if (ret < 0)
 		return;
 
@@ -1623,7 +1624,8 @@ int __kvm_find_s1_desc_level(struct kvm_
 	}
 
 	/* Walk the guest's PT, looking for a match along the way */
-	ret = walk_s1(vcpu, &wi, &wr, va);
+	scoped_guard(srcu, &vcpu->kvm->srcu)
+		ret = walk_s1(vcpu, &wi, &wr, va);
 	switch (ret) {
 	case -EINTR:
 		/* We interrupted the walk on a match, return the level */


