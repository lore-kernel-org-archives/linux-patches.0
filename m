Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855773876DE;
	Thu, 16 Jul 2026 13:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210170; cv=none; b=FtB6azAuXeCYivu6Oe2hZPzefJHHVS+SkjBhoyotGUV6qBof/xv0hurS6afs8hfSHF9NNvY4U6UCX27XD4kGPVBCyidZDkA7pYuZG6BesCr8t71+ooAGHJRm4UWTjQAlUOVsLuenYiWdzeYMlC9X1zUkH/qL+0MBqD2S9tmkE9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210170; c=relaxed/simple;
	bh=WGdwUSYXhlIzDB5n1Q3DwHhagjfkBDNqBt/oUIjpXmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rLZYTGM0dNCHsuQ0O+KMdZsdBA/teLfAxga9S6g65myG0BXoZ+Tun44O9BndJ1haWbaXG2j5RjYjpwjeXuubz6foitvhn/pizLAfOtkR80uNwXZWFqVE+vENEjezZ5CdbmyyodpSEJxKgJ9KnpULiy6/gCQasO4zKzDzWAz0M+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h0CDit7n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h0CDit7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B461F00AC4;
	Thu, 16 Jul 2026 13:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210169;
	bh=C0vOg07z3BVlZdMTPOmYWKgpkpxSrBf+6TFjiwbw1OY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h0CDit7nQFAXhowSY3aCJVfC8E0Hmt/aDNrP9+OhqYIbUGvxeBLYKMhkV/gLWddCa
	 DWihR/k+Wd1hwzQKtxriqEfs3Cp1PhkpvjEh5jRy9W+LWKq9VzNgTZncDM8jV/AHxp
	 T1r22WSEoSpcA4Jj6XBdbSzFi98X1W3v43sfO5LE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 7.1 464/518] KVM: arm64: Dont leak PFN when kvm_translate_vncr() races MMU notifier
Date: Thu, 16 Jul 2026 15:32:12 +0200
Message-ID: <20260716133057.996762681@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

From: Oliver Upton <oupton@kernel.org>

commit 9f76b039a72d7e06374aa96862f0232ed53f7787 upstream.

In the case that kvm_translate_vncr() races with an MMU notifier the
early return does not release a reference on the faulted in PFN. Add
the necessary call to kvm_release_faultin_page() for the unused PFN.

Cc: stable@vger.kernel.org
Fixes: 069a05e535496 ("KVM: arm64: nv: Handle VNCR_EL2-triggered faults")
Reported-by: Sashiko (local):gemini-3.1-pro
Signed-off-by: Oliver Upton <oupton@kernel.org>
Link: https://patch.msgid.link/20260602235450.103057-2-oupton@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/nested.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1327,8 +1327,10 @@ static int kvm_translate_vncr(struct kvm
 	}
 
 	scoped_guard(write_lock, &vcpu->kvm->mmu_lock) {
-		if (mmu_invalidate_retry(vcpu->kvm, mmu_seq))
+		if (mmu_invalidate_retry(vcpu->kvm, mmu_seq)) {
+			kvm_release_faultin_page(vcpu->kvm, page, true, false);
 			return -EAGAIN;
+		}
 
 		vt->gva = va;
 		vt->hpa = pfn << PAGE_SHIFT;


