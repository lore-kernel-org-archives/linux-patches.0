Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E490046D094;
	Tue, 21 Jul 2026 18:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659626; cv=none; b=sDkaHyIjr3bNuvwrlL8szJRBbHjfFQ7k4hT5tzgZeQm+8fP9ZCYEqqzhr5R+4GFCnPSq+a9qmeOm9r6V48mCzoG7+IlOOx/KrL8lYoPsg9LiUZoFXeGFKbbfzxAKvNx1RzSCa31ZXwh6XTAE/63NcHvWdNce3K1cQdKlKLGh9VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659626; c=relaxed/simple;
	bh=xBlnuP/1ggOWGxeBY3aD6s0vMRCo6bceqt5fZauFXXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUDQh+XRDAQpi/Uxk+f7TH0spfdSHmbjFIWEOREx8TBT5eZIcFEDATJnK1Jo0mMZBuEBrye74XZxp5QEJN880fpiRJhNNpdvW2J6knl6LxLuYxDUWF8AyZEV90G6OPFBqsGfbFa5PspRyOAEnatzMNz24Qp6gHICd5P6BHs7P6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EFC/8Snd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EFC/8Snd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053A21F000E9;
	Tue, 21 Jul 2026 18:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659624;
	bh=QEBwL0xF/6GUpZtKVjWfCm1DBWl+VPtoCLmeGz/Tpxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EFC/8Snd9wdxKRR1FE2rGVGn2Y4Sffs5iUCxGkqNmQ0pj2nadgf8w24qX7Qg5vfYT
	 p0gwqfnO1Gk2enWPkwETZ8CN7peP6ex5h/MdH5SGgKgDsaQGT+jkn4Q9Izcpdkkdnq
	 gSZu5vzJ3jAwt6SpQ41uuEqmtMLQc52JZNa17nU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.18 1592/1611] KVM: arm64: Ensure level is always initialized when relaxing perms
Date: Tue, 21 Jul 2026 17:28:28 +0200
Message-ID: <20260721152551.285964908@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Oliver Upton <oupton@kernel.org>

commit 100baf0184896f859290a684f864b8200d8ac872 upstream.

stage2_update_leaf_attrs() returns early before writing to @level if the
table walker returned an error. At the same time,
kvm_pgtable_stage2_relax_perms() uses the level as a TLBI TTL hint when the
error was EAGAIN, indicating the vCPU raced with a table update and the TLB
entry it hit is now stale.

Fall back to an unknown TTL if none was provided by the walk.

Cc: stable@vger.kernel.org
Fixes: be097997a273 ("KVM: arm64: Always invalidate TLB for stage-2 permission faults")
Signed-off-by: Oliver Upton <oupton@kernel.org>
Reviewed-by: Wei-Lin Chang <weilin.chang@arm.com>
Link: https://patch.msgid.link/20260701231620.3300204-2-oupton@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/pgtable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1291,7 +1291,7 @@ int kvm_pgtable_stage2_relax_perms(struc
 				   enum kvm_pgtable_prot prot, enum kvm_pgtable_walk_flags flags)
 {
 	int ret;
-	s8 level;
+	s8 level = TLBI_TTL_UNKNOWN;
 	kvm_pte_t set = 0, clr = 0;
 
 	if (prot & KVM_PTE_LEAF_ATTR_HI_SW)


