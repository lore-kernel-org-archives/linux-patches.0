Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0124F5E18;
	Wed, 30 Sep 2026 18:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792521; cv=none; b=fpqC2bLPx4tC1uul1i4kUbynYO0RVCU8fJkjGN/WvDrcgS/5RCdE3hFGtIVcbQTZiVdXza6I48/j2AgBoZUgeraBY/Dd0l2T0Fg9pjLHol08yrb1UUA5loCuQ0EjuNrim+mQm/FOQgpvB8RhpRZqCRHADGg+fDke5NpOvqmQcvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792521; c=relaxed/simple;
	bh=m4X+RPpxUqbi67UGHGks6gbympC3rOInyx7qaI7cmQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dE3dhvdBAfdyC1dhj0aA3rt/9goOwwMVQ2B6YaKQwmS/Nti4GsHx1Q76SH5smsKNfJ/xNoZdWsSI0JSgv9GTGtTDxT/oN5q/Em7agHA8HaVkHebfUQC31uoRBsV5jiCauvXBiZtQbKYYyR6rbj2Z6ldu/F2fXYnolloYoWSI7lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VpC1R49f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VpC1R49f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717C71F000FF;
	Wed, 30 Sep 2026 18:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792520;
	bh=Ut8wABXSfRD42yZiExnBcPLQl7lrCI3IGFi8wOw7s9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VpC1R49fCQrayIwDaelT6N93Vru/BVrfpWfjITXhmtjJ9ry8y6xkMwRZM1ihHfTe8
	 XgId7W+AeyvUnzgj+3mNXpVyMf/95L3V7qefLI43KjVzrBNbGEsbKiiBlXUU0b1/Tq
	 K+CFn1D/rt7TY/tZBnXeXaZ2/NigCbyelXZiyPbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	Kenta Akagi <k@mgml.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 683/752] KVM: MMU: update comment on the number of page role combinations
Date: Wed, 30 Sep 2026 17:29:13 +0200
Message-ID: <20260930152413.022808590@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit dc1ce45575b3401102568dd60ba8894849d1d64b upstream.

Fix the number of bits in the role, and simplify the explanation of
why several bits or combinations of bits are redundant.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Kenta Akagi <k@mgml.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/kvm_host.h | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 710c9c87cdf2e..2c378064a1db9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -292,19 +292,25 @@ struct kvm_kernel_irq_routing_entry;
  * the number of unique SPs that can theoretically be created is 2^n, where n
  * is the number of bits that are used to compute the role.
  *
- * But, even though there are 18 bits in the mask below, not all combinations
- * of modes and flags are possible.  The maximum number of possible upper-level
- * shadow pages for a single gfn is in the neighborhood of 2^13.
+ * But, even though there are 19 bits in the mask below, not all combinations
+ * of modes and flags are possible:
  *
- *   - invalid shadow pages are not accounted.
- *   - level is effectively limited to four combinations, not 16 as the number
- *     bits would imply, as 4k SPs are not tracked (allowed to go unsync).
- *   - level is effectively unused for non-PAE paging because there is exactly
- *     one upper level (see 4k SP exception above).
- *   - quadrant is used only for non-PAE paging and is exclusive with
- *     gpte_is_8_bytes.
- *   - execonly and ad_disabled are used only for nested EPT, which makes it
- *     exclusive with quadrant.
+ *   - invalid shadow pages are not accounted, so the bits are effectively 18
+ *
+ *   - quadrant will only be used if gpte_is_8_bytes=0 (non-PAE paging);
+ *     execonly and ad_disabled are only used for nested EPT which has
+ *     gpte_is_8_bytes=1.  Therefore, 2 bits are always unused.
+ *
+ *   - the 4 bits of level are effectively limited to the values 2/3/4/5,
+ *     as 4k SPs are not tracked (allowed to go unsync).  In addition non-PAE
+ *     paging has exactly one upper level, making level completely redundant
+ *     when gpte_is_8_bytes=0.
+ *
+ *   - on top of this, smep_andnot_wp and smap_andnot_wp are only set if
+ *     cr0_wp=0, therefore these three bits only give rise to 5 possibilities.
+ *
+ * Therefore, the maximum number of possible upper-level shadow pages for a
+ * single gfn is a bit less than 2^13.
  */
 union kvm_mmu_page_role {
 	u32 word;
-- 
2.53.0



