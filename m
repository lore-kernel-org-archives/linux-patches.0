Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2692F1FDF;
	Mon, 17 Aug 2026 15:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980330; cv=none; b=udYWMsxpJp02rGG0iUbOoWi4NP33boDcAwFuw+V5/9jWLAjqs0wkOjGG7616TZkEhz6I36sguOdGmJ/ZKaEBxGh4U8TGF/p1Vyx/9YN0rb4jz8CDAtdOHqEmt4njl1rgKmW3vyVwtwmkFUzlRXQ4c0WEHkj7aj1bugctHrUAYQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980330; c=relaxed/simple;
	bh=myeaUheryEmzwhJmeqOqz3P7Tr3BEvssJsExmhQ79uU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JffWSaQyRFqWAxF4NxQcNei2S0qvOMlsbRyuuqncBVA3p3iO2nEjFpE7Ae2vGPOtDHGXx9KYHh/DNkRiz1BD158o9kE0u2fGYBgZgSXc13HSkju8iStkWWnC9/yivt+lSqdSypM9oytEHq/+tRv4aJB++KBoby+8vIx+kTZLEoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j77D7VvS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j77D7VvS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011421F000E9;
	Mon, 17 Aug 2026 15:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980328;
	bh=TKD16pD3CsnfYp3s8YFyzIqFp5yGViF5GX29EV/IWnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j77D7VvSw1QIwozzzMHrXX3eClzyyYHcfc4ai56iutCqDej9tBHlLs1ECEcoQZoQF
	 rsEwDZQtWs7skhUm92q8xX7U6MMPdZaGS8AL1borakrGZaQ0IJxuwoD6aZ63okfAE6
	 htD0evbsZdys8xRZUfmhXUMC0nQT+qYQ6MAnv92s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 536/609] KVM: x86: Check for invalid/obsolete root *after* making MMU pages available
Date: Mon, 17 Aug 2026 15:33:52 +0200
Message-ID: <20260817132601.710107423@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 2abd5287f08319fa35764566b15c6e22cb1068db ]

Check for a "stale" page fault, i.e. for an invalid and/or obsolete root,
after making MMU pages available for the shadow MMU.  If reclaiming shadow
pages zaps an in-use root, i.e. marks it invalid, then KVM will attempt to
map memory into an invalid root.  On its own, populating an invalid root is
"fine", but because child shadow pages inherit their parent's role, any
children created during the map/fetch will be created as invalid pages,
thus violating KVM's invariant that invalid pages are never on the list of
active MMU pages.

Note, the underlying flaw has existed since KVM first started tracking
invalid roots in 2008 (commit 2e53d63acba7, "KVM: MMU: ignore zapped root
pagetables"), but the true badness only came along in 2020 (Linux 5.9)
with the invariant that invalid shadow pages can't be on the list of
active pages.

Note #2, inheriting role.invalid when creating child shadow pages is also
far from ideal; that flaw will be addressed separately.

Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Fixes: f95eec9bed76 ("KVM: x86/mmu: Don't put invalid SPs back on the list of active pages")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c         |  9 +++++----
 arch/x86/kvm/mmu/paging_tmpl.h | 10 ++++++----
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7fc8a819b31ac..34f09908961c5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4281,16 +4281,17 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 		return r;
 	}
 
-	r = RET_PF_RETRY;
 	write_lock(&vcpu->kvm->mmu_lock);
 
-	if (is_page_fault_stale(vcpu, fault))
-		goto out_unlock;
-
 	r = make_mmu_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
 
+	if (is_page_fault_stale(vcpu, fault)) {
+		r = RET_PF_RETRY;
+		goto out_unlock;
+	}
+
 	r = direct_map(vcpu, fault);
 
 out_unlock:
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 8d1ab32ee5f9e..2ea7bd1a6bb5f 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -865,15 +865,17 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 
 	orig_pfn = fault->pfn;
 
-	r = RET_PF_RETRY;
 	write_lock(&vcpu->kvm->mmu_lock);
 
-	if (is_page_fault_stale(vcpu, fault))
-		goto out_unlock;
-
 	r = make_mmu_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
+
+	if (is_page_fault_stale(vcpu, fault)) {
+		r = RET_PF_RETRY;
+		goto out_unlock;
+	}
+
 	r = FNAME(fetch)(vcpu, fault, &walker);
 
 out_unlock:
-- 
2.53.0



