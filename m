Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035465;
	b=K/4s13f4qoH8piZlLmgyEVw7Wn3B1PPUq0/0qWm7Z/tbFC5mZK7RNU3F9x7p1RpGEygN
	 oV9nAsf6bCfSEZrK+tXbQkD6OLBFOdhmRO56p8WPMXGznsT4nA5CxzZBvwKex/LYOjg0R
	 jp2lLIrxs5mwYieLRxEWmq/FjhGkY3RLv+MuuvERudUpIy5lD9D/wUYM6/gg5T0CSTsa5
	 GDqlm/NM+6dfel6WLFqyBgjknXMHqA6cYFWZYSOaTTf/ZqZSLLJFIrDDoYB7jWG1I1yFw
	 Skkkq2+eL3kGutzqYJUqmxjABejR+cexgyZwCbZag/EKUtOu5dcJqMMtR2vOM+FszEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035465;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HY5qCMa0XZFEEhFS7HCq3OgC0lVkDYWEcsA1DZSd1o0=;
	b=ifsoesOzj/YQAmhkyKZkj2Eij85tpcZaJkdDH1SanaJ7ioKjGb91bNUCf182qFRQ07Rl
	 aV98avXR4xqjmj2Tijj5gr5B8Q8ftNys+ERm3XAiYJb9yIfREpez7FaQmhiWxqWufo0U4
	 8I/6qlTUEuAQ0frmWW9oYVkm+GWjhLj7JzriRVr7eTvl26rsLaUlTDDpOduOCkhLZTUnO
	 SRP9YV8N6kl3s3IRMvxwIzaRrBtyLFQSrQQ+TzkP3JKBZvlhXsu3mgqAP9NwoLfKvPC82
	 DRbIhWver7EymjjQOL3nj3l5ivxTgTFpq5NeoRe0SDEtM7tiUcKi6ZoAngDWHZ76RvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xciZVRVE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9A8606A31C;
	Wed, 18 Nov 2026 20:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xciZVRVE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062CB1F000C4;
	Wed, 18 Nov 2026 20:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035465;
	bh=HY5qCMa0XZFEEhFS7HCq3OgC0lVkDYWEcsA1DZSd1o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xciZVRVEQilwdP4K/UfqydLAmwKR9hZfqP/oj+y2XtqXh9m9wtUsam4XYMHk16Z9v
	 D2uauA3I0VbRoDjG4ccnA5i3dfvm4TtX1cZhbJZm3co1ayKA0Z4fcO6f0zOJxCyem0
	 2RY+gQEefz7DedomqmK2+usNKHHZ+/5UGKUNOY0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 0714/3318] KVM: x86/mmu: Bug the VM if KVM attempts to walk more levels than the MMU has
Date: Wed, 18 Nov 2026 15:22:16 +0100
Message-ID: <20261118150339.868119462@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 115f9405a2ed6d78ee7ad8436bdd638743f6d1d4 upstream.

Extend the "EFER.LMA && !CR4.PAE" check, which exists largely to guard
against KVM configuring a paging32 MMU with more than 2 levels of paging,
with a very explicit check for exactly that: that KVM isn't trying to walk
more levels of paging than the MMU template provides.  I.e. harden KVM
against all bugs that would cause KVM to generates accesses beyond the
bounds of guest_walker's arrays, regardless of how KVM ended up with the
misconfigured MMU.

Note, don't use w->cpu_role.base.level directly as the paging64 template
only provides two levels of page tables for PAE paging on 32-bit hosts, and
handles the third level by manually emulating the PDPTR access.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260902232028.2767071-4-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/paging_tmpl.h |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -349,13 +349,14 @@ retry_walk:
 	pte_access = ~0;
 
 	/*
-	 * Queue a page fault for injection if this assertion fails, as callers
-	 * assume that walker.fault contains sane info on a walk failure.  I.e.
-	 * avoid making the situation worse by inducing even worse badness
-	 * between when the assertion fails and when KVM kicks the vCPU out to
-	 * userspace (because the VM is bugged).
+	 * Queue a page fault for injection if any of the below assertions fail,
+	 * as callers assume that walker.fault contains sane info on a walk
+	 * failure.  I.e. avoid making the situation worse by inducing even
+	 * worse badness between when the assertion fails and when KVM kicks
+	 * the vCPU out to userspace (because the VM is bugged).
 	 */
-	if (KVM_BUG_ON(is_long_mode(vcpu) && !is_pae(vcpu), vcpu->kvm))
+	if (KVM_BUG_ON(is_long_mode(vcpu) && !is_pae(vcpu), vcpu->kvm) ||
+	    KVM_BUG_ON(walker->max_level > PT_MAX_FULL_LEVELS, vcpu->kvm))
 		goto error;
 
 	++walker->level;


