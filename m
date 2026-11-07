Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061758;
	b=DRzEgnE/oZehVjYERk4GAB0njTL3SCUTK2CUPA4cyPEX5jIhH3dKDYs4X4y7mrACGd3d
	 0KSGKxyC9oKB77y1e+w1JQ66YI0hlE0xUymJJnciQ17RiWSYSZ1Z3KnjWqMQ88uvFfbN9
	 rwUqyVAKnhfQms1eTEN6GSlj43SwN3eORrOY37eDATIEyh5Nk2R+WuhDstjoueeJ28RgC
	 bySEe7kBUp7lEs7B7oEprAMvSoL56HhYytqL0Yob7Ym0DDH5DM88/pSY/IToxowxqdT6n
	 5UxU2F8j50jGKNd3nddjCFASRCDuiePogpjV+2Iibd9xdHmgvlPgMTRqirOZHzvjgLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bQUHFR3Z0zCTsQrLbpgDB4GKeDkslIq/+o7yb16H4Q4=;
	b=M0XLZuJr3cANCTVg+rrlXMFCnWmDGkf3V8jr87WIIeE8P3x9kfPNw1xFQoya+817V+W3
	 tMCLImSiZn1pEBOJAhBmBko/IJ8G/9FUxZNQiWWbCJje85s011tBD1mTxlP+jVRuckRK9
	 L87Kq/JuZso9rp3beYoPBnQs6x/7WP6JpH+S4OlZ/VVYOIX2BBNvzgRXujD5mjLhkyB7+
	 LRmprylKWe63UXrsaoMsrIU1Sg/1KOCOZfPncv25oLtIbN1Y0w7+B7/Wikm5Z6LCpWMnH
	 l/7dBJte3suET48NxG8JljugeEaV6perHh7k48WMVMCCuzwQeB9l+R+iY3LgZLtG47A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v066DLSV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4544A606A32C;
	Sat,  7 Nov 2026 14:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v066DLSV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A661F008A2;
	Sat,  7 Nov 2026 14:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061758;
	bh=bQUHFR3Z0zCTsQrLbpgDB4GKeDkslIq/+o7yb16H4Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v066DLSVFupuoy+m9g47ZfFAounkeIzbPSYKX8lLAd0aXq3FKw05g9Y+kXPBwqWyX
	 yxThYlJcxBweUFSxJazRkuJ5uJVPxE7t7Fct8CxJe1z4OZQXYqDXCtGtDEWZRRoy6/
	 a4cPY9rLRPFBLu0ZFbNrRu03D8PDQvw1mx0Waidw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 0796/1536] KVM: x86/mmu: Bug the VM if KVM attempts to walk more levels than the MMU has
Date: Sat,  7 Nov 2026 08:46:52 -0500
Message-ID: <20261107135019.904658078@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


