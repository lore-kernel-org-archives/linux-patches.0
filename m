Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DCE31E842;
	Sun,  7 Jun 2026 10:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828278; cv=none; b=V1aw5u0ueYb+9qFXRzFlx3UnKbXHT6Kcss95LFQ+iYzkWXzl+9PFBLq1cXNfD8suYSlAfDvvYQ6VUyPA5PtSGUo/QwnqEbteUrofPiQCkEL48x4k5MwSC/hBd1u1R0FCCV+moBCs6ly5s4Gg8nO9fgxMzqdw5m1ShIlDGja3ucE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828278; c=relaxed/simple;
	bh=MA1c6AGatPpN3nlemQ+bWmO5Qvx6s6KF1AzKyJTHPzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q71HVQS0wwtj/rmilifugs4P1uN5hhk7HyzLktkYMd9aud57/Tjq2QEw3VhWcay3e9aV4M9okKyk7n9BBkxCe9HoflArLfI1upTVZmaDTviSfLyEdlW3nBGMLhBEr2xmH+JILl2RO/13Fs3eLPaakin/E4slaZ/8KMpWqTteeZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hb99d3c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hb99d3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B2B1F00893;
	Sun,  7 Jun 2026 10:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828277;
	bh=B37Sh5SWsnrk4rzYmoKvMp080NOAcWelG/aB6eew3I8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0hb99d3ciWDMxO5dlviB/tEOOZmPJ6N3HB8yXztKJYdRATZHnrQXni0jFuTADrJLN
	 IG3Z9uvVRi8OjLb6fn6MVS0he2OjuGxY2/Y9f+bW+gNYvhnuEH0gCRYxmFru5Kalzw
	 TmEZHnH94eCYAli6dkZgTWJZxENDVRRJNwCnrry0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.18 146/315] KVM: SEV: Use the size of the PSC header as the minimum size for PSC requests
Date: Sun,  7 Jun 2026 11:58:53 +0200
Message-ID: <20260607095732.965331596@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit 2be54670bdc017004c4a4b8bddb6ff02ebe7dbe2 upstream.

When handling a Page State Change (PSC) #VMGEXIT use the size of the PSC
header as the minimum size for the scratch area.  Per the GHCB spec, PSC
requests do NOT provide the length, i.e. using control->exit_info_2 for the
length is completely made up behavior.  The existing code "works", e.g.
even though Linux-as-a-guest always passes '0', because KVM doesn't do
anything with the length when the request is in the GHCB's shared buffer.

Use the header as the min length.  Once the header is retrieved, KVM can
use the specified indices to compute the full size of the request.

Fixes: 9b54e248d264 ("KVM: SEV: Add support to handle Page State Change VMGEXIT")
Cc: stable@vger.kernel.org
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260501202250.2115252-6-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4473,7 +4473,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *
 		vcpu->run->system_event.data[0] = control->ghcb_gpa;
 		break;
 	case SVM_VMGEXIT_PSC:
-		ret = setup_vmgexit_scratch(svm, true, control->exit_info_2);
+		ret = setup_vmgexit_scratch(svm, true, sizeof(struct psc_hdr));
 		if (ret)
 			break;
 


