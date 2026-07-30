Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6025B43E9F9;
	Thu, 30 Jul 2026 14:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421195; cv=none; b=iJQNgrI4LcxGM75YHvmyO31oLyAqV8EKyixlkYA9CRIClnRB6JZHLNuIYc24mJwZV6zpayyOo9toLSAeFePCsS2jGXsv1igOXLU7IHDI6gbw2CpX+1aMynlveC6p8Z+ZaojtE5Q/jFQQocFqTeNu6T2vm/Ea+Bf0k4V59L4icas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421195; c=relaxed/simple;
	bh=AOWOP+ekJyKb9I/y1mNZD8YMghqqN5oqUkYiCMlUau4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4hp815dn6OdSAW4RE2wbdVWjGlY0N7dnKTJpSzn6Xx88R0rTN2DcqZFsr2YpS8kJr3ia1can8+HDVNajslSNRtfBAheY8x1bNRRMFOCiFCRuWLg5cFk2C9HI3V2q6ohTKUfOH5sQuwGdoyW3FTztUPWQKMJgJSXehCQ1w8bWzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+CAH/29; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+CAH/29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4881F000E9;
	Thu, 30 Jul 2026 14:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421194;
	bh=8yE4xzJM1NrhmJw4kW/PLE5n2YcGtdEWgY5T7xiX5Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N+CAH/295F/amz6iowiUWolXsxPktY5cv2pyTys3tX5OtUM2tKi5QhEiUtQcBtgGP
	 yjOgPkk10D2bTu13zv2QifQegAJkTl8pIw7nIxYHkrFsaLF1bWaWTZwWUixm8TB5aN
	 NSVcRIqS7u433X3RZK45j6SNaimX4qH7FfZYD3Fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7.1 005/744] KVM: x86: Check for invalid/obsolete root *after* making MMU pages available
Date: Thu, 30 Jul 2026 16:04:38 +0200
Message-ID: <20260730141444.393605975@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit 2abd5287f08319fa35764566b15c6e22cb1068db upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c         |    9 +++++----
 arch/x86/kvm/mmu/paging_tmpl.h |   10 ++++++----
 2 files changed, 11 insertions(+), 8 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4837,16 +4837,17 @@ static int direct_page_fault(struct kvm_
 	if (r != RET_PF_CONTINUE)
 		return r;
 
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
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -827,15 +827,17 @@ static int FNAME(page_fault)(struct kvm_
 	}
 #endif
 
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


